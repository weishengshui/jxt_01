package com.wss.lsl.baijiaxing.test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;


public class IpMobileIdQueryTest {
	
	private HttpClient httpClient;
	
	@Before
	public void setUp(){
		httpClient = new DefaultHttpClient();
	}
	
	@After
	public void tearDown(){
		if(null != httpClient){
			httpClient.getConnectionManager().shutdown();
		}
	}
	
	
	@Test
	public void ipQueryTest(){
		HttpGet httpGet = new HttpGet("http://www.youdao.com/smartresult-xml/search.s?type=ip&q=113.87.240.46");
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		try {
			HttpResponse response = httpClient.execute(httpGet);
			HttpEntity httpEntity = response.getEntity();
			BufferedReader br = new BufferedReader(new InputStreamReader(httpEntity.getContent(), "GBK"));
			String content = null;
			System.out.println("-----------------------------");
			while(null != (content = br.readLine())){
				System.out.println(content);
			}
			System.out.println("-----------------------------");
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void mobileQueryTest(){
		HttpGet httpGet = new HttpGet("http://www.youdao.com/smartresult-xml/search.s?type=mobile&q=13189755310");
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		try {
			HttpResponse response = httpClient.execute(httpGet);
			HttpEntity httpEntity = response.getEntity();
			BufferedReader br = new BufferedReader(new InputStreamReader(httpEntity.getContent(), "GBK"));
			String content = null;
			System.out.println("-----------------------------");
			while(null != (content = br.readLine())){
				System.out.println(content);
			}
			System.out.println("-----------------------------");
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void idQueryTest(){
		HttpGet httpGet = new HttpGet("http://www.youdao.com/smartresult-xml/search.s?type=id&q=430524198810116377");
		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		try {
			HttpResponse response = httpClient.execute(httpGet);
			HttpEntity httpEntity = response.getEntity();
			BufferedReader br = new BufferedReader(new InputStreamReader(httpEntity.getContent(), "GBK"));
			String content = null;
			System.out.println("-----------------------------");
			while(null != (content = br.readLine())){
				System.out.println(content);
			}
			System.out.println("-----------------------------");
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
