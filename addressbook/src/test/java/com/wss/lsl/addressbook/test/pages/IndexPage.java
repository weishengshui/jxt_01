package com.wss.lsl.addressbook.test.pages;

import java.util.HashMap;
import java.util.Map;

import org.apache.tapestry5.dom.Document;
import org.apache.tapestry5.dom.Element;
import org.apache.tapestry5.test.PageTester;
import org.testng.Assert;
import org.testng.annotations.Test;

public class IndexPage extends Assert {
	
	@Test
	public void test1(){
		String appPackage = "com.wss.lsl.addressbook";
		String appName = "App";
		PageTester pageTester = new PageTester(appPackage, appName, "src/main/webapp");
		Document document = pageTester.renderPage("UploadExample");
		Element e = document.getElementById("file");
		assertEquals(e.getAttribute("name"), "file");
	}
	
//	@Test
//    public void test2()
//    {
//        String appPackage = "org.example.app";
//        String appName = "LocaleApp";
//        PageTester tester = new PageTester(appPackage, appName, "src/main/webapp");
//        Object[] context = new Object[]{ "abc", 123 };
//        Document doc = tester.invoke(new ComponentInvocation(new PageLinkTarget("MyPage"), context));
//        assertEquals(doc.getElementById("id1").getChildText(), "hello");
//    }	
	
	@Test
    public void test3()
    {
        String appPackage = "org.example.app";
        String appName = "LocaleApp";
        PageTester tester = new PageTester(appPackage, appName, "src/main/webapp");
        Document doc = tester.renderPage("MyPage");
        Element link = doc.getElementById("link1");
        doc = tester.clickLink(link);
        assertTrue(doc.toString().contains("abc"));
    }
	
	@Test
    public void test4()
    {
        String appPackage = "org.example.app";
        String appName = "LocaleApp";
        PageTester tester = new PageTester(appPackage, appName, "src/main/webapp");
        Document doc = tester.renderPage("MyPage");
        Element form = doc.getElementById("form1");
        Map<String, String> fieldValues = new HashMap<String, String>();
        fieldValues.put("field1", "hello");
        fieldValues.put("field2", "100");
        doc = tester.submitForm(form, fieldValues);
        assertTrue(doc.toString().contains("abc"));
    }
}
