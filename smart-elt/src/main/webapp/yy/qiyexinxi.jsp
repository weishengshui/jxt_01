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
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("1002")==-1)
{
	out.print("你没有操作权限！");
	return;
}

Fun fun=new Fun();
int ln=0;
int pages=1;
int psize=10;
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

String qymc=request.getParameter("qymc");
if (qymc!=null)
{
	qymc=fun.unescape(qymc);
	qymc=URLDecoder.decode(qymc,"utf-8");
}
if (qymc==null) qymc="";

String lxr=request.getParameter("lxr");
if (lxr!=null)
{
	lxr=fun.unescape(lxr);
	lxr=URLDecoder.decode(lxr,"utf-8");
}
if (lxr==null) lxr="";

String khjl=request.getParameter("khjl");
if (khjl!=null)
{
	khjl=fun.unescape(khjl);
	khjl=URLDecoder.decode(khjl,"utf-8");
}
if (khjl==null) khjl="";
String naction=request.getParameter("naction");
String qyid=request.getParameter("qyid");
if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(qyid) || !fun.sqlStrCheck(naction) || !fun.sqlStrCheck(lxr) || !fun.sqlStrCheck(khjl))
{	
	response.sendRedirect("qiyexinxi.jsp");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function searchit(p)
{
	location.href="qiyexinxi.jsp?qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&lxr="+encodeURI(escape(document.getElementById("lxr").value))+"&khjl="+encodeURI(escape(document.getElementById("khjl").value))+"&pno="+p;
}
function setzt(t,id)
{
	if (t==1)
	{
		if (confirm("确认要冻结此企业账户吗，冻结后此企业所有账户将不能登陆!"))
			location.href="qiyexinxi.jsp?naction=dongjie&qyid="+id+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&lxr="+encodeURI(escape(document.getElementById("lxr").value))+"&khjl="+encodeURI(escape(document.getElementById("khjl").value));
	}
	if (t==0)
	{
		if (confirm("确认要解冻此企业账户吗!"))
			location.href="qiyexinxi.jsp?naction=jiedong&qyid="+id+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&lxr="+encodeURI(escape(document.getElementById("lxr").value))+"&khjl="+encodeURI(escape(document.getElementById("khjl").value));
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="1002";
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	
	if (naction!=null && naction.equals("dongjie"))
	{
		strsql="update tbl_qy set zt=4 where nid="+qyid;
		stmt.execute(strsql);
	}
	if (naction!=null && naction.equals("jiedong"))
	{
		strsql="update tbl_qy set zt=2 where nid="+qyid;
		stmt.execute(strsql);
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
            <td><div class="local"><span>企业管理&gt; 企业信息管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>企业名称：</span><input type="text" class="inputbox" style="width: 80px;" name="qymc" id="qymc" value="<%=qymc%>" />
						<span>联系人：</span><input type="text" class="inputbox"  style="width: 50px;" name="lxr" id="lxr" value="<%=lxr%>" />
						<span>客户经理：</span><input type="text" class="inputbox"  style="width: 50px;" name="khjl" id="khjl" value="<%=khjl%>" />				
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="qiyebianji.jsp" class="daorutxt">增加企业</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_qy where (zt=2 or zt=4)";
           		if (qymc!=null && qymc.length()>0)
           			strsql+=" and qymc like '%"+qymc+"%'";
           		if (lxr!=null && lxr.length()>0)
           			strsql+=" and lxr like '%"+lxr+"%'";
           		if (khjl!=null && khjl.length()>0)
           			strsql+=" and khjl like '%"+khjl+"%'";
            	rs=stmt.executeQuery(strsql);
            	if(rs.next())
            	{
            		ln=rs.getInt("hn");
            	}
            	rs.close();
            	pages=(ln-1)/psize+1;
            	
            	
            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="30">一共 <span class="red"><%=ln%></span> 条信息 </td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>                   
                   <th width="15%">企业名称</th>
                   <th width="10%">域名</th>
                   <th width="8%">联系人</th>
                   <th width="10%">联系人邮箱</th>
                   <th width="8%">客户经理</th>
                   <th width="8%">营业执照</th>
                   <th width="8%">税务登记证</th>      
                   <th width="8%">组织机构代码</th> 
                   <th width="8%">Logo</th>       
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select nid,qymc,qybh,lxr,lxremail,yyzz,swdj,zzjg,log,zt,khjl from tbl_qy where (zt=2 or zt=4) ";
                  if (qymc!=null && qymc.length()>0)
             			strsql+=" and qymc like '%"+qymc+"%'";
                  if (lxr!=null && lxr.length()>0)
             			strsql+=" and lxr like '%"+lxr+"%'";
                  if (khjl!=null && khjl.length()>0)
             			strsql+=" and khjl like '%"+khjl+"%'";
                  strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td class="textbreak"><%=rs.getString("qymc")==null?"":rs.getString("qymc")%></td>
                    <td><%=rs.getString("qybh")==null?"":rs.getString("qybh")%></td>
                    <td><%=rs.getString("lxr")==null?"":rs.getString("lxr")%></td>
                    <td><%=rs.getString("lxremail")==null?"":rs.getString("lxremail")%></td>
                    <td><%=rs.getString("khjl")==null?"":rs.getString("khjl")%></td>
                    <td><%if (rs.getString("yyzz")!=null && rs.getString("yyzz").length()>0) out.print("<a href='../"+rs.getString("yyzz")+"' target='_blank' class='blue'>查看</a>");%></td>
                    <td><%if (rs.getString("swdj")!=null && rs.getString("swdj").length()>0) out.print("<a href='../"+rs.getString("swdj")+"' target='_blank' class='blue'>查看</a>");%></td>
                    <td><%if (rs.getString("zzjg")!=null && rs.getString("zzjg").length()>0) out.print("<a href='../"+rs.getString("zzjg")+"' target='_blank' class='blue'>查看</a>");%></td>
                    <td><%if (rs.getString("log")!=null && rs.getString("log").length()>0) out.print("<a href='../"+rs.getString("log")+"' target='_blank' class='blue'>查看</a>");%></td>                
                    <td><a href="qiyebianji.jsp?qyid=<%=rs.getString("nid")%>" class="blue">修改</a>
                    <%if (rs.getInt("zt")==2) out.print("<a href='javascript:void(0);'  class='blue' onclick='setzt(1,"+rs.getString("nid")+")'>冻结<a>"); else out.print("<a href='javascript:void(0);'  class='blue' onclick='setzt(0,"+rs.getString("nid")+")'>解冻<a>"); %>
                    </td>
                  </tr>
                 <%}
                  rs.close();
                  %>
                
                </table>
				</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td style="padding:15px 0"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>                
                <td width="450">
                <%
					int page_no=Integer.valueOf(pno);	
					if (page_no>=5 && page_no<=pages-2)
					{
						for (int i=page_no-3;i<=page_no+2;i++)
						{
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' class='num'  onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							
						}
						out.print("...");
					}
					else if (page_no<5)
					{
						if (pages>6)
						{
							for (int i=1;i<=6;i++)
							{
								if (i==page_no)
									out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);'  class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							}
							out.print("...");
						}
						else
						{
							for (int i=1;i<=pages;i++)
							{
								if (i==page_no)
									out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);' class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							}
						}
					}
					else
					{
						for (int i=pages-5;i<=pages;i++)
						{
							if (i==0) i=1;
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
						}
					}
				
					%>
                </td>
                <td align="right">
                <%if (page_no>1) out.print("<a href='javascript:void(0);' class='up' onclick='searchit("+(page_no-1)+")'>上一页</a>");%>
				<%if (page_no<pages) out.print("<a href='javascript:void(0);' class='up' onclick='searchit("+(page_no+1)+")'>下一页</a>");%>
                </td>
              </tr>
            </table></td>
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