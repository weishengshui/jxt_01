<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); 
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4002")==-1)
{
	out.print("你没有操作权限！");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
<script type="text/javascript">
function saveit()
{
	if(document.getElementById("spmc").value.trim()=="")
	{
		alert("请填写商品名称！");
		return false;
	}
	if(document.getElementById("spl").value.trim()=="")
	{
		alert("请选择商品系列！");
		return false;
	}
	if(document.getElementById("scj").value.trim()=="")
	{
		alert("请填写市场价！");
		return false;
	}
	if(!CheckFloat(document.getElementById("scj").value))
	{
		alert("市场价只能为数字！");
		return false;
	}
	if(document.getElementById("qbjf").value.trim()=="")
	{
		alert("请填写积分价！");
		return false;
	}
	
	if(!CheckNumber(document.getElementById("qbjf").value))
	{
		alert("积分价只能为数字！");
		return false;
	}
	if(!CheckNumber(document.getElementById("cxjf").value))
	{
		alert("促销价只能为数字！");
		return false;
	}
	if (!document.getElementById("zstp1id") && document.getElementById("zstp1").value=="")
	{
		alert("商品图片必须有一张");
		return false;
	}
	document.getElementById("iform").submit();
}

function selspl()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectspl.jsp?time="+timeParam;		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showspl;
	xmlHttp.send(null);
}

function showspl()
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

function ssplagain(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getspllist.jsp?pno="+p+"&ssplmc="+encodeURI(escape(document.getElementById("ssplmc").value))+"&lb1="+document.getElementById("lb1").value+"&time="+timeParam;		
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
function getspl()
{
	var n=document.getElementsByName("splid").length;	
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("splid")[i].checked)
		{
			
			document.getElementById("lmc").value=document.getElementsByName("splid")[i].title;
			document.getElementById("spl").value=document.getElementsByName("splid")[i].value;
		}
	}
	closeLayer();
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
String  menun="4002";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String spmc="",spl="",qbjf="",cxjf="0",scj="",zstp1="",zstp2="",zstp3="",zstp4="",zstp5="",dhjf1="",dhje1="",dhjf2="",dhje2="",dhjf3="",dhje3="",spbh="",lmc="";
String zstp1id="",zstp2id="",zstp3id="",zstp4id="",zstp5id="",dhid1="",dhid2="",dhid3="",xlmr="0",kcyj="",spnr="";
String spid=request.getParameter("spid");
if (spid==null) spid="";
if (!fun.sqlStrCheck(spid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='spnrgl.jsp';");
	out.print("</script>");
	return;
}
try{
	
	
	if (spid!=null && spid.length()>0)
	{
		strsql="select s.spmc,s.spbh,s.spl,s.scj,s.qbjf,s.cxjf,s.kcyj,s.spnr,l.mc,l.sp from tbl_sp s left join tbl_spl l on s.spl=l.nid where s.nid="+spid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			spmc=rs.getString("spmc");
			spl=rs.getString("spl");
			qbjf=rs.getString("qbjf");
			cxjf=rs.getString("cxjf");
			scj=rs.getString("scj");
			spbh=rs.getString("spbh");
			lmc=rs.getString("mc");
			xlmr=rs.getString("sp");
			kcyj=rs.getString("kcyj");
			spnr=rs.getString("spnr");
		}
		rs.close();
		
		int i=1;
		strsql="select nid,jf,je from tbl_dhfs where sp="+spid;
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			if (i==1)
			{
				dhid1=rs.getString("nid");
				dhjf1=rs.getString("jf");
				dhje1=rs.getString("je");
			}			
			if (i==2)
			{
				dhid2=rs.getString("nid");
				dhjf2=rs.getString("jf");
				dhje2=rs.getString("je");
			}
			if (i==3)
			{
				dhid3=rs.getString("nid");
				dhjf3=rs.getString("jf");
				dhje3=rs.getString("je");
			}		
			i++;		
		}
		rs.close();
		
		i=1;
		strsql="select nid,lj from tbl_sptp where sp="+spid;
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			if (i==1)
			{
				zstp1id=rs.getString("nid");
				zstp1=rs.getString("lj");
			}			
			if (i==2)
			{
				zstp2id=rs.getString("nid");
				zstp2=rs.getString("lj");
			}
			if (i==3)
			{
				zstp3id=rs.getString("nid");
				zstp3=rs.getString("lj");
			}
			if (i==4)
			{
				zstp4id=rs.getString("nid");
				zstp4=rs.getString("lj");
			}
			if (i==5)
			{
				zstp5id=rs.getString("nid");
				zstp5=rs.getString("lj");
			}		
			i++;		
		}
		rs.close();
		
	}
	else
	{
		//取系统的库存预警值 
		strsql="select pvalue from tbl_config where pname='spkcyj'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			kcyj=rs.getString("pvalue");
		}
		else
		{
			kcyj="10";
		}
		rs.close();
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
            <td><div class="local"><span>商品管理 &gt; 商品内容管理 &gt; <%if (spid!=null && spid.length()>0) out.print("修改商品"); else out.print("添加商品");%></span><a href="spnrgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="spnrsave.jsp?lb1_=${param.lb1 }&pno=${param.pno }" enctype="multipart/form-data" name="iform" id="iform" method="post">
				<input type="hidden" name="spid" id="spid" value="<%=spid%>" />
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
				  <tr>
                    <td width="30" align="center"><span class="star">*</span></td>
                    <td width="90">商品名称：</td>
                    <td><input type="text" class="input3" name="spmc" id="spmc" value="<%=spmc%>" maxlength="50" /></td>
                  </tr>
                   <tr>
                      <td align="center"></td>
                      <td>商品编号：</td>
                      <td><input type="text" class="input3" name="spbh" id="spbh" value="<%=spbh%>" maxlength="20" /></td>
                   </tr>
                  <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>所属系列：</td>
                      <td><input type="hidden" name="spl" id="spl" value="<%=spl%>" /><input type="text" class="input3" name="lmc" id="lmc" readonly="readonly"  value="<%=lmc%>" /><input type="button" value="选择"  onclick="selspl()" />
                      </td>
                   </tr>
                  
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>市场价：</td>
                      <td><input type="text" class="input3" name="scj" id="scj" value="<%=scj%>" maxlength="8" />元</td>
                   </tr>
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>积分价：</td>
                      <td><input type="text" class="input3" name="qbjf" id="qbjf" value="<%=qbjf%>" maxlength="8" />积分 </td>
                   </tr>
                   <tr>
                      <td align="center"></td>
                      <td>促销价：</td>
                      <td><input type="text" class="input3" name="cxjf" id="cxjf" value="<%=cxjf%>" maxlength="8" />积分</td>
                   </tr>
                    <tr>
                      <td align="center"></td>
                      <td>库存预警：</td>
                      <td><input type="text" class="input3" name="kcyj" id="kcyj" value="<%=kcyj%>" maxlength="4" />&nbsp;小于此值时停止销售</td>
                   </tr>
                   <!--  
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>积分+金额：</td>
                      <td><input type="hidden" name="dhid1" id="dhid1" value="<%=dhid1%>" /><input type="text" class="input4" name="dhjf1" id="dhjf1" value="<%=dhjf1%>" maxlength="8" />积分+<input type="text" class="input4" name="dhje1" id="dhje1" value="<%=dhje1%>" maxlength="8" />元&nbsp;积分和金额都不能为零</td>
                   </tr>
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>积分+金额：</td>
                      <td><input type="hidden" name="dhid2" id="dhid2" value="<%=dhid2%>" /><input type="text" class="input4" name="dhjf2" id="dhjf2" value="<%=dhjf2%>" maxlength="8" />积分+<input type="text" class="input4" name="dhje2" id="dhje2" value="<%=dhje2%>" maxlength="8" />元</td>
                   </tr>
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>积分+金额：</td>
                      <td><input type="hidden" name="dhid3" id="dhid3" value="<%=dhid3%>" /><input type="text" class="input4" name="dhjf3" id="dhjf3" value="<%=dhjf3%>" maxlength="8" />积分+<input type="text" class="input4" name="dhje3" id="dhje3" value="<%=dhje3%>" maxlength="8" />元</td>
                   </tr>
                   -->
                   <tr>
                      <td align="center" valign="top"><span class="star">*</span></td>
                      <td valign="top">商品图片1：</td>
                      <td><input type="file"  name="zstp1" id="zstp1" /> 商品详情页的各种不同角度的主图片,其他页面展示时默认采用第一张,大小为335*335,格式jpg、png
					<%if (zstp1!=null && !zstp1.equals("")){%><br/><input type="hidden" name="zstp1id" id="zstp1id" value="<%=zstp1id%>" /><img src="<%="../"+zstp1%>" /><%} %> &nbsp;&nbsp;</td>
                   </tr>
                   
                   <tr>
                      <td align="center"></td>
                      <td valign="top">商品图片2：</td>
                      <td><input type="file"  name="zstp2" id="zstp2" />
					<%if (zstp2!=null && !zstp2.equals("")){%><br/><input type="hidden" name="zstp2id" id="zstp2id" value="<%=zstp2id%>" /><img src="<%="../"+zstp2%>" /><%} %> &nbsp;&nbsp;</td>
                   </tr>
                   
                   <tr>
                      <td align="center"></td>
                      <td valign="top">商品图片3：</td>
                      <td><input type="file"  name="zstp3" id="zstp3" />
					<%if (zstp3!=null && !zstp3.equals("")){%><br/><input type="hidden" name="zstp3id" id="zstp3id" value="<%=zstp3id%>" /><img src="<%="../"+zstp3%>" /><%} %> &nbsp;&nbsp;</td>
                   </tr>
                   
                   <tr>
                      <td align="center"></td>
                      <td valign="top">商品图片4：</td>
                      <td><input type="file"  name="zstp4" id="zstp4" />
					<%if (zstp4!=null && !zstp4.equals("")){%><br/><input type="hidden" name="zstp4id" id="zstp4id" value="<%=zstp4id%>" /><img src="<%="../"+zstp4%>" /><%} %> &nbsp;&nbsp;</td>
                   </tr>
                   
                   <tr>
                      <td align="center"></td>
                      <td valign="top">商品图片5：</td>
                      <td><input type="file"  name="zstp5" id="zstp5" />
					<%if (zstp5!=null && !zstp5.equals("")){%><br/><input type="hidden" name="zstp5id" id="zstp5id" value="<%=zstp5id%>" /><img src="<%="../"+zstp5%>" /><%} %> &nbsp;&nbsp;</td>
                   </tr>
                   
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>系列默认：</td>
                      <td><input type="radio" name="xlmr" id="xlmr" value="1" <%if (spid!=null && xlmr!=null && xlmr.equals(spid)) out.print("checked='checked'"); %> />是 　　<input type="radio" name="xlmr" id="xlmr" value="0" <%if (spid==null || xlmr==null || !xlmr.equals(spid)) out.print("checked='checked'"); %> />否</td>
                    </tr>
                   <tr>
                   
                    <tr>
                       <td align="center"></td>
                       <td>商品内容：</td>
                       <td><textarea id="spnr" name="spnr"><%=spnr==null?"":spnr%></textarea></td>
                     </tr>
                        
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                  </tr>
                </table>
                <script type="text/javascript">CKEDITOR.replace("spnr");</script>
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
<%}
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
</body>
</html>