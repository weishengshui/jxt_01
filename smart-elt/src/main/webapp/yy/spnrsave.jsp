<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.aviyehuda.easyimage.Image"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="net.coobird.thumbnailator.Thumbnails"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4002")==-1)
{
	out.print("你没有操作权限！");
	return;
}

	String strsql="", spmc="",spl="",qbjf="",cxjf="0",scj="",zstp1="",zstp2="",zstp3="",zstp4="",zstp5="",dhjf1="",dhje1="",dhjf2="",dhje2="",dhjf3="",dhje3="",spbh="",lmc="";
	String zstp1id="",zstp2id="",zstp3id="",zstp4id="",zstp5id="",dhid1="",dhid2="",dhid3="",xlmr="0",kcyj="",spnr="";
	String spid=request.getParameter("spid");
    Connection conn=DbPool.getInstance().getConnection();
    conn.setAutoCommit(false);
    int conncommit=1;
	Statement stmt=conn.createStatement();
	ResultSet rs=null;
	Fun fun=new Fun();
	int phn=0;   //系列中商品数量
	
    File uploadPath = new File(getServletContext().getRealPath("spimg/"));//上传文件目录
    if (!uploadPath.exists()) {
       uploadPath.mkdirs();
    }
    // 临时文件目录
    File tempPathFile = new File(getServletContext().getRealPath("spimg/buffer/"));
    if (!tempPathFile.exists()) {
       tempPathFile.mkdirs();
    }
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
           
           if (fi.isFormField())
           {        	   
        	if (fi.getFieldName().equals("spid")) spid=fi.getString("UTF-8");
        	if (fi.getFieldName().equals("spmc")) spmc=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("spl")) spl=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("qbjf")) qbjf=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("cxjf")) cxjf=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("scj")) scj=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("spbh")) spbh=fi.getString("UTF-8");
           	
           	if (fi.getFieldName().equals("dhjf1")) dhjf1=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhje1")) dhje1=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhjf2")) dhjf2=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhje2")) dhje2=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhjf3")) dhjf3=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhje3")) dhje3=fi.getString("UTF-8");
           	
           	if (fi.getFieldName().equals("zstp1id")) zstp1id=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("zstp2id")) zstp2id=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("zstp3id")) zstp3id=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("zstp4id")) zstp4id=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("zstp5id")) zstp5id=fi.getString("UTF-8");
           	
           	if (fi.getFieldName().equals("dhid1")) dhid1=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhid2")) dhid2=fi.getString("UTF-8");
           	if (fi.getFieldName().equals("dhid3")) dhid3=fi.getString("UTF-8");
           	
        	if (fi.getFieldName().equals("xlmr")) xlmr=fi.getString("UTF-8");
        	if (fi.getFieldName().equals("kcyj")) kcyj=fi.getString("UTF-8");
        	if (fi.getFieldName().equals("spnr")) spnr=fi.getString("UTF-8");
           	if ( !fun.sqlStrCheck(spmc) || !fun.sqlStrCheck(spl) || !fun.sqlStrCheck(qbjf) || !fun.sqlStrCheck(cxjf) || !fun.sqlStrCheck(scj)|| !fun.sqlStrCheck(kcyj))
           	{
           		out.print("<script type='text/javascript'>");
           		out.print("alert('提交的内容中有敏感字符！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
           	}
           	
           }
           else
           {
	           Calendar nowtime=Calendar.getInstance();
	          
	          
	           if (fi.getName() != null && !fi.getName().equals("") ) 
	           {	
	           	String fileName=fi.getName();	
	           
	           	
	           
	    		
	           fileName=fileName.substring(fileName.lastIndexOf("."));
	           if (fi.getFieldName().equals("zstp1"))
	           {zstp1=spl+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=zstp1;}
	           
	           if (fi.getFieldName().equals("zstp2"))
	           {zstp2=spl+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=zstp2;}
	           
	           if (fi.getFieldName().equals("zstp3"))
	           {zstp3=spl+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=zstp3;}
	           
	           if (fi.getFieldName().equals("zstp4"))
	           {zstp4=spl+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=zstp4;}
	           
	           if (fi.getFieldName().equals("zstp5"))
	           {zstp5=spl+String.valueOf(nowtime.getTimeInMillis())+fileName;
	           fileName=zstp5;}
	          
		       fi.write(new File(uploadPath, fileName));
		       fi.delete();
		       
		       //Image image=new Image(uploadPath+"/"+fileName);
		       //image.resize(335,335);		       
		       //image.saveAs(uploadPath+"/"+fileName+"335x335.jpg");
		       
		      // Image image2=new Image(uploadPath+"/"+fileName);
		       //image2.resize(210,210);
		      // image2.saveAs(uploadPath+"/"+fileName+"210x210.jpg");
		       
		      // Image image3=new Image(uploadPath+"/"+fileName);
		      // image3.resize(146,146);
		      // image3.saveAs(uploadPath+"/"+fileName+"146x146.jpg");
		       
		      // Image image4=new Image(uploadPath+"/"+fileName);
		      // image4.resize(60,60);
		      // image4.saveAs(uploadPath+"/"+fileName+"60x60.jpg");
		       Thumbnails.of(new File(uploadPath+"/"+fileName))
		       .size(335,335)
		       .toFile(new File(uploadPath+"/"+fileName+"335x335.jpg"));
		       
		       Thumbnails.of(new File(uploadPath+"/"+fileName))
		       .size(210,210)
		       .toFile(new File(uploadPath+"/"+fileName+"210x210.jpg"));
		       
		       Thumbnails.of(new File(uploadPath+"/"+fileName))
		       .size(146,146)
		       .toFile(new File(uploadPath+"/"+fileName+"146x146.jpg"));
		       
		       Thumbnails.of(new File(uploadPath+"/"+fileName))
		       .size(60,60)
		       .toFile(new File(uploadPath+"/"+fileName+"60x60.jpg"));
	           }
	       }
       }
       
     if (spid!=null && spid.length()>0)
     {
    	 	
    	 	//重名判断
    	 	strsql="select nid from tbl_sp where zt<>-1 and nid<>"+spid+" and spmc='"+spmc+"'";
    	 	rs=stmt.executeQuery(strsql);
    	 	if (rs.next())
    	 	{
    	 		rs.close();
    	 		out.print("<script type='text/javascript'>");
           		out.print("alert('该商品名称已经存在！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
    	 	}
    	 	rs.close();
    	 	
    	 	strsql="update tbl_sp set spmc=?,spbh=?,spl=?,scj=?,qbjf=?,cxjf=?,kcyj=?,spnr=? where nid="+spid;
    	 	PreparedStatement pstmt=conn.prepareStatement(strsql);
    	 	pstmt.setString(1,spmc);
    	 	pstmt.setString(2,spbh);
    	 	pstmt.setString(3,spl);
    	 	pstmt.setString(4,scj);
    	 	pstmt.setString(5,qbjf);
    	 	pstmt.setString(6,cxjf);
    	 	pstmt.setString(7,kcyj);
    	 	pstmt.setString(8,spnr);
    	 	pstmt.executeUpdate();
    	 	pstmt.close();
			
			
			//更新图片表,原有要修改，没有的要新增
			//这里没有考虑要删除的情况
			if (zstp1id!=null && zstp1id.length()>0)
			{
				if (zstp1!=null && zstp1.length()>0)
				{
					strsql="update tbl_sptp set lj='/spimg/"+zstp1+"' where nid="+zstp1id;
					stmt.executeUpdate(strsql);
				}
			}
			else
			{
				if (zstp1!=null && zstp1.length()>0)
				{
					strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp1+"',now())";
					stmt.executeUpdate(strsql);
					//第一个要取编号更新到商品表中
					strsql="select @@identity as zstp1id";
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						zstp1id=rs.getString("zstp1id");
					}
					rs.close();
					
					strsql="update tbl_sp set zstp="+zstp1id+" where nid="+spid;
					stmt.executeUpdate(strsql);			
				}
			}
			
			if (zstp2id!=null && zstp2id.length()>0)
			{
				if (zstp2!=null && zstp2.length()>0)
				{
					strsql="update tbl_sptp set lj='/spimg/"+zstp2+"' where nid="+zstp2id;
					stmt.executeUpdate(strsql);
				}
			}
			else
			{
				if (zstp2!=null && zstp2.length()>0)
				{
					strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp2+"',now())";
					stmt.executeUpdate(strsql);		
				}
			}
			
			if (zstp3id!=null && zstp3id.length()>0)
			{
				if (zstp3!=null && zstp3.length()>0)
				{
					strsql="update tbl_sptp set lj='/spimg/"+zstp3+"' where nid="+zstp3id;
					stmt.executeUpdate(strsql);
				}
			}
			else
			{
				if (zstp3!=null && zstp3.length()>0)
				{
					strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp3+"',now())";
					stmt.executeUpdate(strsql);		
				}
			}
			
			
			if (zstp4id!=null && zstp4id.length()>0)
			{
				if (zstp4!=null && zstp4.length()>0)
				{
					strsql="update tbl_sptp set lj='/spimg/"+zstp4+"' where nid="+zstp4id;
					stmt.executeUpdate(strsql);
				}
			}
			else
			{
				if (zstp4!=null && zstp4.length()>0)
				{
					strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp4+"',now())";
					stmt.executeUpdate(strsql);		
				}
			}
			
			if (zstp5id!=null && zstp5id.length()>0)
			{
				if (zstp5!=null && zstp5.length()>0)
				{
					strsql="update tbl_sptp set lj='/spimg/"+zstp5+"' where nid="+zstp5id;
					stmt.executeUpdate(strsql);
				}
			}
			else
			{
				if (zstp5!=null && zstp5.length()>0)
				{
					strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp5+"',now())";
					stmt.executeUpdate(strsql);		
				}
			}
			
			//更新价格表，先删除后添加
			//删除
			strsql="delete from tbl_dhfs where sp="+spid;
			stmt.executeUpdate(strsql);
			
			if (dhjf1!=null && dhjf1.length()>0 && dhje1!=null && dhje1.length()>0)
			{
				strsql="insert into tbl_dhfs (sp,jf,je) values("+spid+","+dhjf1+","+dhje1+")";
				stmt.executeUpdate(strsql);
				
			}
			if (dhjf2!=null && dhjf2.length()>0 && dhje2!=null && dhje2.length()>0)
			{
				strsql="insert into tbl_dhfs (sp,jf,je) values("+spid+","+dhjf2+","+dhje2+")";
				stmt.executeUpdate(strsql);	
				
			}
			if (dhjf3!=null && dhjf3.length()>0 && dhje3!=null && dhje3.length()>0)
			{
				strsql="insert into tbl_dhfs (sp,jf,je) values("+spid+","+dhjf3+","+dhje3+")";
				stmt.executeUpdate(strsql);	
				
			}
			
			//取最小的积分价,更新到产品表中
			int zsdhfs=0;
			strsql="select nid from tbl_dhfs where sp="+spid+ " order by jf limit 1";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				zsdhfs=rs.getInt("nid");
			}
			rs.close();
			if (zsdhfs>0)
			{
				strsql="update tbl_sp set zsdhfs="+zsdhfs+" where nid="+spid;
				stmt.executeUpdate(strsql);
			}
     }
     else
     {
	    	//重名判断
	 	 	strsql="select nid from tbl_sp where zt<>-1 and spmc='"+spmc+"'";
	 	 	rs=stmt.executeQuery(strsql);
	 	 	if (rs.next())
	 	 	{
	 	 		rs.close();
	 	 		out.print("<script type='text/javascript'>");
        		out.print("alert('该商品名称已经存在！');");
        		out.print("history.back(-1);");
        		out.print("</script>");
        		return;
	 	 	}
	 	 	rs.close();
		 
		 
    	 	//商品信息表
    	 	strsql="insert into tbl_sp (spmc,spbh,spl,scj,qbjf,cxjf,zt,kcyj,spnr,rq) values(?,?,?,?,?,?,?,?,?,now())";
    	 	PreparedStatement pstmt=conn.prepareStatement(strsql);
    	 	pstmt.setString(1,spmc);
    	 	pstmt.setString(2,spbh);
    	 	pstmt.setString(3,spl);
    	 	pstmt.setString(4,scj);
    	 	pstmt.setString(5,qbjf);
    	 	pstmt.setString(6,cxjf);
    	 	pstmt.setString(7,"0");    	 
    	 	pstmt.setString(8,kcyj);
    	 	pstmt.setString(9,spnr);
    	 	pstmt.executeUpdate();
    	 	pstmt.close();
    	 	
			
			strsql="select @@identity as spid";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				spid=rs.getString("spid");
			}
			rs.close();
			
			//如果是系列第一个商品，就算没有设置默认，系统也自动设置默认
			if (xlmr!=null && xlmr.equals("0"))
			{
			   
			   strsql="select count(nid) from tbl_sp where zt<>-1 and spl="+spl;
			   rs=stmt.executeQuery(strsql);
			   if (rs.next())
			   {
				   phn=rs.getInt(1);
			   }
			   rs.close();			   
			  
			}
			
			//商品图片表
			if (zstp1!=null && zstp1.length()>0)
			{
				strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp1+"',now())";
				stmt.executeUpdate(strsql);
				//第一个要取编号更新到商品表中
				strsql="select @@identity as zstp1id";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					zstp1id=rs.getString("zstp1id");
				}
				rs.close();
				
				strsql="update tbl_sp set zstp="+zstp1id+" where nid="+spid;
				stmt.executeUpdate(strsql);			
			}
			
			if (zstp2!=null && zstp2.length()>0)
			{
				strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp2+"',now())";
				stmt.executeUpdate(strsql);						
			}
			
			if (zstp3!=null && zstp3.length()>0)
			{
				strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp3+"',now())";
				stmt.executeUpdate(strsql);						
			}
			
			if (zstp4!=null && zstp4.length()>0)
			{
				strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp4+"',now())";
				stmt.executeUpdate(strsql);						
			}
			
			if (zstp5!=null && zstp5.length()>0)
			{
				strsql="insert into tbl_sptp (sp,lj,rq) values("+spid+",'/spimg/"+zstp5+"',now())";
				stmt.executeUpdate(strsql);						
			}
			
			
			//商品支付表
			if (dhjf1!=null && dhjf1.length()>0 && dhje1!=null && dhje1.length()>0)
			{
				strsql="insert into tbl_dhfs (sp,jf,je) values("+spid+","+dhjf1+","+dhje1+")";
				stmt.executeUpdate(strsql);
				
			}
			if (dhjf2!=null && dhjf2.length()>0 && dhje2!=null && dhje2.length()>0)
			{
				strsql="insert into tbl_dhfs (sp,jf,je) values("+spid+","+dhjf2+","+dhje2+")";
				stmt.executeUpdate(strsql);	
				
			}
			if (dhjf3!=null && dhjf3.length()>0 && dhje3!=null && dhje3.length()>0)
			{
				strsql="insert into tbl_dhfs (sp,jf,je) values("+spid+","+dhjf3+","+dhje3+")";
				stmt.executeUpdate(strsql);	
				
			}
			
			//取最小的积分价,更新到产品表中
			int zsdhfs=0;
			strsql="select nid from tbl_dhfs where sp="+spid+ " order by jf limit 1";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				zsdhfs=rs.getInt("nid");
			}
			rs.close();
			if (zsdhfs>0)
			{
				strsql="update tbl_sp set zsdhfs="+zsdhfs+" where nid="+spid;
				stmt.executeUpdate(strsql);
			}		
     }
     
     //更改系列中的对应的商品
     if ((xlmr!=null && xlmr.equals("1")) || phn==1)
     {
	     strsql="update tbl_spl set sp="+spid+" where nid="+spl;
	     stmt.execute(strsql);
     }
	 
	 response.sendRedirect("spnrgl.jsp?pno="+request.getParameter("pno")+"&lb1="+request.getParameter("lb1_"));
    
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