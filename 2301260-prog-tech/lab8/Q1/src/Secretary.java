public class Secretary extends Employee implements Evaluation {
    private int typingSpeed;
    private int[] score = new int[2];

    Secretary(String name, int salary, int[] score, int typingSpeed) {
        super(name, salary);
        this.typingSpeed = typingSpeed;
        this.score = score;
    }

    @Override
    public double evaluate() {
        return score[0] + score[1];
    }

    @Override
    public char grade(double score) {
        this.setSalary(18000);
        return score >= 90 ? 'P' : 'F';
    }
}
