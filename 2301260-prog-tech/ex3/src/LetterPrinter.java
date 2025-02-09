public class LetterPrinter {
    Letter letter;

    /**
     * Create a printter that
     * 
     * @param letter
     */
    public LetterPrinter(Letter letter) {
        this.letter = letter;
    }

    /**
     * Print out the formatted letter text
     */
    public void print() {
        System.out.println("\n\n");
        System.out.println(this.letter.getText());
    }
}
