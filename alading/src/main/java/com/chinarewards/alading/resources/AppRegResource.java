package com.chinarewards.alading.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;

import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.AppRegisterService;
import com.google.inject.Inject;

@Path("/application")
public class AppRegResource {
	
	@InjectLogger
	private Logger logger;
	
	@Inject
	private AppRegisterService appRegisterService;
	
	@Path("/test")
	@GET
	public String helloworld(@QueryParam("name") String name) {
		return "hello," + name;
	}

	@Path("/auth")
	@GET
	public String authenticate(@QueryParam("appId") String appId,
			@QueryParam("macAddress") String macAddress) throws Exception {

		return appRegisterService.authenticate(appId, macAddress);
	}

	@Path("/register")
	@GET
	public String register(@QueryParam("appId") String appId,
			@QueryParam("regCode") String regCode,
			@QueryParam("macAddress") String macAddress) throws Exception {

		return appRegisterService.register(appId, regCode, macAddress);
	}
	
	@Path("/")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public String index(){
		logger.info("index");
		return "I am index page";
	}

}
