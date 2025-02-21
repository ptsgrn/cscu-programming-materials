public abstract class Taylor {
    private int k;
    private double x;

    Taylor(int k, double x) {
        this.k = k;
        this.x = x;
    }

    public static int factorial(int number) {
        int result = 1;

        for (int factor = 2; factor <= number; factor++) {
            result *= factor;
        }

        return result;
    }

    public int getIteration() {
        return this.k;
    }

    public double getValue() {
        return this.x;
    }

    public abstract void printValue();

    public abstract double getApprox();
}
