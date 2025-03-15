import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter x and y : ");
        int b = sc.nextInt();
        int p = sc.nextInt();

        System.out.println(power(b, p));
    }

    public static int power(int b, int p) {
        if (p == 0) return 1;
        if (p % 2 == 0) {
            int m = power(b, p / 2);
            return m * m;
        } else {
            return b * power(b, p - 1);
        }
    }
}