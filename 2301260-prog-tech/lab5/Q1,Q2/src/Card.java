public class Card {
    private int cardID;
    private int amount;
    private static int count;
    private static final int MINVALUE = 10;

    Card(int amount) {
        this.amount = amount;
        count += 1;
        cardID = count;
    }

    public void addMoney(int amount) {
        this.amount += amount;
    }

    public boolean pay(int amount) {
        if ((this.amount - amount) > MINVALUE) {
            this.amount -= amount;
            return true;
        }
        return false;
    }

    public int getCardID() {
        return cardID;
    }

    public int getAmount() {
        return amount;
    }
}
