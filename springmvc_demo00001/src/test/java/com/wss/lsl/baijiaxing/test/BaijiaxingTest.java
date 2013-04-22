package com.wss.lsl.baijiaxing.test;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.DefaultHttpRequestRetryHandler;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.junit.Test;

public class BaijiaxingTest {

	/*
	 * <form name="form1" action="http://www.98bk.com/cycx/bjx/search.asp"
	 * method="get"> <tr><td align=center>输入要查询的姓氏：<input type=text name=keyword
	 * size=20> <!--<input TYPE=hidden name=select value=biaoti> --> <input
	 * type=submit value=查询></td></tr> </form>
	 */

	@Test
	public void test_baijiaxing() {
		/*
		 * HttpClient httpclient = new DefaultHttpClient();
		 * httpclient.getParams().setParameter("http.method.retry-handler",
		 * "UTF-8"); try { HttpGet httpget = new HttpGet(
		 * "http://www.98bk.com/cycx/bjx/search.asp");
		 * 
		 * System.out.println("executing request " + httpget.getURI());
		 * 
		 * // Create a response handler ResponseHandler<String> responseHandler
		 * = new BasicResponseHandler(); String responseBody =
		 * httpclient.execute(httpget, responseHandler);
		 * System.out.println("飒飒----------------------------------------");
		 * System.out.println(responseBody);
		 * System.out.println("----------------------------------------");
		 * 
		 * } catch (ClientProtocolException e) { // TODO Auto-generated catch
		 * block e.printStackTrace(); } catch (IOException e) { // TODO
		 * Auto-generated catch block e.printStackTrace(); } finally { // When
		 * HttpClient instance is no longer needed, // shut down the connection
		 * manager to ensure // immediate deallocation of all system resources
		 * httpclient.getConnectionManager().shutdown(); }
		 */

		/*
		 * HttpClient httpclient = new DefaultHttpClient(); try { // 创建httpget.
		 * HttpGet httpget = new
		 * HttpGet("http://www.98bk.com/cycx/bjx/search.asp");
		 * System.out.println("executing request " + httpget.getURI()); //
		 * 执行get请求. HttpResponse response = httpclient.execute(httpget); //
		 * 获取响应实体 HttpEntity entity = response.getEntity();
		 * System.out.println("--------------------------------------"); //
		 * 打印响应状态 System.out.println(response.getStatusLine()); if (entity !=
		 * null) { // 打印响应内容长度 System.out.println("Response content length: " +
		 * entity.getContentLength()); // 打印响应内容
		 * System.out.println("Response content: " +
		 * EntityUtils.toString(entity)); }
		 * System.out.println("------------------------------------"); } catch
		 * (ClientProtocolException e) { // TODO Auto-generated catch block
		 * e.printStackTrace(); } catch (IOException e) { // TODO Auto-generated
		 * catch block e.printStackTrace(); } finally { // 关闭连接,释放资源
		 * httpclient.getConnectionManager().shutdown(); }
		 */

		// 创建默认的httpClient实例
		DefaultHttpClient httpclient = new DefaultHttpClient();
		// DefaultHttpClient httpClient = new DefaultHttpClient();
		// DefaultHttpRequestRetryHandler handler = new
		// DefaultHttpRequestRetryHandler(
		// 1, false);
		// httpclient.setHttpRequestRetryHandler(handler);
		// 创建post请求
		String url = "http://www.98bk.com/cycx/bjx/";
		// String url = "http://www.98bk.com/cycx/bjx/search.asp";
		HttpPost post = new HttpPost(url);
		// 创建参数队列
		try {
			System.out.println("--------------------------------------");
			System.out.println("Executing request url:" + post.getURI());
			/*
			 * HttpResponse response = httpclient.execute(post); HttpEntity
			 * entity = response.getEntity(); if (entity != null) {
			 * System.out.println("--------------------------------------");
			 * System.out.println("Response content: " +
			 * EntityUtils.toString(entity, "UTF-8"));
			 * System.out.println("--------------------------------------"); }
			 */
			int count = 1;
			for (int i = 0; i < 4; i++) {
				List<NameValuePair> params = new ArrayList<NameValuePair>();
				params.add(new BasicNameValuePair("page", i + 1 + ""));
				UrlEncodedFormEntity uefEntity = new UrlEncodedFormEntity(
						params, "UTF-8");
				post.setEntity(uefEntity);
				ResponseHandler<String> responseHandler = new BasicResponseHandler();
				String responseBody = httpclient.execute(post, responseHandler);
				String responseContent = new String(
						responseBody.getBytes("ISO-8859-1"), "GBK");
				int startIndex = 0;
				int endIndex = 0;
				if (null != responseContent) {
					while (startIndex != -1) {
						startIndex = responseContent.indexOf("href=cyshow.asp",
								startIndex + 1);
						if (startIndex != -1) {
							endIndex = responseContent.indexOf("</a>",
									startIndex + 1);
							System.out
									.println(responseContent.substring(
											responseContent.indexOf(">",
													startIndex) + 1, endIndex));
							System.out.println("count ====>" + count);
							count++;
						}
					}
				}
			}
			// System.out.println("========>" + new
			// String(responseBody.getBytes("ISO-8859-1"), "GBK"));

			/*
			 * HttpResponse httpResponse = httpclient.execute(post); HttpEntity
			 * httpEntity = httpResponse.getEntity();
			 * System.out.println("content length is: "
			 * +httpEntity.getContentLength());
			 * System.out.println("content type is: "
			 * +httpEntity.getContentType());
			 * System.out.println("content encoding is: "
			 * +httpEntity.getContentEncoding()); BufferedReader br = new
			 * BufferedReader(new InputStreamReader(httpEntity.getContent(),
			 * "GBK")); String lineContent = null; while(null != (lineContent =
			 * br.readLine())){ System.out.println(lineContent); }
			 */
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// 关闭连接,释放资源
			httpclient.getConnectionManager().shutdown();
		}
	}

	@Test
	public void testNameTable() {
		String url = "http://hanyu.iciba.com/zt/3500.html";
		// 创建默认的httpClient实例
		DefaultHttpClient httpclient = new DefaultHttpClient();
		HttpGet httpGet = new HttpGet(url);
		try {
			System.out.println("--------------------------------------");
			System.out.println("Executing request url:" + httpGet.getURI());
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("page", ""));
			ResponseHandler<String> responseHandler = new BasicResponseHandler();
			String responseBody = httpclient.execute(httpGet, responseHandler);
			/*
			 * HttpResponse httpResponse = httpclient.execute(httpGet);
			 * HttpEntity httpEntity = httpResponse.getEntity(); BufferedReader
			 * br = new BufferedReader(new
			 * InputStreamReader(httpEntity.getContent(), "UTF-8")); String
			 * lineContent = null; while((lineContent=br.readLine()) != null){
			 * System.out.println(lineContent); }
			 */
			String responseContent = new String(
					responseBody.getBytes("ISO-8859-1"), "UTF-8");
			// System.out.println(responseContent);
			int startIndex = 0;
			String indexStr = "target='_blank'>";
			int count = 1;
			while (startIndex != -1) {
				startIndex = responseContent.indexOf(indexStr, startIndex + 1);
				if (startIndex != -1) {
					startIndex += indexStr.length();
					if (count % 20 == 0) {
						System.out.println("count ====>" + count);
						System.out.println();
					} 
					System.out.print(responseContent.substring(startIndex,
							startIndex + 1) + "\t");
				}
				count++;
			}
			System.out.println("count ====>" + (count - 1));
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// 关闭连接,释放资源
			httpclient.getConnectionManager().shutdown();
		}
	}
}
