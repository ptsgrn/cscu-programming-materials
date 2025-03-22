public class Main {
    public static void main(String[] args) {
        SortCollection list = new SortCollection();

        //  4.1
        list.add(20);
        list.add(30);

        // 4.2
        list.add(15);
        list.add(25);
        list.add(30);
        list.add(40);

        // 4.3
        list.contain(30);

        // 4.4
        list.contain(28);

        // 4.5
        list.remove(15);
        list.remove(25);
        list.remove(40);

        // 4.6
        list.remove(35);
    }
}