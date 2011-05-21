
// online java compiler (.java -> .class)
// http://www.innovation.ch/java/java_compile.html

import java.applet.*;
 import java.awt.*;
 public class JavaVersionDisplayApplet extends Applet
 { private Label m_labVersionVendor; 
   public JavaVersionDisplayApplet() //constructor
   { Color colFrameBackground = Color.blue;
     Color colFrameForeground = Color.white;
     this.setBackground(colFrameBackground);
     this.setForeground(colFrameForeground);
     m_labVersionVendor = new Label (" Java Version: " +
                                    System.getProperty("java.version")+
                           " from "+System.getProperty("java.vendor"));
     this.add(m_labVersionVendor);
   }
 } 
