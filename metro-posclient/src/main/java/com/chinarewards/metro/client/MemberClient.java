package com.chinarewards.metro.client;

import java.util.List;

import javax.ws.rs.core.MultivaluedMap;

import com.chinarewards.metro.models.Member;
import com.chinarewards.metro.models.RegisterResp;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;

public class MemberClient extends AbstractClient {

	private String url;

	public MemberClient(String url) {
		this.url = url;
	}

	public static void main(String[] args) {

		List<Member> members = new MemberClient("http://localhost:8081/metro/ws")
				.getMembers("P1");
		for (Member m : members) {
			System.out.println("name:" + m.getUserName() + " age:" + m.getAge()
					+ " address:" + m.getAddress());
		}
		
		new MemberClient("http://localhost:8081/metro/ws").saveMember("");
	}

	public List<Member> getMembers(String name) {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("name", name);
		WebResource r = getClient().resource(url + "/member/list").queryParams(
				params);
		try {
			List<Member> m = r.accept("application/json").get(
					new GenericType<List<Member>>() {
					});
			return m;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
	
	public void saveMember(String name) {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		RegisterResp rr = new RegisterResp();
		rr.setPhone("1521354121");
		rr.setPosId("123456");
		rr.setResult("3");
		RegisterResp r = getClient().resource(url + "/member/save").post(RegisterResp.class, rr);
		System.out.println(r.getResult());
		//return wr.accept("application/json").get(new GenericType<RegisterResp>() {});
	}
}
