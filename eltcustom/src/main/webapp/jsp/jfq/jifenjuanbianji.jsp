<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.ssh.util.SecurityUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.ssh.util.DbPool"%>
<%request.setCharacterEncoding("UTF-8");

if (session.getAttribute("hrqyjf")==null || "".equals(session.getAttribute("hrqyjf").toString()))
{
	out.print("你没有操作权限！");
	return;
}

String jfjid=request.getParameter("jfjid");
if (jfjid==null) jfjid="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="save" content="history" />
<link type="text/css" rel="stylesheet" href="common/css/style.css" />
<link type="text/css" rel="stylesheet" href="common/css/ymPrompt.css" />
<link type="text/css" rel="stylesheet" href="jsp/jfq/css/adminstyle.css" />
<script type="text/javascript" src="jsp/jfq/js/calendar3.js"></script>
<script type="text/javascript" src="jsp/jfq/js/common.js"></script>
<script type="text/javascript" src="common/js/common.js"></script>
<script type="text/javascript" src="common/js/jquery-1.7.min.js"></script>
<script type="text/javascript">
var savesl=0;
function saveit()
{
	if(document.getElementById("mc").value.trim()=="")
	{
		alert("请填写福利券名称！");
		return false;
	}
	if(document.getElementById("hd").value.trim()=="0")
	{
		alert("生成福利券功能暂未开放，请联系IRewards运营商！");
		return false;
	}
	if(document.getElementById("qz").value.trim()=="")
	{
		alert("请填写福利券编号的前缀！");
		return false;
	}
	if(!LcNCheck(document.getElementById("qz").value))
	{
		alert("福利券编号的前缀只能为数字和小写字母！");
		return false;
	}
	if(document.getElementById("jf").value.trim()=="")
	{
		alert("请填写积分！");
		return false;
	}
	if(!CheckNumber(document.getElementById("jf").value))
	{
		alert("积分只能为数字！");
		return false;
	}
	if(document.getElementById("yxq").value.trim()=="")
	{
		alert("请填写有效期！");
		return false;
	}
	
	if(document.getElementById("spid").value.trim()=="")
	{
		alert("请选择对应商品！");
		return false;
	}
	if(document.getElementById("scsl").value.trim()=="")
	{
		alert("请填写生成数量！");
		return false;
	}
	if(!CheckNumber(document.getElementById("scsl").value))
	{
		alert("生成数量只能填写数字！");
		return false;
	}
	if (parseInt(document.getElementById("scsl").value, 10)>savesl)
	{
		alert("生成数量不能大于库存数量！");
		return false;
	}
    if (parseInt(document.getElementById("scsl").value, 10)<=0)
    {
        alert("生成数量必须大于0！");
        return false;
    }
	if (confirm("此操作将清空兑换篮，确认继续？")) {
    	removeShopCar();
    	document.getElementById("naction").value="save";
    	document.getElementById("cform").submit();
        document.getElementById("cform").reset();
	}
}

function selsp()
{
    var strSps = getCookie("sp");
    if (strSps) {
        if(strSps=="")return false;
        var timeParam = Math.round(new Date().getTime()/1000);
        var url = "jsp/jfq/selectsp.jsp?t=more&time="+timeParam+"&ids="+strSps;
        xmlHttp.open("GET", url, true);
        xmlHttp.onreadystatechange=showcon;
        xmlHttp.send(null);  
    } else {
        alert("兑换篮里没有商品！");
    }
}

function showcon()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			openLayer(response);
		}
		catch(exception){}
	}
}

function sspagain(p)
{
	var strSps = getCookie("sp");
	if(strSps=="")return false;
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "jsp/jfq/splist.jsp?t=more&time="+timeParam+"&ids="+strSps+"&pno="+p;
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}

function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("dspllist").innerHTML=response;
		}
		catch(exception){}
	}
}

function getsp()
{
	var n=document.getElementsByName("sspid").length;
	var spstr="";
	var scsl=0;
	
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("sspid")[i].checked)
		{
			spstr=document.getElementsByName("sspid")[i].value.split(",")[0];
			scsl=document.getElementsByName("sspid")[i].value.split(",")[1];
			var sparr=document.getElementById("spid").value.split(",");
			var exist=false;
			for(var j=0;j<sparr.length;j++) {
				if(sparr[j]==spstr){
					exist=true;
				}
			}
			if(!exist){
				if (savesl==0 || savesl>parseInt(scsl, 10))
				{
				    document.getElementById("scsl").value=1;
					document.getElementById("scslMaxQty").innerHTML=scsl;
					savesl=scsl;
				}
				document.getElementById("spid").value=document.getElementById("spid").value+spstr+",";
				document.getElementById("spmc").value=document.getElementById("spmc").value+document.getElementsByName("sspid")[i].title+",";
			    $("#scslDesc").show();
			}
			
		}
	}
	
	var spids=document.getElementById("spid").value;
	document.getElementById("jf").value=getFlqJf(spids);
	closeLayer();
}

function delsp()
{
	document.getElementById("spmc").value="";
	document.getElementById("spid").value="";
	document.getElementById("scsl").value="";
	$("#scslDesc").hide();
	savesl=0;
	document.getElementById("jf").value=0;
}

var lbl=1;
function lbshow(v,l)
{
	if (l==2) return;
	lbl=l+1;
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsplb.jsp?lbid="+v+"&lbl="+lbl+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlb;
	xmlHttp.send(null);
	
}
function showlb()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			for(i=lbl;i<3;i++)
			document.getElementById("lblist"+i).innerHTML="";
			document.getElementById("lblist"+lbl).innerHTML=response;
		}
		catch(exception){}
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<div class="main2">
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyyMMdd");
String mc="",hd="",qz="",sm="",spid="",jf="",yxq="",scsl="",spmc="",spid0="",kcsl="";

try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		mc=request.getParameter("mc");
		hd=request.getParameter("hd");
		qz=request.getParameter("qz");
		spid=request.getParameter("spid");
		
		jf=request.getParameter("jf");
		sm=request.getParameter("sm");
		yxq=request.getParameter("yxq");
		scsl=request.getParameter("scsl");
		
		if (!SecurityUtil.sqlParamCheck(mc) || !SecurityUtil.sqlParamCheck(hd) || !SecurityUtil.sqlParamCheck(qz) || !SecurityUtil.sqlParamCheck(spid) || !SecurityUtil.sqlParamCheck(jf) || !SecurityUtil.sqlParamCheck(sm) || !SecurityUtil.sqlParamCheck(yxq) || !SecurityUtil.sqlParamCheck(scsl))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		String redirectUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/gl/bwconfirm.jsp?scflq=1";
		if (jfjid!=null && jfjid.length()>0)
		{
			 //先取一下原数量，如果减少了要加库存
			 int oldkcsl=0;
			 strsql="select kcsl from tbl_jfq where nid="+jfjid;
			 rs=stmt.executeQuery(strsql);
			 if (rs.next())
			 {
				 oldkcsl=rs.getInt("kcsl");
			 }
			 rs.close();
			 
			 if (oldkcsl<Integer.valueOf(scsl))
			 {
				out.print("<script type='text/javascript'>");
		   		out.print("alert('修改后的数量不能超过现有福利券库存量');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
		   		return;
			 }
			 else if (oldkcsl>Integer.valueOf(scsl))
			 {
				 //回收福利券
				 int zfsl=oldkcsl-Integer.valueOf(scsl);
				 strsql="update tbl_jfqmc set zt=6 where nid in (select nid from (select nid from tbl_jfqmc where jfq="+jfjid+" and qy=0 order by nid limit "+zfsl+") aa)";
				 stmt.executeUpdate(strsql);
				 
				 //库存量增加
				 strsql="update tbl_sp set kcsl=kcsl+"+zfsl+",wcdsl=wcdsl+"+zfsl+" where nid in ("+spid+")";
				 stmt.executeUpdate(strsql);
				 
				 //
				 strsql="update tbl_jfq set scsl="+scsl+",kcsl=kcsl-"+zfsl+" where nid="+jfjid;
				 stmt.executeUpdate(strsql);
			 }
			 strsql="update tbl_jfq set mc='"+mc+"',hd="+hd+",yxq='"+yxq+"',sm='"+sm+"' where nid="+jfjid;
			 stmt.executeUpdate(strsql);
			 strsql="update tbl_jfqmc set yxq='"+yxq+"' where jfq="+jfjid;
			 stmt.executeUpdate(strsql);
			 
			//更改对应活动最小积分
			strsql="update tbl_jfqhd set zxjf="+jf+" where nid="+hd+" and zxjf>"+jf;
			stmt.executeUpdate(strsql);
			
			
			 response.sendRedirect(redirectUrl);
		   	  return;
		}
		else
		{
			String qyid = session.getAttribute("hrqyid").toString();
			strsql="insert into tbl_jfq (mc,hd,qz,jf,sm,yxq,scsl,kcsl,srsj,zt,qyid) values('"+mc+"',"+hd+",'"+qz+"',"+jf+",'"+sm+"','"+yxq+"',"+scsl+","+scsl+",now(),1,"+qyid+")";
			stmt.executeUpdate(strsql);
			
			int scsln=Integer.valueOf(scsl);
			String jfqh="",jfq="";
			
			//取到福利券编号
			strsql="select @@identity as jfq";			
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{jfq=rs.getString("jfq");}
			rs.close();
			
			//更改对应活动最小积分
			strsql="update tbl_jfqhd set zxjf="+jf+" where nid="+hd;
			stmt.executeUpdate(strsql);
			
			
			
			//生成明细
			jfqh=qz+sf.format(Calendar.getInstance().getTime());
			for (int i=1;i<=scsln;i++)
			{				
				strsql="insert into tbl_jfqmc (jfq,jfqh,yxq) values("+jfq+",'"+jfqh+String.valueOf(i)+"','"+yxq+"')";
				
				stmt.executeUpdate(strsql);
			}
			
			//保存商品对应关系
			if (spid!=null && spid.length()>0)
			{
				String[] sparr=spid.split(",");
				for (int i=0;i<sparr.length;i++)
				{
					if (sparr[i]!=null && sparr[i].length()>0)
					{
						strsql="insert into tbl_jfqspref (jfq,sp,jfqmc) values("+jfq+","+sparr[i]+",'"+mc+"')";
						out.print(strsql);
						
						stmt.executeUpdate(strsql);
						
						//商品减库存
						strsql="update tbl_sp set kcsl=kcsl-"+scsln+",wcdsl=wcdsl-"+scsln+" where nid="+sparr[i];
						stmt.executeUpdate(strsql);
					}
				}
			}
			
			response.sendRedirect(redirectUrl+"&flqid="+jfq);
	   		return;
		}
	}
	
	if (jfjid!=null && jfjid.length()>0)
	{
		strsql="select mc,hd,qz,jf,sm,yxq,scsl,kcsl from tbl_jfq where nid="+jfjid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			mc=rs.getString("mc");
			hd=rs.getString("hd");
			qz=rs.getString("qz");			
			jf=rs.getString("jf");
			sm=rs.getString("sm");
			yxq=rs.getString("yxq").substring(0,10);
			scsl=rs.getString("scsl");
			kcsl=rs.getString("kcsl");
			
		}
		rs.close();
		
		strsql="select s.nid,s.spmc from tbl_jfqspref j inner join tbl_sp s on j.sp=s.nid where j.jfq="+jfjid;
	  	rs=stmt.executeQuery(strsql);
	  	while(rs.next())
	  	{
	  		if (rs.isLast())
	  			spid=spid+rs.getString("nid");
	  		else
	  			spid=spid+rs.getString("nid")+",";
	  		spmc=spmc+rs.getString("spmc")+",";
	  	}
	  	rs.close();
	  	
	  	out.print("<script type='text/javascript'>savesl="+kcsl+";</script>");
	}
	
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <%@ include file="../base/hrhead.jsp" %>
  <tr>
    <td bgcolor="#f4f4f4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td width="10">&nbsp;</td>
        <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="jfq!scflq.do" name="cform" id="cform" method="post" autocomplete="off">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="jfjid" id="jfjid" value="<%=jfjid%>" /> 
            		  
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">福利券名称：</td>
                          <td><input type="text" name="mc" id="mc" value="<%=mc%>" maxlength="50" class="input3" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>所属活动：</td>
                          <td>自选福利
							<%
							strsql="select nid,hdmc from tbl_jfqhd where hdmc='自选福利' and zt=1 order by nid desc";
							rs=stmt.executeQuery(strsql);
							if(rs.next())
							{
								out.print("<input type=\"hidden\" name=\"hd\" id=\"hd\" value=\""+rs.getString("nid")+"\" />");
							} else {
								out.print("<input type=\"hidden\" name=\"hd\" id=\"hd\" value=\"0\" />");
							}
							rs.close();
							%>
                          </td>
                        </tr>
                        <tr style="display:none">
                          <td align="center"></td>
                          <td>福利券描述：</td>
                          <td><input type="text" name="sm" id="sm" value="自选福利" maxlength="250" class="input3" />                         
                          </td>
                        </tr>
                        <tr style="display:none">
                          <td align="center"><span class="star">*</span></td>
                          <%
                          if (qz == null || "".equals(qz)) {
	                    	  SimpleDateFormat df=new SimpleDateFormat("HHmmssSS");
                              qz = df.format(Calendar.getInstance().getTime());
                          }
                          %>
                          <td>编号前缀：</td>
                          <td><input type="text" name="qz" id="qz" value="<%=qz%>" maxlength="10" class="input3 read" readonly="readonly" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>积分：</td>
                          <td><input type="text" name="jf" id="jf" value="0" maxlength="8" class='input3 read' readonly='readonly' /></td>
                        </tr>
                       
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>对应商品：</td>
                          <td><input type="hidden" name="spid" id="spid" value="<%=spid%>" />                            
                          	 <textarea rows="3" cols="60" name="spmc" id="spmc" <%if (spmc!=null && spmc.length()>0) out.print(" readonly=\"readonly\""); %>><%=spmc%></textarea>&nbsp;<%if (spmc==null || spmc.length()==0){%><span class="xzsp" onclick="selsp()">选择</span>&nbsp;<span class="xzsp" onclick="delsp()">删除选择</span><%} %></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>生成数量：</td>
                          <td>
                          <input type="text" name="scsl" id="scsl" value="<%=scsl%>" maxlength="8" class='input3' />
                          <label id='scslDesc'>当前您可生成最大福利券数量为&nbsp;<label id='scslMaxQty'></label>&nbsp;张</label>
                          </td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <%
                          if (yxq == null || "".equals(yxq)) {
                        	  Calendar cal = Calendar.getInstance(); 
                        	  cal.add(Calendar.MONTH, 1);
                        	  SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
                        	  yxq = sdf.format(cal.getTime());
                          }
                          %>
                          <td>有效期：</td>
                          <td><input type="text" name="yxq" id="yxq" value="<%=yxq%>" maxlength="10" class="input3" readonly="readonly" /></td>
                        </tr>
                        <%if (naction==null || !naction.equals("see")) {%>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="confirmbtn" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                        <% }%>
                      </table>
                      </form>
            </td>
          </tr>
          
        </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
</table>
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
<div class="scflqwrap2"><%@ include file="/jsp/base/bottomnav.jsp" %></div>
<%@ include file="/jsp/base/footer.jsp" %>
</div>
</body>
</html>