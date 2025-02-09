import java.util.Random;
import java.util.Scanner;

public class Game {
    public static final int ROCK = 0;
    public static final int PAPER = 1;
    public static final int SCISSOR = 2;

    private int userScore = 0;
    private int comScore = 0;

    public void play() {
        Scanner sc = new Scanner(System.in);
        Random rand = new Random();

        boolean isEnd = false;
        while (!isEnd) {
            final int computerMind = rand.nextInt(3);
            String input = this.askInput(sc);
            if (!validateInput(input))
                continue;
            int parsedInput = Integer.parseInt(input);
            int winIfMatch = getWin(computerMind);

            System.out.println("You enter: " + choiseToString(parsedInput));
            System.out.println("Computer: " + choiseToString(computerMind));
            
            if (parsedInput == computerMind) {
                System.out.println("It's a tie.");
            } else if (parsedInput == winIfMatch) {
                userScore += 1;
                System.out.println("You win!");
            } else {
                comScore += 1;
                System.out.println("You lose!");
            }

            isEnd = Math.abs(this.userScore - this.comScore) >= 2;

            if (isEnd) {
                System.out.println("----------------------------------------");
                if (userScore < comScore) {
                    System.out.println("Too bad! You lose.");
                } else {
                    System.out.println("Congrats! You win.");
                }
                System.out.println("User Score: " + userScore);
                System.out.println("Computer score: " + comScore);
            }
        }
    }

    private int getWin(int input) {
        return switch (input) {
            case Game.PAPER -> Game.SCISSOR;
            case Game.SCISSOR -> Game.ROCK;
            case Game.ROCK -> Game.PAPER;
            default -> -1;
        };
    }

    private String askInput(Scanner sc) {
        System.out.print("Enter 0 for ROCK, 1 for PAPER, 2 for SCISSORS: ");
        return sc.nextLine().strip();
    }

    private boolean validateInput(String input) {
        return input.equals("0") || input.equals("1") || input.equals("2");
    }

    private String choiseToString(int selectedOption) {
        return switch (selectedOption) {
            case Game.PAPER -> "PAPER";
            case Game.SCISSOR -> "SCISSOR";
            case Game.ROCK -> "ROCK";
            default -> "";
        };
    }
}
