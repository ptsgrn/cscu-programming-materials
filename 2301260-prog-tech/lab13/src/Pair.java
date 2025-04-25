public class Pair<T, U> {
    private T firstValue;
    private U secondValue;

    public Pair(T firstValue, U secondValue) {
        this.firstValue = firstValue;
        this.secondValue = secondValue;
    }

    public T getFirst() {
        return firstValue;
    }

    public U getSecond() {
        return secondValue;
    }

    public void setFirst(T firstValue) {
        this.firstValue = firstValue;
    }

    public void setSecond(U secondValue) {
        this.secondValue = secondValue;
    }

    public void merge(T firstValue) {
        this.firstValue = firstValue;
    }
}
