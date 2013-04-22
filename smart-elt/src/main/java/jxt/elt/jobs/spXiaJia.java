package jxt.elt.jobs;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jxt.elt.common.DbPool;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;


//下架整个系列中库存量小于预警库存的系列
//以实际库存还是以未出单数量来判断

public class spXiaJia implements Job {
	
	public void execute(JobExecutionContext context)
			throws JobExecutionException {
			
		Connection conn=DbPool.getInstance().getConnection();
		try
		{
			Statement stmt=conn.createStatement();
					
			
			//按实际库存查找系列,
			String strsql="update tbl_spl set zt=0 where nid in (select spl from tbl_sp where kcsl<kcyj and spl not in (select spl from tbl_sp where kcsl>=kcyj and  spl in (select spl from tbl_sp where kcsl<kcyj)))";
			stmt.executeUpdate(strsql);
			
			
		}
		catch(Exception e)
		{			
			e.printStackTrace();
		}
		finally
		{
			try{
				if (!conn.isClosed())
					conn.close();
			}
			catch(SQLException ex){ex.printStackTrace();}
		}
	}

}
