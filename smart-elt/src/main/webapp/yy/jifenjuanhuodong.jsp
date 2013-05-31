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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("3002")==-1)
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

String lm=request.getParameter("lm");
if (lm==null) lm="";

String naction=request.getParameter("naction");
String hdid=request.getParameter("hdid");
if ( !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(hdid))
{	
	response.sendRedirect("jifenjuanhuodong.jsp");
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
	location.href="jifenjuanhuodong.jsp?hdmc="+encodeURI(escape(document.getElementById("hdmc").value))+"&lm="+document.getElementById("lm").value+"&pno="+p;
}
function delit(lid)
{
	if (confirm("确认删除此此活动，删除后无法恢复"))
	{
		location.href="jifenjuanhuodong.jsp?naction=del&hdid="+lid+"&hdmc="+encodeURI(escape(document.getElementById("hdmc").value))+"&lm="+document.getElementById("lm").value+"&pno=<%=pno%>";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="3002";
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{
	if (naction!=null && naction.equals("del"))
	{		
		strsql="delete from tbl_jfqhd where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	//下架时取消推荐
	if (naction!=null && naction.equals("xiajia"))
	{		
		strsql="update tbl_jfqhd set zt=0,tj=0 where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("shangjia"))
	{		
		strsql="update tbl_jfqhd set zt=1 where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("tj"))
	{		
		strsql="update tbl_jfqhd set tj=1 where nid="+hdid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("notj"))
	{		
		strsql="update tbl_jfqhd set tj=0 where nid="+hdid;
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
            <td><div class="local"><span>福利券管理&gt; 活动管理</span></div></td>
          </tr>
          <tr><td>
          <%
          strsql="select l.lmmc,count(*) as hn from tbl_jfqlm l left join tbl_jfqhd h on h.lm=l.nid where h.tj=1  and now()>=h.kssj and now()<=h.jssj group by l.lmmc";
          rs=stmt.executeQuery(strsql);
          while(rs.next())
          {
        	  out.print("["+rs.getString("lmmc")+"]可用推荐位<font color='red'>"+String.valueOf(4-rs.getInt("hn"))+"</font>个,");
          }
          rs.close();
          
          strsql="select lmmc from tbl_jfqlm where nid not in  (select l.nid from tbl_jfqlm l left join tbl_jfqhd h on h.lm=l.nid where h.tj=1 and now()>=h.kssj and now()<=h.jssj group by l.nid)";
          rs=stmt.executeQuery(strsql);
          while(rs.next())
          {
        	  out.print("["+rs.getString("lmmc")+"]可用推荐位<font color='red'>4</font>个,");
          }
          rs.close();
          %>
          </td></tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						活动名称：<input type="text" class="inputbox" style="width: 80px;" name="hdmc" id="hdmc" value="<%=hdmc%>" />
						所属类目：<select name="lm" id="lm"><option value="">全部</option>
						<%
						strsql="select nid,lmmc from tbl_jfqlm where sfxs=1 order by xswz desc";
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							out.print("<option value='"+rs.getString("nid")+"'");
							if (lm!=null && rs.getString("nid").equals(lm))
								out.print(" selected='selected'");
							out.print(">"+rs.getString("lmmc")+"</option>");
						}
						rs.close();
						%>
						</select>				
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="jfjhdbianji.jsp" class="daorutxt">增加活动</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_jfqhd where 1=1";
	            if (hdmc!=null && hdmc.length()>0)
	       			strsql+=" and hdmc like '%"+hdmc+"%'";
	       		if (lm!=null && lm.length()>0)
       			strsql+=" and lm="+lm;
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
                   <th width="25%">活动名称</th>
                   <th width="10%">类目</th>
                   <th width="10%">开始日期</th>
                   <th width="10%">结束日期</th>
                   <th width="8%">最小积分</th>
                   <th width="8%">推荐</th>                
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select h.nid,h.hdmc,h.kssj,h.jssj,h.zxjf,h.tj,l.lmmc,h.zt from tbl_jfqhd h left join tbl_jfqlm l on h.lm=l.nid where 1=1";
                  if (hdmc!=null && hdmc.length()>0)
  	       			strsql+=" and h.hdmc like '%"+hdmc+"%'";
  	       		  if (lm!=null && lm.length()>0)
         			strsql+=" and h.lm="+lm;
                  strsql+=" order by h.jssj desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr <% Date date = new Date();
		          		Calendar calendar = new GregorianCalendar();
		        		calendar.setTime(date); 
		        		calendar.add(Calendar.DATE,-1);
		        		date=calendar.getTime(); 
                  	if (rs.getDate("jssj").before(date))out.print(" class='outdate'");%>>                  	
                    <td class="textbreak"><%=rs.getString("hdmc")==null?"":rs.getString("hdmc")%></td>
                    <td><%=rs.getString("lmmc")==null?"":rs.getString("lmmc")%></td>
                    <td><%=rs.getDate("kssj")==null?"":rs.getDate("kssj")%></td>
                    <td><%=rs.getDate("jssj")==null?"":rs.getDate("jssj")%></td>
                    <td><%=rs.getString("zxjf")==null?"":rs.getString("zxjf")%></td>                    
                    <td><%if (rs.getInt("tj")==1) out.print("是"); else out.print("否");%></td>
                    <td><%
                    if (rs.getTimestamp("jssj").after(date))
                    {
                    if (rs.getInt("tj")==1) out.print("<a href='jifenjuanhuodong.jsp?naction=notj&hdid="+rs.getString("nid")+"' class='blue'>取消推荐</a>"); else out.print("<a href='jifenjuanhuodong.jsp?naction=tj&hdid="+rs.getString("nid")+"' class='blue'>推荐</a>"); %>&nbsp;&nbsp;&nbsp;&nbsp;<%if (rs.getInt("zt")==1) out.print("<a href='jifenjuanhuodong.jsp?naction=xiajia&hdid="+rs.getString("nid")+"' class='blue'>下架</a>"); else out.print("<a href='jifenjuanhuodong.jsp?naction=shangjia&hdid="+rs.getString("nid")+"' class='blue'>上架</a>"); %>&nbsp;&nbsp;&nbsp;&nbsp;<%if (rs.getDate("jssj").after(date)) out.print("<a href=\"jfjhdbianji.jsp?hdid="+rs.getString("nid")+"\" class=\"blue\">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;");%><%if (rs.getDate("kssj").after(date)) out.print("<a href='javascript:void(0);' class='blue' onclick='delit("+rs.getString("nid")+")'>删除</a>"); %></td>
                  	<%}
                    else
                    {
                    	out.print("<a href=\"jfjhdbianji.jsp?naction=see&hdid="+rs.getString("nid")+"\" class=\"blue\">查看</a></td>");
                    }
                  	%>
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