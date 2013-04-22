<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.poi.ss.util.Region"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("5002")==-1)
{
	out.print("你没有操作权限！");
	return;
}

	String scjrq=request.getParameter("scjrq");
	if (scjrq==null) scjrq="";
	String ecjrq=request.getParameter("ecjrq");
	if (ecjrq==null) ecjrq="";
	
	String sjsrq=request.getParameter("sjsrq");
	if (sjsrq==null) sjsrq="";
	String ejsrq=request.getParameter("ejsrq");
	if (ejsrq==null) ejsrq="";

	//创建Excel 文件
	HSSFWorkbook workbook = new HSSFWorkbook();
	// 创建工作区
	HSSFSheet sheet = workbook.createSheet("备货单");
	
	
	 HSSFRow rowt = sheet.createRow((short)0);
	 HSSFCell cellt=rowt.createCell((short) 0);
	 rowt.createCell(1);
	 rowt.createCell(2);
	 rowt.createCell(3);
	 
	 SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd");
	 String ddstr="";
	 if ((scjrq!=null && scjrq.length()>0) && (ecjrq!=null && ecjrq.length()>0))
	 {
		 ddstr="订单生成日期:"+scjrq+"--"+ecjrq;		 
	 }
	 else if (scjrq!=null && scjrq.length()>0)
	 {
		 ddstr="订单生成日期:"+scjrq+"--"+sf2.format(Calendar.getInstance().getTime());	
	 }
	 else if (ecjrq!=null && ecjrq.length()>0)
		 ddstr="订单生成日期:"+ecjrq+"之前";	
	 
	 
	 if ((sjsrq!=null && sjsrq.length()>0) && (ejsrq!=null && ejsrq.length()>0))
	 {
		 ddstr+=" 订单付款日期:"+sjsrq+"--"+ejsrq;		 
	 }
	 else if (sjsrq!=null && sjsrq.length()>0)
	 {
		 ddstr+=" 订单付款日期:"+sjsrq+"--"+sf2.format(Calendar.getInstance().getTime());	
	 }
	 else if (ejsrq!=null && ejsrq.length()>0)
		 ddstr+=" 订单付款日期:"+ejsrq+"之前";		
	 
	 if (ddstr==null && ddstr.length()==0)
		 ddstr="所有备货单 ";
	 cellt.setCellValue(ddstr);
	 
	 sheet.addMergedRegion(new Region(0,(short)0,0,(short)3));
	 // 创建行
	 HSSFRow row = sheet.createRow((short)1);
	 
	 // 创建样式
	 //HSSFCellStyle items_style = workbook.createCellStyle();
	 // 设置表头样式
	 //items_style.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
	 // 创建字体
	 //HSSFFont celltbnamefont = workbook.createFont();
	 // 设置表头字体属性
	// celltbnamefont.setFontHeightInPoints((short) 8);
	 // 设置表头字体属性
	// celltbnamefont.setColor((short) HSSFFont.COLOR_RED);
	 // 设置表头字体属性
	// items_style.setFont(celltbnamefont);
	// items_style.setWrapText(true);
	
	HSSFCell cell0=row.createCell((short) 0);
	cell0.setCellValue("序号");
	HSSFCell cell1=row.createCell((short) 1);
	cell1.setCellValue("商品编号");
	sheet.setColumnWidth(1,(short)5335);
	HSSFCell cell2=row.createCell((short) 2);
	cell2.setCellValue("商品名称");
	sheet.setColumnWidth(2,(short)10000);
	HSSFCell cell3=row.createCell((short) 3);
	cell3.setCellValue("数量");
	
	Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	ResultSet rs=null;
	String strsql="";
	int i=1;
	SimpleDateFormat sf=new SimpleDateFormat("yyyyMMddHHmmss");
	try
	{
		strsql="select s.spbh,s.spmc,sum(x.sl) as sl from tbl_ygddzb d inner join tbl_ygddmx x on d.nid=x.dd inner join tbl_sp s on x.sp=s.nid where d.state in (1,11)";
		if (scjrq!=null && scjrq.length()>0)
			strsql+=" and d.cjrq>='"+scjrq+"'";
		if (ecjrq!=null && ecjrq.length()>0)
			strsql+=" and d.cjrq<='"+ecjrq+" 23:59:59'";
			
		if (sjsrq!=null && sjsrq.length()>0)
			strsql+=" and d.jsrq>='"+sjsrq+"'";
		if (ejsrq!=null && ejsrq.length()>0)
			strsql+=" and d.jsrq<='"+ejsrq+" 23:59:59'";
		strsql+=" group by s.spbh,s.spmc";
		
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			HSSFRow datarow = sheet.createRow((short) i + 1);
			for (int j = 1; j < 5; j++) {
		     HSSFCell cell = datarow.createCell((short) (j - 1));
		     if (j==1)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		    	 cell.setCellValue(i+1);
		     }
		     else if (j==2)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    	 
		    	 cell.setCellValue(rs.getString("spbh"));
		     }
		     else if (j==3)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    	 cell.setCellValue(rs.getString("spmc"));
		     }
		     else if (j==4)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		    	 cell.setCellValue(rs.getInt("sl"));
		     }
			}
			i++;
		}
		rs.close();
		
		
		  OutputStream os;
		  String fileName = "bhd"+sf.format(Calendar.getInstance().getTime())+".xls";
		  
		   
		   //response.setContentType("application/msexcel");
		   response.setHeader("Content-type","application/xls"); 
		   response.setHeader("Content-Disposition", "attachment;" + " filename="
		     + new String(fileName.getBytes(), "ISO-8859-1"));
		   
		  
		   //response.setHeader("Content-Disposition", "attachment;filename=booking.xls"); 
		   response.setHeader("Content-Type", "application/vnd.ms-excel; charset=UTF-8"); 
		   //request.setCharacterEncoding("utf-8");
		   
		   os = response.getOutputStream();
		   workbook.write(os);
		   os.close();
		   
		   
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