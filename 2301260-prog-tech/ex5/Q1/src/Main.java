import java.util.Random;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        var magic = new Random().nextInt(100) + 1;
        do {
            System.out.print("Guess magic number: ");
            var guess = sc.nextInt();
            if (guess < magic) System.out.println("Too low");
            if (guess > magic) System.out.println("Too high");
            if (guess == magic) {
                System.out.println("Right");
                break;
            }
        } while (true);
    }
}