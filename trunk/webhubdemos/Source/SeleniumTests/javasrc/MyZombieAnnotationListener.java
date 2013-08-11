package advpackage;

import java.lang.reflect.Constructor;
//import java.lang.reflect.Field;

import java.lang.reflect.Method;
import java.util.Set;

import org.testng.IAnnotationTransformer;
import org.testng.ISuite;
import org.testng.ISuiteListener;
import org.testng.ITestNGMethod;
import org.testng.ITestResult;
import org.testng.TestNG;
import org.testng.annotations.ITestAnnotation;


import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.io.FileInputStream;
import java.io.IOException;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

/* intro          http://rationaleemotions.wordpress.com/2012/01/27/listen-to-what-i-have-to-say-about-testng-listeners/
   useful example https://gist.github.com/krmahadevan/1155871 
*/


public class MyZombieAnnotationListener implements IAnnotationTransformer, ISuiteListener  {

	@Override
	public void onStart(ISuite suite) {
		
		
		//System.out.println("getName of suite = " + suite.getName());
		//System.out.println("onStart ISuite number from XML = " +	suite.getParameter("zombieCount").toString());
		//suite.setAttribute("threadPoolSize", "7");
		//suite.setSuiteThreadPoolSize
		
		//suite.enabled = ("WebHubDemos Test Suite".equals(suite.getName()));
				
	} 

	@Override
	public void transform(ITestAnnotation annotation, Class testClass,
			Constructor testConstructor, Method testMethod) {
		Integer x;
		Document xmlDocument = null;
		String zc = null;
		
	
		DocumentBuilderFactory builderFactory =
		        DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = null;
		try {
		    builder = builderFactory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
		    e.printStackTrace(); 
		}
		
		try {
		    xmlDocument = builder.parse(
		            new FileInputStream("I:\\And-Downloads\\Selenium\\testng-customsuite-adv.xml"));
		} catch (SAXException e) {
		    e.printStackTrace();
		} catch (IOException e) {
			try {
			    xmlDocument = builder.parse(
			            new FileInputStream("D:\\Apps\\Selenium\\HREFTools\\testng-customsuite-adv.xml"));
			} catch (SAXException e2) {
			    e2.printStackTrace();
			} catch (IOException e3) {
			    e3.printStackTrace();
			}
		}
		
		System.out.println("getXmlVersion = " + xmlDocument.getXmlVersion());
		
		
		// http://docs.oracle.com/javase/tutorial/jaxp/xslt/xpath.html
		// simple online xpath tester http://www.xpathtester.com/test
		XPath xPath =  XPathFactory.newInstance().newXPath();
		try {			
			zc = (String)xPath.compile("/suite/parameter[@name=\"specialZombieCount\"]/@value").evaluate(xmlDocument);
			
		} catch (XPathExpressionException e1) {
			
			e1.printStackTrace();
		}
		
		x =  Integer.parseInt(zc);
		
		//System.out.println("getName = " + testMethod.getName());
		System.out.println("Setting Suite InvocationCount and ThreadPoolSize to " + zc);
		annotation.setInvocationCount(x);
	    annotation.setThreadPoolSize(x);
		
	}

	@Override
	public void onFinish(ISuite suite) {
		// TODO Auto-generated method stub
		
	}


}


