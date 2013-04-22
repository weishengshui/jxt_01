package jxt.elt.mail;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class ExpiryNotifyJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		Date date = new Date();
		System.out.println("###Entrying expiry job set up at: "
				+ new SimpleDateFormat("yyyy.MM.dd G 'at' HH:mm:ss z").format(date));
		try {
			new ExpireNotification().jiqExpireHrNofify(date);
		} catch (Exception e) {
			System.err.println("Running hr notify error!");
			e.printStackTrace();
		}

		try {
			new ExpireNotification().jiqExpireStaffNofify(date);
		} catch (Exception e) {
			System.err.println("Running staff notify error!");
			e.printStackTrace();
		}

		try {
			new TransferExpiredJFQ().staffJfq(date);
		} catch (Exception e) {
			System.err.println("Running staff expire transfer error!");
			e.printStackTrace();
		}

		try {
			new TransferExpiredJFQ().qyjfq(date);
		} catch (Exception e) {
			System.err.println("Running qy jfq expire transfer error!");
			e.printStackTrace();
		}
		System.out.println("###End expiry job!");
	}

}
