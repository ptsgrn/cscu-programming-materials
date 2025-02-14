//Project RectangleViewer contains 2 classes
//1. file Main.java
import javax.swing.JFrame;
import java.awt.geom.Ellipse2D;

public class Main {
    public static void main(String[] args) {
        JFrame frame = new JFrame();
        frame.setSize(320, 600);
        frame.setTitle("Light");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        LightComponent component = new LightComponent();
        frame.add(component);
        frame.setVisible(true);
    }
}
