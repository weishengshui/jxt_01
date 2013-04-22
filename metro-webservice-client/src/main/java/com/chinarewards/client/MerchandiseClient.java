package com.chinarewards.client;

import java.util.List;

import javax.ws.rs.core.MultivaluedMap;

import com.chinarewards.metro.models.Member;
import com.chinarewards.metro.models.merchandise.Merchandise;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;

public class MerchandiseClient extends AbstractClient {

	private String url;

	public MerchandiseClient(String url) {
		this.url = url;
	}

	public static void main(String[] args) {

		List<Merchandise> merchandises = new MerchandiseClient(
				"http://localhost:8080/metro/ws").getMerchandises(1);
		for (Merchandise m : merchandises) {
			System.out.println("CommodityId:" + m.getCommodityId() + " name:" + m.getName()
					+ " freight:" + m.getFreight());
		}
	}

	public List<Merchandise> getMerchandises(Integer page) {
		WebResource r = getClient().resource(url + "/merchandise/list/"+page);
		try {
			List<Merchandise> m = r.accept("application/json").get(
					new GenericType<List<Merchandise>>() {
					});
			return m;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
}
