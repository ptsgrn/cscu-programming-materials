import java.util.Objects;

public class LinkedCollection implements SortCollection {
    private MyNode head;
    private int count;

    public LinkedCollection() {
        this.head = null;
        this.count = 0;
    }

    public void add(int data) {
        System.out.println("Add Value: " + data);
        MyNode newNode = new MyNode(data);

        if (head == null) {
            head = newNode;
            printNodes();
            count++;
            return;
        }

        MyNode prev = null;
        MyNode curr = head;

        while (curr != null) {
            if (Objects.equals(curr.getData(), data)) {
                System.out.println(data + " has already existed in List");
                printNodes();
                count++;
                return;
            }
            if (data < curr.getData()) {
                if (prev == null) {
                    newNode.setNext(head);
                    head = newNode;
                } else {
                    prev.setNext(newNode);
                    newNode.setNext(curr);
                }
                System.out.println("count: " + count);
                printNodes();
                count++;
                return;
            }
            prev = curr;
            curr = curr.getNext();
        }
        prev.setNext(newNode);
        System.out.println("count: " + count);
        count++;
        printNodes();
    }

    public void remove() {
        if (count <= 1) {
            System.out.println("not enough elements");
            return;
        }

        if (count == 2) {
            this.head = null;
            this.count = 0;
        }

        int accessCount = 0;
        MyNode curr = head;
        MyNode prev = null;

        while (curr != null) {
            accessCount++;

            if (accessCount == 2) {
                prev.setNext(curr.getNext());
                this.count--;
                continue;
            }

            if (curr.getNext().getNext() == null) {
                prev.setNext(curr.getNext());
                this.count--;
                break;
            }

            prev = curr;
            curr = curr.getNext();
        }

        System.out.println("Remove Second Min & Max");

        printNodes();
    }

    public void printNodes() {
        System.out.print(printNodes(this.head));
    }

    public String printNodes(MyNode node) {
        if (node == null) return "null\n";
        return node.getData() + " -> " + printNodes(node.getNext());
    }
}