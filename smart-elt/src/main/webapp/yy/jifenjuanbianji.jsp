<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8");

if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("3003")==-1)
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
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="../gl/js/calendar3.js"></script>
<script type="text/javascript">
var savesl=0;
function saveit()
{
	if(document.getElementById("mc").value.trim()=="")
	{
		alert("请填写积分券名称！");
		return false;
	}
	if(document.getElementById("hd").value.trim()=="")
	{
		alert("请选择对应的活动！");
		return false;
	}
	if(document.getElementById("qz").value.trim()=="")
	{
		alert("请填写积分券编号的前缀！");
		return false;
	}
	if(!LcNCheck(document.getElementById("qz").value))
	{
		alert("积分券编号的前缀只能为数字和小写字母！");
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
	if (parseInt(document.getElementById("scsl").value)>savesl)
	{
		alert("生成数量不能大于库存数量！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}



function selsp()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsp.jsp?t=more&time="+timeParam;		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showcon;
	xmlHttp.send(null);
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
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getsplist.jsp?t=more&time="+timeParam+"&pno="+p+"&lb1="+document.getElementById("lb1").value+"&sspmc="+encodeURI(escape(document.getElementById("sspmc").value));		
	if (document.getElementById("lb2"))
		url=url+"&lb2="+document.getElementById("lb2").value;
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
			if(document.getElementById("spid").value.indexOf(spstr+",")==-1){
				if (savesl==0 || savesl>parseInt(scsl))
				{
					document.getElementById("scsl").value=scsl;
					savesl=scsl;
				}
				document.getElementById("spid").value=document.getElementById("spid").value+spstr+",";
				document.getElementById("spmc").value=document.getElementById("spmc").value+document.getElementsByName("sspid")[i].title+",";
			}
			
		}
	}
	
	closeLayer();
}

function delsp()
{
	document.getElementById("spmc").value="";
	document.getElementById("spid").value="";
	document.getElementById("scsl").value="";
	savesl=0;
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
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
String  menun="3003";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyyMMdd");
String mc="",hd="",qz="",sm="",spid="",jf="",yxq="",scsl="",spmc="",spid0="",kcsl="";

if (!fun.sqlStrCheck(jfjid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='jifenjuan.jsp';");
	out.print("</script>");
	return;
}
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
		
		if (!fun.sqlStrCheck(mc) || !fun.sqlStrCheck(hd) || !fun.sqlStrCheck(qz) || !fun.sqlStrCheck(spid) || !fun.sqlStrCheck(jf) || !fun.sqlStrCheck(sm) || !fun.sqlStrCheck(yxq) || !fun.sqlStrCheck(scsl))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
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
		   		out.print("alert('修改后的数量不能超过现有积分券库存量');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
		   		return;
			 }
			 else if (oldkcsl>Integer.valueOf(scsl))
			 {
				 //回收积分券
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
			
			
			 response.sendRedirect("jifenjuan.jsp");
		   	  return;
		}
		else
		{
			strsql="insert into tbl_jfq (mc,hd,qz,jf,sm,yxq,scsl,kcsl,srsj) values('"+mc+"',"+hd+",'"+qz+"',"+jf+",'"+sm+"','"+yxq+"',"+scsl+","+scsl+",now())";
			stmt.executeUpdate(strsql);
			
			int scsln=Integer.valueOf(scsl);
			String jfqh="",jfq="";
			
			//取到积分券编号
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
			
			response.sendRedirect("jifenjuan.jsp");
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
  <%@ include file="head.jsp" %>
  <tr>
    <td bgcolor="#f4f4f4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="200" height="100%" valign="top"style="background:url(images/left-bottom.jpg) bottom">
			<%@ include file="leftmenu.jsp" %>
		  </td>
         <td width="10">&nbsp;</td>
        <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><div class="local"><span>积分券管理 &gt; 积分券内容管理 &gt; <%if (jfjid!=null && jfjid.length()>0) out.print("修改积分券"); else out.print("添加积分券");%></span><a href="jifenjuan.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="jifenjuanbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="jfjid" id="jfjid" value="<%=jfjid%>" /> 
            		  
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">积分券名称：</td>
                          <td><input type="text" name="mc" id="mc" value="<%=mc%>" maxlength="50" class="input3" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>所属活动：</td>
                          <td>
                            <select name="hd" id="hd"><option value="">请选择</option>
							<%
							//strsql="select nid,hdmc from tbl_jfqhd where jssj>=SYSDATE() order by nid desc";
							strsql="select nid,hdmc from tbl_jfqhd  order by nid desc";
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								out.print("<option value='"+rs.getString("nid")+"'");
								if (hd!=null && rs.getString("nid").equals(hd))
									out.print(" selected='selected'");
								out.print(">"+rs.getString("hdmc")+"</option>");
							}
							rs.close();
							%>
							</select>
                          </td>
                        </tr>
                        <tr>
                          <td align="center"></td>
                          <td>积分券描述：</td>
                          <td><input type="text" name="sm" id="sm" value="<%=sm%>" maxlength="250" class="input3" />                         
                          </td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>编号前缀：</td>
                          <td><input type="text" name="qz" id="qz" value="<%=qz%>" maxlength="10" class='input3<%if (qz!=null && qz.length()>0) out.print(" read' readonly='readonly'");else out.print("'"); %> /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>积分：</td>
                          <td><input type="text" name="jf" id="jf" value="<%=jf%>" maxlength="8" class='input3<%if (jf!=null && jf.length()>0) out.print(" read' readonly='readonly'");else out.print("'");%> /></td>
                        </tr>
                       
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>对应商品：</td>
                          <td><input type="hidden" name="spid" id="spid" value="<%=spid%>" />                            
                          	 <textarea rows="3" cols="60" name="spmc" id="spmc" <%if (spmc!=null && spmc.length()>0) out.print(" readonly=\"readonly\""); %>><%=spmc%></textarea>&nbsp;<%if (spmc==null || spmc.length()==0){%><span class="caxun2" onclick="selsp()">选择</span>&nbsp;<span class="caxun2" onclick="delsp()">删除选择</span><%} %></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>生成数量：</td>
                          <td><input type="text" name="scsl" id="scsl" value="<%=scsl%>" maxlength="8" class='input3' />
                          </td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>有效期：</td>
                          <td><input type="text" name="yxq" id="yxq" value="<%=yxq%>" maxlength="10" class="input3" onclick="new Calendar().show(this);" readonly="readonly" /></td>
                        </tr>
                        <%if (naction==null || !naction.equals("see")) {%>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
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
  <%@ include file="bottom.jsp" %>
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
</body>
</html>