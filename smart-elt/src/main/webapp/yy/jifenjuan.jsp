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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("3003")==-1)
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

String hdmc=request.getParameter("hdmc");
if (hdmc!=null)
{
	hdmc=fun.unescape(hdmc);
	hdmc=URLDecoder.decode(hdmc,"utf-8");
}
if (hdmc==null) hdmc="";



String jfjmc=request.getParameter("jfjmc");
if (jfjmc!=null)
{
	jfjmc=fun.unescape(jfjmc);
	jfjmc=URLDecoder.decode(jfjmc,"utf-8");
}
if (jfjmc==null) jfjmc="";
String naction=request.getParameter("naction");
String jfjid=request.getParameter("jfjid");
if ( !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(jfjid))
{	
	response.sendRedirect("jifenjuan.jsp");
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
<script type="text/javascript">


function searchit(p)
{
	location.href="jifenjuan.jsp?hdmc="+encodeURI(escape(document.getElementById("hdmc").value))+"&jfjmc="+encodeURI(escape(document.getElementById("jfjmc").value))+"&pno="+p;
}
function delit(lid)
{
	if (confirm("确认删除此库存中的福利券，删除后无法恢复"))
	{
		location.href="jifenjuan.jsp?naction=del&jfjid="+lid+"&hdmc="+encodeURI(escape(document.getElementById("hdmc").value))+"&jfjmc="+encodeURI(escape(document.getElementById("jfjmc").value))+"&pno=<%=pno%>";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="3003";
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{
	//如果没售出过可以删除，售出 过后不删除
	if (naction!=null && naction.equals("del"))
	{
		
		//strsql="delete from tbl_jfq where nid="+jfjid;
		//stmt.executeUpdate(strsql);
	}
	
	if (naction!=null && naction.equals("xiajia"))
	{		
		int jhd=0;
		int jfqn=1;
		//判断福利券活动是否有效
		strsql="select j.hd from tbl_jfq j inner join tbl_jfqhd h on j.hd=h.nid where j.nid="+jfjid+" and h.zt=1 and now()>=h.kssj and now()<=h.jssj";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			jhd=rs.getInt("hd");
		}
		rs.close();
		
		//对应活动还有效，则判断此活动是否还有其他福利券
		if (jhd>0)
		{
			strsql="select count(nid) as hn from tbl_jfq where hd="+jhd+" and nid<>"+jfjid+" and zt=1";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				jfqn=rs.getInt("hn");
			}
			rs.close();
		}
		
		if (jfqn==0)
		{
		%>	
			<script type="text/javascript">
	   		if (confirm('该福利券对应的活动中没有其他有效福利券了，请下架此对应活动！'))
	   			location.href="jifenjuan.jsp?naction=xiajia2&jfjid=<%=jfjid%>";
	   		else
	   			locaton.href="jifenjuan.jsp";
	   		</script>
	   	<%
		}
		else
		{
			strsql="update tbl_jfq set zt=0 where nid="+jfjid;
			stmt.executeUpdate(strsql);
		}
		
		
	}
	if (naction!=null && naction.equals("xiajia2"))
	{		
		strsql="update tbl_jfq set zt=0 where nid="+jfjid;
		stmt.executeUpdate(strsql);
	}
	
	if (naction!=null && naction.equals("shangjia"))
	{		
		strsql="update tbl_jfq set zt=1 where nid="+jfjid;
		stmt.executeUpdate(strsql);
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
            <td><div class="local"><span>福利券管理&gt; 福利券内容管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>活动名称：</span><input type="text" class="inputbox" style="width: 80px;" name="hdmc" id="hdmc" value="<%=hdmc%>" />
						<span>福利券名称：</span><input type="text" class="inputbox" style="width: 80px;" name="jfjmc" id="jfjmc" value="<%=jfjmc%>" />
								
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="jifenjuanbianji.jsp" class="daorutxt">增加福利券</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(j.nid) as hn from tbl_jfq j left join tbl_jfqhd h on j.hd=h.nid where 1=1";
	            if (hdmc!=null && hdmc.length()>0)
	       			strsql+=" and h.hdmc like '%"+hdmc+"%'";
	            if (jfjmc!=null && jfjmc.length()>0)
	       			strsql+=" and j.mc like '%"+jfjmc+"%'";
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
                   <th width="8%">券编号</th>
                   <th width="20%">福利券名称</th>            
                   <th width="20%">所属活动</th>
                   <th width="10%">有效期</th>                   
                   <th width="8%">积分</th>
                   <th width="8%">生成数量</th>
                   <th width="8%">库存数量</th>                                
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select j.nid,j.qz,j.mc,h.hdmc,j.yxq,j.scsl,j.kcsl,j.jf,j.zt,h.kssj,h.jssj from tbl_jfq j left join tbl_jfqhd h on j.hd=h.nid where 1=1";
                  if (hdmc!=null && hdmc.length()>0)
  	       			strsql+=" and h.hdmc like '%"+hdmc+"%'";
  	              if (jfjmc!=null && jfjmc.length()>0)
  	       			strsql+=" and j.mc like '%"+jfjmc+"%'";
                  strsql+=" order by j.zt desc,j.yxq limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td><%=rs.getString("qz")==null?"":rs.getString("qz")%></td>
                    <td><%=rs.getString("mc")==null?"":rs.getString("mc")%></td>
                    <td><%=rs.getString("hdmc")==null?"":rs.getString("hdmc")%></td>
                    <td><%=rs.getDate("yxq")==null?"":rs.getDate("yxq")%></td>
                    <td><%=rs.getString("jf")==null?"":rs.getString("jf")%></td>
                    <td><%=rs.getString("scsl")==null?"":rs.getString("scsl")%></td>
                    <td><%=rs.getString("kcsl")==null?"":rs.getString("kcsl")%></td>
                    <td><%
                    	if (rs.getInt("zt")==1)
                    			out.print("<a href='jifenjuan.jsp?naction=xiajia&jfjid="+rs.getString("nid")+"' class='blue'>下架</a>&nbsp;&nbsp;&nbsp;&nbsp;"); 
                       else if (rs.getInt("zt")==0 && rs.getDate("yxq").after(Calendar.getInstance().getTime()))
                    			out.print("<a href='jifenjuan.jsp?naction=shangjia&jfjid="+rs.getString("nid")+"' class='blue'>上架</a>&nbsp;&nbsp;&nbsp;&nbsp;"); %>
                    			
                    	<%
                    	if (rs.getDate("yxq").after(Calendar.getInstance().getTime()) && rs.getInt("zt")==0)                   	
                    		out.print("<a href=\"jifenjuanbianji.jsp?jfjid="+rs.getString("nid")+"\" class=\"blue\">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;");
                    	if (rs.getDate("yxq").before(Calendar.getInstance().getTime()))
                    		out.print("<a href=\"jifenjuanbianji.jsp?naction=see&jfjid="+rs.getString("nid")+"\" class=\"blue\">查看</a>&nbsp;&nbsp;&nbsp;&nbsp;");
                    	%></td>
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