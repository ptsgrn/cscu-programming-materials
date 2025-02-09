import java.util.ArrayList;

public class CourseRegister {
    private int id;
    private ArrayList<Student> students;

    public CourseRegister(int id) {
        this.id = id;
        this.students = new ArrayList<Student>();
    }

    public boolean register(Student student) {
        if (this.students.contains(student)) return false;
        this.students.add(student);
        System.out.println(student.sid + " REGISTERED SUCCESSFULLY");
        return true;
    }

    public boolean drop(String sid) {
        Student[] foundStudent = (Student[]) this.students
                .stream()
                .filter(s -> s.sid.equals(sid))
                .toArray(Student[]::new);
        if (foundStudent.length == 0) {
            System.out.println(sid + " NOT REGISTERED");
            return false;
        }
        for (Student student : foundStudent) {
            this.students.remove(student);
        }
        System.out.println(sid + " DROPPED SUCCESSFULLY");
        return true;
    }

    public void printReg() {
        System.out.println(this.id);
        for (Student student : this.students) {
            System.out.println(student.sid + " " + student.name);
        }
        System.out.println("Total students in this course: " + this.students.toArray().length);
    }
}
