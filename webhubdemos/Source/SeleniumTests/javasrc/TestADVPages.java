package advpackage;

// useful              http://www.guru99.com/introduction-to-selenium-grid.html
// useful              http://marakana.com/bookshelf/selenium_tutorial/selenium2.html#_api
// very useful         http://code.google.com/p/selenium/wiki/GettingStarted
// essential reference http://code.google.com/p/selenium/wiki/Grid2
// nice test example using WordPress target  http://testng.org/doc/selenium.html
// Java "testng" docs  http://testng.org/doc/documentation-main.html
// well written        http://www.packtpub.com/sites/default/files/downloads/Distributed_Testing_with_Selenium_Grid.pdf


//import org.testng.annotations.Test;
import org.openqa.selenium.remote.DesiredCapabilities;
import java.net.MalformedURLException;
import java.net.URL;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.*;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
//import org.openqa.selenium.firefox.FirefoxDriver;
import org.testng.Assert;
import org.testng.annotations.*;


public class TestADVPages {
	public String baseUrl, selenHub; 
	public DesiredCapabilities capability;
		
  @BeforeTest
  public void setUp() throws MalformedURLException {
	  baseUrl = "http://w12.demos.href.com";
	  System.out.println("setUp thread Id = " + String.valueOf(Thread.currentThread().getId()));

	  //selenHub = "db.demos.href.com:4444"; 
	  selenHub = "localhost:4444";
	  
	  capability = DesiredCapabilities.htmlUnit();   
	  // as htmlUnit, the user agent goes through as Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0) 
	  
	  capability.setBrowserName(DesiredCapabilities.htmlUnit().getBrowserName());	  
	  //capability.setPlatform(org.openqa.selenium.Platform.WINDOWS);	  
  
	  capability.setPlatform(org.openqa.selenium.Platform.ANY);	  
  }
	
  @AfterTest
  public void afterTest() {
  }
  
  @Test(threadPoolSize = 2, invocationCount = 4,  timeOut = 45000)
  public void verifyHomepageTitle() throws MalformedURLException {
	Long IPort; 
	WebDriver driver; 
	String gridURL;
	WebElement webElement;
	

	  //IPort = 4444; // - 10 + Thread.currentThread().getId();
	  //System.out.println("IPort = " + String.valueOf(IPort));
  
	  //nodeURL = "http://localhost:4444/wd/hub"; //" + String.valueOf(IPort) + "/wd/hub";
	  gridURL = "http://" + selenHub + "/wd/hub";
	  //System.out.println("gridURL = " + gridURL);

	  driver = new RemoteWebDriver(new URL(gridURL), capability);
	  //System.out.println("01");
	  driver.manage().deleteAllCookies();
	  //System.out.println("02");

    driver.get(baseUrl + "/scripts/runisa64.dll?demos:pgwhatismyip");
    webElement = (driver.findElement(By.id("ip")));
    System.out.println("remoteAddress = " + webElement.getText());
    webElement = (driver.findElement(By.id("ua")));
    System.out.println("userAgent = " + webElement.getText());
    
      driver.get(baseUrl + "/scripts/runisa64.dll?adv");
	  
	  //System.out.println("03");
	  String expectedTitle = "Page pgWelcome: Welcome Page for adv Demo (in the \"adv\" WebHub Demo)";
	  String actualTitle = driver.getTitle();
	  System.out.println(actualTitle);
	  
	  Assert.assertEquals(actualTitle, expectedTitle);
	  
     driver.findElement(By.id("a-pgenteradv")).click();
     if (1 == 1) {
     driver.findElement(By.linkText("Internal Workings")).click();
     driver.findElement(By.linkText("Cycle List Navigation Bar")).click();
     driver.findElement(By.linkText("How to Use it")).click();
     driver.findElement(By.cssSelector("img[alt=\"Logo for adv WebHub demo\"]")).click();
     driver.findElement(By.id("a-viewfiles")).click();
     driver.findElement(By.cssSelector("img[alt=\"Logo for adv WebHub demo\"]")).click();
     driver.findElement(By.id("a-pgabout")).click();
     driver.findElement(By.cssSelector("img[alt=\"Logo for adv WebHub demo\"]")).click();
     driver.findElement(By.id("a-pgenteradv")).click();
     driver.findElement(By.linkText("Click to Show Next Advertisement")).click();
     driver.findElement(By.linkText("Click to Show Next Advertisement")).click();
     driver.findElement(By.linkText("Click to Show Next Advertisement")).click();
     driver.findElement(By.linkText("Click to Show Next Advertisement")).click();
     driver.findElement(By.linkText("Click to Show Next Advertisement")).click();
     }

     
     if (2==2) {
   	    driver.get(baseUrl + "/scripts/runisa64.dll?demos");
   	    actualTitle = driver.getTitle();
   	    System.out.println(actualTitle);
     	  expectedTitle = "Page pgWelcome: Welcome Page for demos Demo (in the \"demos\" WebHub Demo)";
	    Assert.assertEquals(actualTitle, expectedTitle);
   	    driver.findElement(By.id("a-pgenterdemos")).click();
   	    driver.findElement(By.linkText("Lite Demos")).click();
   	    driver.findElement(By.linkText("Source")).click();
     }
     
     driver.quit();
     
  }
}
