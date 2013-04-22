package jxt.elt.jobs;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jxt.elt.common.DbPool;
import jxt.elt.common.SendEmailBean;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.mysql.jdbc.PreparedStatement;


//邮件发送
//发送失败后没有再次处理
public class EmailSending implements Job {
	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
			
		Connection conn=DbPool.getInstance().getConnection();
		
		try
		{
			conn.setAutoCommit(false);			
			Statement stmt=conn.createStatement();
			ResultSet rs=null;
			
			String nid="",jsyx="",bt="",nr="";
			Boolean szt=false;
			String strsql="select nid,jsyx,bt,nr from tbl_yjdf where ljfs=1 order by fsdj desc limit 1";			
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{				
				
				nid=rs.getString(1);
				jsyx=rs.getString(2);
				bt=rs.getString(3);
				nr=rs.getString(4);				
			}
			rs.close();
			
			if (jsyx!=null && jsyx.length()>0)
			{
				SendEmailBean seb=new SendEmailBean();
				szt=seb.sendHtmlEmail(jsyx,nr, bt);				
				if (szt)
					strsql="insert into tbl_yjyf (qy,yg,fsyx,jsyx,bt,nr,fssj,fslx,fsdj,fszt) select qy,yg,fsyx,jsyx,bt,nr,now(),fslx,fsdj,1 from tbl_yjdf where nid="+nid;
				else
					strsql="insert into tbl_yjyf (qy,yg,fsyx,jsyx,bt,nr,fssj,fslx,fsdj,fszt) select qy,yg,fsyx,jsyx,bt,nr,now(),fslx,fsdj,0 from tbl_yjdf where nid="+nid;
				
				
				stmt.executeUpdate(strsql);
				stmt.executeUpdate("delete from tbl_yjdf where nid="+nid);
				
			}
			
			conn.commit();
			
			
		}
		catch(Exception e)
		{			
			e.printStackTrace();
			try
			{
				conn.rollback();				
			}
			catch(Exception ee){}
		}
		finally
		{
			try{
				if (!conn.isClosed())
				{					
					conn.close();
				}
			}
			catch(SQLException ex){ex.printStackTrace();}
		}
	}

}
