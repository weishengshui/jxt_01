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
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",2,")==-1) 
	response.sendRedirect("main.jsp");
	Connection conn=DbPool.getInstance().getConnection();
	Statement stmt=conn.createStatement();
	ResultSet rs=null;
	Statement stmt2=conn.createStatement();
	ResultSet rs2=null;	
	String strsql="",zzzt="";
	int i=0;
	SimpleDateFormat sf=new SimpleDateFormat("yyyyMMddHHmmss");
	SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd");
	String soutdate=request.getParameter("soutdate");
	String eoutdate=request.getParameter("eoutdate");
    try
    {
    	//创建Excel 文件
		HSSFWorkbook workbook = new HSSFWorkbook();
		// 创建工作区
		
		HSSFSheet sheet = workbook.createSheet("积分购买明细报表");	
		HSSFRow row = sheet.createRow((short)0);	
		HSSFCell cell0=row.createCell((short) 0);
		cell0.setCellValue("订单号");
		HSSFCell cell1=row.createCell((short) 1);
		cell1.setCellValue("购买日期");	
		HSSFCell cell2=row.createCell((short) 2);
		cell2.setCellValue("到账日期");	
		HSSFCell cell3=row.createCell((short) 3);
		cell3.setCellValue("购买积分(分)");	
		HSSFCell cell4=row.createCell((short) 4);
		cell4.setCellValue("支付金额");
		HSSFCell cell5=row.createCell((short) 5);
		cell5.setCellValue("到账积分 ");
		HSSFCell cell6=row.createCell((short) 6);
		cell6.setCellValue("支付方式");
		HSSFCell cell7=row.createCell((short) 7);
		cell7.setCellValue("状态");	
		
		strsql="select nid,zzsj,zzbh,zzjf,zzje,dzjf, zzzt,fksj,zzfs from tbl_jfzz where qy="+session.getAttribute("qy");
		if (soutdate!=null && soutdate.length()>0)
			strsql+=" and zzsj>='"+soutdate+"'";
		if (eoutdate!=null && eoutdate.length()>0)
			strsql+=" and zzsj<='"+eoutdate+" 23:59:59'";
		strsql+=" order by nid desc";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			HSSFRow datarow = sheet.createRow((short) i + 1);
			for (int j = 0; j < 8; j++) {
		     HSSFCell cell = datarow.createCell((short) (j));
		     if (j==0)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    	 cell.setCellValue(rs.getString("zzbh"));
		     }
		     if (j==1)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_STRING);		    	 
		    	 cell.setCellValue(sf2.format(rs.getDate("zzsj")));
		     }
		     if (j==2)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    	 cell.setCellValue(rs.getString("fksj")==null?"":sf2.format(rs.getDate("fksj")));
		     }
		     if (j==3)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		    	 cell.setCellValue(rs.getInt("zzjf"));
		     }
		     if (j==4)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		    	 cell.setCellValue(rs.getDouble("zzje"));
		     }
		     if (j==5)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
		    	 cell.setCellValue(rs.getString("dzjf")==null?"":rs.getString("dzjf"));
		     }
		     if (j==6)
		     {
		    	 cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    	 cell.setCellValue(rs.getInt("zzfs")==1?"线下支付":"线上支付");
		     }
		     if (j==7)
		     {
		    	cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    	if (rs.getInt("zzzt")==0)
					zzzt="未付款";
				if (rs.getInt("zzzt")==1)
					zzzt="完成支付";
				if (rs.getInt("zzzt")==2)
					zzzt="线下支付未付款";
				if (rs.getInt("zzzt")==3)
					zzzt="交易成功";
				if (rs.getInt("zzzt")==-1 || rs.getInt("zzzt")==-2)
					zzzt="已取消";	
		    	 cell.setCellValue(zzzt);
		     }
		     
			}
			i++;
		}
		rs.close();
		
		//发放明细是指发放成功的还是包括所有数据
		//目前取已发放成功的
		HSSFSheet sheet2=workbook.createSheet("积分发放明细报表");
		HSSFRow row2 = sheet2.createRow((short)0);	
		HSSFCell cell20=row2.createCell((short) 0);
		cell20.setCellValue("发放日期");
		HSSFCell cell21=row2.createCell((short) 1);
		cell21.setCellValue("发放名目");	
		HSSFCell cell22=row2.createCell((short) 2);
		cell22.setCellValue("奖励对象");	
		HSSFCell cell23=row2.createCell((short) 3);
		cell23.setCellValue("人数/部门数");	
		HSSFCell cell24=row2.createCell((short) 4);
		cell24.setCellValue("发放总积分");
		HSSFCell cell25=row2.createCell((short) 5);
		cell25.setCellValue("备注信息 ");
		
		StringBuffer jfffsj=new StringBuffer();
		StringBuffer jfffmm=new StringBuffer();
		StringBuffer jfffbz=new StringBuffer();
		StringBuffer jfff=new StringBuffer();
		String jldx="",jlrs="",jljf="";
		int sheet2row=1;
		strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.bz from tbl_jfff f left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy")+" and f.ffxx=0 and f.ffzt=1";
		if (soutdate!=null && soutdate.length()>0)
			strsql+=" and f.ffsj>='"+soutdate+"'";
		if (eoutdate!=null && eoutdate.length()>0)
			strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
		strsql+=" order by ffsj desc";
		
		rs=stmt.executeQuery(strsql);
		while (rs.next())
		{
			jfff.append(rs.getString("nid")+",");
			jfffsj.append(sf2.format(rs.getDate("ffsj"))+",");
			jfffmm.append(rs.getString("mc2")==null?rs.getString("mc1"):rs.getString("mc2"));
			jfffmm.append(",");
			jfffbz.append(rs.getString("bz")+" '");			
		}
		rs.close();
		
		if (jfffsj!=null && jfffsj.length()>0)
		{
			String[] jfffarr=jfff.toString().split(",");
			String[] jfffsjarr=jfffsj.toString().split(",");
			String[] jfffmmarr=jfffmm.toString().split(",");
			String[] jfffbzarr=jfffbz.toString().split("'");
			for (int k=0;k<jfffarr.length;k++)
			{
				
				
				i=0;
				String jfstr="";
				//考虑不同部门有可能有不同的积分，先按积分分组
				strsql="select jf from tbl_jfffxx where jfff="+jfffarr[k]+" and fflx=1 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{
					String[] jfarr=jfstr.split(",");
					for (int j=0;j<jfarr.length;j++)
					{
						i=0;						
						strsql="select b.bmmc from tbl_jfffxx f left join tbl_qybm b on f.lxbh=b.nid where f.jfff="+jfffarr[k]+" and f.fflx=1 and f.jf="+jfarr[j]; 
						jldx="";						
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							jldx=jldx+rs.getString("bmmc")+",";													
							i++;
						}
						rs.close();
						HSSFRow datarow = sheet2.createRow(sheet2row);
						datarow.createCell((short) (0)).setCellValue(jfffsjarr[k]);
						datarow.createCell((short) (1)).setCellValue(jfffmmarr[k]);
						datarow.createCell((short) (2)).setCellValue(jldx);
						datarow.createCell((short) (3)).setCellValue(String.valueOf(i));
						datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr[j])*i);
						datarow.createCell((short) (5)).setCellValue(jfffbzarr[k]);
						sheet2row++;
					}
				}
				
				//小组
				jfstr="";
				strsql="select jf from tbl_jfffxx where jfff="+jfffarr[k]+" and fflx=2 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{	
					String[] jfarr2=jfstr.split(",");
					for (int j=0;j<jfarr2.length;j++)
					{
						i=0;
						jldx="";
						strsql="select f.jf,x.xzmc from tbl_jfffxx f left join tbl_qyxz x on f.lxbh=x.nid where f.jfff="+jfffarr[k]+" and f.fflx=2 and f.jf="+jfarr2[j]; 
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							jldx=jldx+rs.getString("xzmc")+",";	
													
							i++;
						}
						rs.close();
						
						HSSFRow datarow = sheet2.createRow(sheet2row);
						datarow.createCell((short) (0)).setCellValue(jfffsjarr[k]);
						datarow.createCell((short) (1)).setCellValue(jfffmmarr[k]);
						datarow.createCell((short) (2)).setCellValue(jldx);
						datarow.createCell((short) (3)).setCellValue(String.valueOf(i));
						datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr2[j])*i);
						datarow.createCell((short) (5)).setCellValue(jfffbzarr[k]);
						sheet2row++;						
					}
				}
				
				//个别员工
				jfstr="";
				strsql="select jf from tbl_jfffxx where jfff="+jfffarr[k]+" and fflx=3 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{
					String[] jfarr3=jfstr.split(",");
					for (int j=0;j<jfarr3.length;j++)
					{
						i=0;
						jldx="";
						strsql="select y.ygxm from tbl_jfffxx f left join tbl_jfffmc m on f.nid=m.jfffxx left join tbl_qyyg y on m.hqr=y.nid where f.jfff="+jfffarr[k]+" and f.fflx=3 and f.jf="+jfarr3[j]; 
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							jldx=jldx+rs.getString("ygxm")+",";								
							i++;
						}
						rs.close();
						
						HSSFRow datarow = sheet2.createRow(sheet2row);
						datarow.createCell((short) (0)).setCellValue(jfffsjarr[k]);
						datarow.createCell((short) (1)).setCellValue(jfffmmarr[k]);
						datarow.createCell((short) (2)).setCellValue(jldx);
						datarow.createCell((short) (3)).setCellValue(String.valueOf(i));
						datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr3[j])*i);
						datarow.createCell((short) (5)).setCellValue(jfffbzarr[k]);
						sheet2row++;	
						
					}
				}
				
				//全体员工
				jfstr="";
				strsql="select jf from tbl_jfffxx where jfff="+jfffarr[k]+" and fflx=4 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{
					String[] jfarr4=jfstr.split(",");
					for (int j=0;j<jfarr4.length;j++)
					{
						i=0;					
						strsql="select rs from tbl_jfffxx where jfff="+jfffarr[k]+" and fflx=4 and jf="+jfarr4[j]; 
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							HSSFRow datarow = sheet2.createRow(sheet2row);
							datarow.createCell((short) (0)).setCellValue(jfffsjarr[k]);
							datarow.createCell((short) (1)).setCellValue(jfffmmarr[k]);
							datarow.createCell((short) (2)).setCellValue("全体员工");
							datarow.createCell((short) (3)).setCellValue(rs.getString("rs"));
							datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr4[j])*rs.getInt("rs"));
							datarow.createCell((short) (5)).setCellValue(jfffbzarr[k]);
							sheet2row++;
						}
						rs.close();
						
						
					}
				}
			}
		}
		
		
			
		//
		HSSFSheet sheet3=workbook.createSheet("积分券购买明细报表");
		HSSFRow row3 = sheet3.createRow((short)0);	
		row3.createCell((short) 0).setCellValue("订单号");
		row3.createCell((short) 1).setCellValue("购买日期");	
		row3.createCell((short) 2).setCellValue("积分券名称");	
		row3.createCell((short) 3).setCellValue("所属类目");	
		row3.createCell((short) 4).setCellValue("数量(张)");
		row3.createCell((short) 5).setCellValue("金额(积分)");
		row3.createCell((short) 6).setCellValue("状态");	
		i=1;
		strsql="select d.ddbh,d.ddsj,q.mc,l.lmmc,m.sl,q.jf,d.zt from tbl_jfqddmc m inner join tbl_jfqdd d on m.jfqdd=d.nid left join tbl_jfq q on m.jfq=q.nid left join tbl_jfqhd h on q.hd=h.nid left join tbl_jfqlm l on h.lm=l.nid where d.qy="+session.getAttribute("qy");
		if (soutdate!=null && soutdate.length()>0)
			strsql+=" and d.ddsj>='"+soutdate+"'";
		if (eoutdate!=null && eoutdate.length()>0)
			strsql+=" and d.ddsj<='"+eoutdate+" 23:59:59'";
		strsql+=" order by d.ddsj desc";
		
		rs=stmt.executeQuery(strsql);
		while (rs.next())
		{
			HSSFRow datarow=sheet3.createRow(i);
			datarow.createCell(0).setCellValue(rs.getString("ddbh"));
			datarow.createCell(1).setCellValue(sf2.format(rs.getDate("ddsj")));
			datarow.createCell(2).setCellValue(rs.getString("mc"));
			datarow.createCell(3).setCellValue(rs.getString("lmmc"));
			datarow.createCell(4).setCellValue(rs.getInt("sl"));
			datarow.createCell(5).setCellValue(rs.getInt("sl")*rs.getInt("jf"));
			if (rs.getInt("zt")==-1)
				zzzt="已取消";
			else if (rs.getInt("zt")==0)
				zzzt="未付款";
			else if (rs.getInt("zt")==1)
				zzzt="交易成功";
			datarow.createCell(6).setCellValue(zzzt);
			i++;
		}
		rs.close();
		
		//
		HSSFSheet sheet4=workbook.createSheet("积分券发放明细报表");
		HSSFRow row4 = sheet4.createRow((short)0);
		row4.createCell((short) 0).setCellValue("发放日期");
		row4.createCell((short) 1).setCellValue("发放名目");
		row4.createCell((short) 2).setCellValue("奖励对象");	
		row4.createCell((short) 3).setCellValue("人数/部门数");
		row4.createCell((short) 4).setCellValue("发放总数量");
		row4.createCell((short) 5).setCellValue("备注信息 ");
		
		StringBuffer jfqffsj=new StringBuffer();
		StringBuffer jfqffmm=new StringBuffer();
		StringBuffer jfqffbz=new StringBuffer();
		StringBuffer jfqff=new StringBuffer();
		
		int sheet4row=1;
		strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.bz from tbl_jfqff f left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy")+" and f.ffxx=0  and f.ffzt=1";
		if (soutdate!=null && soutdate.length()>0)
			strsql+=" and f.ffsj>='"+soutdate+"'";
		if (eoutdate!=null && eoutdate.length()>0)
			strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
		strsql+=" order by ffsj desc";
		
		rs=stmt.executeQuery(strsql);
		while (rs.next())
		{
			jfqff.append(rs.getString("nid")+",");
			jfqffsj.append(sf2.format(rs.getDate("ffsj"))+",");
			jfqffmm.append(rs.getString("mc2")==null?rs.getString("mc1"):rs.getString("mc2"));
			jfqffmm.append(",");
			jfqffbz.append(rs.getString("bz")+" '");			
		}
		rs.close();
		
		if (jfqffsj!=null && jfqffsj.length()>0)
		{
			String[] jfqffarr=jfqff.toString().split(",");
			String[] jfqffsjarr=jfqffsj.toString().split(",");
			String[] jfqffmmarr=jfqffmm.toString().split(",");
			String[] jfqffbzarr=jfqffbz.toString().split("'");
			for (int k=0;k<jfqffarr.length;k++)
			{
				
				
				i=0;
				String jfstr="";
				//考虑不同部门有可能有不同的积分，先按积分分组
				strsql="select jf from tbl_jfqffxx where jfqff="+jfqffarr[k]+" and fflx=1 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{
					String[] jfarr=jfstr.split(",");
					for (int j=0;j<jfarr.length;j++)
					{
						i=0;						
						strsql="select b.bmmc from tbl_jfqffxx f left join tbl_qybm b on f.lxbh=b.nid where f.jfqff="+jfqffarr[k]+" and f.fflx=1 and f.jf="+jfarr[j]; 
						jldx="";						
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							jldx=jldx+rs.getString("bmmc")+",";													
							i++;
						}
						rs.close();
						HSSFRow datarow = sheet4.createRow(sheet4row);
						datarow.createCell((short) (0)).setCellValue(jfqffsjarr[k]);
						datarow.createCell((short) (1)).setCellValue(jfqffmmarr[k]);
						datarow.createCell((short) (2)).setCellValue(jldx);
						datarow.createCell((short) (3)).setCellValue(String.valueOf(i));
						datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr[j])*i);
						datarow.createCell((short) (5)).setCellValue(jfqffbzarr[k]);
						sheet4row++;
					}
				}
				
				//小组
				jfstr="";
				strsql="select jf from tbl_jfqffxx where jfqff="+jfqffarr[k]+" and fflx=2 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{	
					String[] jfarr2=jfstr.split(",");
					for (int j=0;j<jfarr2.length;j++)
					{
						i=0;
						jldx="";
						strsql="select f.jf,x.xzmc from tbl_jfqffxx f left join tbl_qyxz x on f.lxbh=x.nid where f.jfqff="+jfqffarr[k]+" and f.fflx=2 and f.jf="+jfarr2[j]; 
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							jldx=jldx+rs.getString("xzmc")+",";	
													
							i++;
						}
						rs.close();
						
						HSSFRow datarow = sheet4.createRow(sheet4row);
						datarow.createCell((short) (0)).setCellValue(jfqffsjarr[k]);
						datarow.createCell((short) (1)).setCellValue(jfqffmmarr[k]);
						datarow.createCell((short) (2)).setCellValue(jldx);
						datarow.createCell((short) (3)).setCellValue(String.valueOf(i));
						datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr2[j])*i);
						datarow.createCell((short) (5)).setCellValue(jfqffbzarr[k]);
						sheet4row++;						
					}
				}
				
				//个别员工
				jfstr="";
				strsql="select jf from tbl_jfqffxx where jfqff="+jfqffarr[k]+" and fflx=3 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{
					String[] jfarr3=jfstr.split(",");
					for (int j=0;j<jfarr3.length;j++)
					{
						i=0;
						jldx="";
						strsql="select y.ygxm from tbl_jfqffxx f left join tbl_jfqffmc m on f.nid=m.jfqffxx left join tbl_qyyg y on m.hqr=y.nid where f.jfqff="+jfqffarr[k]+" and f.fflx=3 and f.jf="+jfarr3[j]; 
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							jldx=jldx+rs.getString("ygxm")+",";								
							i++;
						}
						rs.close();
						
						HSSFRow datarow = sheet4.createRow(sheet4row);
						datarow.createCell((short) (0)).setCellValue(jfqffsjarr[k]);
						datarow.createCell((short) (1)).setCellValue(jfqffmmarr[k]);
						datarow.createCell((short) (2)).setCellValue(jldx);
						datarow.createCell((short) (3)).setCellValue(String.valueOf(i));
						datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr3[j])*i);
						datarow.createCell((short) (5)).setCellValue(jfqffbzarr[k]);
						sheet4row++;	
						
					}
				}
				
				//全体员工
				jfstr="";
				strsql="select jf from tbl_jfqffxx where jfqff="+jfqffarr[k]+" and fflx=4 group by jf";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					jfstr=jfstr+rs.getString("jf")+",";
				}
				rs.close();
				
				if (jfstr.length()>0)
				{
					String[] jfarr4=jfstr.split(",");
					for (int j=0;j<jfarr4.length;j++)
					{
						i=0;					
						strsql="select rs from tbl_jfqffxx where jfqff="+jfqffarr[k]+" and fflx=4 and jf="+jfarr4[j]; 
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							HSSFRow datarow = sheet4.createRow(sheet4row);
							datarow.createCell((short) (0)).setCellValue(jfqffsjarr[k]);
							datarow.createCell((short) (1)).setCellValue(jfqffmmarr[k]);
							datarow.createCell((short) (2)).setCellValue("全体员工");
							datarow.createCell((short) (3)).setCellValue(rs.getString("rs"));
							datarow.createCell((short) (4)).setCellValue(Integer.valueOf(jfarr4[j])*rs.getInt("rs"));
							datarow.createCell((short) (5)).setCellValue(jfqffbzarr[k]);
							sheet4row++;
						}
						rs.close();
						
						
					}
				}
			}
		}
		
		
		HSSFSheet sheet5=workbook.createSheet("发放名目统计分析报表");
		HSSFRow row5=sheet5.createRow(0);
		row5.createCell(0).setCellValue("发放名目");	
		HSSFRow row5_1=sheet5.createRow(1);
		row5_1.createCell(0).setCellValue("一级目录");
		row5_1.createCell(1).setCellValue("二级目录");
		row5_1.createCell(2).setCellValue("累积奖励积分");
		row5_1.createCell(4).setCellValue("积分券数量");
		row5_1.createCell(5).setCellValue("积分券总价值");
		row5_1.createCell(7).setCellValue("名目累积使用积分");
		row5_1.createCell(8).setCellValue("积分使用占比");
		
		//因名称不能重名，可以直接以名称来定位
		//有二级名目的
		i=2;
		strsql="select m2.mmmc,m1.mmmc from tbl_jfmm m1 inner join tbl_jfmm m2 on m1.fmm=m2.nid where (m1.qy="+session.getAttribute("qy")+" or m1.qy=0) and m1.fmm<>0 order by m1.fmm";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			HSSFRow datarow=sheet5.createRow(i);
			datarow.createCell(0).setCellValue(rs.getString(1));
			datarow.createCell(1).setCellValue(rs.getString(2));
			i++;
		}
		rs.close();
		//无二级名目的
		String nocheckmm=",";
		strsql="select mmmc from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm=0 and nid not in (select fmm from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm<>0)";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			HSSFRow datarow=sheet5.createRow(i);
			datarow.createCell(0).setCellValue(rs.getString(1));
			datarow.createCell(1).setCellValue("");
			nocheckmm+=rs.getString(1)+",";
			i++;
		}
		rs.close();
		
		int nosum=i;
		//取原只是一级后有子名目的,从发放表中取
		//积分发放表中
		
		strsql="select mmmc from tbl_jfmm where nid in (select mm1 from tbl_jfff where qy="+session.getAttribute("qy")+" and ffzt=1 and ffxx=0 and mm2=0  group by mm1)";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			if (nocheckmm.indexOf(","+rs.getString(1)+",")==-1)
			{
				HSSFRow datarow=sheet5.createRow(i);
				datarow.createCell(0).setCellValue(rs.getString(1));
				datarow.createCell(1).setCellValue("");
				nocheckmm+=rs.getString(1)+",";
				i++;
			}
		}
		rs.close();
		//积分券发放表
		strsql="select mmmc from tbl_jfmm where nid in (select mm1 from tbl_jfqff where qy="+session.getAttribute("qy")+" and ffzt=1 and ffxx=0 and mm2=0  group by mm1)";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			//排除上面积分发放中已有
			if (nocheckmm.indexOf(","+rs.getString(1)+",")==-1)
			{
				HSSFRow datarow=sheet5.createRow(i);
				datarow.createCell(0).setCellValue(rs.getString(1));
				datarow.createCell(1).setCellValue("");
				i++;
			}
		}
		rs.close();
		
		String getmmmc1="",getmmmc2="";
		int ajf=0,ajfq=0;
		Double alln=0.0;
		for (int m=2;m<i;m++)
		{
			getmmmc1=sheet5.getRow(m).getCell(0).getStringCellValue();
			getmmmc2=sheet5.getRow(m).getCell(1).getStringCellValue();
			
			if (getmmmc2!=null && getmmmc2.length()>0)
			{
				//累积奖励积分
				strsql="select sum(ffjf) as tjf from tbl_jfff f inner join tbl_jfmm m on f.mm2=m.nid where f.qy="+session.getAttribute("qy")+" and f.ffzt=1 and f.ffxx=0 and m.mmmc='"+getmmmc2+"'";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet5.getRow(m).createCell(2).setCellValue(rs.getInt("tjf"));
					ajf=ajf+rs.getInt("tjf");
				}
				rs.close();
				
				//积分券数量,积分券总价值
				strsql="select sum(x.rs*x.jf),sum(x.rs*x.jf*q.jf) from tbl_jfqffxx x inner join tbl_jfqff f on x.jfqff=f.nid inner join tbl_jfmm m on f.mm2=m.nid inner join tbl_jfq q on x.jfq=q.nid where f.qy="+session.getAttribute("qy")+" and f.ffzt=1 and f.ffxx=0 and m.mmmc='"+getmmmc2+"'";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet5.getRow(m).createCell(4).setCellValue(rs.getInt(1));
					sheet5.getRow(m).createCell(5).setCellValue(rs.getInt(2));
					ajfq=ajfq+rs.getInt(2);
				}
				rs.close();
			}
			else
			{
				//累积奖励积分
				strsql="select sum(ffjf) as tjf from tbl_jfff f inner join tbl_jfmm m on f.mm1=m.nid where f.qy="+session.getAttribute("qy")+" and f.ffzt=1 and f.ffxx=0 and m.mmmc='"+getmmmc1+"'";
				if (m>=nosum)
					strsql+=" and f.mm2=0";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet5.getRow(m).createCell(2).setCellValue(rs.getInt("tjf"));
					ajf=ajf+rs.getInt("tjf");
				}
				rs.close();
				
				//积分券数量,积分券总价值
				strsql="select sum(x.rs*x.jf),sum(x.rs*x.jf*q.jf) from tbl_jfqffxx x inner join tbl_jfqff f on x.jfqff=f.nid inner join tbl_jfmm m on f.mm1=m.nid inner join tbl_jfq q on x.jfq=q.nid where f.qy="+session.getAttribute("qy")+" and f.ffzt=1 and f.ffxx=0 and m.mmmc='"+getmmmc1+"'";
				if (m>=nosum)
					strsql+=" and f.mm2=0";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet5.getRow(m).createCell(4).setCellValue(rs.getInt(1));
					sheet5.getRow(m).createCell(5).setCellValue(rs.getInt(2));
					ajfq=ajfq+rs.getInt(2);
				}
				rs.close();				
			}
			sheet5.getRow(m).createCell(7).setCellValue(sheet5.getRow(m).getCell(2).getNumericCellValue()+sheet5.getRow(m).getCell(5).getNumericCellValue());
			alln=alln+sheet5.getRow(m).getCell(7).getNumericCellValue();
		}
		for (int m=2;m<i;m++)
		{
			if (alln>0)
			sheet5.getRow(m).createCell(8).setCellValue(String.valueOf(Math.round(sheet5.getRow(m).getCell(7).getNumericCellValue()/alln*100))+"%");			
		}
		
		HSSFRow datarow_t=sheet5.createRow(i+1);
		datarow_t.createCell(0).setCellValue("总计");
		datarow_t.createCell(2).setCellValue(ajf);
		datarow_t.createCell(5).setCellValue(ajfq);
		datarow_t.createCell(7).setCellValue(alln);
		datarow_t.createCell(8).setCellValue("100%");
		
		HSSFSheet sheet6=workbook.createSheet("员工账户状况报表");
		HSSFRow row6=sheet6.createRow(0);
		row6.createCell(0).setCellValue("姓名");	
		row6.createCell(1).setCellValue("获得总积分");
		row6.createCell(2).setCellValue("积分获得总次数");
		row6.createCell(3).setCellValue("剩余积分");
		row6.createCell(4).setCellValue("获得总积分券");
		row6.createCell(5).setCellValue("获得总次数");
		row6.createCell(6).setCellValue("剩余积分券");
		//先获取姓名和剩余积分 
		StringBuffer ygid=new StringBuffer();
		i=1;
		strsql="select nid,ygxm,jf from tbl_qyyg where qy="+session.getAttribute("qy")+" and  xtzt<>3 and zt=1";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			HSSFRow datarow=sheet6.createRow(i);
			ygid.append(rs.getString("nid")+",");
			datarow.createCell(0).setCellValue(rs.getString("ygxm"));
			datarow.createCell(3).setCellValue(rs.getInt("jf"));
			i=i+1;
		}
		rs.close();
		if (ygid!=null && ygid.length()>0)
		{
			String[] ygidarr=ygid.toString().split(",");
			for (int m=0;m<ygidarr.length;m++)
			{
				//总积分，积分次数
				strsql="select sum(c.ffjf),count(c.ffjf) from tbl_jfffmc c inner join tbl_jfff f on c.jfff=f.nid where c.hqr="+ygidarr[m]+" and c.sfff=1";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet6.getRow(m+1).createCell(1).setCellValue(rs.getInt(1));
					sheet6.getRow(m+1).createCell(2).setCellValue(rs.getInt(2));
				}
				rs.close();
				
				//总积分券，积分券次数
				strsql="select sum(c.ffjf),count(c.ffjf) from tbl_jfqffmc c inner join tbl_jfqff f on c.jfqff=f.nid where c.hqr="+ygidarr[m]+" and c.sfff=1";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet6.getRow(m+1).createCell(4).setCellValue(rs.getInt(1));
					sheet6.getRow(m+1).createCell(5).setCellValue(rs.getInt(2));
				}
				rs.close();
				
				//剩余积分券
				strsql="select count(nid) from tbl_jfqmc where qyyg="+ygidarr[m]+" and ffzt=1 and zt=0";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					sheet6.getRow(m+1).createCell(6).setCellValue(rs.getInt(1));					
				}
				rs.close();
			}
		}
		
		HSSFSheet sheet7=workbook.createSheet("	员工账户获得明细报表");	
		HSSFRow row7=sheet7.createRow(0);
		row7.createCell(0).setCellValue("姓名");	
		row7.createCell(1).setCellValue("类型");
		row7.createCell(2).setCellValue("获得来源");
		row7.createCell(3).setCellValue("发放名目");
		row7.createCell(4).setCellValue("领取时间");
		row7.createCell(5).setCellValue("获得数量");
		
		StringBuffer ygid2=new StringBuffer();
		StringBuffer ygxm2=new StringBuffer();
		
		strsql="select nid,ygxm from tbl_qyyg where qy="+session.getAttribute("qy")+" and  xtzt<>3 and zt=1";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			
			ygid2.append(rs.getString("nid")+",");
			ygxm2.append(rs.getString("ygxm")+"'");			
			
		}
		rs.close();
		i=0;
		if (ygid2!=null && ygid2.length()>0)
		{
			String[] ygidarr=ygid2.toString().split(",");
			String[] ygxmarr=ygxm2.toString().split("'");
			for (int m=0;m<ygidarr.length;m++)
			{				
				strsql="select m.ffly,m.ffjf,m.lqsj,m1.mmmc as mc1,m2.mmmc as mc2 from tbl_jfffmc m inner join tbl_jfff f on m.jfff=f.nid left join tbl_jfmm m1 on m1.nid=f.mm1 left join tbl_jfmm m2 on m2.nid=f.mm2 where m.hqr="+ygidarr[m];
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					HSSFRow datarow=sheet7.createRow(i+1);
					datarow.createCell(0).setCellValue(ygxmarr[m]);
					datarow.createCell(1).setCellValue("积分");
					datarow.createCell(2).setCellValue(rs.getString("ffly"));
					datarow.createCell(3).setCellValue(rs.getString("mc2")==null?rs.getString("mc1"):rs.getString("mc2"));
					datarow.createCell(4).setCellValue(rs.getString("lqsj")==null?"":sf2.format(rs.getDate("lqsj")));
					datarow.createCell(5).setCellValue(rs.getInt("ffjf"));
					i++;
				}
				rs.close();
				
				//积分券,因为要显示领取时间，所以只能每张积分券是一条记录
				strsql="select q.ffly,q.lqsj,m1.mmmc as mc1,m2.mmmc as mc2 from tbl_jfqmc q inner join tbl_jfqffmc m on q.jfqffmc=m.nid inner join tbl_jfqff f on m.jfqff=f.nid left join tbl_jfmm m1 on m1.nid=f.mm1 left join tbl_jfmm m2 on m2.nid=f.mm2 where q.qyyg="+ygidarr[m]+" and q.ffzt=1";
				if (soutdate!=null && soutdate.length()>0)
					strsql+=" and f.ffsj>='"+soutdate+"'";
				if (eoutdate!=null && eoutdate.length()>0)
					strsql+=" and f.ffsj<='"+eoutdate+" 23:59:59'";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
					HSSFRow datarow=sheet7.createRow(i+1);
					datarow.createCell(0).setCellValue(ygxmarr[m]);
					datarow.createCell(1).setCellValue("积分券");
					datarow.createCell(2).setCellValue(rs.getString("ffly"));
					datarow.createCell(3).setCellValue(rs.getString("mc2")==null?rs.getString("mc1"):rs.getString("mc2"));
					datarow.createCell(4).setCellValue(rs.getString("lqsj")==null?"":sf2.format(rs.getDate("lqsj")));
					datarow.createCell(5).setCellValue(1);
					i++;
				}
				rs.close();
				
			}
		}
		
		  OutputStream os;
		  String fileName = "HR报表"+sf.format(Calendar.getInstance().getTime())+".xls";
		  
		   
		  response.setHeader("Content-type","application/xls"); 
		   response.setHeader("Content-Disposition", "attachment;" + " filename="
		     + new String(fileName.getBytes(), "UTF-8"));
		   
		  
		   //response.setHeader("Content-Disposition", "attachment;filename=booking.xls"); 
		   response.setHeader("Content-Type", "application/vnd.ms-excel; charset=UTF-8");
		   
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