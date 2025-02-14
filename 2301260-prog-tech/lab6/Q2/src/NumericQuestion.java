public class NumericQuestion extends Question {
    NumericQuestion(String questionText) {
        super(questionText);
    }

    @Override
    public boolean checkAnswer(String response) {
        try {
            double parsedResponse = Double.parseDouble(response);
            return (parsedResponse - Double.parseDouble(this.getAnswer())) < 0.01;
        } catch (NumberFormatException e) {
            throw new RuntimeException("You should answer a correct numeric reponse.");
        }
    }
}
