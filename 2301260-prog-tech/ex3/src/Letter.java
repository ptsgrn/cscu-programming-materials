import java.util.ArrayList;
import java.util.List;

public class Letter {
    /**
     * Who send this letter
     */
    private final String from;
    /**
     * Who receive this letter
     */
    private final String to;
    /**
     * List of letter lines
     */
    private final List<String> texts;

    /**
     * Create a letter
     * 
     * @param from Who send this letter
     * @param to   Who will receive this letter
     */
    Letter(String from, String to) {
        this.from = from;
        this.to = to;
        this.texts = new ArrayList<>();
    }

    /**
     * Add a new line to letter text
     * 
     * @param line
     */
    public void addLine(String line) {
        this.texts.add(line);
    }

    /**
     * Get formatted letter text
     * 
     * @return
     */
    public String getText() {
        StringBuilder sb = new StringBuilder();
        sb.append("Dear ").append(this.to).append(": \n\n");
        sb.append(String.join("\n", this.texts));
        sb.append("\n\nSincerely,\n").append("\n").append(this.from);
        return sb.toString();
    }
}
