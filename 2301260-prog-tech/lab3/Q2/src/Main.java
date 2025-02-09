import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Student 1: Enter ID, name, major");
        String[] v1 = sc.nextLine().split(" ");
        Student s1 = new Student(v1[0], v1[1] + " " + v1[2], v1[3]);

        System.out.println("Student 2: Enter ID, name, major");
        String[] v2 = sc.nextLine().split(" ");

        Student s2 = new Student();
        s2.setID(v2[0]);
        s2.setName(v2[1] + " " + v2[2]);
        s2.setMajor(v2[3]);

        System.out.println("Student 1: " + s1);
        System.out.println("Student 2: " + s2);

        System.out.println(
                (s1.sameYear(s2) ? "Same" : "Different") + " year, "
                        + (s1.sameLevel(s2) ? "same" : "different") + " level, "
                        + (s1.sameFaculty(s2) ? "same" : "different") + " faculty"
        );
    }
}