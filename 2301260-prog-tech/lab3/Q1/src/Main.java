import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter course ID, credit and grade; or X to terminate");
        String input = sc.nextLine();
        System.out.println(input);
        Double cumulativegrade = 0.0;
        Double weights = 0.0;
        while (!input.equals("X")) {
            var values = input.split(" ");
            cumulativegrade += getNumeric(values[2]) * Double.parseDouble(values[1]);
            weights += Double.parseDouble(values[1]);
            input = sc.nextLine();
            System.out.println(input);
        }
        System.out.println(cumulativegrade);
        System.out.println(weights);
        var gpa = cumulativegrade / weights;
        System.out.println("GPA = " + gpa);
    }

    public static Double getNumeric(String grade) {
        switch (grade) {
            case "A":
                return 4.0;
            case "B+":
                return 3.5;
            case "B":
                return 3.0;
            case "C+":
                return 2.5;
            case "C":
                return 2.0;
            case "D+":
                return 1.5;
            case "D":
                return 1.0;
            case "F":
                return .0;
            default:
                System.out.println(grade + " is not a valid grading.");
                return .0;
        }
    }
}