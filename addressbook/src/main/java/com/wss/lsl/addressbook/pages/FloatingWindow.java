package com.wss.lsl.addressbook.pages;

import org.apache.tapestry5.annotations.Environmental;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SetupRender;
import org.apache.tapestry5.services.javascript.JavaScriptSupport;

public class FloatingWindow {

	@Environmental
	private JavaScriptSupport js;
	@Property(write = false)
	private String floatingWindowJS = "js/floatingwindow.js";

	@SetupRender
	void callJs() {
	}

}
