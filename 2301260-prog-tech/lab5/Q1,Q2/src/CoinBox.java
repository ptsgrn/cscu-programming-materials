public class CoinBox {
    private int value;
    private int amount;

    CoinBox(int value, int amount) {
        this.value = value;
        this.amount = amount;
    }

    public int getAmount() {
        return amount;
    }

    public int getValue() {
        return value;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }
}
