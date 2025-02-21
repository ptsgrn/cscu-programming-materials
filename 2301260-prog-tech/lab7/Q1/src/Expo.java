public class Expo extends Taylor {
    Expo(int k, double x) {
        super(k, x);
    }

    @Override
    public double getApprox() {
        double approx = 0;
        double x = this.getValue();
        int it = this.getIteration();
        for (int i = 0; i < it; i++) {
            approx += Math.pow(x, i) / factorial(i);
        }
        return approx;
    }

    @Override
    public void printValue() {
        System.out.println("Value from Math.exp() is " + Math.exp(this.getValue()));
        System.out.println("Approximated value is " + getApprox());
    }
}
