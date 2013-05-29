package com.wss.lsl.addressbook.pages;

import org.apache.tapestry5.annotations.Environmental;
import org.apache.tapestry5.annotations.SetupRender;
import org.apache.tapestry5.services.javascript.JavaScriptSupport;

public class ScollLoadingExample {

	// @Inject
	// @Path("context:js/jquery/jquery-1.8.0.min.js")
	// private Asset jquery;
	//
	// @Inject
	// @Path("context:js/jquery.scrollLoading-min.js")
	// private Asset scrollLoading;

	@Environmental
	private JavaScriptSupport javaScriptSupport;

	@SetupRender
	void setupRender11() {
		javaScriptSupport.addScript("$('%s').scrollLoading();",
				".scrollLoading");
	}

}
