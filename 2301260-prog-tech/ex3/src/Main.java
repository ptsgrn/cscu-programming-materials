import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        System.out.println(String.join("##", args));
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Enter from: ");
            String from = scanner.nextLine();
            System.out.print("Enter to: ");
            String to = scanner.nextLine();
            Letter letter = new Letter(from, to);

            while (true) {
                System.out.print("Enter line: ");
                String line = scanner.nextLine();
                if ("".equals(line)) {
                    break;
                }
                letter.addLine(line);
            }

            LetterPrinter printer = new LetterPrinter(letter);
            printer.print();
        }
    }
}
