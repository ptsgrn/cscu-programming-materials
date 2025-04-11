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
        if (node == null)
            return;
        inorder(node.getLeft());
        System.out.print(node.getData() + "\t");
        inorder(node.getRight());
    }
    
    public String visualize() {
        //         {
        //     "kind": { "graph": true },
        //     "nodes": [
        //         { "id": "1", "label": "1" },
        //         { "id": "2", "label": "2", "color": "orange" },
        //         { "id": "3", "label": "3" }
        //     ],
        //     "edges": [
        //         { "from": "1", "to": "2", "color": "red" },
        //         { "from": "1", "to": "3" }
        //     ]
        // }

        StringBuilder sb = new StringBuilder();
        sb.append("{\n");
        sb.append("    \"kind\": { \"graph\": true },\n");
        sb.append("    \"nodes\": [\n");
        visualizeNodes(root, sb);
        sb.append("    ],\n");
        sb.append("    \"edges\": [\n");
        visualizeEdges(root, sb);
        sb.append("    ]\n");
        sb.append("}\n");
        return sb.toString();
    }

    private void visualizeNodes(BTNode node, StringBuilder sb) {
        if (node == null)
            return;
        sb.append("        { \"id\": \"").append(node.getData()).append("\", \"label\": \"").append(node.getData()).append("\" },\n");
        visualizeNodes(node.getLeft(), sb);
        visualizeNodes(node.getRight(), sb);
    }
    
    private void visualizeEdges(BTNode node, StringBuilder sb) {
        if (node == null)
            return;
        if (node.getLeft() != null) {
            sb.append("        { \"from\": \"" + node.getData() + "\", \"to\": \"" + node.getLeft().getData() + "\" },\n");
        }
        if (node.getRight() != null) {
            sb.append("        { \"from\": \"" + node.getData() + "\", \"to\": \"" + node.getRight().getData() + "\" },\n");
        }
        visualizeEdges(node.getLeft(), sb);
        visualizeEdges(node.getRight(), sb);
    }
    public void clear() {
        root = null;
    }
}
