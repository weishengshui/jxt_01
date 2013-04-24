package com.chinarewards.oauth.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;

import com.chinarewards.oauth.ServiceLocator;
import com.chinarewards.oauth.log.InjectLogger;
import com.chinarewards.oauth.service.AppRegisterService;

@Path("/application")
public class AppRegResource {
	
	@InjectLogger
	private Logger logger;
	
	@Path("/test")
	@GET
	public String helloworld(@QueryParam("name") String name) {
		return "hello," + name;
	}

	@Path("/auth")
	@GET
	public String authenticate(@QueryParam("appId") String appId,
			@QueryParam("macAddress") String macAddress) throws Exception {
		AppRegisterService service = ServiceLocator.getInstance()
				.getAppRegisterService();

		return service.authenticate(appId, macAddress);
	}

	@Path("/register")
	@GET
	public String register(@QueryParam("appId") String appId,
			@QueryParam("regCode") String regCode,
			@QueryParam("macAddress") String macAddress) throws Exception {
		AppRegisterService service = ServiceLocator.getInstance()
				.getAppRegisterService();
		return service.register(appId, regCode, macAddress);
	}
	
	@Path("/")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public String index(){
		logger.info("index");
		return "I am index page";
	}

}
