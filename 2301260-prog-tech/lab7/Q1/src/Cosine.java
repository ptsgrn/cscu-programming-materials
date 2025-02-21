public class Cosine extends Taylor {
    Cosine(int k, double x) {
        super(k, x);
    }

    @Override
    public double getApprox() {
        double approx = 0;
        double x = this.getValue();
        int it = this.getIteration();
        for (int n = 0; n < it; n++) {
            approx += Math.pow(-1, n) * Math.pow(x, 2 * n) / factorial(2 * n);
        }
        return approx;
    }

    @Override
    public void printValue() {
        System.out.println("Value from Math.cos() is " + Math.cos(this.getValue()));
        System.out.println("Approximated value is " + getApprox());
    }
}
