public class Main {
    public static void main(String[] args) {
        Cup myCup = new Cup();  // Create a cup with a maximum volume of 300
        myCup.add(150.0);  // Add 150 units of liquid
        myCup.add(200.0);  // Attempt to add 200 units of liquid (overflow scenario)

    }
}