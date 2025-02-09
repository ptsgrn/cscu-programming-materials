public class CourseGrade {
    private Course course;
    private String grade;

    public CourseGrade(Course c, String g) {
        this.course = c;
        this.grade = g;
    }

    public Course getCourse() {
        return course;
    }

    public String getGrade() {
        return grade;
    }

    public String report() {
        return course.getCid() + " " + course.getName() + " " + course.getCredit() + " " + getGrade();
    }

    public Double toNumericGrade(String g) {
        return switch (g) {
            case "A" -> 4.0;
            case "B+" -> 3.5;
            case "B" -> 3.0;
            case "C+" -> 2.5;
            case "C" -> 2.0;
            case "D+" -> 1.5;
            case "D" -> 1.0;
            default -> 0.0;
        };
    }

    public Double getNumericGrade() {
        return toNumericGrade(grade);
    }
}
