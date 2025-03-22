public class MyNode {
    private Integer data;
    private MyNode next = null;

    public MyNode(Integer obj) {
        this.data = obj;
    }

    public MyNode getNext() {
        return this.next;
    }

    public void setNext(MyNode next) {
        this.next = next;
    }

    public void setData(Integer data) {
        this.data = data;
    }

    public Integer getData() {
        return data;
    }
}
