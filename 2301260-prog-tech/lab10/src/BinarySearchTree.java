public class BinarySearchTree {
    private BTNode root;

    public void add(int data) {
        if (this.root == null) {
            this.root = new BTNode(data);
            return;
        }
        BTNode currentNode = this.root;
        BTNode preNode = null;

        while (currentNode != null) {
            preNode = currentNode;
            if (data < currentNode.getData()) {
                currentNode = currentNode.getLeft();
            } else {
                currentNode = currentNode.getRight();
            }
        }

        if (preNode != null) {
            if (data < preNode.getData()) {
                preNode.setLeft(new BTNode(data));
            } else {
                preNode.setRight(new BTNode(data));
            }
        }
    }

    public void printTree() {
        inorder(root);
    }

    public void inorder(BTNode node) {
        if (node == null) return;
        inorder(node.getLeft());
        System.out.print(node.getData() + "\t");
        inorder(node.getRight());
    }
}
