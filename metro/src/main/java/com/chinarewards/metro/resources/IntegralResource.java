package com.chinarewards.metro.resources;

import java.io.StringWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.account.TxStatus;
import com.chinarewards.metro.domain.account.Unit;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.business.RedemptionDetail;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.models.CheckCodeResp;
import com.chinarewards.metro.models.ExternalMemberReg;
import com.chinarewards.metro.models.IntegralAddResp;
import com.chinarewards.metro.models.IntegralConsumeResp;
import com.chinarewards.metro.models.common.DES3;
import com.chinarewards.metro.models.request.CheckCodeReq;
import com.chinarewards.metro.models.request.IntegralAddReq;
import com.chinarewards.metro.models.request.IntegralConsumeReq;
import com.chinarewards.metro.repository.shop.ShopRepository;
import com.chinarewards.metro.sequence.BusinessNumGenerator;
import com.chinarewards.metro.service.account.IAccountService;
import com.chinarewards.metro.service.activity.IActivityService;
import com.chinarewards.metro.service.discount.IDiscountService;
import com.chinarewards.metro.service.integralManagement.IIntegralManagementService;
import com.chinarewards.metro.service.line.ILineService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.merchandise.IMerchandiseService;
import com.chinarewards.metro.service.message.impl.MessageService;
import com.chinarewards.utils.StringUtil;

@Component
@Path("/integral")
public class IntegralResource {

	@Autowired
	IDiscountService discountService;
	@Autowired
	IMemberService memberService;
	@Autowired
	ILineService lineService;
	@Autowired
	IActivityService activityService;
	@Autowired
	ShopRepository shopRepository;
	@Autowired
	BusinessNumGenerator businessNumGenerator;
	@Autowired
	IMerchandiseService merchandiseService;
	@Autowired
	HBDaoSupport hbDaoSupport;
	@Autowired
	IAccountService accountService;
	@Autowired
	IIntegralManagementService integralManagementService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@POST
	@Path("/useIntegral")
	@Produces({ "application/xml", "application/json" })
	public IntegralConsumeResp useIntegral(IntegralConsumeReq req) throws JAXBException {
		//OperateStatus  0--失败；1--成功
		
		IntegralConsumeResp resp=new IntegralConsumeResp();
		resp.setOrderId(req.getOrderId());
		resp.setOrderSource(req.getOrderSource());
		resp.setDescription(req.getDescription());
		// check sign
		String checkStr = req.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(IntegralConsumeReq.class);
		req.setCheckStr(SHA1Util.SHA1Encode(req
				.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(req, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		if(StringUtil.isEmptyString(req.getOrderId())){
			resp.setErrorInformation("订单id不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getCommodityIdList()==null||req.getCommodityIdList().size()==0){
			resp.setErrorInformation("商品不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(StringUtil.isEmptyString(req.getOrderSource())){
			resp.setErrorInformation("订单来源不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getPoint()==0){
			resp.setErrorInformation("积分不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getPoint()<0){
			resp.setErrorInformation("积分填写错误！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getOperateTime()==null){
			resp.setErrorInformation("操作时间不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(StringUtil.isEmptyString(req.getUserId())||req.getUserId()==null){
			resp.setErrorInformation("会员id不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else{
			resp=integralManagementService.useIntegral(req, resp);
		}
        resp.setPoint(req.getPoint());
        resp.setOperateTime(req.getOperateTime());
        resp.setUserId(req.getUserId());
        // sign
        logger.trace("===================");
		String ckvalue = resp.getSignValue();
		resp.setCheckStr(SHA1Util.SHA1Encode(ckvalue));
		JAXBContext ctx = JAXBContext.newInstance(IntegralConsumeResp.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(resp, writer);
		String custString = writer.toString();
		resp.setCheckStr(MD5.MD5Encoder(custString));
        
		return resp;
	}
	
	@POST
	@Path("/addIntegral")
	@Produces({ "application/xml", "application/json" })
	public IntegralAddResp addIntegral(IntegralAddReq req) throws JAXBException {
		// check sign
		String checkStr = req.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(IntegralAddReq.class);
		req.setCheckStr(SHA1Util.SHA1Encode(req
				.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(req, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		final byte[] keyBytes = DES3.getKeyBytes("20130220112053"); // 24字节的密钥
		IntegralAddResp resp=new IntegralAddResp();
		String point="";
		String money="";
		
		try {
			 point=DES3.decryptStrMode(keyBytes, req.getPoint());
			 money=DES3.decryptStrMode(keyBytes, req.getMoney());
		} catch (Exception e) {
			resp.setErrorInformation("您提供数据出错！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
			String ckvalue = resp.getSignValue();
			resp.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

			JAXBContext ctx = JAXBContext.newInstance(IntegralAddResp.class);
			StringWriter writer = new StringWriter();
			ctx.createMarshaller().marshal(resp, writer);
			String custString = writer.toString();
			resp.setCheckStr(MD5.MD5Encoder(custString));
			return resp;
		}
		
		Pattern pattern = Pattern.compile("[0-9]*");
		if(StringUtil.isEmptyString(req.getRequestRource())){
			resp.setErrorInformation("请求来源不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getCommodityIdList()==null&&req.getCommodityIdList().size()==0){
			resp.setErrorInformation("商品ID不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(StringUtil.isEmptyString(req.getPoint())){
			resp.setErrorInformation("积分不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(StringUtil.isEmptyString(req.getMoney())){
			resp.setErrorInformation("金额不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getOperateTime()==null){
			resp.setErrorInformation("操作时间不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(req.getUserId()==null){
			resp.setErrorInformation("会员id不能为空！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if( pattern.matcher(point).matches()==false){
			resp.setErrorInformation("请输入正确的积分！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if( pattern.matcher(money).matches()==false){
			resp.setErrorInformation("请输入正确的金额！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(!StringUtil.isEmptyString(point) &&Integer.valueOf(point)<0){
			resp.setErrorInformation("积分不能为负数！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(!StringUtil.isEmptyString(money) &&Integer.valueOf(money)<0){
			resp.setErrorInformation("金额不能为负数！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}
		
		
	    req.setPoint(point);
	    req.setMoney(money);
	    if(resp.getOperateStatus()!=0||StringUtil.isEmptyString(resp.getErrorInformation())){
	    	resp=integralManagementService.addIntegral(req);
	    
			resp.setPoint(Double.valueOf(point));
		
	    }
		resp.setRequestRource(req.getRequestRource());
		resp.setOperateTime(req.getOperateTime());
		resp.setUserId(req.getUserId());
		 // sign
		String ckvalue = resp.getSignValue();
		resp.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext.newInstance(IntegralAddResp.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(resp, writer);
		String custString = writer.toString();
		resp.setCheckStr(MD5.MD5Encoder(custString));
		
		return resp;
	}

	
	
	public IDiscountService getDiscountService() {
		return discountService;
	}

	public void setDiscountService(IDiscountService discountService) {
		this.discountService = discountService;
	}

	public IMemberService getMemberService() {
		return memberService;
	}

	public void setMemberService(IMemberService memberService) {
		this.memberService = memberService;
	}

	public ILineService getLineService() {
		return lineService;
	}

	public void setLineService(ILineService lineService) {
		this.lineService = lineService;
	}

	public IActivityService getActivityService() {
		return activityService;
	}

	public void setActivityService(IActivityService activityService) {
		this.activityService = activityService;
	}

}
