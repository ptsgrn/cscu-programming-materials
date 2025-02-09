import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // read input
        System.out.print("Enter n: ");
        int n = sc.nextInt();
        ArrayList<Integer> primes = new ArrayList<Integer>();
        for (int i = 2; i <= n; i++) {
            boolean isPrime = true;
            for (int prime : primes) {
                if (i / 2 < prime) break;
                if (i % prime == 0) {
                    isPrime = false;
                    break;
                }
            }
            if (isPrime) primes.add(i);
        }

        for (int p : primes) {
            System.out.println(p);
        }
    }
}