using System.Diagnostics;

namespace _2nd_rw_problem;

// Readers-writers with fair access using System.Threading.Semaphore.
// Every thread (reader or writer) first waits on `serviceQueue`, so when a writer
// leaves the critical section, waiting readers and writers compete equally and the
// next one to enter is decided by whoever wins the semaphore, not by role.
class Program
{
    const int N = 100;                 // total threads
    static int n = 5;                  // writers (override with: dotnet run -- 10)

    static int x = 0;                  // shared data
    static int order = 0;              // order of entering the critical section

    static int readCount = 0;

    static readonly Semaphore serviceQueue = new(1, 1); // turnstile shared by readers and writers
    static readonly Semaphore rmutex = new(1, 1);       // protects readCount
    static readonly Semaphore resource = new(1, 1);     // the shared resource (x)

    static void Reader()
    {
        serviceQueue.WaitOne();                     // wait for our turn, same as writers
        rmutex.WaitOne();
        readCount++;
        if (readCount == 1) resource.WaitOne();     // first reader locks out writers
        serviceQueue.Release();                     // let the next thread (reader or writer) line up
        rmutex.Release();

        // ---- critical section (read) ----
        Interlocked.Increment(ref order);
        int value = x;
        Thread.Sleep(1000);
        _ = value;
        // ----------------------------------

        rmutex.WaitOne();
        readCount--;
        if (readCount == 0) resource.Release();     // last reader lets a writer in
        rmutex.Release();
    }

    static void Writer()
    {
        serviceQueue.WaitOne();                     // wait for our turn, same as readers
        resource.WaitOne();                         // wait for current readers/writer to finish
        serviceQueue.Release();

        // ---- critical section (write) ----
        int no = Interlocked.Increment(ref order);
        x = x + 1;
        Thread.Sleep(1000);
        Console.WriteLine($"no = {no} x = {x}");
        // ----------------------------------
        resource.Release();
    }

    static void Main(string[] args)
    {
        if (args.Length > 0 && int.TryParse(args[0], out int w) && w >= 0 && w <= N) n = w;

        var rng = new Random();

        // Randomly choose n writers: shuffle indices, first n are writers.
        int[] idx = Enumerable.Range(0, N).ToArray();
        rng.Shuffle(idx);
        var isWriter = new bool[N];
        for (int i = 0; i < n; i++) isWriter[idx[i]] = true;

        // Create (but don't start) all threads, each with a random start time in [0.00, 1.00] s.
        var threads = new Thread[N];
        var startAt = new double[N];
        for (int i = 0; i < N; i++)
        {
            threads[i] = new Thread(isWriter[i] ? Writer : Reader);
            startAt[i] = rng.Next(0, 101) / 100.0;
        }

        // Start threads in order of their start time; all are started within 1 second.
        int[] byTime = Enumerable.Range(0, N).OrderBy(i => startAt[i]).ToArray();
        var sw = Stopwatch.StartNew();
        foreach (int i in byTime)
        {
            int waitMs = (int)(startAt[i] * 1000 - sw.Elapsed.TotalMilliseconds);
            if (waitMs > 0) Thread.Sleep(waitMs);
            threads[i].Start();
        }

        foreach (var t in threads) t.Join();
        sw.Stop();

        Console.WriteLine($"elapsed time = {sw.Elapsed.TotalSeconds:F2} seconds");
    }
}
