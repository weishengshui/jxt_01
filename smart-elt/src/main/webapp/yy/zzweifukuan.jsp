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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("2001")==-1)
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

String khjl=request.getParameter("khjl");
if (khjl!=null)
{
	khjl=fun.unescape(khjl);
	khjl=URLDecoder.decode(khjl,"utf-8");
}
if (khjl==null) khjl="";

String zzbh=request.getParameter("zzbh");
if (zzbh==null) zzbh="";
String sddrj=request.getParameter("sddrj");
if (sddrj==null) sddrj="";
String eddrj=request.getParameter("eddrj");
if (eddrj==null) eddrj="";

SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd");
String neddrj="",nefkrj="";
if (eddrj!=null && eddrj.length()>0)
	neddrj=sf2.format(new Date(sf2.parse(eddrj).getTime()+24*60*60*1000));



String naction=request.getParameter("naction");
if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(zzbh) || !fun.sqlStrCheck(khjl) || !fun.sqlStrCheck(sddrj) || !fun.sqlStrCheck(eddrj))
{	
	response.sendRedirect("zzweifukuan.jsp");
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
<script type="text/javascript" src="../gl/js/calendar3.js"></script>
<script type="text/javascript">


function searchit(p)
{
	location.href="zzweifukuan.jsp?qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&zzbh="+encodeURI(escape(document.getElementById("zzbh").value))+"&khjl="+encodeURI(escape(document.getElementById("khjl").value))+"&sddrj="+document.getElementById("sddrj").value+"&eddrj="+document.getElementById("eddrj").value+"&pno="+p;
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="2001";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	
	
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
            <td><div class="local"><span>积分管理&gt; 在线订单-未支付</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>企业名称：</span><input type="text" class="inputbox" style="width: 80px;" name="qymc" id="qymc" value="<%=qymc%>" />
						<span>订单号：</span><input type="text" class="inputbox"  style="width: 80px;" name="zzbh" id="zzbh" value="<%=zzbh%>" />
						<span>订单生成日期：</span><input type="text" class="inputbox"  style="width: 80px;" name="sddrj" id="sddrj" value="<%=sddrj%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text" class="inputbox"  style="width: 80px;" name="eddrj" id="eddrj" value="<%=eddrj%>"  onclick="new Calendar().show(this);" readonly="readonly" />	
						<span>客户经理：</span><input type="text" class="inputbox"  style="width: 50px;" name="khjl" id="khjl" value="<%=khjl%>" />						
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(z.nid) as hn from tbl_jfzz z left join tbl_qy q on z.qy=q.nid  where z.zzzt=0";
           		if (qymc!=null && qymc.length()>0)
           			strsql+=" and q.qymc like '%"+qymc+"%'";
           		if (zzbh!=null && zzbh.length()>0)
           			strsql+=" and z.zzbh like '%"+zzbh+"%'";
           		if (khjl!=null && khjl.length()>0)
           			strsql+=" and q.khjl like '%"+khjl+"%'";
           		if (sddrj!=null && sddrj.length()>0)
           			strsql+=" and zzsj>='"+sddrj+"'";
          		if (eddrj!=null && eddrj.length()>0)
              		strsql+=" and zzsj<'"+neddrj+"'";
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
                   <th width="15%">订单生成日期</th>          
                   <th width="15%">企业名称</th>
                   <th width="10%">订单号</th>
                   <th width="10%">支付金额</th>
                   <th width="10%">购买积分</th>
                   <th width="10%">操作人</th>
                   <th width="25%">备注</th>
                   <th width="5%">客户经理</th>
                 </tr>
                  <%
                  strsql="select z.nid, z.zzsj,q.qymc,z.zzbh,z.zzje,z.zzjf,z.zzbz,y.ygxm,q.khjl from tbl_jfzz z left join tbl_qy q on z.qy=q.nid left join tbl_qyyg y on z.zzr=y.nid  where z.zzzt=0";
             		if (qymc!=null && qymc.length()>0)
             			strsql+=" and q.qymc like '%"+qymc+"%'";
             		if (zzbh!=null && zzbh.length()>0)
             			strsql+=" and z.zzbh like '%"+zzbh+"%'";
             		if (khjl!=null && khjl.length()>0)
               			strsql+=" and q.khjl like '%"+khjl+"%'";
               		if (sddrj!=null && sddrj.length()>0)
               			strsql+=" and zzsj>='"+sddrj+"'";
              		if (eddrj!=null && eddrj.length()>0)
                  		strsql+=" and zzsj<'"+neddrj+"'";
                  strsql+=" order by z.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>
                  	<td><%=sf.format(rs.getTimestamp("zzsj"))%></td>             	
                    <td class="textbreak"><%=rs.getString("qymc")%></td>
                    <td><%=rs.getString("zzbh")==null?"":rs.getString("zzbh")%></td>
                    <td><%=rs.getString("zzje")==null?"":rs.getString("zzje")%></td>
                    <td><%=rs.getString("zzjf")==null?"":rs.getString("zzjf")%></td>
                    <td><%=rs.getString("ygxm")==null?"":rs.getString("ygxm")%></td>
                    <td><%=rs.getString("zzbz")==null?"":rs.getString("zzbz")%></td>
                    <td><%=rs.getString("khjl")==null?"":rs.getString("khjl")%></td>
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