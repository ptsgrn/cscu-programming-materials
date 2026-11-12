namespace error_diffusion;

using System.Diagnostics;
using StbImageSharp;
using StbImageWriteSharp;

// Floyd–Steinberg error diffusion: sequential vs. parallel (lock-free row pipeline).
//
// Dependency: pixel (y, x) needs the error from (y, x-1) and from (y-1, x-1..x+1).
// So row y may process pixel x as soon as row y-1 has finished pixel x+1.
// Thread t processes rows t, t+n, t+2n, ...; each row publishes how many pixels
// it has finished (Volatile.Write = release barrier), and the next row waits on it
// (Volatile.Read = acquire barrier). No locks are needed.
//
// Speed tricks (from the assignment hints):
//  - integer math only; Python's floor-division `e*k // 16` == arithmetic shift `(e*k) >> 4`
//  - input/output kept as byte[]; errors as short[]
//  - the error to the right is carried in a register; the errors to the next row are
//    accumulated in registers and each next-row cell is written exactly once (no +=),
//    so the error buffer never needs clearing and only a small ring of rows is used
//  - one dummy row/cell absorbs errors that fall off the bottom/right edge
//  - n worker threads are created once and reused for every run
class Program
{
    const int Threshold = 128;

    static void Main(string[] args)
    {
        if (args.Length < 1)
        {
            Console.WriteLine("Usage: error-diffusion <input file or URL> [output] [threads] [runs]");
            return;
        }
        string inputPath = args[0];
        bool isUrl = inputPath.StartsWith("http://") || inputPath.StartsWith("https://");
        string outputPath = args.Length > 1 ? args[1]
            : (isUrl ? "output" : Path.ChangeExtension(inputPath, null) + "_output") + ".png";
        int threads = args.Length > 2 ? int.Parse(args[2]) : Environment.ProcessorCount;
        int runs = args.Length > 3 ? int.Parse(args[3]) : 5;

        // ---- Pre-processing (not timed): download/read file, decode, convert to grayscale ----
        byte[] fileBytes = isUrl
            ? new HttpClient().GetByteArrayAsync(inputPath).GetAwaiter().GetResult()
            : File.ReadAllBytes(inputPath);
        var (input, w, h) = LoadGrayscale(fileBytes);
        Console.WriteLine($"{inputPath}: {w}x{h}, threads={threads}, runs={runs}");

        var seqOut = new byte[w * h];
        var parOut = new byte[w * h];
        var seqErr = new short[(w + 1) * 2];

        // Warm up JIT
        Sequential(input, seqOut, seqErr, w, h);
        using var pool = new DitherPool(threads, w, h);
        pool.Run(input, parOut);

        // ---- Timed part: error diffusion only ----
        var (t1, t1Med) = Bench(runs, () => Sequential(input, seqOut, seqErr, w, h));
        var (t2, t2Med) = Bench(runs, () => pool.Run(input, parOut));

        bool same = seqOut.AsSpan().SequenceEqual(parOut);
        Console.WriteLine($"t1 (single core) = {t1,8:F2} ms   (median {t1Med:F2} ms, {runs} runs)");
        Console.WriteLine($"t2 ({threads} threads)  = {t2,8:F2} ms   (median {t2Med:F2} ms, {runs} runs)");
        Console.WriteLine($"Speedup t1/t2    = {t1 / t2:F2}x");
        Console.WriteLine($"Parallel == Sequential: {same}");

        using (var fs = File.Create(outputPath))
            new ImageWriter().WritePng(parOut, w, h, StbImageWriteSharp.ColorComponents.Grey, fs);
        Console.WriteLine($"Output image saved to {outputPath}");
    }

    // Returns (best, median) time in ms
    static (double, double) Bench(int runs, Action action)
    {
        var times = new double[runs];
        for (int i = 0; i < runs; i++)
        {
            var sw = Stopwatch.StartNew();
            action();
            times[i] = sw.Elapsed.TotalMilliseconds;
        }
        Array.Sort(times);
        return (times[0], times[runs / 2]);
    }

    // Decode and convert to 8-bit grayscale exactly like PIL's Image.convert('L'),
    // so the result matches error_diffusion.py even if the image is stored as RGB.
    static (byte[] gray, int w, int h) LoadGrayscale(byte[] fileBytes)
    {
        var img = ImageResult.FromMemory(fileBytes, StbImageSharp.ColorComponents.Default);
        int w = img.Width, h = img.Height, n = w * h;
        byte[] d = img.Data;
        switch (img.Comp)
        {
            case StbImageSharp.ColorComponents.Grey:
                return (d, w, h);
            case StbImageSharp.ColorComponents.GreyAlpha: // PIL 'LA' -> 'L' drops alpha
            {
                var g = new byte[n];
                for (int i = 0; i < n; i++) g[i] = d[2 * i];
                return (g, w, h);
            }
            default: // RGB / RGBA: PIL's L = (R*19595 + G*38470 + B*7471 + 0x8000) >> 16
            {
                int c = img.Comp == StbImageSharp.ColorComponents.RedGreenBlue ? 3 : 4;
                var g = new byte[n];
                for (int i = 0; i < n; i++)
                {
                    int p = i * c;
                    g[i] = (byte)((d[p] * 19595 + d[p + 1] * 38470 + d[p + 2] * 7471 + 0x8000) >> 16);
                }
                return (g, w, h);
            }
        }
    }

    // ---------------- Sequential ----------------
    // err holds 2 rows of (w+1) shorts: current row's incoming error, next row's (+1 dummy cell).
    static void Sequential(byte[] input, byte[] output, short[] err, int w, int h)
    {
        int stride = w + 1;
        for (int y = 0; y < h; y++)
        {
            var cur = err.AsSpan((y & 1) * stride, stride);
            var next = err.AsSpan(((y + 1) & 1) * stride, stride);
            var row = new RowState();
            ProcessPixels(input.AsSpan(y * w, w), output.AsSpan(y * w, w), cur, next, y == 0, 0, w, ref row);
            next[w - 1] = (short)row.AccPrev;
        }
    }

    // Carried state while walking a row left to right
    struct RowState
    {
        public int Right;   // error going to (y, x+1)       : 7/16
        public int AccPrev; // partial sum for next row x-1 : 1/16 of x-2 + 5/16 of x-1
        public int AccCur;  // partial sum for next row x   : 1/16 of x-1
    }

    // Processes pixels [from, to) of one row. Shared by sequential and parallel code.
    static void ProcessPixels(ReadOnlySpan<byte> inRow, Span<byte> outRow,
                              Span<short> cur, Span<short> next,
                              bool firstRow, int from, int to, ref RowState s)
    {
        int right = s.Right, accPrev = s.AccPrev, accCur = s.AccCur;
        for (int x = from; x < to; x++)
        {
            int v = inRow[x] + right + (firstRow ? 0 : cur[x]);
            int nv = v > Threshold ? 255 : 0;
            outRow[x] = (byte)nv;
            int e = v - nv;

            right = (e * 7) >> 4;                       // == floor(e*7/16) like Python //
            if (x > 0) next[x - 1] = (short)(accPrev + ((e * 3) >> 4)); // (y+1, x-1) complete
            accPrev = accCur + ((e * 5) >> 4);
            accCur = e >> 4;                            // e*1 >> 4
        }
        s.Right = right; s.AccPrev = accPrev; s.AccCur = accCur;
    }

    // ---------------- Parallel ----------------
    sealed class DitherPool : IDisposable
    {
        const int Block = 256;  // pixels processed between progress publications
        const int Pad = 16;     // 16 ints = 64 bytes: one cache line per progress counter
        const int Ring = 64;    // number of error rows kept (any value >= 1 is correct)

        readonly int n, w, h, stride;
        readonly Thread[] threads;
        readonly Barrier barrier;
        readonly int[] progress;   // progress[y*Pad] = #pixels finished in row y
        readonly short[] err;      // Ring rows of (w+1) shorts
        byte[] input = [], output = [];
        volatile bool stop;

        public DitherPool(int n, int w, int h)
        {
            this.n = n; this.w = w; this.h = h;
            stride = w + 1;                     // +1 dummy cell on the right
            progress = new int[h * Pad];
            err = new short[Ring * stride];
            barrier = new Barrier(n + 1);       // n workers + main thread
            threads = new Thread[n];
            for (int t = 0; t < n; t++)
            {
                int id = t;
                threads[t] = new Thread(() => Worker(id)) { IsBackground = true };
                threads[t].Start();
            }
        }

        public void Run(byte[] input, byte[] output)
        {
            this.input = input; this.output = output;
            Array.Clear(progress);
            barrier.SignalAndWait();   // start
            barrier.SignalAndWait();   // wait for all workers to finish
        }

        void Worker(int id)
        {
            while (true)
            {
                barrier.SignalAndWait();
                if (stop) return;
                for (int y = id; y < h; y += n) DoRow(y);
                barrier.SignalAndWait();
            }
        }

        void DoRow(int y)
        {
            var inRow = new ReadOnlySpan<byte>(input, y * w, w);
            var outRow = new Span<byte>(output, y * w, w);
            var cur = new Span<short>(err, (y % Ring) * stride, stride);
            var next = new Span<short>(err, ((y + 1) % Ring) * stride, stride);
            ref int myProgress = ref progress[y * Pad];
            var s = new RowState();
            int seen = 0; // last progress observed for row y-1

            for (int from = 0; from < w; from += Block)
            {
                int to = Math.Min(from + Block, w);
                if (y > 0)
                {
                    // Pixel to-1 needs row y-1 to have finished pixel `to` (i.e. count >= to+1)
                    int need = Math.Min(to + 1, w);
                    if (seen < need)
                    {
                        ref int above = ref progress[(y - 1) * Pad];
                        var spin = new SpinWait();
                        while ((seen = Volatile.Read(ref above)) < need)
                            spin.SpinOnce(sleep1Threshold: -1);
                    }
                }
                ProcessPixels(inRow, outRow, cur, next, y == 0, from, to, ref s);
                if (to == w) next[w - 1] = (short)s.AccPrev;
                Volatile.Write(ref myProgress, to); // publish (release)
            }
        }

        public void Dispose()
        {
            stop = true;
            barrier.SignalAndWait();
            foreach (var t in threads) t.Join();
            barrier.Dispose();
        }
    }
}
