public class Question {
    private String text;
    private String answer;

    Question(String questionText) {
        this.text = questionText;
    }

    public String getAnswer() {
        return answer;
    }

    public String getText() {
        return text;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public void setText(String text) {
        this.text = text;
    }

    public boolean checkAnswer(String response) {
        return this.answer.equals(response);
    }

    public void display() {
        System.out.println(this.getText());
    }
}
