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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4001")==-1)
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

String lb1=request.getParameter("lb1");
String lb2=request.getParameter("lb2");
String lb3=request.getParameter("lb3");

String naction=request.getParameter("naction");
String lid=request.getParameter("lid");
if (!fun.sqlStrCheck(lmc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(lid) || !fun.sqlStrCheck(naction))
{	
	response.sendRedirect("spxlgl.jsp");
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
	location.href="spxlgl.jsp?lmc="+encodeURI(escape(document.getElementById("lmc").value))+"&lb1="+document.getElementById("lb1").value+"&pno="+p;
}

function delit(lid)
{
	if (confirm("确认删除此商品系统吗，删除后无法恢复"))
	{
		location.href="spxlgl.jsp?naction=del&lid="+lid+"&lmc="+encodeURI(escape(document.getElementById("lmc").value))+"&lb1="+document.getElementById("lb1").value+"&pno=<%=pno%>";
	}
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4001";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	
	if (naction!=null && naction.equals("del"))
	{		
		//strsql="update tbl_spl set zt=-1 where nid="+lid;
		//stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("xiajia"))
	{		
		strsql="update tbl_spl set zt=0 where nid="+lid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("shangjia"))
	{		
		strsql="update tbl_spl set zt=1 where nid="+lid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("tj"))
	{		
		strsql="update tbl_spl set sftj=1 where nid="+lid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && naction.equals("notj"))
	{		
		strsql="update tbl_spl set sftj=0 where nid="+lid;
		stmt.executeUpdate(strsql);
	}
	// 大类推荐
	if (naction!=null && naction.equals("dltj"))
	{	
		String querySql = "select count(*) c from tbl_spl where lb1 = " + request.getParameter("pid") + " and rm = 1";
		ResultSet rss = stmt.executeQuery(querySql);
		int n = 0;
		String rm = request.getParameter("rm");
		if(rss.next()){
			n = rss.getInt("c");
		}
		if(n >= 4 && "1".equals(rm)){
			out.println("<script>alert('推荐不能超过4个');</script>");
		}else{
			strsql="update tbl_spl set rm = " + request.getParameter("rm") + " where nid="+request.getParameter("nid");
			stmt.executeUpdate(strsql);
		}
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
            <td><div class="local"><span>商品管理&gt; 商品系列管理</span></div></td>
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
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"><a href="spxlbianji.jsp" class="daorutxt">增加系列</a>
						<%
							String sqls = "SELECT SUM(rm) rm,(select mc from tbl_splm where nid = lb1 AND sfxs = 1) mc FROM tbl_spl GROUP BY lb1";
							rs = stmt.executeQuery(sqls);
							while (rs.next()){
								if(rs.getString("mc") != null){
									out.print("["+rs.getString("mc")+"]可用推荐位<font color='red'>"+(4-rs.getInt("rm"))+"</font>&nbsp;");
								}
							}
						%>
					</div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_spl where zt>=0";
           		if (lmc!=null && lmc.length()>0)
           			strsql+=" and mc like '%"+lmc+"%'";
           		if (lb1!=null && lb1.length()>0)
           			strsql+=" and lb1="+lb1;
           		if (lb2!=null && lb2.length()>0)
           			strsql+=" and lb2="+lb2;
           		if (lb3!=null && lb3.length()>0)
           			strsql+=" and lb3="+lb3;
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
                   <th width="25%">系列名称</th>
                   <th width="10%">类目1</th>
                   <th width="10%">类目2</th>
                   <th width="10%">类目3</th>
                   <th width="25%">默认商品</th>
                   <th width="5%">大类推荐</th>
                   <th width="5%">热门兑换</th>
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select m1.nid pid,l.rm,l.nid,l.mc as lmc,l.zt,l.sftj,s.spmc as spmc,m1.mc as lmmc1,m2.mc as lmmc2,m3.mc as lmmc3 from tbl_spl l left join tbl_sp s on l.sp=s.nid left join tbl_splm m1 on l.lb1=m1.nid left join tbl_splm m2 on l.lb2=m2.nid left join tbl_splm m3 on l.lb3=m3.nid where l.zt>=0";
                  if (lmc!=null && lmc.length()>0)
            		strsql+=" and l.mc like '%"+lmc+"%'";
	           	  if (lb1!=null && lb1.length()>0)
	           			strsql+=" and l.lb1="+lb1;
	           	  if (lb2!=null && lb2.length()>0)
	           			strsql+=" and l.lb2="+lb2;
	           	  if (lb3!=null && lb3.length()>0)
           			   strsql+=" and l.lb3="+lb3;
                  strsql+=" order by l.sftj desc,l.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td class="textbreak"><%=rs.getString("lmc")%></td>
                    <td><%=rs.getString("lmmc1")==null?"":rs.getString("lmmc1")%></td>
                    <td><%=rs.getString("lmmc2")==null?"":rs.getString("lmmc2")%></td>
                    <td><%=rs.getString("lmmc3")==null?"":rs.getString("lmmc3")%></td>
                    <td class="textbreak"><%=rs.getString("spmc")==null?"":rs.getString("spmc")%></td>
                    <td>
                    	<%
                    		String aa = request.getParameter("lb1") == null ?"":request.getParameter("lb1");
                    		if(rs.getInt("rm")==1){
						%>
							<a href="spxlgl.jsp?naction=dltj&nid=<%=rs.getString("nid") %>&rm=0&lb1=<%=aa%>&pid=<%=rs.getString("pid") %>&pno=${param.pno}" class="blue">否</a>
						<%  }else{
						%>
							<a href="spxlgl.jsp?naction=dltj&nid=<%=rs.getString("nid") %>&rm=1&lb1=<%=aa%>&pid=<%=rs.getString("pid") %>&pno=${param.pno}" class="blue">是</a>
						<%
							}
                    	%>
                    </td>
                    <td> <%if (rs.getInt("sftj")==0) out.print("<a href='spxlgl.jsp?naction=tj&lb1="+aa+"&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&lid="+rs.getString("nid")+"' class='blue'>是</a>"); else out.print("<a href='spxlgl.jsp?naction=notj&lb1="+aa+"&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&lid="+rs.getString("nid")+"' class='blue'>否</a>"); %></td>
                    <td>                   
                    <a href="spxlbianji.jsp?lb1=<%=aa %>&lid=<%=rs.getString("nid")%>&pno=${param.pno}" class="blue">修改</a>
                    &nbsp;&nbsp;&nbsp;&nbsp;<%if (rs.getInt("zt")==1) out.print("<a href='spxlgl.jsp?naction=xiajia&lb1="+aa+"&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&lb1="+aa+"&lid="+rs.getString("nid")+"' class='blue'>下架</a>"); else out.print("<a href='spxlgl.jsp?naction=shangjia&lb1="+aa+"&pno="+(request.getParameter("pno")==null?"1":request.getParameter("pno"))+"&lid="+rs.getString("nid")+"' class='blue'>上架</a>"); %></td>
                 
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