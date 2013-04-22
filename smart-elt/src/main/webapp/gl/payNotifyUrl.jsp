<%@page import="com.tenpay.TenpayParameterProvider"%>
<%@page import="com.tenpay.PayLogger"%>
<%@page import="java.math.BigDecimal"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@page import="jxt.elt.common.DbPool"%>
<%@ page import="com.tenpay.RequestHandler" %>
<%@ page import="com.tenpay.ResponseHandler" %>   
<%@ page import="com.tenpay.client.ClientResponseHandler" %>    
<%@ page import="com.tenpay.client.TenpayHttpClient" %>
<%@ page import="com.tenpay.util.TenpayUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
Connection conn=DbPool.getInstance().getConnection();
int conncommit=1;
try{
conn.setAutoCommit(false);
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
//---------------------------------------------------------
//财付通支付通知（后台通知）示例，商户按照此文档进行开发即可
//---------------------------------------------------------

//创建支付应答对象
ResponseHandler resHandler = new ResponseHandler(request, response);
resHandler.setKey(TenpayParameterProvider.getProvider.getKey());

System.out.println("后台回调返回参数:"+resHandler.getAllParameters());
PayLogger.getLogger().log("Background notification","后台回调返回参数:"+resHandler.getAllParameters().toString(),"");

//判断签名
if(resHandler.isTenpaySign()) {
	
	//通知id
	String notify_id = resHandler.getParameter("notify_id");
	
	//创建请求对象
	RequestHandler queryReq = new RequestHandler(null, null);
	//通信对象
	TenpayHttpClient httpClient = new TenpayHttpClient();
	//应答对象
	ClientResponseHandler queryRes = new ClientResponseHandler();
	
	//通过通知ID查询，确保通知来至财付通
	queryReq.init();
	queryReq.setKey(TenpayParameterProvider.getProvider.getKey());
	queryReq.setGateUrl("https://gw.tenpay.com/gateway/simpleverifynotifyid.xml");
	queryReq.setParameter("partner", TenpayParameterProvider.getProvider.getPartner());
	queryReq.setParameter("notify_id", notify_id);
	
	//通信对象
	httpClient.setTimeOut(5);
	//设置请求内容
	httpClient.setReqContent(queryReq.getRequestURL());
	PayLogger.getLogger().log("notification validate","验证ID请求字符串:"+queryReq.getRequestURL(),"");
	
	//后台调用
	if(httpClient.call()) {
		//设置结果参数
		queryRes.setContent(httpClient.getResContent());
		PayLogger.getLogger().log("notification validate","验证ID返回字符串:"+httpClient.getResContent(),"");
		queryRes.setKey(TenpayParameterProvider.getProvider.getKey());
			
			
		//获取id验证返回状态码，0表示此通知id是财付通发起
		String retcode = queryRes.getParameter("retcode");
		
		//商户订单号
		String out_trade_no = resHandler.getParameter("out_trade_no");
		//财付通订单号
		String transaction_id = resHandler.getParameter("transaction_id");
		//金额,以分为单位
		String pay_return_total_fee = resHandler.getParameter("total_fee");
		//如果有使用折扣券，discount有值，total_fee+discount=原请求的total_fee
		String discount = resHandler.getParameter("discount");
		//支付结果
		String trade_state = resHandler.getParameter("trade_state");
		//交易模式，1即时到账，2中介担保
		String trade_mode = resHandler.getParameter("trade_mode");
			
		//判断签名及结果
		if(queryRes.isTenpaySign()&& "0".equals(retcode)){ 
			// get buyed order info.
			int zzzt=0,qy=0,sfzk=0;
		  	double total_fee=0;
		  	int zzjf=0;
		  	String zzsj = "";
		  	String qyid="";
			strsql="select qy,zzje,zzjf,zzsj,zzzt from tbl_jfzz where zzbh="+out_trade_no +" for update";  	
		  	rs=stmt.executeQuery(strsql);
		  	if (rs.next())
		  	{
		  		total_fee=rs.getDouble("zzje");
				zzjf=rs.getInt("zzjf");
				zzsj=sf.format(rs.getDate("zzsj"));
				zzzt=rs.getInt("zzzt");
				qyid=rs.getString("qy");
		  		rs.close();
		  	}
		  	else
		  	{
		  		PayLogger.getLogger().log("notification!","That id is "+out_trade_no+" buyed order[tbl_jfzz] not found !!","&trandeNo:"+out_trade_no);
		  		throw new IllegalArgumentException("That id is "+out_trade_no+" buyed order[tbl_jfzz] not found !!");
		  	}
		  	
			if("1".equals(trade_mode)){       //即时到账 
				if( "0".equals(trade_state)){
					
					// 未支付状态
					if(zzzt == 0 ){
						//有支付折扣只更新状态
						if (zzjf!=total_fee*10)
						{
							strsql="update tbl_jfzz set zzzt=1,fksj=now(),zzfs=2  where zzbh='"+out_trade_no+"'";
							stmt.executeUpdate(strsql);
						}
						else
						{
							//更新企业积分
							strsql="update tbl_qy set jf=jf+"+String.valueOf(total_fee*10)+" where nid="+qyid;
							stmt.executeUpdate(strsql);
							
							//更新状态					
							strsql="update tbl_jfzz set zzzt=3,dzjf="+String.valueOf(total_fee*10)+",fksj=now(),zzfs=2 where zzbh='"+out_trade_no+"'";
							stmt.executeUpdate(strsql);
						}
					}
					
					PayLogger.getLogger().log("notification pay and local success!","即时到账支付成功","&trandeNo:"+out_trade_no);
					//给财付通系统发送成功信息，财付通系统收到此结果后不再进行后续通知
					resHandler.sendToCFT("success");
					
				}else{
					PayLogger.getLogger().log("nofitication validate","即时到账支付失败","&notify_id"+notify_id);
					resHandler.sendToCFT("fail");
				}
			}else if("2".equals(trade_mode)){
				// 中介担保方式不支持
				PayLogger.getLogger().log("nofitication validate","trade_mode 2 unsupported","&notify_id"+notify_id);
				
			}
		}else{
			//错误时，返回结果未签名，记录retcode、retmsg看失败详情。
			PayLogger.getLogger().log("nofitication validate","查询验证签名失败或id验证失败"+",retcode:" + queryRes.getParameter("retcode"),"&notify_id"+notify_id);
		}
	} else {
		//有可能因为网络原因，请求已经处理，但未收到应答。
		PayLogger.getLogger().log("nofitication validate","后台调用通信失败"+",ResponseCode:" + httpClient.getResponseCode()+"&ErrInfo"+httpClient.getErrInfo(),"&notify_id"+notify_id);
	}
}else{
	PayLogger.getLogger().log("notification","通知签名验证失败","");
}
}finally{
	if (!conn.isClosed())
	{	
		if (conncommit==1)
			conn.commit();
		conn.close();
	}

}
%>

