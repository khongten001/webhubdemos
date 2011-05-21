//**************************************
// Name: Teeny tiny applet
// Description: Simplest java applet
// NB: the name of the public class must equal the .java filename, i.e. Welcome

// Thanks: http://www.roseindia.net/java/example/java/applet/FirstApplet.shtml

// Online java compiler:
// http://www.innovation.ch/java/java_compile.html

import java.applet.*;
import java.awt.*;

public class Welcome extends Applet{
  public void paint(Graphics g){
    g.drawString("Welcome via Java Applet.",40,20);
  }
}