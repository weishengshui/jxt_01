package com.chinarewards.metro.core.common;

import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig.Feature;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class CommonUtil {

	protected final static Logger logger = Logger.getLogger(CommonUtil.class);

	/**
	 * 获取request对象
	 * 
	 * @return
	 */
	public static HttpServletRequest getRequest() {
		if(RequestContextHolder.getRequestAttributes() == null) return null;
		ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes) RequestContextHolder
				.getRequestAttributes();
		return servletRequestAttributes.getRequest();
	}

	/**
	 * ajax response输出
	 * 
	 * @param str
	 * @param response
	 */
	public static void output(String str, HttpServletResponse response) {
		try {
			response.getOutputStream().write(str.getBytes("UTF-8"));
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}

	/**
	 * 返回输出流
	 * 
	 * @param response
	 * @return
	 */
	public static ServletOutputStream output(HttpServletResponse response) {
		try {
			return response.getOutputStream();
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
		return null;
	}

	/**
	 * 对象转换成json格式
	 * 
	 * @param o
	 * @return
	 */
	public static String toJson(Object o) {
		String s = null;
		try {
			s = new ObjectMapper().writeValueAsString(o);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return s;
	}
	
	/**
	 * 对象转换成json格式 (解决延迟加载的问题)
	 * 
	 * @param o
	 * @return
	 */
	public static String toJsonLazy(Object o) {
		String s = null;
		try {
			ObjectMapper om = new ObjectMapper();
			om.configure(Feature.FAIL_ON_EMPTY_BEANS, false);
			s = om.writeValueAsString(o);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return s;
	}

	/**
	 * 将 "1,2,3,3,5" 字符转为Integer数组
	 * 
	 * @param value
	 * @return
	 */
	public static Integer[] getIntegers(String value) {
		try {
			if (value != null) {
				String[] param = value.split(",");
				Set<Integer> set = new LinkedHashSet<Integer>();
				for (int i = 0; i < param.length; i++)
					set.add(Integer.valueOf(param[i]));
				Integer[] rs = new Integer[set.size()];
				return set.toArray(rs);
			}
		} catch (Exception e) {
		}
		return null;
	}
	
	/**
	 * 从身份证中提取生日
	 * @return
	 */
	public static String getBirthByIdCard(String idCard){
		idCard = idCard.substring(6,14);
		return idCard.substring(0,4)+"-"+idCard.substring(4,6)+"-"+idCard.substring(6);
	}
	
	/**
	 * 替换特殊字符，json不能正确解析这些字符，所以替换为html的转移字符，在网页上能正常显示
	 * 
	 * @param content
	 * @return
	 */
	public static String replaceSomeChar(String content) {
		content = content.replaceAll("'", "&#39;");
		content = content.replaceAll("\"", "&quot;");
		content = content.replaceAll("<", "&lt;");
		content = content.replaceAll(">", "&gt;");
		return content;
	}
	
	/**
	 * 验证Email
	 * @param email
	 * @return
	 */
	public static boolean emailFormat(String email){  
        boolean tag = true;  
        final String pattern1 = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";  
        final Pattern pattern = Pattern.compile(pattern1);  
        final Matcher mat = pattern.matcher(email);  
        if (!mat.find()) {  
            tag = false;  
        }  
        return tag;  
    }
}
