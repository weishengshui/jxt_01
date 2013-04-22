<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="jxt.elt.common.DbPool"%>
<%@page import="jxt.elt.common.SecurityUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工弹性福利，忠诚度奖励平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="alexaVerifyID" content="3uALKwptCi_lsgjfRsj24FLuNx8" />
<meta name="description" content="IRewards国内领先的专注于员工忠诚度管理的专业服务公司。通过对员工群体福利需求、工作模式的分析，以及自主研发的弹性福利和奖励平台，提高员工与企业、员工与员工之间的互动，提升员工关系和忠诚度。">
<link href="css/loginstyle.css" type="text/css" rel="stylesheet" />

<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));
</script>

<link rel="stylesheet" type="text/css" href="css/colortip-1.0-jquery.css"/>
<script type="text/javascript" src="gl/js/common.js"></script>
<script type="text/javascript" src="gl/js/jquery-1.7.min.js"></script>
<script type="text/javascript" src="gl/js/colortip-1.0-jquery.js"></script>
<script type="text/javascript" src="gl/js/script.js"></script>
<script type="text/javascript">
function login()
{
	if (document.getElementById("logname").value==null || document.getElementById("logname").value=="")
	{
		document.getElementById("errinfo").innerHTML ="请输入登录账号";
		return false;
	}
	if (document.getElementById("logpwd").value==null || document.getElementById("logpwd").value=="")
	{
		document.getElementById("errinfo").innerHTML ="请输入登录密码";
		return false;
	}
	document.getElementById("userId").value=document.getElementById("logname").value;
	document.getElementById("password").value=document.getElementById("logpwd").value;
	document.getElementById("logform").submit();
}
function logpwdchecck(t)
{
	if (t==1)
	{
		if (document.getElementById("logpwdtxt").value=="请输入您的密码")
		{				
			document.getElementById("logpwdtxt").style.display="none";
			document.getElementById("logpwd").style.display="";
			document.getElementById("logpwd").focus();
		}
	}
	else
	{
		if (document.getElementById("logpwd").value=="")
		{
			document.getElementById("logpwdtxt").style.display="";
			document.getElementById("logpwd").style.display="none";
		}
	}
}
function swap(seq){
	document.getElementById("logt").value=seq;
	if(seq == 1){
		document.getElementById("barh1").className ="";
		document.getElementById("barh2").className ="off2";		
	}
	if(seq == 2){
		document.getElementById("barh1").className ="off1";
		document.getElementById("barh2").className ="";
		
	}
}

function gogetpwd()
{
	openLayer("<div class=\"gpw\"><div class='close' onclick='closeLayer()'>X</div><div class=\"mtt\"><ul><li>通过邮箱找回密码</li></ul></div><div class=\"mcc\"><div class=\"lbox\"><b></b></div><div class=\"rbox\"><div class=\"item\"><span class=\"label\"><i>*</i>邮箱：</span><span><input type=\"text\" value=\"\" class=\"s-textbox\" name=\"gpemail\" id=\"gpemail\" /></span></div><div class=\"itembtns\"><input value=\" \" type=\"submit\" onclick='getpwd()' class=\"btn-1\" ></div></div></div>");
}
function getpwd()
{
	if (document.getElementById("gpemail").value=="")
	{
		document.getElementById("gpemail").focus();
		return;
	}
	if (!EmailCheck(document.getElementById("gpemail").value))
	{
		alert("邮箱格式不正确！");
		return;
	}
	
	alert("密码已成功发放到你邮箱！");	
	var timeParam = Math.round(new Date().getTime()/1000);	
	var url = "getpwd.jsp?email="+encodeURI(escape(document.getElementById("gpemail").value))+"&time="+timeParam;
	closeLayer();
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=getpwds;
	xmlHttp.send(null);	
}
function getpwds()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{
		}
		catch(exception){}
	}
}

var isIe = (document.all) ? true : false;
function init(){
    document.onkeydown = function(evt){
        catchKeyDown(evt);
    }
}

function catchKeyDown(evt){
    evt = (evt) ? evt : ((window.event) ? window.event : "");
    var key = isIe ? evt.keyCode : evt.which;

    if (evt.keyCode == 13) {
        var el = evt.srcElement || evt.target;
        if (el.name=="logname")
		{
           if (isIe)
              evt.keyCode = 9;
           else
              document.getElementById("logpwdtxt").focus();
        }
		if (el.name=="logpwd")
			login();
    }
}
window.onload = init;
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
 <div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div> 
<form action="http://192.168.4.235:7070/eltcustom/login.action" name="clogform" id="clogform" method="post">
<input type="hidden" name="userId" id="userId" />
<input type="hidden" name="password" id="password" />
</form>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();

try
{
	String logname=request.getParameter("logname");
	String logpwd=request.getParameter("logpwd");
	String logt=request.getParameter("logt");
	String validateCode=request.getParameter("validateCode");
	if (logt==null) logt="1"; 
	if (logname!=null && !logname.equals("") && logpwd!=null  && !logpwd.equals(""))
	{
		if (fun.sqlStrCheck(logname) && fun.sqlStrCheck(logpwd))
		{
			SecurityUtil su=new SecurityUtil();
			String strsql="select y.nid,y.ygxm,y.qy,y.gly,y.glqx,y.jf as ygjf,y.zt as yzt,y.xtzt,q.qymc,q.jf as qyjf,q.djjf,q.zt,q.log from tbl_qyyg y left join tbl_qy q on y.qy=q.nid where y.xtzt<>3 and y.email='" + logname +"' and y.dlmm='"+su.md5(logpwd)+"'";
			String reurl="";
//			if(validateCode.equals(request.getSession().getAttribute("rand").toString())){
				if("on".equals(request.getParameter("checkbox"))){
					Cookie cookie =  new Cookie("logname", logname);
					cookie.setMaxAge(60 * 60 * 24 * 14);//设置Cookie有效期为14天
					response.addCookie(cookie);
				}
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					if (rs.getString("zt")!=null && rs.getString("zt").equals("4"))
					{
						rs.close();
						out.print("<script type='text/javascript'>");
		         		out.print("alert('企业冻结中，请与本公司联系！');");	         		
		         		out.print("</script>");
					}
					else if (rs.getString("yzt")!=null && rs.getString("yzt").equals("0"))
					{
						rs.close();
						out.print("<script type='text/javascript'>");
		         		out.print("alert('您已离职不能登陆！');");	         		
		         		out.print("</script>");
					}
					else if (rs.getString("xtzt")!=null && rs.getString("xtzt").equals("2"))
					{
						rs.close();
						out.print("<script type='text/javascript'>");
						out.print("alert('账号冻结中，请与HR联系！');");         		
		         		out.print("</script>");
					}
				
					else
					{					
						
						session.setAttribute("ygxm",rs.getString("ygxm"));
						session.setAttribute("qymc",rs.getString("qymc"));
						session.setAttribute("ygid",rs.getString("nid"));
						session.setAttribute("qy",rs.getString("qy"));
						if (rs.getString("glqx")!=null)
							session.setAttribute("glqx",rs.getString("glqx"));
						else
							session.setAttribute("glqx","");
						session.setAttribute("qyjf",rs.getString("qyjf"));
						session.setAttribute("ygjf",rs.getString("ygjf"));
						session.setAttribute("djjf",rs.getString("djjf"));
						session.setAttribute("email",logname);
						session.setAttribute("qylog",rs.getString("log"));
						int gly=rs.getInt("gly");
						rs.close();
						//session.getServletContext().setAttribute("session",session);
						session.setAttribute("ffbm","''");
						session.setAttribute("ffxz","''");
						if (logt!=null && logt.equals("2"))
						{
							if (gly==1)
							{
								reurl="gl/main.jsp";
							}
							else
							{
								session.setAttribute("qyjf","0");
								int ffjf=0;
								String ffbm="",ffxz="";
								//没有判断是否要待发放积分，只判断是否是leader
								//从部门表判断是否是leader
								strsql="select nid from tbl_qybm where ld="+session.getAttribute("ygid");
								rs=stmt.executeQuery(strsql);
								while (rs.next())
								{
									ffjf=1;
									if (rs.isLast())
										ffbm=ffbm+rs.getString("nid");
									else
										ffbm=ffbm+rs.getString("nid")+",";
								}
								rs.close();
								
								
								strsql="select nid from tbl_qyxz where ld="+session.getAttribute("ygid");
								rs=stmt.executeQuery(strsql);
								while (rs.next())
								{
									ffjf=1;
									if (rs.isLast())
										ffxz=ffxz+rs.getString("nid");
									else
										ffxz=ffxz+rs.getString("nid")+",";
								}
								rs.close();
								
								
								if (ffjf==1)
								{
									session.setAttribute("ffjf","1");
									if (ffbm!=null && ffbm.length()>0)
										session.setAttribute("ffbm",ffbm);
									if (ffxz!=null && ffxz.length()>0)
									session.setAttribute("ffxz",ffxz);
									reurl="gl/main.jsp";
								}
								else
								{
									%>
									<script type="text/javascript">
									document.getElementById("userId").value="<%=logname%>";
									document.getElementById("password").value="<%=logpwd%>";
									document.getElementById("clogform").submit();
									</script>
									<%
								}
							}
						}
						else
						{
							//reurl="eltcustom/login!list.do";	
							%>
							<script type="text/javascript">
							document.getElementById("userId").value="<%=logname%>";
							document.getElementById("password").value="<%=logpwd%>";
							document.getElementById("clogform").submit();
							</script>
							<%
						}
						
					}
				}
				else
				{
					rs.close();
					out.print("<script type='text/javascript'>");
	         		out.print("alert('用户名或者密码错误！');");
	         		out.print("</script>");
				}
		//	}else{
		//		out.print("<script type='text/javascript'>");
		// 		out.print("alert('验证码错误！');");
		// 		out.print("</script>");
		//	}
			
			if (reurl!=null && !reurl.equals(""))
				response.sendRedirect(reurl);
		}
	}

}
  catch(Exception e)
{			
	e.printStackTrace();
}
finally
{
	if (!conn.isClosed())
		conn.close();
}
   %>



<div class="head">
		<div class="logo"><img src="images/IRewardLOGO.jpg" /></div>
	</div>	
	<div class="banner">
		<div class="banner2">
			<div style="float: left; position: absolute; top: 345px; padding-left: 360px;">
				<a target="_Blank" href="common/aboutus.jsp"><img src="images/knowmore.jpg"></a>
			</div>
			<form action="index.jsp" name="logform" id="logform" method="post">
			<input type="hidden" name="logt" id="logt" />			
			<div class="login">
				<div><h2 id="barh1" onclick="swap(1)">员工用户登录</h2><h2 id="barh2" onclick="swap(2)" class="off2">企业用户登录</h2></div>
				<div class="inputbox-user">
					<%
						String loginName=request.getParameter("logname");
						Cookie[] cookies = request.getCookies();
						String cookieUserName = "";
						if(cookies != null && cookies.length > 0){
							for(Cookie c : cookies){
								if("logname".equals(c.getName())){
									cookieUserName = c.getValue();
								}
							}
						}
					%>
					<%
						if(loginName != null){
					%>
							<input type="text" class="input1" value="<%=loginName %>"  onFocus="javascript:if(this.value=='请输入您的用户名') this.value='';" onBlur="javascript:if(this.value=='') this.value='请输入您的用户名';"  name="logname" id="logname" />
					<%
						}else if("".equals(cookieUserName)){
					%>
						<input type="text" class="input1" value="请输入您的用户名"  onFocus="javascript:if(this.value=='请输入您的用户名') this.value='';" onBlur="javascript:if(this.value=='') this.value='请输入您的用户名';"  name="logname" id="logname" />	
					<%	
						
						}else{
					%>
							<input type="text" class="input1" value="<%=cookieUserName %>"  onFocus="javascript:if(this.value=='请输入您的用户名') this.value='';" onBlur="javascript:if(this.value=='') this.value='请输入您的用户名';"  name="logname" id="logname" />	
					<%
						}
					%>
				</div>
				<div class="inputbox-mima"><input type="text" class="input1" value="请输入您的密码" name="logpwdtxt" id="logpwdtxt" onfocus="logpwdchecck(1)" /><input type="password" class="input1" name="logpwd" id="logpwd" style="display: none;" onBlur="logpwdchecck(0)" /></div>
				<div class="inputbox-mima" >
					<%--
					<table style="float: left">
						<tr>
							<td style="color:gray">验证码：</td>
							<td><input name="validateCode" type="text" style="width: 50px;" /></td>
							<td style="line-height:10px;">&nbsp;<img src="image.jpg" style="cursor:pointer" onclick="this.src='image.jpg?'+new Date().getTime();"/></td>
						</tr>
						<tr>
							<td colspan="3" style="color:gray;height:25px;">
								<span title="为了您的信息安全，请不要在网吧<br/>或公用电脑上面使用此功能">
								<label style="font-size:12px; line-height:12px;cursor: pointer;">
									<input type="checkbox" name="checkbox" style="vertical-align: top;cursor: pointer;"/>
									两周内自动填写用户名
								</label>
							</td>
						</tr>
					</table>
					 --%>
				</div>
				<div class="inputbox-btn" style="margin: 40px 0 0 30px"><a href="#" class="loginbtn" onclick="login()"></a><a href="#" onclick="gogetpwd()" class="mfsctxt">忘记密码</a></div>
			</div>
			</form>
		</div>
	</div>
	<div class="center">
		<div class="center2">
			<div class="center-states">IRewards为企业提供专业领先的员工忠诚度奖励平台；同时，以低成本、高效率的方式实现弹性福利体系的建立。</div>
			<ul class="centerbox">
				<li><h1><img src="images/png1.jpg" /></h1><span>企业：<br />企业专属的员工弹性福利和认可/奖励平台，提升员工满意度和忠诚度</span><h2><a  target="_blank" href="register.jsp?t=1">企业申请</a></h2></li>
				<li><h1><img src="images/png3.jpg" /></h1><span>员工：<br />
				领取多元的奖励及福利相关商品，涵盖线上线下千余种商品及公司周边</span>
				  <h2><a  target="_blank" href="register.jsp?t=2">员工试用</a></h2></li>
				<li><h1><img src="images/png2.jpg" /></h1><span>联合商家提供个性
化的特惠订阅，以
及反向定价功能</span><h2><a target="_blank" href="common/joinus.jsp">申请合作</a></h2></li>
			</ul>
			<div class="partner">
				<h1><img src="images/partner.jpg" /></h1>
				<div class="rollBox">
					<div class="LeftBotton" onmousedown="ISL_GoUp()" onmouseup="ISL_StopUp()" onmouseout="ISL_StopUp()"></div>
					<div class="Cont" id="ISL_Cont">
						<div class="ScrCont">
							<div id="List1">       
						<!-- 图片列表 begin -->
						 		<div class="pic"><a href="http://www.familymart.com.cn/shfm/" target="_blank"><img src="images/partner/familymart.jpg"/></a></div>
								<div class="pic"><a href="http://www.lenovo.com" target="_blank"><img src="images/partner/lenovo.jpg"/></a></div>
								<div class="pic"><a href="http://www.tencent.com" target="_blank"><img src="images/partner/tencent.jpg"/></a></div>
								<div class="pic"><a href="http://www.chinalife.com.cn" target="_blank"><img src="images/partner/chinalife.jpg"/></a></div>
								<div class="pic"><a href="http://www.it-times.com.cn/wangzhidaohang/17157.jhtml" target="_blank"><img src="images/partner/ITshibao.png"/></a></div>
								<div class="pic"><a href="http://www.web20share.com/2012/12/irewards.html" target="_blank"><img src="images/partner/web20share.png"/></a></div>
								<div class="pic"><a href="http://tech.163.com/12/1226/13/8JLF07T800094MOK.html" target="_blank"><img src="images/partner/wangyi.png"/></a></div>
								<div class="pic"><a href="http://www.tmtforum.com/html/quzhan/dianshang/201212/1355980054.html" target="_blank"><img src="images/partner/TMTForum.png"/></a></div>
								<div class="pic"><a href="http://cn.technode.com/post/2012-12-26/40046354341" target="_blank"><img src="images/partner/dongdiankeji.jpg"/></a></div>
								<div class="pic piclast"><a href="http://www.adidas.com" target="_blank"><img src="images/partner/adidas.jpg"/></a></div>       
				
						<!-- 图片列表 end -->
						
					   		</div>
					   		<div id="List2"></div>
					 	 </div>
					 </div>
					 <div class="RightBotton" onmousedown="ISL_GoDown()" onmouseup="ISL_StopDown()" onmouseout="ISL_StopDown()"></div>
    			</div>
				<script language="javascript" type="text/javascript">
<!--//--><![CDATA[//><!--
//图片滚动列表 5icool.org
var Speed = 1; //速度(毫秒)
var Space = 8; //每次移动(px)
var PageWidth = 896; //翻页宽度  根据不同宽度改动
var fill = 0; //整体移位
var MoveLock = false;
var MoveTimeObj;
var Comp = 0;
var AutoPlayObj = null;
GetObj("List2").innerHTML = GetObj("List1").innerHTML;
GetObj('ISL_Cont').scrollLeft = fill;
GetObj("ISL_Cont").onmouseover = function(){clearInterval(AutoPlayObj);}
GetObj("ISL_Cont").onmouseout = function(){AutoPlay();}
AutoPlay();
function GetObj(objName){if(document.getElementById){return eval('document.getElementById("'+objName+'")')}else{return eval('document.all.'+objName)}}
function AutoPlay(){ //自动滚动
 clearInterval(AutoPlayObj);
 AutoPlayObj = setInterval('ISL_GoDown();ISL_StopDown();',3000); //间隔时间
}
function ISL_GoUp(){ //上翻开始
 if(MoveLock) return;
 clearInterval(AutoPlayObj);
 MoveLock = true;
 MoveTimeObj = setInterval('ISL_ScrUp();',Speed);
}
function ISL_StopUp(){ //上翻停止
 clearInterval(MoveTimeObj);
 if(GetObj('ISL_Cont').scrollLeft % PageWidth - fill != 0){
  Comp = fill - (GetObj('ISL_Cont').scrollLeft % PageWidth);
  CompScr();
 }else{
  MoveLock = false;
 }
 AutoPlay();
}
function ISL_ScrUp(){ //上翻动作
 if(GetObj('ISL_Cont').scrollLeft <= 0){GetObj('ISL_Cont').scrollLeft = GetObj('ISL_Cont').scrollLeft + GetObj('List1').offsetWidth}
 GetObj('ISL_Cont').scrollLeft -= Space ;
}
function ISL_GoDown(){ //下翻
 clearInterval(MoveTimeObj);
 if(MoveLock) return;
 clearInterval(AutoPlayObj);
 MoveLock = true;
 ISL_ScrDown();
 MoveTimeObj = setInterval('ISL_ScrDown()',Speed);
}
function ISL_StopDown(){ //下翻停止
 clearInterval(MoveTimeObj);
 if(GetObj('ISL_Cont').scrollLeft % PageWidth - fill != 0 ){
  Comp = PageWidth - GetObj('ISL_Cont').scrollLeft % PageWidth + fill;
  CompScr();
 }else{
  MoveLock = false;
 }
 AutoPlay();
}
function ISL_ScrDown(){ //下翻动作
 if(GetObj('ISL_Cont').scrollLeft >= GetObj('List1').scrollWidth){GetObj('ISL_Cont').scrollLeft = GetObj('ISL_Cont').scrollLeft - GetObj('List1').scrollWidth;}
 GetObj('ISL_Cont').scrollLeft += Space ;
}
function CompScr(){
 var num;
 if(Comp == 0){MoveLock = false;return;}
 if(Comp < 0){ //上翻
  if(Comp < -Space){
   Comp += Space;
   num = Space;
  }else{
   num = -Comp;
   Comp = 0;
  }
  GetObj('ISL_Cont').scrollLeft -= num;
  setTimeout('CompScr()',Speed);
 }else{ //下翻
  if(Comp > Space){
   Comp -= Space;
   num = Space;
  }else{
   num = Comp;
   Comp = 0;
  }
  GetObj('ISL_Cont').scrollLeft += num;
  setTimeout('CompScr()',Speed);
 }
}
//--><!]]>
</script>
			</div>
		</div>
	</div>
	<div class="bottom">
		<a target="_Blank"  href="common/aboutus.jsp">关于我们</a><a target="_Blank" href="common/joinus.jsp">商户加盟</a><a target="_Blank" href="common/recruit.jsp">招贤纳士</a><a target="_Blank" href="common/contactus.jsp">联系我们</a>　　　　<a target="_blank" href="http://weibo.com/yuangongfuli" style="padding:0 10px 0 0"><img src="images/weibo-sina.jpg" /></a><a target="_blank" href="http://t.qq.com/tanxingfuli" style="padding:0 10px 0 0"><img src="images/weibo-qq.jpg" /></a>
		<div><a target="_blank" href="http://www.miibeian.gov.cn">沪ICP备12045301号</a></div>
	</div>
</body>
</html>

