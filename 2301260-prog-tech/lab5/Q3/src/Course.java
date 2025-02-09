public class Course {
    private String cid;
    private String name;
    private int credit;

    Course(String cid, String name, int credit) {
        this.cid = cid;
        this.name = name;
        this.credit = credit;
    }

    public String getCid() {
        return cid;
    }

    public String getName() {
        return name;
    }

    public int getCredit() {
        return credit;
    }
}
