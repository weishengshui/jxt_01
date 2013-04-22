package com.chinarewards.metro.resources;

import java.io.StringWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.models.merchandise.Merchandise;
import com.chinarewards.metro.models.merchandise.MerchandiseArray;
import com.chinarewards.metro.models.request.MerchandiseReq;
import com.chinarewards.metro.service.merchandise.IMerchandiseService;

@Component
@Path("/merchandise")
public class MerchandiseResource {

	@Autowired
	private IMerchandiseService merchandiseService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	@POST
	@Path("/list")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public MerchandiseArray account(MerchandiseReq req, @Context HttpServletRequest request) throws JAXBException {
		
		logger.trace("========== entry process get merchandises list ==========");
		MerchandiseArray result = new MerchandiseArray();

		// check sign
		String checkStr = req.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MerchandiseReq.class);
		req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(req, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			return result;
		}

		List<Merchandise> merchandises = merchandiseService.getMerchandiseForClient(req, request);
		result.setList(merchandises);

		// sign
		String signValue = result.getSignValue();
		result.setCheckStr(SHA1Util.SHA1Encode(signValue));
		JAXBContext ctx = JAXBContext.newInstance(MerchandiseArray.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(result, writer);
		String custString = writer.toString();
		result.setCheckStr(MD5.MD5Encoder(custString));
		
		return result;
	}

}
