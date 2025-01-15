public class LetterPrinter {
    Letter letter;

    public LetterPrinter(Letter letter) {
        this.letter = letter;
    }

    public void print() {
        System.out.println("\n\n");
        System.out.println(this.letter.getText());
    }
}
