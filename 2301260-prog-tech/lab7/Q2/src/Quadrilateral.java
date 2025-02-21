import java.awt.Point;
import java.util.ArrayList;
import java.util.Arrays;

public abstract class Quadrilateral {
    private Point a, b, c, d;

    public Quadrilateral(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) {
        a = new Point(x1, y1);
        b = new Point(x2, y2);
        c = new Point(x3, y3);
        d = new Point(x4, y4);
    }

    public double[] getSortedDist() {
        var distances = new double[6];
        distances[0] = a.distance(b);
        distances[1] = b.distance(c);
        distances[2] = c.distance(d);
        distances[3] = d.distance(a);
        distances[4] = a.distance(c);
        distances[5] = b.distance(d);
        return sort(distances);
    }

    public double[] sort(double[] a) {
        for (int i = 0; i < a.length; i++) {
            var item = a[i];
            int cmpPos = i - 1;
            while (cmpPos >= 0 && item < a[cmpPos]) {
                a[cmpPos + 1] = a[cmpPos];
                cmpPos = cmpPos - 1;
            }
            a[cmpPos + 1] = item;
        }
        return a;
    }

    @Override
    public String toString() {
        return a.toString() + "\n" + b.toString() + "\n" + c.toString() + "\n" + d.toString();
    }

    public abstract double area();
}
