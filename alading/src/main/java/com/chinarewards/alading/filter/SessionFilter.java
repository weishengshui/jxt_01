package com.chinarewards.alading.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.inject.Singleton;

@Singleton
public class SessionFilter implements Filter {

	private List<String> filterDirs = new ArrayList<String>();

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		String include = filterConfig.getInitParameter("include");
		if (null != include) {
			StringTokenizer tokenizer = new StringTokenizer(include, ",");
			filterDirs.clear();
			while (tokenizer.hasMoreTokens()) {
				filterDirs.add(tokenizer.nextToken());
			}
		}
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		HttpSession session = req.getSession();

		System.out.println("url " + req.getRequestURL().toString());
		System.out.println("uri " + req.getRequestURI());
		System.out.println("servletpath " + req.getServletPath());

//		if (req.getRequestURI().contains("ishelf")) { // restful 资源访问不过滤
//			chain.doFilter(request, response);
//		} else {
			// 是否要过滤
			boolean isFilter = false;
			for (String dir : filterDirs) {
				if (req.getRequestURI().indexOf(dir) != -1) {
					isFilter = true;
					break;
				}
			}
			if (isFilter && null == session.getAttribute("username")) {
				res.sendRedirect(req.getContextPath() + "/login.jsp");
			} else {
				chain.doFilter(request, response);
			}
//		}

	}

	@Override
	public void destroy() {

	}

}
