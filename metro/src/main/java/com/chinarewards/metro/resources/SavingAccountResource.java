package com.chinarewards.metro.resources;

import java.io.StringWriter;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.system.ISysLogService;

/**
 * 
 * @author weishengshui
 * 
 */
@Component
@Path("/savingAccount")
public class SavingAccountResource {

	@Autowired
	private IMemberService memberService;
	@Autowired
	private ISysLogService sysLogService;

	/**
	 * 储值卡消费
	 * 
	 * @param reg
	 * @return
	 * @throws JAXBException
	 */
	@POST
	@Path("/consumption")
	@Produces({ "application/xml", "application/json" })
	public SavingAccountConsumptionRes modify(SavingAccountConsumptionReq req)
			throws JAXBException {

		// check sign
		String checkStr = req.getCheckStr();
		JAXBContext c = JAXBContext
				.newInstance(SavingAccountConsumptionReq.class);
		req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(req, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}

		SavingAccountConsumptionRes savingAccountConsumptionRes = null;
		
		com.chinarewards.metro.domain.member.Member member = memberService.findMemberById(req.getUserId());
		String name = null;
		if(null == member){
		}else {
			name = member.getSurname() + member.getName();
			name = (name==null)?member.getPhone():name;
		}
		try {
			savingAccountConsumptionRes = memberService
					.savingAccountConsumptionForClient(req);
			try {
				if(savingAccountConsumptionRes.getOperateStatus().equals(new Integer(1))){
					sysLogService.addSysLog("会员储值卡消费", name, OperationEvent.EVENT_CONSUMPTION.getName(), "成功");
				}else{
					sysLogService.addSysLog("会员储值卡消费", name, OperationEvent.EVENT_CONSUMPTION.getName(), "失败");
				}
			} catch (Exception e) {
			}
		} catch (RuntimeException e) {
			String orderId = req.getOrderId();
			String orderSource = req.getOrderSource();
			Double point = req.getPoint(); // 扣除金额。
			String operateTime = req.getOperateTime(); // 操作时间。格式yyyyMMddHHmmss
			Integer userId = req.getUserId(); // 会员Id
			String description = req.getDescription(); // 订单描述。可选
			savingAccountConsumptionRes = new SavingAccountConsumptionRes();
			savingAccountConsumptionRes.setDescription(description);
			savingAccountConsumptionRes.setOperateStatus(2);// failure
			savingAccountConsumptionRes.setOrderId(orderId);
			savingAccountConsumptionRes.setOrderSource(orderSource);
			savingAccountConsumptionRes.setPoint(point);
			savingAccountConsumptionRes.setOperateTime(operateTime);
			savingAccountConsumptionRes.setUserId(userId);
			savingAccountConsumptionRes.setStatusDescription("数据库异常");
//			e.printStackTrace();//transaction exception
			try {
				sysLogService.addSysLog("会员储值卡消费", name, OperationEvent.EVENT_CONSUMPTION.getName(), "失败");
			} catch (Exception e1) {
			}
		}

		// sign
		String ckvalue = savingAccountConsumptionRes.getSignValue();
		savingAccountConsumptionRes.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext
				.newInstance(SavingAccountConsumptionRes.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(savingAccountConsumptionRes, writer);
		String custString = writer.toString();
		savingAccountConsumptionRes.setCheckStr(MD5.MD5Encoder(custString));

		return savingAccountConsumptionRes;
	}

}
