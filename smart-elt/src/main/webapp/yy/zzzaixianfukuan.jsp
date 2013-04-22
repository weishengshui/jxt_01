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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("2003")==-1)
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
String sfkrj=request.getParameter("sfkrj");
if (sfkrj==null) sfkrj="";
String efkrj=request.getParameter("efkrj");
if (efkrj==null) efkrj="";

SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd");
String neddrj="",nefkrj="";
if (eddrj!=null && eddrj.length()>0)
	neddrj=sf2.format(new Date(sf2.parse(eddrj).getTime()+24*60*60*1000));
if (efkrj!=null && efkrj.length()>0)
	nefkrj=sf2.format(new Date(sf2.parse(efkrj).getTime()+24*60*60*1000));

String naction=request.getParameter("naction");
String zzid=request.getParameter("zzid");
if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(zzid) || !fun.sqlStrCheck(zzbh)|| !fun.sqlStrCheck(khjl)|| !fun.sqlStrCheck(sddrj)|| !fun.sqlStrCheck(eddrj)|| !fun.sqlStrCheck(sfkrj)|| !fun.sqlStrCheck(efkrj))
{	
	response.sendRedirect("zzzaixianfukuan.jsp");
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
<script type="text/javascript" src="../gl/js/calendar3.js"></script>
<script type="text/javascript">


function searchit(p)
{
	location.href="zzzaixianfukuan.jsp?qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&zzbh="+encodeURI(escape(document.getElementById("zzbh").value))+"&khjl="+encodeURI(escape(document.getElementById("khjl").value))+"&sddrj="+document.getElementById("sddrj").value+"&eddrj="+document.getElementById("eddrj").value+"&sfkrj="+document.getElementById("sfkrj").value+"&efkrj="+document.getElementById("efkrj").value+"&pno="+p;
}
function ddzz(zid)
{
	if (confirm("确认充值积分？"))
	{
		location.href="zzzaixianfukuan.jsp?naction=audit&zzid="+zid+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&zzbh="+encodeURI(escape(document.getElementById("zzbh").value))+"&khjl="+encodeURI(escape(document.getElementById("khjl").value))+"&sddrj="+document.getElementById("sddrj").value+"&eddrj="+document.getElementById("eddrj").value+"&sfkrj="+document.getElementById("sfkrj").value+"&efkrj="+document.getElementById("efkrj").value+"&pno=<%=pno%>";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="2003";
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

try{
	//在线充值未发放的发放积分
	if (naction!=null && naction.equals("audit"))
	{
		
		//积分账户加上积分，修改充值单 数据
		int nzzzt=0,qyid=0;
		Double nzzje=0.0;
		strsql="select qy,zzje,zzzt from tbl_jfzz where nid="+zzid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			qyid=rs.getInt("qy");
			nzzzt=rs.getInt("zzzt");
			nzzje=rs.getDouble("zzje");
		}
		rs.close();
		
		if (nzzzt==1)
		{
			strsql="update tbl_jfzz set zzzt=3,dzjf=zzje*10,fksj=now(),far="+session.getAttribute("xtyh")+",fasj=now() where nid="+zzid;
			stmt.executeUpdate(strsql);
			
			strsql="update tbl_qy set jf=jf+"+String.valueOf(nzzje*10)+" where nid="+qyid;
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
            <td><div class="local"><span>积分管理&gt; 在线订单-已支付</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun" style="padding: 10px;">
						企业名称：<input type="text" style="width: 80px;" name="qymc" id="qymc" value="<%=qymc%>" />
						订单号：<input type="text"  style="width: 80px;" name="zzbh" id="zzbh" value="<%=zzbh%>" />
						客户经理：<input type="text"  style="width: 50px;" name="khjl" id="khjl" value="<%=khjl%>" />
						<br/><br/>
						订单生成日期：<input type="text" style="width: 80px;" name="sddrj" id="sddrj" value="<%=sddrj%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text"  style="width: 80px;" name="eddrj" id="eddrj" value="<%=eddrj%>"  onclick="new Calendar().show(this);" readonly="readonly" />	
						付款日期：<input type="text"  style="width: 80px;" name="sfkrj" id="sfkrj" value="<%=sfkrj%>"  onclick="new Calendar().show(this);" readonly="readonly" />--<input type="text"  style="width: 80px;" name="efkrj" id="efkrj" value="<%=efkrj%>"  onclick="new Calendar().show(this);" readonly="readonly" />										
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
						
					</div>
					<div class="caxun-r"></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(z.nid) as hn from tbl_jfzz z left join tbl_qy q on z.qy=q.nid  where z.zzfs=2";
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
          		if (sfkrj!=null && sfkrj.length()>0)
           			strsql+=" and fksj>='"+sfkrj+"'";
          		if (efkrj!=null && efkrj.length()>0)
              		strsql+=" and fksj<'"+nefkrj+"'";
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
                   <th width="12%">订单生成日期</th>
                   <th width="12%">付款日期</th>       
                   <th width="12%">企业名称</th>
                   <th width="8%">订单号</th>
                   <th width="8%">支付金额</th>
                   <th width="8%">购买积分</th>
                   <th width="8%">操作人</th>
                   <th width="10%">备注</th>
                   <th width="8%">客户经理</th>
                   <th width="8%">状态</th>
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select z.nid, z.zzsj,z.fksj,q.qymc,z.zzbh,z.zzje,z.zzjf,z.zzbz,z.zzzt,y.ygxm,q.khjl from tbl_jfzz z left join tbl_qy q on z.qy=q.nid left join tbl_qyyg y on z.zzr=y.nid  where z.zzfs=2";
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
              		if (sfkrj!=null && sfkrj.length()>0)
               			strsql+=" and fksj>='"+sfkrj+"'";
              		if (efkrj!=null && efkrj.length()>0)
                  		strsql+=" and fksj<'"+nefkrj+"'";
                  strsql+=" order by z.zzzt ,z.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>
                  	<td><%=sf.format(rs.getTimestamp("zzsj"))%></td>
                  	<td><%=sf.format(rs.getTimestamp("fksj"))%></td>             	
                    <td class="textbreak"><%=rs.getString("qymc")==null?"":rs.getString("qymc")%></td>
                    <td><%=rs.getString("zzbh")==null?"":rs.getString("zzbh")%></td>
                    <td><%=rs.getString("zzje")==null?"":rs.getString("zzje")%></td>
                    <td><%=rs.getString("zzjf")==null?"":rs.getString("zzjf")%></td>
                    <td><%=rs.getString("ygxm")==null?"":rs.getString("ygxm")%></td>
                    <td><%=rs.getString("zzbz")==null?"":rs.getString("zzbz")%></td>
                    <td><%=rs.getString("khjl")==null?"":rs.getString("khjl")%></td>
                    <td><%if (rs.getInt("zzzt")==1) out.print("未充值");
                    if (rs.getInt("zzzt")==3) out.print("已充值");
                   %></td>
                    <td><%if (rs.getInt("zzzt")==1) {%><a href="javascript:void(0);" onclick="ddzz(<%=rs.getString("nid")%>)" class="blue">充值</a><%}%></td>
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