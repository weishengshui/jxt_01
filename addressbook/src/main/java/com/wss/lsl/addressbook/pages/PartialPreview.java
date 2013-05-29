package com.wss.lsl.addressbook.pages;

import org.apache.tapestry5.Asset;
import org.apache.tapestry5.annotations.AfterRender;
import org.apache.tapestry5.annotations.Environmental;
import org.apache.tapestry5.annotations.Path;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.javascript.JavaScriptSupport;
import org.apache.tapestry5.services.javascript.StylesheetLink;
import org.apache.tapestry5.services.javascript.StylesheetOptions;

/**
 * 局部预览
 * 
 * @author weishengshui
 * 
 */
public class PartialPreview {

	@Inject
	@Path("context:css/ps/base.css")
	private Asset baseCss;

	@Inject
	@Path("context:css/ps/pshow.css")
	private Asset pshowCss;

	@Environmental
	private JavaScriptSupport javaScriptSupport;

	@AfterRender
	void loadCssFile() {
		javaScriptSupport.importStylesheet(new StylesheetLink(baseCss,
				new StylesheetOptions("all")));
		javaScriptSupport.importStylesheet(new StylesheetLink(pshowCss,
				new StylesheetOptions("all")));
	}
}
