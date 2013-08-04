package advpackage;

// useful http://www.guru99.com/introduction-to-selenium-grid.html
// useful http://marakana.com/bookshelf/selenium_tutorial/selenium2.html#_api

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
	public String baseUrl, nodeURL; 
	public WebDriver driver; // = new FirefoxDriver();
	public Long IPort; 
	public DesiredCapabilities capability;
	
	
  @BeforeClass
  public void setUp() throws MalformedURLException {
	  baseUrl = "http://w12.demos.href.com/scripts/runisa64.dll?adv:";
	  nodeURL = "http://localhost:5555/wd/hub";
	  capability = DesiredCapabilities.htmlUnit();   
	  // as htmlUnit, the user agent goes through as Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0) 
	  
	  capability.setBrowserName(DesiredCapabilities.htmlUnit().getBrowserName());	  
	  capability.setVersion(DesiredCapabilities.htmlUnit().getVersion());	  
	  capability.setPlatform(org.openqa.selenium.Platform.WINDOWS);	  

	  System.out.println("thread Id = " + String.valueOf(Thread.currentThread().getId()));

	  IPort = 5554 + Thread.currentThread().getId();
	  System.out.println("IPort = " + String.valueOf(IPort));
  
	  nodeURL = "http://localhost:" + String.valueOf(IPort) + "/wd/hub";
	  System.out.println("nodeURL = " + nodeURL);
	  
	  driver = new RemoteWebDriver(new URL(nodeURL), capability);
	  driver.manage().deleteAllCookies();
  
  }
	
  @AfterClass
  public void afterTest() {
	     driver.quit();	  
  }
  
  @Test(threadPoolSize = 3, invocationCount = 3,  timeOut = 10000)
  public void verifyHomepageTitle() {

	  
	  System.out.println("thread Id = " + String.valueOf(Thread.currentThread().getId()));
	  driver.get(baseUrl);
	  String expectedTitle = "Page pgWelcome: Welcome Page for adv Demo (in the \"adv\" WebHub Demo)";
	  String actualTitle = driver.getTitle();
	  
	  Assert.assertEquals(actualTitle, expectedTitle);
	  
     driver.findElement(By.id("a-pgenteradv")).click();
     if (1 == 3) {
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
     
  }
}
