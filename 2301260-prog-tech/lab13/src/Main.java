public class Main {
    public static void main(String[] args) {
        Pair<String, String> p1 = new Pair<>("John", "Smith");
        Pair<String, Integer> p2 = new Pair<>("Wick", 67);
        System.out.println(p1.getFirst());
        p1.merge(p2.getFirst());
        System.out.println(p1.getFirst());

        System.out.println("--------------------------");

        Pair<String, Integer> p3 = new Pair<>("John", 32);
        System.out.println(p3.getFirst());
        p3.setFirst("Loki");
        System.out.println(p3.getFirst());
        p3.setSecond(4);
        System.out.println(p3.getSecond());
    }
}