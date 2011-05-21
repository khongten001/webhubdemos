import java.applet.*;
 import java.awt.*;
 public class JavaVersionDisplayApplet extends Applet
 { private Label m_labVersionVendor; 
   public JavaVersionDisplayApplet() //constructor
   { Color colFrameBackground = Color.pink;
     this.setBackground(colFrameBackground);
     m_labVersionVendor = new Label (" Java Version: " +
                                    System.getProperty("java.version")+
                           " from "+System.getProperty("java.vendor"));
     this.add(m_labVersionVendor);
   }
 } 
