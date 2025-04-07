public class Main {
    public static void main(String[] args) {
        BinarySearchTree tree = new BinarySearchTree();
        tree.add(9);
        tree.add(2);
        tree.add(12);
        tree.add(1);
        tree.add(5);
        tree.add(10);
        tree.add(15);
        System.out.println("nnodes: "+tree.nnodes());
        System.out.println("Max: "+tree.getMax());
        System.out.println("Is 12 in the tree? " + tree.contain(12));
        System.out.println("Is 20 in the tree? " + tree.contain(20));
        tree.remove(5);
        tree.printTree();
    }
}