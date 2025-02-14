import java.util.ArrayList;

public class ChoiceQuestion extends Question {
    private ArrayList<String> choices = new ArrayList<>();

    public ChoiceQuestion(String questionText) {
        super(questionText);
    }

    public void addChoice(String choice, boolean correct) {
        this.choices.add(choice);
        if (correct) {
            this.setAnswer(choice);
        }
    }

    @Override
    public void display() {
        System.out.println(this.getText());
        for (int i = 0; i < this.choices.size(); i++) {
            System.out.println((i + 1) + ": " + this.choices.get(i));
        }
    }

    @Override
    public boolean checkAnswer(String response) {
        int parsedSelection = Integer.parseInt(response);
        if (parsedSelection < 1 || parsedSelection > this.choices.size()) {
            System.out.println("Response not in a valid range");
        }
        return this.choices.get(parsedSelection - 1).equals(this.getAnswer());
    }
}
