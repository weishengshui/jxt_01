package com.wss.lsl.addressbook.pages;

import org.apache.tapestry5.Asset;
import org.apache.tapestry5.annotations.AfterRender;
import org.apache.tapestry5.annotations.Environmental;
import org.apache.tapestry5.annotations.Path;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.javascript.JavaScriptSupport;

/**
 * 局部预览
 * 
 * @author weishengshui
 * 
 */
public class PartialPreview {

	@Inject
	@Path("context:css/ps/pshow.css")
	private Asset pshowCss;
	@Property
	private final String pshowJS = "js/ps/pshow.js";

	@Environmental
	private JavaScriptSupport javaScriptSupport;

	@AfterRender
	void loadCssFile() {
		javaScriptSupport.importStylesheet(pshowCss);
//		javaScriptSupport.importStylesheet(new StylesheetLink(baseCss,
//				new StylesheetOptions("all")));
//		javaScriptSupport.importStylesheet(new StylesheetLink(pshowCss,
//				new StylesheetOptions("all")));
	}
}
