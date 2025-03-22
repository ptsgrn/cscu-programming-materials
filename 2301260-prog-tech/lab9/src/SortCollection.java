import java.util.Objects;

public class SortCollection implements Collection {
    private MyNode startNode;
    private int count;

    public SortCollection() {
        this.startNode = null;
        this.count = 0;
    }

    @Override
    public void add(int data) {
        System.out.println("Add Value: " + data);
        MyNode newNode = new MyNode(data);
        count = 0;

        if (startNode == null) {
            startNode = newNode;
            printList();
            return;
        }

        MyNode prev = null;
        MyNode curr = startNode;
        while (curr != null) {
            count++;
            if (Objects.equals(curr.getData(), data)) {
                System.out.println(data + " has already existed in List");
                return;
            }
            if (data < curr.getData()) {
                if (prev == null) {
                    newNode.setNext(startNode);
                    startNode = newNode;
                } else {
                    prev.setNext(newNode);
                    newNode.setNext(curr);
                }
                System.out.println("count: " + count);
                printList();
                return;
            }
            prev = curr;
            curr = curr.getNext();
        }
        prev.setNext(newNode);
        System.out.println("count: " + count);
        printList();
    }

    @Override
    public void remove(int data) {
        System.out.println("Remove Value: " + data);
        count = 0;
        MyNode curr = startNode;
        MyNode prev = null;

        while (curr != null) {
            count++;
            if (curr.getData() == data) {
                if (prev == null) {
                    startNode = curr.getNext();
                } else {
                    prev.setNext(curr.getNext());
                }
                System.out.println("count: " + (count - 1));
                printList();
                return;
            }
            prev = curr;
            curr = curr.getNext();
        }
        System.out.println("Not Found");
        System.out.println("count: " + count);
    }

    @Override
    public boolean contain(int data) {
        System.out.println("Is " + data + " in the List?");
        count = 0;
        MyNode curr = startNode;
        while (curr != null) {
            count++;
            if (curr.getData() >= data) {
                boolean found = (curr.getData() == data);
                System.out.println(found);
                return found;
            }
            curr = curr.getNext();
        }
        System.out.println(false);
        return false;
    }

    @Override
    public boolean isEmpty() {
        return startNode == null;
    }

    @Override
    public int size() {
        int size = 0;
        MyNode curr = startNode;
        while (curr != null) {
            size++;
            curr = curr.getNext();
        }
        return size;
    }

    public void printList() {
        MyNode curr = startNode;
        while (curr != null) {
            System.out.print(curr.getData() + "\t");
            curr = curr.getNext();
        }
        System.out.println("\n------------------------------------------------");
    }
}
