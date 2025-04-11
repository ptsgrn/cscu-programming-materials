public interface SortCollection {
    int count = 0;
    MyNode head = null;

    public void add(int data);

    public void remove();

    public void printNodes();

    public String printNodes(MyNode node);
}
