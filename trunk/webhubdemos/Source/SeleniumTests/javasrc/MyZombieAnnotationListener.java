package advpackage;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;

import java.lang.reflect.Method;
import java.util.Set;

import org.testng.IAnnotationTransformer;
import org.testng.IClass;
import org.testng.IHookable;
import org.testng.ISuite;
import org.testng.ISuiteListener;
import org.testng.ITestContext;
import org.testng.ITestNGMethod;
import org.testng.ITestResult;
import org.testng.TestNG;
import org.testng.annotations.ITestAnnotation;
import advpackage.TestADVPages;


import org.w3c.dom.Document;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.io.FileInputStream;
import java.io.IOException;
import org.xml.sax.SAXException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

/* intro          http://rationaleemotions.wordpress.com/2012/01/27/listen-to-what-i-have-to-say-about-testng-listeners/
   useful example https://gist.github.com/krmahadevan/1155871 
*/


public class MyZombieAnnotationListener implements IAnnotationTransformer { //,ISuiteListener  {

/*	@Override
	public void onStart(ISuite suite) {
		// TODO Auto-generated method stub
		System.out.println("zombie count parameter off Suite XML = " +	suite.getParameter("zombieCount").toString());
		//suite.setAttribute("threadPoolSize", "7");
		//suite.setSuiteThreadPoolSize
		
	} */

	@Override
	public void transform(ITestAnnotation annotation, Class testClass,
			Constructor testConstructor, Method testMethod) {
		Integer x;
		Document xmlDocument = null;
		String zc = null;
		
		//testConstructor.
		//annotation.
		//System.out.println("annotation = " + annotation.getParameters().toString());
		
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
		    e.printStackTrace();
		}
		if (xmlDocument == null) {
		  System.out.println("xmlDocument is null !!!");	
		}
		else {
		System.out.println("getBaseURI = " + xmlDocument.getBaseURI());
		System.out.println("getDocumentURI = " + xmlDocument.getDocumentURI());
		System.out.println("getXmlVersion = " + xmlDocument.getXmlVersion());
		}
		
		XPath xPath =  XPathFactory.newInstance().newXPath();
		try {			
			zc = (String)xPath.compile("/suite/parameter[@name=\"zombieCount\"]/@value").evaluate(xmlDocument);
			
		} catch (XPathExpressionException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		System.out.println("zc = " + zc);
		
		x =  Integer.parseInt(zc);
		
		
		System.out.println("getName = " + testMethod.getName());
		   if ( ("verifyHomepageTitle".equals(testMethod.getName())) ) {
			     annotation.setInvocationCount(x);
			     annotation.setThreadPoolSize(x);
		   }
		   else {
			   System.out.println("different getName");
		   }
		   
		
	}

/*	@Override
	public void onFinish(ISuite suite) {
		// TODO Auto-generated method stub
		
	} */


}


