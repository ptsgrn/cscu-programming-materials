import java.util.Scanner;

public class Main {
    public static void main(String args[]) {
        Scanner sc = new Scanner(System.in);
        String input = "DUMMY";
        CourseRegister course = new CourseRegister(2301260);
        while (true) {
            System.out.println("Enter ID, name, major:");
            input = sc.nextLine().strip();
            System.out.println(input);
            if (input.equals("X")) break;
            String[] parsed = input.split(" ");
            Student student = new Student(parsed[0], parsed[1] + " " + parsed[2], parsed[3]);
            course.register(student);
        }

        // Print all student registered
        course.printReg();

        System.out.println("Drop student -> Enter ID of the student:");
        String droppingStudent = sc.nextLine();
        course.drop(droppingStudent);

        course.printReg();
    }
}