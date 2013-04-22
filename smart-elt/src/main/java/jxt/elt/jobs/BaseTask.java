package jxt.elt.jobs;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jxt.elt.common.DbPool;

import org.quartz.CronScheduleBuilder;
import org.quartz.CronTrigger;
import org.quartz.Job;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;




public class BaseTask implements Job {
	

	private Connection con = null;
	private Statement stmt = null;
	private Statement stmt1 = null;

	private void task() {
		try {			
			SchedulerFactory taskFactory = new StdSchedulerFactory();
			Scheduler tasksched = taskFactory.getScheduler();
			con = DbPool.getInstance().getConnection();
			stmt = con.createStatement();
			stmt1 = con.createStatement();
			con.setAutoCommit(true);
			ResultSet rs_job = stmt.executeQuery("select nid,mc,pl,zc,zt,lm from tbl_task");

			while (rs_job.next()) {
				JobKey jk = new JobKey(rs_job.getString("mc"));			

				if (rs_job.getInt("zt") == 1) {
					if (!tasksched.checkExists(jk)) {
						Class c = Class.forName(rs_job.getString("lm"));
						JobDetail job = JobBuilder.newJob(c).withIdentity(
								rs_job.getString("mc")).build();
						CronTrigger trigger = TriggerBuilder.newTrigger()
								.withIdentity("T_" + rs_job.getString("mc"))
								.withSchedule(
										CronScheduleBuilder.cronSchedule(rs_job
												.getString("pl"))).startNow().build();
						tasksched.scheduleJob(job, trigger);

					} else {						
						
						if (rs_job.getInt("zc") == 1) {
							tasksched.deleteJob(jk);
							Class c = Class.forName(rs_job.getString("lm"));
							JobDetail job = JobBuilder.newJob(c).withIdentity(
									rs_job.getString("mc")).build();
							CronTrigger trigger = TriggerBuilder.newTrigger()
									.withIdentity("T_" + rs_job.getString("mc"))
									.withSchedule(
											CronScheduleBuilder.cronSchedule(rs_job
													.getString("pl"))).startNow().build();
							tasksched.scheduleJob(job, trigger);
							stmt1.executeUpdate("update tbl_task set zc = 0 where nid = "
											+ rs_job.getInt("nid"));

						}
					}

				} else {
					// ɾ����Ҫִ�е�job
					if (tasksched.checkExists(jk)) {
						tasksched.deleteJob(jk);
					}
				}
			}
		} catch (Exception e) {
		} finally {
			try {
				if (stmt != null) {
						stmt.close();
				}
				if (stmt1 != null) {
					stmt.close();
				}
				if (!con.isClosed()) {
					con.close();
				}
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void execute(JobExecutionContext context)
			throws JobExecutionException {
			task();			
	}

}
