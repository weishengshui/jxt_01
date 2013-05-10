package com.chinarewards.alading.resources;

import javax.ws.rs.core.MediaType;

import com.chinarewards.alading.response.PicUrlList;
import com.sun.jersey.api.client.WebResource;

public class ClientService extends AbstractClient {
	public static void main(String[] args) {
		new ClientService().obtainPicUrlList("admin", "password");
		
	}

	private String url = "http://192.168.4.235:8080/alading/ishelf";

//	public ClientService(String url) {
//		this.url = url;
//	}

	public PicUrlList obtainPicUrlList(String username, String password) {
		WebResource webResource = getClient().resource(url+"/pic");
		PicUrlList picUrlList = webResource.type(MediaType.APPLICATION_FORM_URLENCODED).accept(MediaType.APPLICATION_XML).post(PicUrlList.class, "username="+username+"&password="+password);
		return picUrlList;
	}
}
