public class Truck extends Car {
    private double m_weight;
    private double weight;

    Truck(double gas, double eff, double m_weight, double weight) {
        super(gas, eff);
        this.m_weight = m_weight;
        this.weight = Math.min(m_weight, weight);
    }

    @Override
    public void drive(double distance) {
        double gasUsed = distance / this.getEfficiency();
        double factor = 1;
        if (weight > 20) {
            factor = 0.3;
        } else if (weight >= 10 && weight < 20) {
            factor = 0.2;
        } else if (weight >= 1 && weight < 10) {
            factor = 0.1;
        }
        gasUsed = gasUsed + (gasUsed * factor);
        if (gasUsed > this.getGas()) {
            System.out.println("You cannot\n" +
                    "drive too far, please add gas");
            return;
        }
        this.setGas(this.getGas() - gasUsed);
    }
}
