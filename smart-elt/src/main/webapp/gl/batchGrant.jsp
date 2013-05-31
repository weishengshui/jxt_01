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
function goback(t)
{
	if (t==0)
		document.getElementById("aiform").action="assignintegral.jsp";	
	else
		document.getElementById("aiform").action="leaderai.jsp?xid="+t;
	document.getElementById("aiform").submit();
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
String ffsj="";
String bz="";
String mm2 = "";

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
menun=3;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
if (mm2==null) mm2="";
ArrayList fflx=new ArrayList();
ArrayList ojf=new ArrayList();
ArrayList ygid=new ArrayList();
String fflxs="",ojfs="",ygids="",bmids="",xzids="";
String sendfflx="",sendojfs="",sendvalue="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
int xxfflx=0,xxlxbh=0;
StringBuffer errorbuffer = new StringBuffer();
try
{
    int index = 0;
    int size = 0;
    boolean isallcorrect = true;
    if (dlist == null || dlist.size() == 0) {
        errorbuffer.append("模板格式有误,请下载最新的发放积分模板!");
        out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignintegral.jsp';</script>");
        return;
    }
    Map<String, List<String>> dataList = new HashMap<String, List<String>>();
    for (String[] items : dlist) {
    	boolean iscorrect = true;
    	
        if (index == 0) {
	    	if (null == items || items.length != 5) {
	            errorbuffer.append("模板格式有误,请下载最新的发放积分模板!");
	            out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignintegral.jsp';</script>");
	            return;
	        }
            String jfsmu = items[4];
            if (!jfsmu.startsWith("积分数")) {
                errorbuffer.append("模板格式有误,请下载最新的发放积分模板!");
                out.print("<script type=\"text/javascript\">alert('" + errorbuffer.toString() + "'); location.href='assignintegral.jsp';</script>");
                return;
            }
            index++;
            continue;
        }
        index++;
        
        String email = items[2];
        String jfs = items[4];
        String nid = "";
        int zt = 0;
        if (null != email && !email.isEmpty() && null != jfs && !jfs.isEmpty() && fun.sqlStrCheck(email)) {
            if (!fun.isNumeric(jfs)) {
              //TODO: ERROR LOG 积分必须是数字
                errorbuffer.append("帐号:");
	            errorbuffer.append(email);
	            errorbuffer.append(" 有误，");
	            errorbuffer.append("字段:积分数 非数字格式");
                iscorrect = false;
                isallcorrect = false;
            } else if (Integer.valueOf(jfs) <= 0) {
                errorbuffer.append("帐号:");
	            errorbuffer.append(email);
	            errorbuffer.append(" 有误，");
	            errorbuffer.append("字段:积分数 必须大于0");
                iscorrect = false;
                isallcorrect = false;
            }
	        strsql = "select nid,zt from tbl_qyyg where email = '" + email +"' and qy = " + session.getAttribute("qy");
	        rs=stmt.executeQuery(strsql);
	        if (rs.next()) {
	            nid = rs.getString("nid");
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
            if (dataList.containsKey(jfs)) {
			    dataList.get(jfs).add(nid);
			} else {
			    List<String> ids = new ArrayList<String>();
			    ids.add(nid);
			    dataList.put(jfs, ids);
			}
            size ++;
        } 
        if (!iscorrect) {
            errorbuffer.append("\\n");
        }
    }
    if (size == 0 && isallcorrect) {
        out.print("<script type=\"text/javascript\">alert('积分数都为空或者发放用户都已离职，发放积分失败!'); location.href='assignintegral.jsp';</script>");
    }
    if (!isallcorrect) {
        out.print("<script type=\"text/javascript\">alert('错误信息如下:\\n" + errorbuffer.toString() + "'); location.href='assignintegral.jsp';</script>");
        return;
    }
    for (Entry<String, List<String>> entry : dataList.entrySet()) {
        String jfs = entry.getKey();
        List<String> idList = entry.getValue();
        String[] ids = new String[idList.size()];
        int i = 0;
        for (String id : idList) {
            ids[i] = id;
            i++;
        }
	    fflx.add("3");
	    ojf.add(jfs);
	    ygid.add(ids);
    }
	String mmmc="";
	
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
		
		int tjf=0;
		
		%>
		
 
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico1">
						<div class="local-1"><h1>填写发放积分信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico2">
						<div class="local-2"><h1>确认发放信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local-3"><h1>确认发放</h1></div>
					</li>
				</ul>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<div class="jf-ffmm"><span class="star">*</span>&nbsp;<strong>发放名目</strong>&nbsp;&nbsp;<%=mmmc%></div>
				<div class="jf-ffmm" style="border:0"><span class="star">*</span>&nbsp;<strong>发放信息</strong></div>
				<%
				int fn=0;
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
							
							if (fflxs.equals("3"))
							{
								
								fn=0;
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
								out.print("<li>发放对象:");	
								rs=stmt.executeQuery(strsql);
								while(rs.next())
								{
								out.print(rs.getString("ygxm")+",");
								fn++;
								}
								rs.close();
								out.print("</li>");
								if (fn>1)
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:每人"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*ygarr.length)+"</span> 积分</div></li></ul>");
								else
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*ygarr.length)+"</span> 积分</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*ygarr.length;
							}
						}
					}
				}
				%>
				<form action="aisuccess.jsp" name="aiform" id="aiform" method="post">		
				<input type="hidden" name="mm1" id="mm1" value="<%=mm1%>"  />
				<input type="hidden" name="mm2" id="mm2" value="<%=mm2%>"  />
				<input type="hidden" name="ffsj" id="ffsj" value="<%=ffsj%>"/>
				<input type="hidden" name="bz" id="bz" value="<%=bz%>"/>
				<input type="hidden" name="sendfflx" id="sendfflx"  value="<%=sendfflx%>"/>
				<input type="hidden" name="sendojfs" id="sendojfs"  value="<%=sendojfs%>"/>
				<input type="hidden" name="sendvalue" id="sendvalue"  value="<%=sendvalue%>"/>
				<input type="hidden" name="ctjf" id="ctjf"  value="<%=tjf%>"/>
				<input type="hidden" name="ffh" id="ffh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>								
				</form>
				<div class="jf-ffdata"><span class="star floatleft">*&nbsp;</span><h1>发放日期</h1><h2><%=ffsj%></h2><h3>
				<%if (sf.parse(ffsj).after(Calendar.getInstance().getTime())) out.print("时间未到，暂未发放");%>
				</h3></div>
				<div class="jf-mark"><h1>备注信息</h1><span><%=bz%></span></div>
				<div class="jf-sum">总计 <span class="yellowtxt"><%=tjf%></span> 积分<span id="ajfalert" style="font-size:14px;">
				<%
				int jf =  Integer.valueOf((String) session.getAttribute("qyjf"));
				boolean isEnough = jf >= tjf;
				if (!isEnough) {
				    %>
				 ，您的积分余额不足，请 <a class="blue" href="buyintegral.jsp">购买积分</a> 或者 修改发放信息</span>
				    <%
				}
				%>
				</div>
				<div class="jf-confirm">
				<%
				if (isEnough) {
				%>
				<span class="floatleft"><a href="javascript:document.getElementById('aiform').submit();" class="confirmbtn"></a></span>
				<% 
				}
				%>
				<span class="modify"><a href="assignintegral.jsp" >返回修改</a></span> <span class="modify"><a href="main.jsp">取消发放</a></span>
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
