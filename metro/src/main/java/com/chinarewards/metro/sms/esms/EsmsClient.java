package com.chinarewards.metro.sms.esms;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.chinarewards.metro.sms.ISMSSendQueue;
import com.chinarewards.metro.sms.SMSException;
import com.chinarewards.metro.sms.SMSStatus;

public class EsmsClient implements ISMSSendQueue {

	private static Log log = LogFactory.getLog(EsmsClient.class);

	private String mtUrl; // = "http://esms.etonenet.com/sms/mt";

	private String command; // = "MT_REQUEST";

	private String spid; // = "1234";

	private String sppassword; // = "1234";

	// sp服务代码，可选参数，默认为 00
	String spsc; // = "00";

	// 源号码，可选参数
	String sa; // = "10657109053657";

	// 下行内容以及编码格式，必填参数
	int dc = 15;

	public static void main(String[] arg) throws SMSException {

		String mtUrl = "http://esms.etonenet.com/sms/mt";
		String command = "MT_REQUEST";
		String spid = "5303";
		String sppassword = "qm5303";
		// sp服务代码，可选参数，默认为 00
		String spsc = "00";
		// 源号码，可选参数
		String sa = "10657109053657";
		ISMSSendQueue ret = new EsmsClient(mtUrl, command, spid, sppassword,
				spsc, sa);

		String aa = ret.queue(null, "8615818727773", "why? from client esms");
		System.out.println("$$$aa" + aa);
	}

	public EsmsClient(String mtUrl, String command, String spid,
			String sppassword, String spsc, String sa) {
		this.mtUrl = mtUrl;
		this.command = command;
		this.spid = spid;
		this.sppassword = sppassword;
		this.spsc = spsc;
		this.sa = sa;
	}

	/**
	 * 将普通字符串转换成Hex编码字符串
	 * 
	 * @param dataCoding
	 *            编码格式，15表示GBK编码，8表示UnicodeBigUnmarked编码，0表示ISO8859-1编码
	 * @param realStr
	 *            普通字符串
	 * @return Hex编码字符串
	 * @throws UnsupportedEncodingException
	 */
	public static String encodeHexStr(int dataCoding, String realStr) {
		String hexStr = null;
		if (realStr != null) {
			try {
				if (dataCoding == 15) {
					hexStr = new String(Hex.encodeHex(realStr.getBytes("GBK")));
				} else if ((dataCoding & 0x0C) == 0x08) {
					hexStr = new String(Hex.encodeHex(realStr
							.getBytes("UnicodeBigUnmarked")));
				} else {
					hexStr = new String(Hex.encodeHex(realStr
							.getBytes("ISO8859-1")));
				}
			} catch (UnsupportedEncodingException e) {
				log.error("Decoding content error happended!",e);
			}
		}
		return hexStr;
	}

	/**
	 * 将Hex编码字符串转换成普通字符串
	 * 
	 * @param dataCoding
	 *            反编码格式，15表示GBK编码，8表示UnicodeBigUnmarked编码，0表示ISO8859-1编码
	 * @param hexStr
	 *            Hex编码字符串
	 * @return 普通字符串
	 */
	public static String decodeHexStr(int dataCoding, String hexStr) {
		String realStr = null;
		try {
			if (hexStr != null) {
				if (dataCoding == 15) {
					realStr = new String(Hex.decodeHex(hexStr.toCharArray()),
							"GBK");
				} else if ((dataCoding & 0x0C) == 0x08) {
					realStr = new String(Hex.decodeHex(hexStr.toCharArray()),
							"UnicodeBigUnmarked");
				} else {
					realStr = new String(Hex.decodeHex(hexStr.toCharArray()),
							"ISO8859-1");
				}
			}
		} catch (Exception e) {
			log.error("decode content error happended!",e);
		}

		return realStr;
	}

	/**
	 * 发送http GET请求，并返回http响应字符串
	 * 
	 * @param urlstr
	 *            完整的请求url字符串
	 * @return
	 */
	public static String doGetRequest(String urlstr) {
		String res = null;
		HttpClient client = new HttpClient(
				new MultiThreadedHttpConnectionManager());
		client.getParams().setIntParameter("http.socket.timeout", 10000);
		client.getParams().setIntParameter("http.connection.timeout", 5000);

		HttpMethod httpmethod = new GetMethod(urlstr);
		try {
			int statusCode = client.executeMethod(httpmethod);
			if (statusCode == HttpStatus.SC_OK) {
				res = httpmethod.getResponseBodyAsString();
			}
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			httpmethod.releaseConnection();
		}
		return res;
	}

	/**
	 * 发送http POST请求，并返回http响应字符串
	 * 
	 * @param urlstr
	 *            完整的请求url字符串
	 * @return
	 */
	public static String doPostRequest(String urlstr) {
		String res = null;
		HttpClient client = new HttpClient(
				new MultiThreadedHttpConnectionManager());
		client.getParams().setIntParameter("http.socket.timeout", 10000);
		client.getParams().setIntParameter("http.connection.timeout", 5000);

		HttpMethod httpmethod = new PostMethod(urlstr);
		try {
			int statusCode = client.executeMethod(httpmethod);
			if (statusCode == HttpStatus.SC_OK) {
				res = httpmethod.getResponseBodyAsString();
			}
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			httpmethod.releaseConnection();
		}
		return res;
	}

	/**
	 * 将 短信下行 请求响应字符串解析到一个HashMap中
	 * 
	 * @param resStr
	 * @return
	 */
	public static HashMap<String, String> parseResStr(String resStr) {
		HashMap<String, String> pp = new HashMap<String, String>();
		try {
			String[] ps = resStr.split("&");
			for (int i = 0; i < ps.length; i++) {
				int ix = ps[i].indexOf("=");
				if (ix != -1) {
					pp.put(ps[i].substring(0, ix), ps[i].substring(ix + 1));
				}
			}
		} catch (Exception e) {
			log.error("parase string error happended!",e);
		}
		return pp;
	}

	@Override
	public void init() {
	}

	@Override
	public void destroy() {

	}

	@Override
	public String queue(String provider, String mobileNo, String message)
			throws SMSException {
		return queue(provider, null, mobileNo, message);
	}

	@Override
	public String queue(String provider, String sourceNo, String mobileNo,
			String message) throws SMSException {

		// 目标号码，必填参数
		String da = "86" + mobileNo;
		String ecodeform = "GBK";

		try {
			String sm = new String(Hex.encodeHex(message.getBytes(ecodeform)));

			// 组成url字符串
			StringBuilder smsUrl = new StringBuilder();
			smsUrl.append(mtUrl);
			smsUrl.append("?command=" + command);
			smsUrl.append("&spid=" + spid);
			smsUrl.append("&sppassword=" + sppassword);
			smsUrl.append("&spsc=" + spsc);
			smsUrl.append("&sa=" + sa);
			smsUrl.append("&da=" + da);
			smsUrl.append("&sm=" + sm);
			smsUrl.append("&dc=" + dc);
			log.trace("Esms request parameter: " + smsUrl);
			// 发送http请求，并接收http响应
			String resStr = doGetRequest(smsUrl.toString());
			log.trace("Esms response parameter:" + resStr);
			// 解析响应字符串
			HashMap<String, String> pp = parseResStr(resStr);
			log.debug(pp.get("command"));
			log.debug(pp.get("spid"));
			log.debug(pp.get("mtmsgid"));
			log.debug(pp.get("mtstat"));
			log.debug(pp.get("mterrcode"));
			return pp.get("mterrcode");
		} catch (UnsupportedEncodingException e) {
			throw new SMSException(e);
		}

	}

	@Override
	public SMSStatus getStatus(String taskId) throws SMSException {
		throw new SMSException("Unsupported!");
	}

	@Override
	public boolean isSupportStatusTracking() {
		return false;
	}

}
