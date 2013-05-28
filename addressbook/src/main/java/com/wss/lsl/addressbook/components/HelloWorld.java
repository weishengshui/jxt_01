package com.wss.lsl.addressbook.components;

import org.apache.tapestry5.MarkupWriter;
import org.apache.tapestry5.annotations.BeginRender;

public class HelloWorld {
	
	@BeginRender
	void renderMessage(MarkupWriter writer){
		writer.write("bonjonr from Helloworld components.");
	}
}
