package com.chinarewards.metro.core.exceptions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

public class AjaxMappingExceptionResolver extends SimpleMappingExceptionResolver{
	
	private static Log logger = LogFactory.getLog(AjaxMappingExceptionResolver.class);

	@Override
	protected ModelAndView doResolveException(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex) {
		logger.error("", ex);
		if(request.getHeader("x-requested-with") != null) {
			throw new RuntimeException(ex);
		} else {
			return super.doResolveException(request, response, handler, ex);
		}
	}
}
