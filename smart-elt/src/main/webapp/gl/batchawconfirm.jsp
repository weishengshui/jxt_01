<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="jxt.elt.common.ExcelReader"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Set"%>


<%request.setCharacterEncoding("UTF-8"); %>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
 <script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function goback(qid,xid)
{
	if (xid==0)
		document.getElementById("awform").action="assignwelfare.jsp?qid="+qid;	
	else
		document.getElementById("awform").action="leaderaw.jsp?xid="+xid+"&qid="+qid;
	document.getElementById("awform").submit();
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
Fun fun=new Fun();
File uploadPath = new File(getServletContext().getRealPath("gl/ygdr/"));//上传文件目录
if (!uploadPath.exists()) {
   uploadPath.mkdirs();
}
// 临时文件目录
File tempPathFile = new File(getServletContext().getRealPath("gl/ygdr/buffer/"));
if (!tempPathFile.exists()) {
   tempPathFile.mkdirs();
}
List<String[]> dlist = null;
String mm1 = "";
String mm2 = "";
String ffsj="";
String bz="";
String jfq="";

try {
   // Create a factory for disk-based file items
   DiskFileItemFactory factory = new DiskFileItemFactory();

   // Set factory constraints
   factory.setSizeThreshold(409600); // 设置缓冲区大小，这里是40kb
   factory.setRepository(tempPathFile);//设置缓冲区目录

   // Create a new file upload handler
   ServletFileUpload upload = new ServletFileUpload(factory);

   // Set overall request size constraint
   upload.setSizeMax(4194304); // 设置最大文件尺寸，这里是4MB

   List<FileItem> items = upload.parseRequest(request);//得到所有的文件
   Iterator<FileItem> i = items.iterator();
   
   while (i.hasNext()) {
       FileItem fi = (FileItem) i.next();
       String fileName="";
       if (!fi.isFormField())
       {
      
           Calendar nowtime=Calendar.getInstance();
              
           if (fi.getName() != null && !fi.getName().equals("") ) {
               fileName=fi.getName();	
          
               fileName=fileName.substring(fileName.lastIndexOf("."));
               
	           fi.write(new File(uploadPath, fileName));
	           fi.delete();
           }
           ExcelReader er=new ExcelReader(uploadPath+"/"+fileName);
           dlist=er.getAllDataFromfftemplate(0);
       } else {
           String filedName = fi.getFieldName();
           if ("mm1".equals(filedName)) {
               mm1 = fi.getString();
           } else if ("ffsj".equals(filedName)) {
               ffsj = fi.getString();
           } else if ("bz".equals(filedName)) {
               bz = fi.getString("UTF-8");
           } else if ("jfq".equals(filedName)) {
               jfq = fi.getString();
           } else if ("mm2".equals(filedName)) {
               mm2 = fi.getString();
           }
       }
   }
} catch (Exception e) {
    e.printStackTrace();
}

%>
<%
menun=5;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
if (mm2==null) mm2="";
String xid=request.getParameter("xid");
ArrayList fflx=new ArrayList();
ArrayList ojf=new ArrayList();
ArrayList ygid=new ArrayList();
ArrayList bmid=new ArrayList();
ArrayList xzid=new ArrayList();
String fflxs="",ojfs="",ygids="",bmids="",xzids="";
String sendfflx="",sendojfs="",sendvalue="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
int xxfflx=0,xxlxbh=0;
StringBuffer errorbuffer = new StringBuffer();
try
{
    strsql = "SELECT mc as jfqmcdb FROM tbl_jfq where nid = " + jfq;
    String jfqmcdb = null;
    rs = stmt.executeQuery(strsql);
    if (rs.next()) {
        jfqmcdb = rs.getString("jfqmcdb");
    }
    rs.close();
	String mmmc="";
	int index = 0;
    int size = 0;
    boolean isallcorrect = true;
    if (dlist == null || dlist.size() == 0) {
        errorbuffer.append("模板格式有误,请下载最新的发放福利券模板!");
        out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignwelfare.jsp?qid="+jfq+"';</script>");
        return;
    }
    Map<String, List<String>> dataList = new HashMap<String, List<String>>();
	for (String[] item : dlist) {
	    boolean iscorrect = true;
	    if (index == 0) {
		    if (null == item || item.length != 6) {
	            errorbuffer.append("模板格式有误,请下载最新的发放福利券模板!");
	            out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignwelfare.jsp?qid="+jfq+"';</script>");
	            return;
	        }
		    String jfqsmu = item[4];
            if (!jfqsmu.startsWith("福利券数量")) {
                errorbuffer.append("模板格式有误,请下载最新的福利券模板!");
                out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignwelfare.jsp?qid="+jfq+"';</script>");
                return;
            }
            index++;
            continue;
        }
        index++;
        String jfqmc = item[5];
        if (jfqmc == null || jfqmc.isEmpty() || !jfqmc.equals(jfqmcdb)) {
            errorbuffer.append("福利券名称与当前不匹配,请下载对应的福利券模板!");
            out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignwelfare.jsp?qid="+jfq+"';</script>");
            return;
        }
        index++;
	    String jfqsl = item[4];
	    String email = item[2];
	    String id ="";
	    int zt = 0;
	    if (null != email && !email.isEmpty() && null != jfqsl && !jfqsl.isEmpty() && fun.sqlStrCheck(email)) {
	        if (!fun.isNumeric(jfqsl)) {
	              //TODO: ERROR LOG 积分必须是数字
	                errorbuffer.append("帐号:");
		            errorbuffer.append(email);
		            errorbuffer.append(" 有误，");
		            errorbuffer.append("字段:福利券数量 非数字格式");
	                iscorrect = false;
	                isallcorrect = false;
	            } else if (Integer.valueOf(jfqsl) <= 0) {
	                errorbuffer.append("帐号:");
		            errorbuffer.append(email);
		            errorbuffer.append(" 有误，");
		            errorbuffer.append("字段:福利券数量 必须大于0");
	                iscorrect = false;
	                isallcorrect = false;
	            }
		    	
			    strsql = "select nid,zt from tbl_qyyg where email = '" + email +"' and qy = " + session.getAttribute("qy");
		        rs = stmt.executeQuery(strsql);
		        if (rs.next()) {
		            id = rs.getString("nid");
		            zt = rs.getInt("zt");
		            if (zt == 0) {
		                iscorrect = false;
		            }
		        } else {
		          //TODO: ERROR LOG 没有此员工
		            if (iscorrect) {
		                errorbuffer.append("帐号:");
		                errorbuffer.append(email);
		                errorbuffer.append(" 有误，");
		            	errorbuffer.append("字段:email 无此员工");
		            } else {
		                errorbuffer.append(",email");
		            }
		            iscorrect = false;
		            isallcorrect = false;
		        }
	    } else {
	      //TODO: ERROR LOG email 含有非法字符
            errorbuffer.append("帐号:");
	        errorbuffer.append(email);
	        errorbuffer.append(" 有误，");
	        errorbuffer.append("字段:email 含有非法字符");
            iscorrect = false;
            isallcorrect = false;
	    }
	    if (isallcorrect && iscorrect) {
			if (dataList.containsKey(jfqsl)) {
			    dataList.get(jfqsl).add(id);
			} else {
			    List<String> ids = new ArrayList<String>();
			    ids.add(id);
			    dataList.put(jfqsl, ids);
			}
            size ++;
        } 
        if (!iscorrect) {
            errorbuffer.append("\\n");
        }
	    
	}
	if (size == 0 && isallcorrect) {
        out.print("<script type=\"text/javascript\">alert('福利券数量都为空或者发放用户都已离职，发送福利券失败!'); location.href='assignwelfare.jsp?qid="+jfq+"';</script>");
    }
    if (!isallcorrect) {
        out.print("<script type=\"text/javascript\">alert('错误信息如下:\\n" + errorbuffer.toString() + "'); location.href='assignwelfare.jsp?qid="+jfq+"';</script>");
        return;
    }
    
    for (Entry<String, List<String>> entry : dataList.entrySet()) {
        String jfqsl = entry.getKey();
        List<String> idList = entry.getValue();
        String[] ids = new String[idList.size()];
        int i = 0;
        for (String id : idList) {
            ids[i] = id;
            i++;
        }
	    fflx.add("3");
	    ojf.add(jfqsl);
	    ygid.add(ids);
    }
	int staffn=0;
	int tjf=0;
	int haven=0;
	
	if (xid!=null && xid.length()>0)
	{
		strsql="select fflx,lxbh,jf-yffjf as haven from tbl_jfqffxx where nid="+xid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			xxfflx=rs.getInt("fflx");
			xxlxbh=rs.getInt("lxbh");
			haven=rs.getInt("haven");
		}
		rs.close();
	}
	else
	{
		strsql="select sum(sl-ffsl) as haven from tbl_jfqddmc  where qy="+session.getAttribute("qy")+" and zt=1 and sl<>ffsl and ddtype=0 and jfq="+jfq;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			haven=rs.getInt("haven");
		}
		rs.close();
	}
	
	if (xxfflx==1)
		strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1 and bm like '%,"+xxlxbh+",%'";
	
	if (xxfflx==2)
		strsql="select count(x.nid) as hn from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+xxlxbh+"  and y.xtzt<>3  and y.zt=1";
	if (xxfflx==0)
		strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1";
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
		{
			staffn=rs.getInt("hn");
		}
	rs.close();
	
	
	
	if (mm1!=null && mm1.length()>0)
	{
		strsql="select mmmc from tbl_jfmm where nid="+mm1;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{mmmc=rs.getString("mmmc");}
	}
	if (mm2!=null && mm2.length()>0)
	{
		strsql="select mmmc from tbl_jfmm where nid="+mm2;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{mmmc=mmmc+","+rs.getString("mmmc");}
	}
	
		%>
		
 
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local2">
					<li class="local2-ico3"><h1>选择福利券</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico1"><h1>选择发放对象</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico2"><h1 class="current-local">确认发放信息</h1></li>
					<li><h1>确认发放</h1></li>
				</ul>
				
				<%
				strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,h.hdmc,h.hdtp from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.nid="+jfq;
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
				%>
				<div class="confirm-t">您选择的福利券</div>
				<div class="confirm-states">
					<h1><img src="../hdimg/<%=rs.getString("hdtp")%>" width="121" height="88" /></h1>
					<dl>
						<dt><%=rs.getString("hdmc")%></dt>
						<dd><%=rs.getString("mc")%></dd>
					</dl>
					<span id="selnumbers"></span>
				</div>
				<%}
				rs.close();
				%>
				
				<div class="jf-ffmm"><span class="star">*</span>&nbsp;<strong>发放名目</strong>&nbsp;&nbsp;<%=mmmc%></div>
				<div class="jf-ffmm" style="border:0"><span class="star">*</span>&nbsp;<strong>发放信息</strong></div>
				<%
				for (int i=0;i<fflx.size();i++)
				{
					if (fflx.get(i)!=null)
						{
						fflxs=fflx.get(i).toString();
						ojfs=ojf.get(i).toString();
						
						if (fflxs!=null && fflxs.length()>0)
						{
							sendfflx=sendfflx+fflxs+";";
							sendojfs=sendojfs+ojfs+";";
							if (fflxs.equals("1"))
							{
								String[] bmarr= (String[]) bmid.get(i);
								bmids="";
								
								for (int j=0;j<bmarr.length;j++)
									{
										if (j<bmarr.length-1)
										bmids=bmids+bmarr[j]+",";
										else
										bmids=bmids+bmarr[j];
									}
								sendvalue=sendvalue+bmids+";";
								strsql="select bmmc from tbl_qybm where nid in ("+bmids+")";
								
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>发放授权:");
								rs=stmt.executeQuery(strsql);
								while(rs.next())
								{
									out.print(rs.getString("bmmc")+",");
								}
								rs.close();
								out.print("</li>");
								out.print("<li><span class=\"floatleft txtsize14\">发放福利:每部门"+ojfs+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*bmarr.length)+"</span> 张</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*bmarr.length;
							}
							
							if (fflxs.equals("2"))
							{
								
								int xzl=0;
								xzids=xzid.get(i).toString();
								xzids=xzids.substring(0,xzids.length()-1);
								
								sendvalue=sendvalue+xzids+";";
								strsql="select xzmc from tbl_qyxz where nid in ("+xzids+")";
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>发放授权:");								
								rs=stmt.executeQuery(strsql);
								while (rs.next())
								{
									out.print(rs.getString("xzmc")+",");
									xzl++;
								}
								rs.close();
								out.print("</li>");
								out.print("<li><span class=\"floatleft txtsize14\">发放福利:每小组"+ojfs+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*xzl)+"</span> 张</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*xzl;
							}
							
							if (fflxs.equals("3"))
							{
								
								
								String[] ygarr= (String[]) ygid.get(i);
								ygids="";
								
								for (int j=0;j<ygarr.length;j++)
									{
										if (j<ygarr.length-1)
										ygids=ygids+ygarr[j]+",";
										else
										ygids=ygids+ygarr[j];	
									}
								sendvalue=sendvalue+ygids+";";
								strsql="select ygxm from tbl_qyyg where nid in ("+ygids+")";
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>获奖对象:");	
								rs=stmt.executeQuery(strsql);
								while(rs.next())
								{
								out.print(rs.getString("ygxm")+",");
								}
								rs.close();
								out.print("</li>");
								out.print("<li><span class=\"floatleft txtsize14\">发放福利:每人"+ojfs+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*ygarr.length)+"</span> 张</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*ygarr.length;
							}
							if (fflxs.equals("4"))
							{
								sendvalue=sendvalue+staffn+";";
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>获奖对象:");	
								out.print("全体员工(共"+staffn+"人)");
								out.print("</li>");
								out.print("<li><span class=\"floatleft txtsize14\">发放福利:每人"+ojfs+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*staffn)+"</span> 张</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*staffn;
							}
						}
					}
				}
				%>
				<%if (xid==null || xid.length()==0)  {%>
				<form action="awsuccess.jsp" name="awform" id="awform" method="post">		
				<input type="hidden" name="mm1" id="mm1" value="<%=mm1%>"  /><input type="hidden" name="mm2" id="mm2" value="<%=mm2%>"  />
				<input type="hidden" name="ffsj" id="ffsj" value="<%=ffsj%>"/>
				<input type="hidden" name="bz" id="bz" value="<%=bz%>"/>
				<input type="hidden" name="sendfflx" id="sendfflx"  value="<%=sendfflx%>"/>
				<input type="hidden" name="sendojfs" id="sendojfs"  value="<%=sendojfs%>"/>
				<input type="hidden" name="sendvalue" id="sendvalue"  value="<%=sendvalue%>"/>
				<input type="hidden" name="jfq" id="jfq" value="<%=jfq%>"  />
				<input type="hidden" name="ctjf" id="ctjf"  value="<%=tjf%>"/>
				<input type="hidden" name="ffh" id="ffh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>		
				</form>
				<%} else { %>
				<form action="leaderaws.jsp" name="awform" id="awform" method="post">		
				<input type="hidden" name="mm1" id="mm1" value="<%=mm1%>"  /><input type="hidden" name="mm2" id="mm2" value="<%=mm2%>"  />
				<input type="hidden" name="ffsj" id="ffsj" value="<%=ffsj%>"/>
				<input type="hidden" name="bz" id="bz" value="<%=bz%>"/>
				<input type="hidden" name="sendfflx" id="sendfflx"  value="<%=sendfflx%>"/>
				<input type="hidden" name="sendojfs" id="sendojfs"  value="<%=sendojfs%>"/>
				<input type="hidden" name="sendvalue" id="sendvalue"  value="<%=sendvalue%>"/>
				<input type="hidden" name="jfq" id="jfq" value="<%=jfq%>"  />
				<input type="hidden" name="xid" id="xid"  value="<%=xid%>"/>
				<input type="hidden" name="ctjf" id="ctjf"  value="<%=tjf%>"/>
				<input type="hidden" name="ffh" id="ffh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>											
				</form>
				<%} %>
				<div class="jf-ffdata"><span class="star floatleft">*&nbsp;</span><h1>发放日期</h1><h2><%=ffsj%></h2><h3>
				<%if (sf.parse(ffsj).after(Calendar.getInstance().getTime())) out.print("时间未到，暂未发放");%>
				</h3></div>
				<div class="jf-mark"><h1>备注信息</h1><span><%=bz%></span></div>
				<div class="jf-sum">总计 <span class="yellowtxt"><%=tjf%></span> 张<span id="ajfalert" style="font-size:14px;">
				<%
				strsql = "select sum(m.sl-m.ffsl) as sysl from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate() and m.ddtype=0 and jfq=" + jfq;
		        rs=stmt.executeQuery(strsql);
		        int sysl = 0;
		        if (rs.next()) {
		            sysl = rs.getInt("sysl");
		        }
		        rs.close();
				
				boolean isEnough = sysl >= tjf;
				if (!isEnough) {
				    %>
				 ，您的福利券数量不足，请 <a class="blue" href="buywelfare.jsp">购买福利</a> 或者 修改发放信息</span>
				    <%
				}
				%></div>
				<script type="text/javascript">document.getElementById("selnumbers").innerHTML="您共拥有 <%=haven%> 张，已选择 <%=tjf%> 张";</script>
				<%if (xid==null || xid.length()==0)  {%>
				
				<div class="jf-confirm">
				<%
				if (isEnough) {
				%>
					<span class="floatleft"><a href="javascript:document.getElementById('awform').submit();" class="confirmbtn"></a></span>
				<% 
				}
				%>
				<span class="modify"><a href="assignwelfare.jsp?qid=<%=jfq%>">返回修改</a></span> <span class="modify"><a href="main.jsp">取消发放</a></span>
				<%} else { %>
					<%
				if (isEnough) {
				%>
				<span class="floatleft"><a href="javascript:document.getElementById('awform').submit();" class="confirmbtn"></a></span>
				<% 
				}
					
				%>
				<span class="modify"><a href="assignwelfare.jsp?qid=<%=jfq%>">返回修改</a></span> <span class="modify"><a href="leaderw.jsp">取消发放</a></span>
				<%} %>
				</div>
			</div>	
	  	</div>
	</div>
	
	<%@ include file="footer.jsp" %>
	<%
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
</body>
</html>