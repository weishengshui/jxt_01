<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); %>

<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
String t=request.getParameter("t");
String param=request.getParameter("param");
String query=request.getParameter("query");
String pno=request.getParameter("page");
if (pno==null || pno.equals(""))
	pno="1";
int ln=0;
int pages=1;
int psize=2;

if (!fun.sqlStrCheck(param))
	return;

try
{
	StringBuffer returns=new StringBuffer();
	returns.append("{\"rows\":[");
	
	//保存浏览记录
	if (t!=null && t.equals("slljl"))
	{		
		String llid="";
		if (param!=null && param.length()>0)
		{
			strsql="select sp from tbl_spl where nid="+param;
			
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				query=rs.getString("sp");
			}
			rs.close();			
		}
		else
		{
			strsql="select spl from tbl_sp where nid="+query;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				param=rs.getString("spl");
			}
			rs.close();			
		}
		
		strsql="select nid from tbl_lljl where yg="+session.getAttribute("ygid")+" and sp="+query;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			llid=rs.getString("nid");
		}
		rs.close();
		if(!llid.equals(""))
			strsql="update tbl_lljl set llsj=now() where nid="+llid;
		else
			strsql="insert into tbl_lljl (qy,yg,spl,sp,llsj) values("+session.getAttribute("qy")+","+session.getAttribute("ygid")+","+param+","+query+",now())";
		
		stmt.executeUpdate(strsql);
		
		
	}
	//同类商品销售量排序
	if (t!=null && t.equals("tlxsl"))
	{
		strsql="SELECT t.nid,t.sp,s.qbjf,s.spmc,s.lj,s.je,s.jf,t.mc FROM tbl_spl t" +
		" LEFT JOIN (SELECT m.nid,m.qbjf,m.yf,m.kcsl,m.wcdsl,m.xsl,m.scj,m.spmc,n.jf,n.je,p.lj FROM tbl_sp m" +
		" LEFT JOIN tbl_sptp p ON m.zstp = p.nid" +
		" LEFT JOIN tbl_dhfs n ON m.zsdhfs = n.nid ) s ON t.sp = s.nid" +
		" WHERE t.sp IS NOT NULL AND t.zt = 1  AND t.lb3 = "+param +" order by t.ydsl desc limit 5";
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"sp\":\""+rs.getString("sp")+"\",");
			returns.append("\"qbjf\":\""+rs.getString("qbjf")+"\",");
			returns.append("\"spmc\":\""+rs.getString("spmc")+"\",");
			returns.append("\"mc\":\""+rs.getString("mc")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");
			
			if (rs.getString("je")!=null)
				returns.append("\"je\":\""+rs.getString("je")+"\",");
			else
				returns.append("\"je\":\"\",");	
			returns.append("\"jf\":\""+rs.getString("jf")+"\"},");
		}
		rs.close();
	}
	
	////同价位商品
	if (t!=null && t.equals("tltjw"))
	{
		strsql="SELECT t.nid,t.sp,s.qbjf,s.spmc,s.lj,s.je,s.jf,t.mc FROM tbl_spl t" +
		" LEFT JOIN (SELECT m.nid,m.qbjf,m.yf,m.kcsl,m.wcdsl,m.xsl,m.scj,m.spmc,n.jf,n.je,p.lj FROM tbl_sp m" +
		" LEFT JOIN tbl_sptp p ON m.zstp = p.nid" +
		" LEFT JOIN tbl_dhfs n ON m.zsdhfs = n.nid ) s ON t.sp = s.nid" +
		" WHERE t.sp IS NOT NULL AND t.zt = 1  AND t.lb3 = "+param +" and (s.qbjf - "+query+" <=100" +
		" or  "+query+"- s.qbjf <= 100) order by s.qbjf limit 5";
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"sp\":\""+rs.getString("sp")+"\",");
			returns.append("\"qbjf\":\""+rs.getString("qbjf")+"\",");
			returns.append("\"spmc\":\""+rs.getString("spmc")+"\",");
			returns.append("\"mc\":\""+rs.getString("mc")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");
			if (rs.getString("je")!=null)
				returns.append("\"je\":\""+rs.getString("je")+"\",");
			else
				returns.append("\"je\":\"\",");	
			returns.append("\"jf\":\""+rs.getString("jf")+"\"},");
		}
		rs.close();
	}
	
	
	////商品系列信息
	if (t!=null && t.equals("splinfo"))
	{
		strsql="SELECT t.nid,t.sp,t.mc,t.lb1,t.lb2,t.lb3,l3.mc AS lb3mc,l2.mc AS lb2mc,l1.mc AS lb1mc,t.ydsl,t.cpjs,t.shfw,t.rq" +
		" FROM tbl_spl t" +
		" LEFT JOIN tbl_splm l3 ON t.lb3 = l3.nid " +
		" LEFT JOIN tbl_splm l2 ON t.lb2 = l2.nid " +
		" LEFT JOIN tbl_splm l1 ON t.lb1 = l1.nid " +
		" WHERE t.sp IS NOT NULL AND t.zt = 1  AND t.nid = " +param;
		
		rs=stmt.executeQuery(strsql);
		
		if(rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"sp\":\""+rs.getString("sp")+"\",");			
			returns.append("\"mc\":\""+rs.getString("mc")+"\",");
			returns.append("\"lb1\":\""+rs.getString("lb1")+"\",");
			returns.append("\"lb2\":\""+rs.getString("lb2")+"\",");
			returns.append("\"lb3\":\""+rs.getString("lb3")+"\",");
			returns.append("\"lb3mc\":\""+rs.getString("lb3mc")+"\",");
			returns.append("\"lb2mc\":\""+rs.getString("lb2mc")+"\",");
			returns.append("\"lb1mc\":\""+rs.getString("lb1mc")+"\",");			
			returns.append("\"ydsl\":\""+rs.getString("ydsl")+"\",");
			returns.append("\"cpjs\":\""+URLEncoder.encode(rs.getString("cpjs"),"utf-8")+"\",");
			returns.append("\"shfw\":\""+URLEncoder.encode(rs.getString("shfw"),"utf-8")+"\",");			
			returns.append("\"rq\":\""+rs.getString("rq")+"\"},");
			
		}
		rs.close();
	}
	
	////商品信息
	if (t!=null && t.equals("spinfo"))
	{
		strsql="SELECT t.nid,t.qbjf,t.cxjf,t.yf,t.kcsl,t.wcdsl,t.xsl,t.scj,t.rq,t.spmc,t.zstp,n.jf,n.je ,p.lj,t.zt,t.spbh,t.spnr" +
		" FROM tbl_sp t" +
		" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
		" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
		" WHERE t.zt = 1  AND t.nid = " +param;		
		rs=stmt.executeQuery(strsql);
		
		if (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"qbjf\":\""+rs.getString("qbjf")+"\",");			
			returns.append("\"cxjf\":\""+rs.getString("cxjf")+"\",");
			returns.append("\"yf\":\""+rs.getString("yf")+"\",");
			returns.append("\"kcsl\":\""+rs.getString("kcsl")+"\",");
			returns.append("\"wcdsl\":\""+rs.getString("wcdsl")+"\",");
			returns.append("\"xsl\":\""+rs.getString("xsl")+"\",");
			returns.append("\"scj\":\""+rs.getString("scj")+"\",");
			returns.append("\"rq\":\""+rs.getString("rq")+"\",");			
			returns.append("\"spmc\":\""+rs.getString("spmc")+"\",");
			returns.append("\"zstp\":\""+rs.getString("zstp")+"\",");
			returns.append("\"jf\":\""+rs.getString("jf")+"\",");
			returns.append("\"je\":\""+rs.getString("je")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");
			returns.append("\"zt\":\""+rs.getString("zt")+"\",");
			returns.append("\"spnr\":\""+URLEncoder.encode(rs.getString("spnr"),"utf-8")+"\",");
			returns.append("\"spbh\":\""+rs.getString("spbh")+"\"},");
		}
		rs.close();
	}
	
	////兑换方式
	if (t!=null && t.equals("dhfs"))
	{
		strsql="SELECT t.nid,t.jf,t.je,t.sp FROM tbl_dhfs t" +
		" WHERE t.sp="+param;
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"jf\":\""+rs.getString("jf")+"\",");
			returns.append("\"je\":\""+rs.getString("je")+"\",");			
			returns.append("\"sp\":\""+rs.getString("sp")+"\"},");
		}
		rs.close();
	}
	
	//评价分页
	if (t!=null && t.equals("pj"))
	{
		strsql ="SELECT COUNT(t.nid) AS count FROM tbl_pj t where 1=1 "+param;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{ln=rs.getInt("hn");}
		rs.close();
		pages=(ln-1)/psize+1;
		
		strsql ="SELECT t.nid,t.spl,t.yg,t.zpf,t.pjxj,t.pjnr,t.pj,u.ygxm,u.nc," +
		" DATE_FORMAT(t.rq,'%Y.%m.%d %H:%i') pjrq FROM tbl_pj t " +
		" LEFT JOIN tbl_qyyg u ON u.nid = t.yg WHERE 1=1 "+param +" ORDER BY t.rq DESC limit  " + (Integer.valueOf(pno)-1)*psize+","+psize;
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"spl\":\""+rs.getString("spl")+"\",");
			returns.append("\"yg\":\""+rs.getString("yg")+"\",");
			returns.append("\"zpf\":\""+rs.getString("zpf")+"\",");
			returns.append("\"pjxj\":\""+rs.getString("pjxj")+"\",");
			returns.append("\"pjnr\":\""+rs.getString("pjnr")+"\",");
			returns.append("\"pj\":\""+rs.getString("pj")+"\",");
			returns.append("\"ygxm\":\""+rs.getString("ygxm")+"\",");
			returns.append("\"nc\":\""+rs.getString("nc")+"\",");
			returns.append("\"pjrq\":\""+rs.getString("pjrq")+"\"},");
		}
		rs.close();
	}
	
	//商品系列下的商品信息
	if (t!=null && t.equals("spbyspl"))
	{
		strsql="SELECT t.nid,t.qbjf,t.cxjf,t.yf,t.kcsl,t.wcdsl,t.xsl,t.scj,t.rq,t.spmc,t.zstp,n.jf,n.je ,p.lj,t.zt,t.spbh" +
		" FROM tbl_sp t" +
		" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
		" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
		" WHERE t.zt = 1  AND t.spl = " + param;
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"qbjf\":\""+rs.getString("qbjf")+"\",");			
			returns.append("\"cxjf\":\""+rs.getString("cxjf")+"\",");
			returns.append("\"yf\":\""+rs.getString("yf")+"\",");
			returns.append("\"kcsl\":\""+rs.getString("kcsl")+"\",");
			returns.append("\"wcdsl\":\""+rs.getString("wcdsl")+"\",");
			returns.append("\"xsl\":\""+rs.getString("xsl")+"\",");
			returns.append("\"scj\":\""+rs.getString("scj")+"\",");
			returns.append("\"rq\":\""+rs.getString("rq")+"\",");			
			returns.append("\"spmc\":\""+rs.getString("spmc")+"\",");
			returns.append("\"zstp\":\""+rs.getString("zstp")+"\",");
			returns.append("\"jf\":\""+rs.getString("jf")+"\",");
			returns.append("\"je\":\""+rs.getString("je")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");
			returns.append("\"zt\":\""+rs.getString("zt")+"\",");
			returns.append("\"spbh\":\""+rs.getString("spbh")+"\"},");
		}
		rs.close();
	}
	
	//商品图片
	if (t!=null && t.equals("sptp"))
	{
		strsql="SELECT t.sp,t.lj,t.tpmc,p.zstp FROM tbl_sptp t " +
		" LEFT JOIN tbl_sp p ON t.nid = p.zstp WHERE  t.sp =  "+param;
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"sp\":\""+rs.getString("sp")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");			
			returns.append("\"tpmc\":\""+rs.getString("tpmc")+"\",");
			if (rs.getString("zstp")!=null)
				returns.append("\"zstp\":\""+rs.getString("zstp")+"\"},");
			else
				returns.append("\"zstp\":\"\"},");
		}
		rs.close();
	}
	
	//评价统计
	if (t!=null && t.equals("pjsum"))
	{
		StringBuffer returns2=new StringBuffer();
		returns2.append("{\"xj\":[");
		
		strsql=" SELECT COUNT(t.nid) AS countxj,t.pjxj  FROM tbl_pj t where 1=1 AND t.spl = " +
		param+" GROUP BY t.pjxj ORDER BY t.pjxj DESC";
		rs=stmt.executeQuery(strsql);
		while (rs.next())
		{
			returns2.append("{\"countxj\":\""+rs.getString("countxj")+"\",");
			if (rs.isLast())
				returns2.append("\"pjxj\":\""+rs.getString("pjxj")+"\"}]");
			else
				returns2.append("\"pjxj\":\""+rs.getString("pjxj")+"\"},");
		}
		rs.close();
		

		returns2.append(",\"lx\":[");		
		strsql = " SELECT COUNT(t.nid) AS countxj,t.pj  FROM tbl_pj t where 1=1  AND t.spl =" +
		param+" GROUP BY t.pj ORDER BY t.pjxj DESC";
		rs=stmt.executeQuery(strsql);
		while (rs.next())
		{
			returns2.append("{\"countxj\":\""+rs.getString("countxj")+"\",");
			if (rs.isLast())
				returns2.append("\"pj\":\""+rs.getString("pj")+"\"}]");
			else
				returns2.append("\"pj\":\""+rs.getString("pj")+"\"},");
		}
		rs.close();
		
		strsql = " SELECT COUNT(t.nid) AS totalcount,SUM(t.zpf)" +
		" AS sumxj FROM tbl_pj t where 1=1 AND t.spl =" +param;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			returns2.append(",\"total\":[");
			returns2.append("{\"totalcount\":\""+rs.getString("totalcount")+"\",");
			returns2.append("{\"sumxj\":\""+rs.getString("sumxj")+"\"}]");
		}
		rs.close();
		returns2.append("}");
		out.print(returns2.toString());
		return;
	}
	
	
	//同事兑换
	if (t!=null && t.equals("tsmsp"))
	{
		strsql= "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM  tbl_qyyg t" +
		" LEFT JOIN tbl_ygddmx m ON t.nid = m.yg" +
		" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc  FROM tbl_spl k" +
		" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
		" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
		" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s  ON m.spl = s.nid " +
		" WHERE t.qy = "+session.getAttribute("qy")+" AND m.state!=9 AND t.nid != "+session.getAttribute("ygid")+" ORDER BY s.nid DESC limit 7 ";
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"sp\":\""+rs.getString("sp")+"\",");
			returns.append("\"qbjf\":\""+rs.getString("qbjf")+"\",");
			returns.append("\"mc\":\""+rs.getString("mc")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");
			if (rs.getString("je")!=null)
				returns.append("\"je\":\""+rs.getString("je")+"\",");
			else
				returns.append("\"je\":\"\",");	
			returns.append("\"jf\":\""+rs.getString("jf")+"\"},");
		}
		rs.close();
	}
	
	//最近浏览
	if (t!=null && t.equals("profile"))
	{
		strsql= "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_lljl t" +
		" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc  FROM tbl_spl k" +
		" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
		"  LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
		"  LEFT JOIN tbl_sptp n ON m.zstp = n.nid" +
		" ) s ON t.spl = s.nid " +
		" WHERE t.yg ="+session.getAttribute("ygid")+" ORDER BY t.llsj DESC  limit 7 ";
		
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{			
			returns.append("{\"nid\":\""+rs.getString("nid")+"\",");
			returns.append("\"sp\":\""+rs.getString("sp")+"\",");
			returns.append("\"qbjf\":\""+rs.getString("qbjf")+"\",");
			returns.append("\"mc\":\""+rs.getString("mc")+"\",");
			returns.append("\"lj\":\""+rs.getString("lj")+"\",");
			if (rs.getString("je")!=null)
				returns.append("\"je\":\""+rs.getString("je")+"\",");
			else
				returns.append("\"je\":\"\",");	
			returns.append("\"jf\":\""+rs.getString("jf")+"\"},");
		}
		rs.close();
	}

	String outs="";
	if (t.equals("slljl"))
	{
		outs="{\"spl\":\""+param+"\",\"sp\":\""+query+"\"}";
	}
	else
	{
		if (returns.length()>10)
			outs=returns.substring(0,returns.length()-1);
		
		if (outs.length()>0)
		{
			outs=outs+"]}";	
		}
	}
	
	out.print(outs);
}
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
