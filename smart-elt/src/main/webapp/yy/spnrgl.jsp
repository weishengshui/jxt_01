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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4002")==-1)
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

String lmc=request.getParameter("lmc");
if (lmc!=null)
{
	lmc=fun.unescape(lmc);
	lmc=URLDecoder.decode(lmc,"utf-8");
}
if (lmc==null) lmc="";

String mc=request.getParameter("mc");
if (mc!=null)
{
	mc=fun.unescape(mc);
	mc=URLDecoder.decode(mc,"utf-8");
}
if (mc==null) mc="";

String lb1=request.getParameter("lb1");
String lb2=request.getParameter("lb2");
String lb3=request.getParameter("lb3");

String naction=request.getParameter("naction");
String spid=request.getParameter("spid");
String spl=request.getParameter("spl");
if (!fun.sqlStrCheck(lmc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(spid) || !fun.sqlStrCheck(naction) || !fun.sqlStrCheck(mc) ||!fun.sqlStrCheck(spl))
{	
	response.sendRedirect("spnrgl.jsp");
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
	location.href="spnrgl.jsp?lmc="+encodeURI(escape(document.getElementById("lmc").value))+"&lb1="+document.getElementById("lb1").value+"&mc="+encodeURI(escape(document.getElementById("mc").value))+"&pno="+p;
}

function delit(spid,aa)
{
	if (confirm("确认删除此商品信息吗，删除后将无法恢复！"))
	{
		location.href="spnrgl.jsp?naction=del&spid="+spid+"&lmc="+encodeURI(escape(document.getElementById("lmc").value))+"&lb1="+document.getElementById("lb1").value+"&mc="+encodeURI(escape(document.getElementById("mc").value))+"&pno=<%=pno%>";
	}
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4002";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	
	if (naction!=null && naction.equals("del"))
	{		
		strsql="update tbl_sp set zt=-1 where nid="+spid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("xiajia"))
	{		
		strsql="update tbl_sp set zt=0 where nid="+spid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("shangjia"))
	{		
		strsql="update tbl_sp set zt=1 where nid="+spid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("mr"))
	{		
		strsql="update tbl_spl set sp="+spid+" where nid="+spl;
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
            <td><div class="local"><span>商品管理&gt; 商品内容管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>系列名称：</span><input type="text" class="inputbox" style="width: 80px;" name="lmc" id="lmc" value="<%=lmc%>" />
						<span>类目：</span><select name="lb1" id="lb1" onchange="getsplb(this)">
						<option value="">全部</option>
						<%
						strsql="select nid,mc from tbl_splm where flm=0 order by xswz desc";
						rs=stmt.executeQuery(strsql);
						while (rs.next())
						{
							if (lb1!=null && lb1.equals(rs.getString("nid")))
								out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mc")+"</option>");
							else
								out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
						}
						rs.close();
						%>
						</select>
						<span>商品名称：</span><input type="text" class="inputbox" style="width: 80px;" name="mc" id="mc" value="<%=mc%>" />
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="spnrbianji.jsp" class="daorutxt">增加商品</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(s.nid) as hn from tbl_sp s left join tbl_spl l on s.spl=l.nid where s.zt>=0";
            	 if (mc!=null && mc.length()>0)
               		strsql+=" and spmc like '%"+mc+"%'";
           		if (lmc!=null && lmc.length()>0)
           			strsql+=" and l.mc like '%"+lmc+"%'";
           		if (lb1!=null && lb1.length()>0)
           			strsql+=" and l.lb1="+lb1;
           		if (lb2!=null && lb2.length()>0)
           			strsql+=" and l.lb2="+lb2;
           		if (lb3!=null && lb3.length()>0)
           			strsql+=" and l.lb3="+lb3;
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
                   <th width="25%">商品名称</th>
                   <th width="25%">系列名称</th>
                   <th width="8%">类目1</th>
                   <th width="8%">类目2</th>
                   <th width="8%">类目3</th>
                   <th width="10%">系列默认</th>
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select s.nid,s.spl,s.spmc,s.zt,l.mc as lmc,l.sp as mrid,l.zt as lzt,m1.mc as lmmc1,m2.mc as lmmc2,m3.mc as lmmc3 from tbl_sp s left join  tbl_spl l on s.spl=l.nid left join tbl_splm m1 on l.lb1=m1.nid left join tbl_splm m2 on l.lb2=m2.nid left join tbl_splm m3 on l.lb3=m3.nid where s.zt>=0";
                  if (mc!=null && mc.length()>0)
              		strsql+=" and spmc like '%"+mc+"%'";
                  if (lmc!=null && lmc.length()>0)
            		strsql+=" and l.mc like '%"+lmc+"%'";
	           	  if (lb1!=null && lb1.length()>0)
	           			strsql+=" and l.lb1="+lb1;
	           	  if (lb2!=null && lb2.length()>0)
	           			strsql+=" and l.lb2="+lb2;
	           	  if (lb3!=null && lb3.length()>0)
           			   strsql+=" and l.lb3="+lb3;
                  strsql+=" order by s.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                	  String aa = request.getParameter("lb1");
                	  aa = (aa== null ?"":request.getParameter("lb1"));
                  %>
                  <tr>
                  	<td class="textbreak"><%=rs.getString("spmc")%></td>            	
                    <td class="textbreak"><%=rs.getString("lmc")%></td>
                    <td><%=rs.getString("lmmc1")==null?"":rs.getString("lmmc1")%></td>
                    <td><%=rs.getString("lmmc2")==null?"":rs.getString("lmmc2")%></td>
                    <td><%=rs.getString("lmmc3")==null?"":rs.getString("lmmc3")%></td>
                    <td><%if (rs.getString("mrid")==null || !rs.getString("mrid").equals(rs.getString("nid"))) out.print("<a href='spnrgl.jsp?naction=mr&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&lb1="+aa+"&spid="+rs.getString("nid")+"&spl="+rs.getString("spl")+"'>设为默认<a>"); else out.print("<font color='red'>默认</font>");%></td>                     
                    <td><a href="spnrbianji.jsp?lb1=<%=aa%>&spid=<%=rs.getString("nid")%>&pno=${param.pno}" class="blue">修改</a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <%
                    if (rs.getInt("zt")==1 && rs.getString("mrid")!=null && rs.getString("mrid").equals(rs.getString("nid")))
                    	out.print("<font color='#CCCCCC'>下架</font>"); 
                    else if (rs.getInt("zt")==1)
                    	out.print("<a href='spnrgl.jsp?naction=xiajia&lb1="+aa+"&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&spid="+rs.getString("nid")+"' class='blue'>下架</a>"); 
                    else if (rs.getInt("lzt")==0)
                    	out.print("<font color='#CCCCCC'>上架</font>");
                    else
                    	out.print("<a href='spnrgl.jsp?naction=shangjia&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&lb1="+aa+"&spid="+rs.getString("nid")+"' class='blue'>上架</a>"); %>
                    &nbsp;&nbsp;&nbsp;&nbsp;<%if (rs.getInt("zt")==0) out.print("<a href='javascript:void(0);' class='blue' onclick='delit("+rs.getString("nid")+",\""+aa+"\")'>删除</a>"); %></td>
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