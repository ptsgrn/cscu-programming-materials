public class Student {
    public String name;
    public String sid;
    public String major;

    public Student() {
    }

    public Student(String sid, String name, String major) {
        this.name = name;
        this.sid = sid;
        this.major = major;
    }

    public void setID(String sid) {
        this.sid = sid;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public boolean equals(Student s2) {
        return this.name.equals(s2.name) && this.sid.equals(s2.sid) && this.major.equals(s2.major);
    }

    public String toString() {
        return this.sid + " " + this.name + " " + this.major;
    }

    public int getFacultyCode() {
        return getDigit(8, 9);
    }

    public int getLevelCode() {
        return getDigit(2, 2);
    }

    public int getYear() {
        return getDigit(0, 1);
    }

    public boolean sameYear(Student s2) {
        return this.getYear() == s2.getYear();
    }

    public boolean sameLevel(Student s2) {
        return this.getLevelCode() == s2.getLevelCode();
    }

    public boolean sameFaculty(Student s2) {
        return this.getFacultyCode() == s2.getFacultyCode();
    }

    public int getDigit(Integer s, Integer e) {
        return Integer.parseInt(this.sid.substring(s, e + 1));
    }
}
