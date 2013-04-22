package jxt.elt.common;

import java.io.IOException;

import javax.servlet.GenericServlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import jxt.elt.jobs.BaseTask;
import jxt.elt.mail.ExpiryNotifyJob;

import org.apache.velocity.app.Velocity;
import org.apache.velocity.app.VelocityEngine;
import org.quartz.CronScheduleBuilder;
import org.quartz.CronTrigger;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;

public class TriggerServer extends GenericServlet {

	private static final long serialVersionUID = 280204297004452974L;

	// Log logger = LogFactory.getLog(this.getClass());

	public void init(ServletConfig config) throws ServletException {

		try {
			JobDetail job = JobBuilder.newJob(BaseTask.class)
					.withIdentity("basejob", "basegroup").build();

			CronTrigger trigger = TriggerBuilder
					.newTrigger()
					.withIdentity("basetrigger", "basegroup")
					.withSchedule(
							CronScheduleBuilder.cronSchedule("0 0/1 * * * ?"))

					.startNow().build();
			SchedulerFactory sf = new StdSchedulerFactory();
			Scheduler sched = sf.getScheduler();
			sched.scheduleJob(job, trigger);

			// XXX 启动积分券过期提醒job
			// "0 30 23 * * ?"
			/** 先屏蔽*/ 
			CronTrigger expireTrigger = TriggerBuilder
					.newTrigger()
					.withIdentity("expireTrigger", "basegroup")
					.withSchedule(
							CronScheduleBuilder.cronSchedule("0 50 23 * * ?"))
					.startNow().build();
			Scheduler expireScheduler = sf.getScheduler();
			expireScheduler.scheduleJob(JobBuilder
					.newJob(ExpiryNotifyJob.class).build(), expireTrigger);
			 
		} catch (Exception e) {
			e.printStackTrace();
		}

		// init velocity
		try {
			System.out.println("initilizating velocity template engine!");
			Velocity.setProperty("resource.loader", "class");
			Velocity.setProperty("class.resource.loader.class",
					"org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader");
			Velocity.setProperty(Velocity.ENCODING_DEFAULT, "utf-8");
			Velocity.setProperty(Velocity.INPUT_ENCODING, "utf-8");
			Velocity.setProperty(Velocity.OUTPUT_ENCODING, "utf-8");

			// disable velocity log output .
			Velocity.setProperty(Velocity.RUNTIME_LOG_LOGSYSTEM_CLASS,
					"org.apache.velocity.runtime.log.NullLogChute");

			Velocity.init();
			// logger.info("velocity template engine configed success alreadly!");
		} catch (Exception e) {
			e.printStackTrace();
			System.err
					.println("Init Velocity error,some system templates maybe miss!");
		}
	}

	public String getServletInfo() {
		return "";
	}

	public void service(ServletRequest arg0, ServletResponse arg1)
			throws ServletException, IOException {

	}

}
