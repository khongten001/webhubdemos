//**************************************
// Name: Teeny tiny banner applet
// Description: Simplest java applet

// Thanks: http://www.roseindia.net/java/example/java/applet/FirstApplet.shtml

import java.applet.*;
import java.awt.*;

public class FirstApplet extends Applet{
  public void paint(Graphics g){
    g.drawString("Welcome in Java Applet.",40,20);
  }
}