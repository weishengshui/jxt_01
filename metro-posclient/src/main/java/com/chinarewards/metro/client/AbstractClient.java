package com.chinarewards.metro.client;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.client.filter.LoggingFilter;

public class AbstractClient {
	private Client client;
	private LoggingFilter loggingFilter;
	
	/**
	 * Returns the Jersey client. The client will be created if not.
	 * 
	 * @return
	 */
	protected Client getClient() {
		// lazy loaded.
		if (client == null) {
			ClientConfig clientConfig = new DefaultClientConfig();
			Client client = Client.create(clientConfig);
			// XXX allow client filter configuration.
			loggingFilter = new LoggingFilter();
			client.addFilter(loggingFilter);
			this.client = client;
		}
		return this.client;
	}

	/**
	 * Current implementation invokes {@link Client#destroy()} and set it to
	 * <code>null</code> to destroy the Jersey client.
	 */
	public void destroy() {
		if (client != null) {
			try {
				client.destroy();
			} catch (Throwable t) {
				// mute all exceptions
			}
			client = null;
		}
		loggingFilter = null;
	}
}
