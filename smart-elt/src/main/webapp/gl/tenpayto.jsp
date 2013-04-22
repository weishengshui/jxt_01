<%@page import="java.math.RoundingMode"%>
<%@page import="com.tenpay.util.TenpayUtil"%>
<%@page import="com.tenpay.*"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.tenpay.TenpayParameterProvider"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%@ include file="../common/hrlogcheck.jsp"%>
<%@page import="jxt.elt.common.DbPool"%>
<%
	if (session.getAttribute("glqx").toString().indexOf(",10,") == -1) {
		response.sendRedirect("main.jsp");
	}

	//请求的url
	String requestUrl = "";

	//获取debug信息,建议把请求和debug信息写入日志，方便定位问题
	String debuginfo = "";

	Exception exception = null;

	Connection conn = DbPool.getInstance().getConnection();
	Statement stmt = conn.createStatement();
	Fun fun = new Fun();
	ResultSet rs = null;
	String strsql = "", zzjf = "", zzje = "", bz = "", zzbh = "";
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	String zzsj = "";

	try {
		zzbh = request.getParameter("zzbh");
		if (zzbh != null && !zzbh.equals("")) {
			if (!fun.sqlStrCheck(zzbh)) {
				response.sendRedirect("buyintegral.jsp");
				return;
			}
			strsql = "select nid,zzje,zzjf,zzbz,zzbh,zzsj from tbl_jfzz where zzbh="
					+ zzbh;
			rs = stmt.executeQuery(strsql);
			if (rs.next()) {
				zzbh = rs.getString("zzbh");
				zzjf = rs.getString("zzjf");
				zzje = rs.getString("zzje");
				bz = rs.getString("zzbz");
				zzsj = sf.format(rs.getDate("zzsj"));
				if (bz == null)
					bz = "";
				rs.close();
			} else {
				rs.close();
				response.sendRedirect("buyintegral.jsp");
				return;
			}
		}

		//财付通支付链接生成
		String currTime = TenpayUtil.getCurrTime();
		//创建支付请求对象
		RequestHandler reqHandler = new RequestHandler(request,
				response);
		reqHandler.init();
		//设置密钥
		reqHandler.setKey(TenpayParameterProvider.getProvider.getKey());
		//设置支付网关
		reqHandler.setGateUrl(TenpayParameterProvider.getProvider
				.getGW());

		//-----------------------------
		//设置支付参数
		//-----------------------------
		reqHandler.setParameter("partner",
				TenpayParameterProvider.getProvider.getPartner()); //商户号
		reqHandler.setParameter("out_trade_no", zzbh); //商家订单号

		// 转化分单位
		System.out.println("########!!! zzje:" + zzje);
		BigDecimal bzzje = new BigDecimal(zzje);
		bzzje = bzzje.multiply(new BigDecimal(100));
		long izzje = bzzje.setScale(0, BigDecimal.ROUND_DOWN)
				.longValue();
		System.out.println("#### total fee " + izzje);

		reqHandler.setParameter("total_fee", String.valueOf(izzje)); //商品金额,以分为单位
		reqHandler.setParameter("return_url",
				TenpayParameterProvider.getProvider.getReturnUrl()); //交易完成后跳转的URL
		reqHandler.setParameter("notify_url",
				TenpayParameterProvider.getProvider.getNotifyUrl()); //接收财付通通知的URL
		reqHandler.setParameter("body", "IRewards积分"); //商品描述
		reqHandler.setParameter("bank_type", "DEFAULT"); //银行类型(中介担保时此参数无效)
		reqHandler.setParameter("spbill_create_ip",
				request.getRemoteAddr()); //用户的公网ip，不是商户服务器IP
		reqHandler.setParameter("fee_type", "1"); //币种，1人民币
		reqHandler.setParameter("subject", ""); //商品名称(中介交易时必填)

		//系统可选参数
		reqHandler.setParameter("sign_type", "MD5"); //签名类型,默认：MD5
		reqHandler.setParameter("service_version", "1.0"); //版本号，默认为1.0
		reqHandler.setParameter("input_charset", "UTF-8"); //字符编码
		//reqHandler.setParameter("sign_key_index", "1");             //密钥序号

		//业务可选参数
		/*reqHandler.setParameter("attach", zzbh);		            //附加数据，原样返回 <这里设置为商家订单号 >
		reqHandler.setParameter("product_fee", "");                 //商品费用，必须保证transport_fee + product_fee=total_fee
		reqHandler.setParameter("transport_fee", "0");               //物流费用，必须保证transport_fee + product_fee=total_fee
		reqHandler.setParameter("time_start", currTime);            //订单生成时间，格式为yyyymmddhhmmss
		reqHandler.setParameter("time_expire", "");                 //订单失效时间，格式为yyyymmddhhmmss
		reqHandler.setParameter("buyer_id", "");                    //买方财付通账号
		reqHandler.setParameter("goods_tag", "");                   //商品标记
		reqHandler.setParameter("trade_mode", trade_mode);                 //交易模式，1即时到账(默认)，2中介担保，3后台选择（买家进支付中心列表选择）
		reqHandler.setParameter("transport_desc", "");              //物流说明
		reqHandler.setParameter("trans_type", "1");                  //交易类型，1实物交易，2虚拟交易
		reqHandler.setParameter("agentid", "");                     //平台ID
		reqHandler.setParameter("agent_type", "");                  //代理模式，0无代理(默认)，1表示卡易售模式，2表示网店模式
		reqHandler.setParameter("seller_id", "");                   //卖家商户号，为空则等同于partner
		 */

		//请求的url
		requestUrl = reqHandler.getRequestURL();

		//获取debug信息,建议把请求和debug信息写入日志，方便定位问题
		debuginfo = reqHandler.getDebugInfo();

		reqHandler.doSend();
	} catch (Exception e) {
		exception = e;
		e.printStackTrace();
	} finally {
		PayLogger.getLogger().log(
				"Call tenpay",
				"RequestUrl[" + requestUrl + "] debugInfo[" + debuginfo
						+ "]", zzbh);
		if (!conn.isClosed())
			conn.close();
	}
%>
