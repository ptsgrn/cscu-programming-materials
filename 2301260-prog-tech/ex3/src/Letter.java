import java.util.ArrayList;
import java.util.List;

public class Letter {
    private final String from;
    private final String to;
    private final List<String> texts;

    Letter(String from, String to) {
        this.from = from;
        this.to = to;
        this.texts = new ArrayList<>();
    }

    public void addLine(String line) {
        this.texts.add(line);
    }

    public String getText() {
        StringBuilder sb = new StringBuilder();
        sb.append("Dear ").append(this.to).append(": \n\n");
        sb.append(String.join("\n", this.texts));
        sb.append("\n\nSincerely,\n").append("\n").append(this.from);
        return sb.toString();
    }
}
