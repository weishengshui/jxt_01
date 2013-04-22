package com.chinarewards.metro.resources;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.Config;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.core.common.SystemParamsConfig;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.domain.metro.MetroSite;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.models.line.LineModel;
import com.chinarewards.metro.models.line.MetroLine;
import com.chinarewards.metro.models.line.ShopModel;
import com.chinarewards.metro.models.line.SiteModel;
import com.chinarewards.metro.models.request.MetroLineReq;
import com.chinarewards.metro.models.request.MetroSiteReq;
import com.chinarewards.metro.models.request.ShopReq;
import com.chinarewards.metro.models.response.ShopModelRes;
import com.chinarewards.metro.models.response.SiteModelRes;
import com.chinarewards.metro.service.line.ILineService;
@Component
@Path("/line")
public class LineResource {

	@Autowired
	private ILineService lineService;
	
	/**
	 * 外部接口获取门店信息
	 * @param table
	 * @param operateType
	 * @param description
	 * @param operateTime
	 * @return
	 * @throws JAXBException 
	 */
	@POST
	@Path("/shop/list")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public ShopModelRes findShopList(ShopReq m) throws JAXBException {
		
		String checkStr = m.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(ShopReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String ss = r.toString();
		if (!MD5.MD5Encoder(ss).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		List<Shop> list = lineService.offExternalShopList();
		List<ShopModel> listModel = new ArrayList<ShopModel>();
		for(Shop s : list){
			ShopModel shopModel = new ShopModel();
			shopModel.setShopId(s.getId());
			shopModel.setAddress(s.getProvince()+s.getCity()+s.getCity()+s.getRegion());
			shopModel.setBrand(s.getBrandName());
			shopModel.setChineseName(s.getName());
			shopModel.setEnglishName(s.getEnName());
			shopModel.setPosition(s.getLongitude()+","+s.getLatitude());
			shopModel.setStationed(s.getSiteId());
			shopModel.setTelephone(s.getWorkPhone());
			shopModel.setType(s.getShopType());
			listModel.add(shopModel);
		}
		ShopModelRes s = new ShopModelRes();
		s.setShopList(listModel);
		
		JAXBContext ctx = JAXBContext.newInstance(ShopModelRes.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(s, writer);
		String custString = writer.toString();
		s.setCheckStr(MD5.MD5Encoder(custString));
		
		return s;
	}
	
	
	/**
	 * 外部接口获取站点信息
	 * @param table
	 * @param operateType
	 * @param description
	 * @param operateTime
	 * @return
	 * @throws JAXBException 
	 */
	@POST
	@Path("/site/list")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public SiteModelRes findSiteList(MetroSiteReq m) throws JAXBException {
		
		String checkStr = m.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MetroSiteReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String ss = r.toString();
		if (!MD5.MD5Encoder(ss).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		List<MetroSite> list = lineService.offExternalSiteList();
		List<SiteModel> listModel = new ArrayList<SiteModel>();
		for(MetroSite ms : list){
			SiteModel siteModel  = new SiteModel();
			siteModel.setDescription(ms.getDescs());
			siteModel.setHotArea(ms.getHotArea());
			siteModel.setLineName(ms.getLineName());
			siteModel.setName(ms.getName());
			siteModel.setOrderNumber(ms.getOrderNos());
			siteModel.setPosition(ms.getLongitude()+","+ms.getLatitude());
			if(StringUtils.isNotEmpty(ms.getSmallPic())){
				siteModel.setSmallPic(SystemParamsConfig.getSysVariable("img_host").getValue()+"formalPath=SITE_IMG&fileName="+ms.getSmallPic());
			}
			if(StringUtils.isNotEmpty(ms.getPic())){
				siteModel.setPic(SystemParamsConfig.getSysVariable("img_host").getValue()+"formalPath=SITE_IMG&fileName="+ms.getPic());
			}
			siteModel.setStationId(ms.getId());
			listModel.add(siteModel);
		}
		SiteModelRes s = new SiteModelRes();
		s.setSiteList(listModel);
		
		JAXBContext ctx = JAXBContext.newInstance(SiteModelRes.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(s, writer);
		String custString = writer.toString();
		s.setCheckStr(MD5.MD5Encoder(custString));
		
		return s;
	}
	
	
	/**
	 * 获得线路信息
	 * @param req
	 * @return
	 * @throws JAXBException 
	 */
	@POST
	@Path("/lineDataList")
	@Produces({ "application/xml", "application/json" })
	public MetroLine findLineList(MetroLineReq req) throws JAXBException {
		String checkStr = req.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MetroLineReq.class);
		req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(req, r);
		String ss = r.toString();
		if (!MD5.MD5Encoder(ss).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		List<LineModel> listModel = lineService.queryLineInfos();
		List<LineModel> list = new ArrayList<LineModel>();
		for(LineModel m : listModel){
			LineModel lineModel = new LineModel();
			lineModel.setLineId(m.getLineId());
			lineModel.setLineName(m.getLineName());
			lineModel.setLineNum(m.getLineNum());
			if(StringUtils.isNotEmpty(m.getPic())){
				lineModel.setPic(SystemParamsConfig.getSysVariable("img_host").getValue()+"formalPath=LINE_IMG&fileName="+m.getPic());
			}
			if(StringUtils.isNotEmpty(m.getSmallPic())){
				lineModel.setSmallPic(SystemParamsConfig.getSysVariable("img_host").getValue()+"formalPath=LINE_IMG&fileName="+m.getSmallPic());
			}
			list.add(lineModel);
		}
		MetroLine s = new MetroLine();
		s.setModels(list);
		JAXBContext ctx = JAXBContext.newInstance(MetroLine.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(s, writer);
		String custString = writer.toString();
		s.setCheckStr(MD5.MD5Encoder(custString));
		return s;
	}
}
