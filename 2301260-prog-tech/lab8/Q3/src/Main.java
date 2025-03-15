import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter a positive integer : ");
        int n = sc.nextInt();
        System.out.println("Prime factors of " + n + " are " + primeFactor(n).stream().map(Object::toString)
                .collect(Collectors.joining(",")) + ".");
    }

    public static ArrayList<Integer> primeFactor(int n) {
        HashSet<Integer> factors = new HashSet<>();
        for (int i = 2; i < n; i++) {
            if (n % i == 0) {
                int f = n / i;
                factors.addAll(primeFactor(i));
                factors.addAll(primeFactor(f));
                return new ArrayList<>(factors);
            }
        }
        factors.add(n);
        return new ArrayList<>(factors);
    }
}