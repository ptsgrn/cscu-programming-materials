import java.sql.Array;
import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter n: ");
        int n = sc.nextInt();
        var nthPrimes = run(n);
        for (Integer i : nthPrimes) {
            System.out.println(i);
        }
    }

    public static ArrayList<Integer> run(int n) {
        ArrayList<Integer> primes = new ArrayList<Integer>();
        if (n == 0) return primes;
        primes.add(2);
        int i = 2;
        while (true) {
            if (primes.toArray().length >= n) break;
            boolean isPrime = true;
            for (int j : primes) {
                if (i % j == 0) {
                    isPrime = false;
                    break;
                }
            }
            if (isPrime) primes.add(i);
            i++;
        }
        return primes;
    }
}