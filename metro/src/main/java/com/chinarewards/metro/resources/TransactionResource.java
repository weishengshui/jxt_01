package com.chinarewards.metro.resources;

import java.io.StringWriter;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.core.common.POSSalesCode;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.models.MemberSignArray;
import com.chinarewards.metro.models.SalesResp;
import com.chinarewards.metro.models.order.ExtOrderInfo;
import com.chinarewards.metro.models.order.ExtOrderInfoArray;
import com.chinarewards.metro.models.order.OrderRespArray;
import com.chinarewards.metro.models.request.SalesReq;
import com.chinarewards.metro.service.account.ITransactionService;

@Component
@Path("/trans")
public class TransactionResource {

	@Autowired
	private ITransactionService transactionService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@POST
	@Path("/push/order")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public OrderRespArray processExtOrder(ExtOrderInfoArray arrays)
			throws JAXBException {

		logger.trace("========== entry process extorder ==========");
		List<ExtOrderInfo> orders = arrays.getList();

		// check sign
		String checkStr = arrays.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(ExtOrderInfoArray.class);
		arrays.setCheckStr(SHA1Util.SHA1Encode(arrays.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(arrays, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			OrderRespArray result = new OrderRespArray();
			result.setResult("1");
			return result;
		}

		OrderRespArray result = transactionService.processExtOrders(orders);

		// sign
		String ckvalue = result.getSignValue();
		result.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext.newInstance(OrderRespArray.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(result, writer);
		String custString = writer.toString();
		result.setCheckStr(MD5.MD5Encoder(custString));
		
		return result;
	}

	@POST
	@Path("/sale")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public SalesResp posSales(SalesReq salesReq) {
		SalesResp result = transactionService.posSales("0",
				salesReq.getConsumeDetails(), salesReq.getPosId(),
				salesReq.getIdentify(), salesReq.getSerialId(),salesReq.isResend());
		if (result.getResult().equals(POSSalesCode.FAIL)) {
			result.setTip("获取积分失败");
		} else if (result.getResult().equals(POSSalesCode.MEMBER_NOT_EXISTS)) {
			result.setTip("会员不存在");
		} else if (result.getResult().equals(POSSalesCode.INVALID_POS)) {
			result.setTip("未注册终端");
		} else if (result.getResult().equals(POSSalesCode.OTHERS)) {
			result.setTip("未知异常,请联系管理员");
		}

		// decode .

		return result;
	}

	public ITransactionService getTransactionService() {
		return transactionService;
	}

	public void setTransactionService(ITransactionService transactionService) {
		this.transactionService = transactionService;
	}
}
