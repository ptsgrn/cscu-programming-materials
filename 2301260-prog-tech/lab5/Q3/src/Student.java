import java.util.ArrayList;

public class Student {
    private String sid;
    private String firstname;
    private String lastname;
    private ArrayList<CourseGrade> transcript = new ArrayList<>();

    Student(String sid, String firstname, String lastname) {
        this.sid = sid;
        this.firstname = firstname;
        this.lastname = lastname;
    }

    public String getName() {
        return firstname + " " + lastname;
    }

    public void addGradeReport(Course c, String g) {
        this.transcript.add(new CourseGrade(c, g));
    }

    public Double calGPA() {
        double sum = this.transcript.stream().mapToDouble(o -> o.getNumericGrade() * o.getCourse().getCredit()).sum();
        double weightsSum = this.transcript.stream().mapToDouble(o -> o.getCourse().getCredit()).sum();
        return weightsSum == 0 ? 0.0 : sum / weightsSum;
    }

    public String report() {
        return "\n------ Transcript ------\n"
                + " " + sid + " " + getName() + "\n"
                + gradeReports()
                + "  GPA: " + String.format("%.2f", calGPA());
    }

    private String gradeReports() {
        StringBuilder report = new StringBuilder();
        for (CourseGrade cg : this.transcript) {
            report.append(cg.report()).append("\n");
        }
        return report.toString();
    }
}
