
import java.util.Scanner;

public abstract class Main {
  public static void main(String[] args) {
    System.out.print("Enter firstname lastname age: ");
    try (Scanner scanner = new Scanner(System.in)) {
      String firstname = scanner.next();
      String lastname = scanner.next();
      Integer age = scanner.nextInt();
      StringBuilder sb = new StringBuilder();
      sb.append(lastname)
          .append(", ")
          .append(firstname)
          .append(" is ")
          .append(age)
          .append(" years old.");
      System.out.println(sb.toString());
    }
  }
}
