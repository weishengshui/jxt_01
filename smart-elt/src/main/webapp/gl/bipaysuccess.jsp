<%@page import="com.tenpay.PayLogger"%>
<%@page import="java.math.BigDecimal"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%@page import="com.tenpay.client.ClientResponseHandler"%>
<%@page import="com.tenpay.client.TenpayHttpClient"%>
<%@page import="com.tenpay.RequestHandler"%>
<%@page import="com.tenpay.TenpayParameterProvider"%>
<%@ page import="com.tenpay.ResponseHandler"%>  
<%@ page import="com.tenpay.util.TenpayUtil"%> 

<%
if (!isAuth && !isLeader) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
 <script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">

function reftopjf(jf)
{
	var shows="";
	for (var i=1;i<=jf.length;i++)
	{
		shows=shows+"<li>"+jf.substring(i-1,i)+"</li>";
	}	
	document.getElementById("headjf").innerHTML=shows;	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>

<%@ include file="head.jsp" %>
<%
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";
try
{
  SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
  String bh=request.getParameter("bh");
  String pt=request.getParameter("pt");
  String zzsj="";
  if ((bh!=null &&!fun.sqlStrCheck(bh)) || (pt!=null && !fun.sqlStrCheck(pt)))
  {
  	response.sendRedirect("buyintegral.jsp");
  	return;
  }
  
  int zzzt=0,qy=0,sfzk=0;
  double total_fee=0;
  int zzjf=0;
  	//线下支付
  	if (pt!=null && pt.equals("3"))
  	{
		strsql="select zzje,zzjf,zzsj,zzzt from tbl_jfzz where zzbh='"+bh+"'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			total_fee=rs.getDouble("zzje");
			zzjf=rs.getInt("zzjf");
			zzsj=sf.format(rs.getDate("zzsj"));
			zzzt=rs.getInt("zzzt");
		}
		rs.close();
		
		if (zzzt==0)
		{
			strsql="update tbl_jfzz set zzzt=2,zzfs=1 where zzbh='"+bh+"'";
			stmt.executeUpdate(strsql);
		}
		%>
		<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico3">
						<div class="local2-1"><h1>确认购买积分数</h1><h2><%=zzsj%></h2></div>
					</li>
					<li class="local-ico1">
						<div class="local2-2"><h1>选择支付方式</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local2-3"><h1>订单成功</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
				</ul>	
				<div class="paydetail">恭喜您，您的订单 <span class="txt1"><%=bh%></span> 已经生成，您已选择“线下支付”，请将购买积分款项（<%=total_fee%>元）支付到合同约定的公司账号<br/><br/>您购买的<%=zzjf%>积分将在线下支付成功之后到账，感谢您的使用！ </div>
				<%if (isAuth) {%>
				<div class="paytishi">您目前公司账户积分余额 <span><%=session.getAttribute("qyjf")%></span></div>
				<%} else if (isLeader) { %>
				<div class="paytishi">您目前账户积分余额 <span><%=session.getAttribute("qyjf")%></span></div>
				<%} %>
				<div class="paybtnbox2">					<a href="assignintegral.jsp" class="ffjfbtn2"></a>
					<span>您还可以进行以下操作</span>
					<a href="buyintegral.jsp" class="jsgmbtn2"></a>
					<a href="buywelfare.jsp" class="gmflbtn2"></a>					
				</div>
				<div class="clear"></div>
			</div>	
	  	</div>
	</div>
		<%
  	}
  	else
  	{
  		
  		String payErrorInfo = "";
  		//---------------------------------------------------------
  		//财付通支付应答（处理回调）示例，商户按照此文档进行开发即可
  		//---------------------------------------------------------
  		
  		//创建支付应答对象
  		ResponseHandler resHandler = new ResponseHandler(request, response);
  		resHandler.setKey(TenpayParameterProvider.getProvider.getKey());
  		
  		//判断签名
  		if(resHandler.isTenpaySign()) {
  		
  		    //通知id
  			String notify_id = resHandler.getParameter("notify_id");
  			//商户订单号
  			String out_trade_no = resHandler.getParameter("out_trade_no");
  			// bh == out_trade_no 交易号
  			bh = out_trade_no;
  			//财付通订单号
  			String transaction_id = resHandler.getParameter("transaction_id");
  			//金额,以分为单位
  			String tenpay_total_fee = resHandler.getParameter("total_fee");
  			
  			PayLogger.getLogger().log("call pay return",resHandler.getAllParameters().toString(),out_trade_no);
  			
  			double tenpay_return_total_fee = Double.parseDouble(tenpay_total_fee);
  			if(total_fee*100 != tenpay_return_total_fee){
  				// XXX log ....
  				total_fee = tenpay_return_total_fee / 100 ;
  			}
  			
  			//如果有使用折扣券，discount有值，total_fee+discount=原请求的total_fee
  			String discount = resHandler.getParameter("discount");
  			//支付结果
  			String trade_state = resHandler.getParameter("trade_state");
  			//交易模式，1即时到账，2中介担保
  			String trade_mode = resHandler.getParameter("trade_mode");
  			
  			// 通过notify_id向财付通验证有效性
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
  			PayLogger.getLogger().log("validate pay return",queryReq.getRequestURL(),"&notify_Id:"+notify_id);
  			
  			if("1".equals(trade_mode)){       //即时到账 
  				if( "0".equals(trade_state)){
  					
  					// 调用验证接口
  					if(httpClient.call()) {
  						
  						//设置结果参数
  						queryRes.setContent(httpClient.getResContent());
  						queryRes.setKey(TenpayParameterProvider.getProvider.getKey());
 						
  						//获取id验证返回状态码，0表示此通知id是财付通发起
  						String retcode = queryRes.getParameter("retcode");
  						
  						PayLogger.getLogger().log("validate nofitication return",httpClient.getResContent(),"&notify_Id:"+notify_id,"&retcode:"+retcode);
  						// 验证成功
  						if(queryRes.isTenpaySign()&& "0".equals(retcode)){ 
  							 //------------------------------
  							//即时到账处理业务开始
  							//------------------------------
  							//获取debug信息,建议把debug信息写入日志，方便定位问题
					  		//String debuginfo = resHandler.getDebugInfo();
					  		//System.out.println("debuginfo:" + debuginfo);
					  		//out.print("sign_String:  " + debuginfo + "<br><br>");
					  		
  							//PayLogger.getLogger().log(out_trade_no,"success",queryReq.getRequestURL(),debuginfo,"");
		
  							strsql="select qy,zzjf,zzje,zzzt,zztype,zzr from tbl_jfzz where zzbh='"+bh+"' for update";
							rs=stmt.executeQuery(strsql);
  							int zztype=0,zzr=0;
							if (rs.next())
							{
								qy=rs.getInt("qy");
								zzzt=rs.getInt("zzzt");
								total_fee=rs.getDouble("zzje");
								zzjf=rs.getInt("zzjf");
								zztype=rs.getInt("zztype");
								zzr=rs.getInt("zzr");
							}
							rs.close();
							
							if (zzzt==0)
							{
								//有支付折扣只更新状态
								if (zzjf!=total_fee*10)
								{
									strsql="update tbl_jfzz set zzzt=1,fksj=now(),zzfs=2  where zzbh='"+bh+"'";
									stmt.executeUpdate(strsql);
								}
								else
								{
									//更新状态					
									strsql="update tbl_jfzz set zzzt=3,dzjf="+String.valueOf(total_fee*10)+",fksj=now(),zzfs=2 where zzbh='"+bh+"'";
									stmt.executeUpdate(strsql);
									
									//zztype 0:企业HR和管理员  1:部门leader 2:小组leader 3:员工既是部门leader,又是小组leader
									if (zztype==0) {
										//更新企业积分
										strsql="update tbl_qy set jf=jf+"+String.valueOf(total_fee*10)+" where nid="+qy;
										stmt.executeUpdate(strsql);
									} else {
										String ffh=zzr+String.valueOf(Calendar.getInstance().getTimeInMillis());
										strsql="insert into tbl_jfff (qy,ffjf,ffr,ffsj,ffzt,ffh,fftype) values("+qy+","+zzjf+","+zzr+",now(),1,'"+ffh+"',"+zztype+")";
										stmt.executeUpdate(strsql);
										
										strsql="select nid from tbl_jfff where qy="+qy+" and ffr="+zzr+" and ffh='"+ffh+"'";
										rs=stmt.executeQuery(strsql);
										String jfffId="";
										if (rs.next())
										{
											jfffId=rs.getString("nid");
										}
										rs.close();
										
										//1:部门 2:小组
										int fflx=1;
										if (zztype==2) {
											fflx=2;
											strsql="select nid,xzmc as mc from tbl_qyxz where ld="+zzr;
										} else {
											fflx=1;
											strsql="select nid,bmmc as mc from tbl_qybm where ld="+zzr;
										}
										rs=stmt.executeQuery(strsql);
										String nid="0";
										String mc="";
										if (rs.next())
										{
											nid=rs.getString("nid");
											mc=rs.getString("mc");
										}
										rs.close();
										
										strsql="insert into tbl_jfffxx (qy,jfff,fflx,lxbh,jf,ldbh,jsmc) values("+qy+","+jfffId+","+fflx+","+nid+","+zzjf+","+zzr+",'"+mc+"')";
										stmt.executeUpdate(strsql);

										getjfxx(stmt, session);
										out.print("<script type='text/javascript'>reftopjfxx('"+session.getAttribute("hrffjf")+"', '"+session.getAttribute("gmjf")+"');</script>");
									}
									
									long newqyjf=Integer.valueOf(session.getAttribute("qyjf").toString())+Math.round(total_fee*10);
									session.setAttribute("qyjf",newqyjf);
									out.print("<script type='text/javascript'>reftopjf('"+newqyjf+"')</script>");
								}
								
							}
  							//------------------------------
  							//即时到账处理业务完毕
  							//------------------------------
  							PayLogger.getLogger().log("Determined pay and local success","即时到帐付款成功","&zzbh:"+out_trade_no);
  						}else{
  							payErrorInfo = "调用认证接口返回的页面验证签名失败!";
  						}
  					}
  					// 调用验证借口失败
  					else{
  						payErrorInfo = "Call tenpay validate return false! <code>httpClient.call() return false</code>";
  					}
  					
  				}else{
  					payErrorInfo = "即时到帐付款失败,trade_state not [0] actually value is :"+trade_state;	
  				}
  			}else if("2".equals(trade_mode)){    //中介担保
  				throw new UnsupportedOperationException("trade_mode [2] unsupported!");
  			}
  		} else {
  			payErrorInfo = "财付通返回的页面认证签名失败";
  		}
  		
  		if(null != payErrorInfo && !payErrorInfo.isEmpty()){
  			PayLogger.getLogger().log("pay or validate failed",payErrorInfo,"");
  		}
  		
  strsql="select z.zzbh,z.zzjf,z.zzje,z.dzjf,z.zzzt,z.zzbz,z.zzsj,z.fksj,z.dzjf,q.jf from tbl_jfzz z left join tbl_qy q on z.qy=q.nid where z.zzbh='"+bh+"'";
  
  rs=stmt.executeQuery(strsql);
  if (rs.next())
  {
 %>
	
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico3">
						<div class="local2-1"><h1>确认购买积分数</h1><h2><%=sf.format(rs.getDate("zzsj")) %></h2></div>
					</li>
					<li class="local-ico1">
						<div class="local2-2"><h1>选择支付方式</h1><h2><%=sf.format(rs.getDate("fksj")) %></h2></div>
					</li>
					<li>
						<div class="local2-3"><h1>订单成功</h1><h2><%=(rs.getDate("fksj")!=null)?sf.format(rs.getDate("fksj")):"" %></h2></div>
					</li>
				</ul>	
				<div class="paydetail">
				恭喜您，您的订单 <span class="txt1"><%=rs.getString("zzbh") %></span> 已经购买了 <span class="txt2"><%=rs.getString("zzjf") %></span> 积分，已经付款成功！
				</div>
				<div class="paytishi">您目前公司账户积分余额 <span><%=rs.getString("jf")%></span></div>
				<div class="paybtnbox2">
					<a href="assignintegral.jsp" class="ffjfbtn2"></a>
					<span>您还可以进行以下操作</span>
					<a href="buyintegral.jsp" class="jsgmbtn2"></a>
					<a href="buywelfare.jsp" class="gmflbtn2"></a>
				</div>
				<div class="clear"></div>
			</div>	
	  	</div>
	</div>
	<%}
	rs.close();
	}
	%>
	<%@ include file="footer.jsp" %>
	<%
	
}
  catch(Exception e)
{			
	e.printStackTrace();
	conn.rollback();
	conncommit=0;
}
finally
{
	if (!conn.isClosed())
	{	
		if (conncommit==1)
			conn.commit();
		conn.close();
	}
}
	 %>
</body>
</html>
