import java.util.Arrays;
import java.util.Scanner;
import java.util.stream.Stream;

public class Main {
    public static void main(String[] args) {
        var sc = new Scanner(System.in);
        var p1 = inputPoint(sc, "A");
        var p2 = inputPoint(sc, "B");
        System.out.println("A = " + p1 + " B = " + p2 + " Distance = " + p1.distance(p2));
        var move = inputMovePoint(sc);
        p1.translate(move[0], move[1]);
        p2.translate(move[0], move[1]);
        System.out.println("A = " + p1 + " B = " + p2 + " Distance = " + p1.distance(p2));
        System.out.println("A and B are " + (p1.equals(p2) ? "" : "not ") + "at the same position.");
    }

    private static Double[] readline(Scanner sc, String prompt) {
        System.out.print(prompt);
        return Arrays.stream(
                        sc.nextLine().strip().split(" ")
                )
                .map(Double::parseDouble)
                .toArray(Double[]::new);
    }

    private static Point inputPoint(Scanner sc, String point) {
        var r2 = readline(sc, "point " + point + ": ");
        return new Point(r2[0], r2[1]);
    }

    private static Double[] inputMovePoint(Scanner sc) {
        System.out.print("Move the point: ");
        return Arrays.stream(
                        sc.nextLine().split(" ")
                )
                .map(Double::parseDouble)
                .toArray(Double[]::new);
    }
}

