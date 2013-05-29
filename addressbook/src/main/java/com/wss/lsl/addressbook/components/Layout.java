package com.wss.lsl.addressbook.components;

import org.apache.tapestry5.BindingConstants;
import org.apache.tapestry5.SymbolConstants;
import org.apache.tapestry5.annotations.Import;
import org.apache.tapestry5.annotations.InjectPage;
import org.apache.tapestry5.annotations.Parameter;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.ioc.annotations.Symbol;

import com.wss.lsl.addressbook.pages.ListAddresses;

/**
 * Layout component for pages of application myapp2.
 */
@Import(stylesheet = { "context:layout/layout.css" }, library = { "context:/js/jquery.scrollLoading-min.js" })
public class Layout {
	/**
	 * The page title, for the <title> element and the <h1>element.
	 */
	@Property
	@Parameter(required = true, defaultPrefix = BindingConstants.LITERAL)
	private String title;

	@Property
	@Inject
	@Symbol(SymbolConstants.APPLICATION_VERSION)
	private String appVersion;

	@InjectPage
	private ListAddresses listAddresses;

	Object onActionFromIndex() {
		return listAddresses;
	}
}
