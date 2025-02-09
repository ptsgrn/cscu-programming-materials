import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class VendingMachine {
    private ArrayList<DrinkBox> drinkList = new ArrayList<DrinkBox>();
    private ArrayList<CoinBox> coinList = new ArrayList<CoinBox>();
    private int revenue;

    public VendingMachine() {
        drinkList.add(new DrinkBox("Coke", 13, 2));
        drinkList.add(new DrinkBox("Sprite", 13, 2));
        drinkList.add(new DrinkBox("GreenTea", 20, 2));
        drinkList.add(new DrinkBox("Water", 10, 2));
        drinkList.add(new DrinkBox("MinuteMaid", 18, 2));
        drinkList.add(new DrinkBox("Pepsi", 13, 2));
        drinkList.add(new DrinkBox("Vitamilk", 15, 2));
        drinkList.add(new DrinkBox("RootBeer", 13, 2));
        coinList.add(new CoinBox(1, 20));
        coinList.add(new CoinBox(2, 20));
        coinList.add(new CoinBox(5, 10));
        coinList.add(new CoinBox(10, 0));
    }

    public String buy(String name, Card c) {
        // Filter the drink list and collect into a list
        List<DrinkBox> foundDrinks = this.drinkList.stream().filter(d -> d.getName().equals(name)).collect(Collectors.toList());

        if (foundDrinks.isEmpty()) {
            return "Drink not found";
        }

        DrinkBox selectedDrink = foundDrinks.get(0);

        if (selectedDrink.getAmount() <= 0) {
            return "Out of stock";
        }

        // Validate card ID
        if (c.getCardID() <= 0 || c.getCardID() >= 100) {
            return "Invalid card";
        }

        // Check payment
        if (!c.pay(selectedDrink.getPrice())) {
            return "Not enough money";
        }

        // Update stock
        for (DrinkBox drinkBox : this.drinkList) {
            if (drinkBox.getName().equals(name)) {
                drinkBox.setAmount(drinkBox.getAmount() - 1);
            }
        }
        this.revenue += selectedDrink.getPrice();
        return "Thank you";
    }

    public String buy(String name, ArrayList<Integer> coinValue) {
        // Filter the drink list and collect into a list
        List<DrinkBox> foundDrinks = this.drinkList.stream().filter(d -> d.getName().equals(name)).collect(Collectors.toList());

        if (foundDrinks.isEmpty()) {
            return "Drink not found";
        }

        DrinkBox selectedDrink = foundDrinks.get(0);

        if (selectedDrink.getAmount() <= 0) {
            return "Out of stock";
        }

        int sumCoinValue = (int) coinValue.stream().mapToLong(Integer::longValue).sum();

        // Check payment
        if (sumCoinValue < selectedDrink.getPrice()) {
            return "Not enough money";
        }
        // Update stock
        for (DrinkBox drinkBox : this.drinkList) {
            if (drinkBox.getName().equals(name)) {
                drinkBox.setAmount(drinkBox.getAmount() - 1);
            }
        }
        this.revenue += selectedDrink.getPrice();
        int remainingAmount = sumCoinValue - selectedDrink.getPrice();
        List<CoinBox> currentCoin = this.coinList.stream().sorted(Comparator.comparing(CoinBox::getValue).reversed()).collect(Collectors.toList());
        ArrayList<CoinBox> exchangeCoins = new ArrayList<>();
        for (CoinBox coin : currentCoin) {
            var count = Math.min(coin.getAmount(), Math.floor(remainingAmount / coin.getValue()));
            remainingAmount -= count * coin.getValue();
            if (count != 0) exchangeCoins.add(new CoinBox(coin.getValue(), (int) count));
        }

        if (remainingAmount != 0) {
            return "Cannot give change";
        }

        this.revenue += sumCoinValue - remainingAmount;

        for (CoinBox coin : exchangeCoins) {
            for (CoinBox coinBox : this.coinList) {
                if (coinBox.getValue() == coin.getValue()) {
                    coinBox.setAmount(coinBox.getAmount() - coin.getAmount());
                }
            }
        }

        return "Thank you\n" + formatExchange(exchangeCoins);
    }

    private String formatExchange(ArrayList<CoinBox> coins) {
        String result = "Exchange:\n";
        for (CoinBox coin : coins) {
            result += " -> ฿" + coin.getValue() + ": " + coin.getAmount() + "\n";
        }
        return result;
    }

    @Override
    public String toString() {
        return this.getDrinkDetail() + "\nCoin Stored:\n -> " + this.coinList.stream().map(o -> "฿" + o.getValue() + ": " + o.getAmount()).collect(Collectors.joining("\n -> "));
    }

    public void endOfDayProcess() {
        this.drinkList = new ArrayList<>();
        drinkList.add(new DrinkBox("Coke", 13, 2));
        drinkList.add(new DrinkBox("Sprite", 13, 2));
        drinkList.add(new DrinkBox("GreenTea", 20, 2));
        drinkList.add(new DrinkBox("Water", 10, 2));
        drinkList.add(new DrinkBox("MinuteMaid", 18, 2));
        drinkList.add(new DrinkBox("Pepsi", 13, 2));
        drinkList.add(new DrinkBox("Vitamilk", 15, 2));
        drinkList.add(new DrinkBox("RootBeer", 13, 2));
        this.revenue = 0;
    }

    public int getRevenue() {
        return this.revenue;
    }

    public String getDrinkDetail() {
        String result = "**********************\n";
        for (DrinkBox drink : this.drinkList) {
            result += drink.getName() + " " + drink.getPrice() + " " + drink.getAmount();
            result += "\n";
        }
        return result;
    }
}