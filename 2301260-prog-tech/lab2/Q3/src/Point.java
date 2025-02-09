import java.util.Objects;

public class Point {
    public Double x;
    public Double y;

    public Point(Double x, Double y) {
        this.x = x;
        this.y = y;
    }

    public Double distance(Point p2) {
        return Math.sqrt(Math.pow(p2.x - this.x, 2) + Math.pow(p2.y - this.y, 2));
    }

    public void translate(Double dx, Double dy) {
        this.x += dx;
        this.y += dy;
    }

    public Boolean equals(Point p2) {
        return (Objects.equals(this.x, p2.x) && Objects.equals(this.y, p2.y));
    }

    public String toString() {
        return ("(" + this.x + "," + this.y + ")");
    }
}
