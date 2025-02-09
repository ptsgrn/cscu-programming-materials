import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        ArrayList<Course> courses = new ArrayList<>();
        ArrayList<Student> students = new ArrayList<>();

        Scanner sc = new Scanner(System.in);
        System.out.print("Enter 3 student ID and name:\n");
        for (int i = 0; i < 3; i++) {
            students.add(inputStudent(sc));
        }

        System.out.print("Enter 5 course ID, name, and credits:\n");
        for (int i = 0; i < 5; i++) {
            courses.add(inputCourse(sc));
        }

        for (Student s : students) {
            String input = "";
            System.out.println(s.getName() + " grade report:");
            while (true) {
                input = sc.nextLine().strip();
                if (input.toUpperCase().equals("X")) break;
                String[] parsedInput = input.split(" ");

                s.addGradeReport(getCourse(courses, parsedInput[0]), parsedInput[1]);
            }
        }

        for (Student s : students) {
            System.out.println(s.report());
        }
    }

    public static Student inputStudent(Scanner sc) {
        String[] input = sc.nextLine().split(" ");
        return new Student(input[0], input[1], input[2]);
    }

    public static Course inputCourse(Scanner sc) {
        String _input = sc.nextLine().strip();
        String[] input = _input.split(" ");
        String code = input[0];
        String name = String.join(" ", Arrays.copyOfRange(input, 1, input.length - 1));
        int credits;

        try {
            credits = Integer.parseInt(input[input.length - 1]); // Convert last element to integer
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid credit value. It must be an integer.");
        }

        return new Course(code, name, credits);
    }


    public static Course getCourse(ArrayList<Course> courses, String cid) {
        return courses.stream().filter(c -> c.getCid().equals(cid)).findFirst().get();
    }
}