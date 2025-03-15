public class Subject implements Evaluation {
    private String subjName;
    private int[] score;

    Subject(String subjName, int[] score) {
        this.subjName = subjName;
        this.score = score;
    }

    @Override
    public double evaluate() {
        double sum = 0;
        for (var n : score) {
            sum += n;
        }
        return sum / score.length;
    }

    @Override
    public char grade(double score) {
        return score >= 70 ? 'P' : 'F';
    }

    @Override
    public String toString() {
        return this.subjName;
    }
}
