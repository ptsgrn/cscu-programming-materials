import java.util.Arrays;
import java.util.Scanner;

public abstract class Main {
  public static void main(String[] args) {
    try (Scanner sc = new Scanner(System.in)) {
      System.out.print("First point : ");
      Double[] p1 = readline(sc);
      System.out.print("Second point : ");
      Double[] p2 = readline(sc);
      System.out.print("Third point : ");
      Double[] p3 = readline(sc);
      System.out.print("Fourth point : ");
      Double[] p4 = readline(sc);

      System.out.println("The centroid is ( "
          + centroid(p1[0], p2[0], p3[0], p4[0])
          + ", "
          + centroid(p1[1], p2[1], p3[1], p4[1])
          + " ).");

      Double sumDistance = sumDistance(p1, p2, p3, p4);
      System.out.println("Sum of distance is " + sumDistance.toString() + ".");
      Double[] sortedList = sorted(p1, p2, p3, p4);
      System.out.println("Shortest distance is " + sortedList[0] + ".");
      System.out.println("Longest distance is " + sortedList[sortedList.length - 1] + ".");
    }
  }

  static Double[] readline(Scanner sc) {
    String line = sc.nextLine();
    String[] splittedValue = line.split(" ");
    var x = Double.valueOf(splittedValue[0].trim());
    var y = Double.valueOf(splittedValue[1].trim());
    Double[] num = { x, y };
    return num;
  }

  static Double centroid(Double x1, Double x2, Double x3, Double x4) {
    return (x1 + x2 + x3 + x4) / 4;
  }

  static Double[] getCentroid(Double[] p1, Double[] p2, Double[] p3, Double[] p4) {
    Double[] centroid = { centroid(p1[0], p2[0], p3[0], p4[0]), centroid(p1[1], p2[1], p3[1], p4[1]) };
    return centroid;
  }

  static Double sumDistance(Double[] p1, Double[] p2, Double[] p3, Double[] p4) {
    Double[] centroid = getCentroid(p1, p2, p3, p4);
    Double sum = pairDistance(centroid, p1) + pairDistance(centroid, p2) + pairDistance(centroid, p3)
        + pairDistance(centroid, p4);
    return sum;
  }

  static Double pairDistance(Double[] p1, Double[] p2) {
    Double distance = Math.sqrt(Math.pow(p2[0] - p1[0], 2) + Math.pow(p2[1] - p1[1], 2));
    return distance;
  }

  static Double[] sorted(Double[] p1, Double[] p2, Double[] p3, Double[] p4) {
    Double[] centroid = getCentroid(p1, p2, p3, p4);
    Double[] distances = { pairDistance(centroid, p1), pairDistance(centroid, p2), pairDistance(centroid, p3),
        pairDistance(centroid, p4) };
    Arrays.sort(distances);
    return distances;
  }
}
