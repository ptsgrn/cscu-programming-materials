import javax.swing.*;
import java.awt.*;
import java.awt.geom.Ellipse2D;

public class LightComponent extends JComponent {
    public void paintComponent(Graphics g) {
        Graphics2D g2 = (Graphics2D) g;
        Rectangle box = new Rectangle(50, 50, 200, 450);
        g2.draw(box);
        Ellipse2D.Double red = new Ellipse2D.Double(85, 75, 125, 125);
        g2.draw(red);
        g2.setColor(Color.RED);
        g2.fill(red);
        red.y += 140;
        g2.setColor(Color.YELLOW);
        g2.fill(red);
        red.y += 140;
        g2.setColor(Color.GREEN);
        g2.fill(red);
    }
}
