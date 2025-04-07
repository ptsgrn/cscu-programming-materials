public class BinarySearchTree {
    private BTNode root;
    private int count = 0;

    public void add(int data) {
        count += 1;
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

        if (data < preNode.getData()) {
            preNode.setLeft(new BTNode(data));
        } else {
            preNode.setRight(new BTNode(data));
        }
    }

    public boolean contain(int data) {
        BTNode currentNode = this.root;
        boolean isFound = false;

        while (currentNode != null) {
            if (data < currentNode.getData()) {
                currentNode = currentNode.getLeft();
            } else if (data > currentNode.getData()) {
                currentNode = currentNode.getRight();
            } else {
                isFound = true;
                break;
            }
        }

        return isFound;
    }

    public int getMax() {
        BTNode curNode = this.root;
        BTNode preNode = null;
        if (this.root == null) return 0;
        while (curNode != null) {
            preNode = curNode;
            curNode = curNode.getRight();
        }
        return preNode.getData();
    }

    public int nnodes() {
        return count;
    }

    public void remove(int data) {
        this.removeRecursive(root, data);
    }

    private BTNode removeRecursive(BTNode root, int data) {
        if (root == null) return null;
        if (data < root.getData()) {
            root.setLeft(removeRecursive(root.getLeft(), data));
        } else if (data > root.getData()) {
            root.setRight(removeRecursive(root.getRight(), data));
        } else {
            if (root.getLeft() == null) {
                return root.getRight();
            } else if (root.getRight() == null) {
                return root.getLeft();
            }

            root.setData(inorderSuccessor(root.getRight()));
            root.setRight(removeRecursive(root.getRight(), root.getData()));
        }
        count -= 1;

        return root;
    }

    private int inorderSuccessor(BTNode root) {
        int minimum = root.getData();
        while (root.getLeft() != null) {
            minimum = root.getLeft().getData();
            root = root.getLeft();
        }
        return minimum;
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
