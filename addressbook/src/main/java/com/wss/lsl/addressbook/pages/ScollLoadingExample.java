package com.wss.lsl.addressbook.pages;

import org.apache.tapestry5.Asset;
import org.apache.tapestry5.annotations.Environmental;
import org.apache.tapestry5.annotations.Path;
import org.apache.tapestry5.annotations.SetupRender;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.javascript.JavaScriptSupport;

public class ScollLoadingExample {

	@Inject
	@Path("context:js/jquery/jquery-1.8.0.min.js")
	private Asset jquery;

	@Inject
	@Path("context:js/jquery.scrollLoading-min.js")
	private Asset scrollLoading;

	@Environmental
	private JavaScriptSupport javaScriptSupport;

	/**
	 * <p>
	 * 这样加载会把tapestry的js也加载进来了。jquery 与 tapestry 的 js 库有冲突
	 * </p>
	 * 只好在页面单独加载
	 */
	@SetupRender
	void setupRender11() {
		// javaScriptSupport.importJavaScriptLibrary(jquery);
		// javaScriptSupport.importJavaScriptLibrary(scrollLoading);
	}
}
