package jxt.elt.jobs;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import jxt.elt.common.DbPool;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class FlqXiaJia
  implements Job
{
  public void execute(JobExecutionContext context)
    throws JobExecutionException
  {
    Connection conn = DbPool.getInstance().getConnection();
    try {
      Statement stmt = conn.createStatement();
      String strsql = "update tbl_jfq set zt=0 where kcsl=0";
      stmt.executeUpdate(strsql);
    } catch (Exception ex) {
      ex.printStackTrace();
    } finally {
      try {
        if (!conn.isClosed())
          conn.close();
      } catch (SQLException ex) {
        ex.printStackTrace();
      }
    }
  }
}