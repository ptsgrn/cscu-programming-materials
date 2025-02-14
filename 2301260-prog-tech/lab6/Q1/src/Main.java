public class Main {
    public static void main(String[] args) {
        Car myCar = new Car(50, 20); // 20 miles per gallon
        myCar.addGas(20); // add into tank 20 gallons
        myCar.drive(100); // drive 100 miles (use 5 gallons)
        System.out.println("Gas left = " + myCar.getGas() + " gallons");
        Truck t = new Truck(50, 20, 15, 20);
        t.drive(100);
        System.out.println("Gas left = " + t.getGas() + " gallons");
        Truck t2 = new Truck(0, 20, 20, 15);
        t2.addGas(5);
        t2.drive(100);
        System.out.println("Gas left = " + t2.getGas() + " gallons");
    }
}