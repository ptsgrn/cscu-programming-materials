import java.util.Random;

public class Main {
    public static void main(String[] args) {
        Mtx ma = new Mtx(10, 5);
        Mtx mb = new Mtx(10, 5);
        Mtx mc = new Mtx(5, 3);

        ma.setValues(generateRandomArray(10, 5));
        mb.setValues(generateRandomArray(10, 5));
        mc.setValues(generateRandomArray(5, 3));

        System.out.println("A =");
        printArray(ma.getValues());
        System.out.println("\nB =");
        printArray(mb.getValues());
        System.out.println("\nC =");
        printArray(mc.getValues());

        System.out.println("A + B =");
        printArray(ma.add(mb));

        System.out.println("B * 2 =");
        printArray(mb.mul(2));

        System.out.println("A * B =");
        printArray(ma.mul(mb));

        System.out.println("A * C =");
        printArray(ma.mul(mc));
    }

    public static int[][] generateRandomArray(int rows, int cols) {
        Random rand = new Random();
        int[][] array = new int[rows][cols];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                array[i][j] = rand.nextInt(201) - 100; // Random number from -100 to 100
            }
        }
        return array;
    }

    public static void printArray(int[][] array) {
        if (!(array instanceof int[][])) return;
        for (int[] row : array) {
            for (int value : row) {
                System.out.printf("%7d", value);
            }
            System.out.println();
        }
    }
}