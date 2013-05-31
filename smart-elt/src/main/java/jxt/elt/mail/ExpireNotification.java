package jxt.elt.mail;

import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jxt.elt.common.DbPool;
import jxt.elt.common.EmailTemplate;
import jxt.elt.common.SendEmailBean;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;

public class ExpireNotification {

	Connection connection;
	SendEmailBean sendEmailBean;

	public ExpireNotification() throws SQLException {
		connection = DbPool.getInstance().getConnection();
		connection.setAutoCommit(false);
		sendEmailBean = new SendEmailBean(0);
	}

	public void saveNotify(int i, String refId, String jfq, String content)
			throws SQLException {

		boolean exists = false;
		String ckexists = "select count(1) ct from tbl_expirynotify where refid="
				+ refId + " and jfq=" + jfq;
		Statement stmt = connection.createStatement();
		ResultSet rs = stmt.executeQuery(ckexists);
		while (rs.next()) {
			exists = rs.getInt("ct") > 0;
		}
		if (i == 1) {
			PreparedStatement statement = connection
					.prepareStatement("insert into  tbl_expirynotify (refid,jfq,firstnotifydate,content1) values (?,?,?,?)");
			statement.setString(1, refId);
			statement.setString(2, jfq);
			statement.setDate(3, new java.sql.Date(new Date().getTime()));
			statement.setString(4, content);
			statement.execute();

		} else {
			if (exists) {
				PreparedStatement statement = connection
						.prepareStatement("update tbl_expirynotify set secondnotifydate=?,content2=? where refid=? and jfq =?");
				statement.setDate(1, new java.sql.Date(new Date().getTime()));
				statement.setString(2, content);
				statement.setString(3, refId);
				statement.setString(4, jfq);

				statement.executeUpdate();
			} else {
				PreparedStatement statement = connection
						.prepareStatement("insert into  tbl_expirynotify (refid,jfq,secondnotifydate,content2) values (?,?,?,?)");
				statement.setString(1, refId);
				statement.setString(2, jfq);
				statement.setDate(3, new java.sql.Date(new Date().getTime()));
				statement.setString(4, content);
				statement.execute();
			}
		}
	}

	public int checkSend(Date compareDate, String refId, String jfq,
			Date hdExpireDate) throws SQLException {

		Date first = null;
		Date second = null;

		PreparedStatement statement = connection
				.prepareStatement("select firstnotifydate,secondnotifydate from tbl_expirynotify where refid=? and jfq=?");

		statement.setString(1, refId);
		statement.setString(2, jfq);

		ResultSet rs = statement.executeQuery();
		while (rs.next()) {
			first = rs.getDate("firstnotifydate");
			second = rs.getDate("secondnotifydate");
		}

		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");

		if (first == null
				&& fmt.format(compareDate).equals(fmt.format(hdExpireDate))) {
			return 1;
		}

		if (second == null) {

			Calendar hdcalendar = Calendar.getInstance();
			hdcalendar.setTime(hdExpireDate);
			hdcalendar.set(Calendar.HOUR_OF_DAY, 0);
			hdcalendar.set(Calendar.MINUTE, 0);
			hdcalendar.set(Calendar.SECOND, 0);
			hdcalendar.set(Calendar.MILLISECOND, 0);

			long lfirst = hdcalendar.getTime().getTime();

			Calendar fcalendar = Calendar.getInstance();
			fcalendar.setTime(compareDate);
			fcalendar.set(Calendar.HOUR_OF_DAY, 0);
			fcalendar.set(Calendar.MINUTE, 0);
			fcalendar.set(Calendar.SECOND, 0);
			fcalendar.set(Calendar.MILLISECOND, 0);
			long lcompareDate = fcalendar.getTime().getTime();

//			System.out.println("Range Day hdexpire:"
//					+ fmt.format(hdcalendar.getTime()) + " current:"
//					+ fmt.format(fcalendar.getTime()));
//			System.out.println("Range Day:" + (lcompareDate - lfirst)
//					/ (24 * 60 * 60 * 1000));
			if ((lcompareDate - lfirst) / (24 * 60 * 60 * 1000) >= 7) {

				return 2;
			}
		}

		return -1;
	}

	public void jiqExpireStaffNofify(Date runningDate) {

		//System.out.println("JFQ staff expire notification!");

		Map<String/* ygId */, Map<String, ExpireJfqVO>> map = new HashMap<String/* ygId */, Map<String, ExpireJfqVO>>();
		try {
			PreparedStatement statement = connection
					.prepareStatement("SELECT t.nid,t.jfq,t.qyyg, t.sysj,t.yxq,t.jfq,t.sflq,t.ffly,s.mc,t.ffyy,t.zt,hd.jssj FROM tbl_jfqmc t LEFT JOIN tbl_jfq s ON t.jfq = s.nid left join tbl_jfqhd hd ON hd.nid=s.hd WHERE t.sysj IS NULL AND t.ffzt =1 AND hd.jssj>=? and hd.jssj<?");

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(runningDate);
			calendar.set(Calendar.HOUR_OF_DAY, 0);
			calendar.set(Calendar.MINUTE, 0);
			calendar.set(Calendar.SECOND, 0);
			calendar.set(Calendar.MILLISECOND, 0);

			// 　以当天运行为基准，七天前过期的活动
			calendar.add(Calendar.DAY_OF_MONTH, -7);
			Date rangeFrom = calendar.getTime();

			// 活动结束时间小于明天　／／过期活动条件
			calendar.add(Calendar.DAY_OF_MONTH, 8);
			Date rangeTo = calendar.getTime();

			statement.setDate(1, new java.sql.Date(rangeFrom.getTime()));
			statement.setDate(2, new java.sql.Date(rangeTo.getTime()));

			ResultSet rs = statement.executeQuery();
			while (rs.next()) {
				String yg = rs.getString("qyyg");
				if (!map.containsKey(yg)) {
					map.put(yg, new HashMap<String, ExpireJfqVO>());
				}

				String jfqId = rs.getString("jfq");
				if (map.get(yg).keySet().contains(jfqId)) {
					int quantity = map.get(yg).get(jfqId).getQuantity();
					map.get(yg).get(jfqId).setQuantity(quantity + 1);
				} else {
					ExpireJfqVO vo = new ExpireJfqVO();
					vo.setExpireDate(rs.getDate("yxq"));
					vo.setName(rs.getString("mc"));

					vo.setHdExpireDate(rs.getDate("jssj"));

					vo.setQuantity(1);
					vo.setRefId(yg);
					vo.setJfqId(jfqId);
					map.get(yg).put(jfqId, vo);
				}
			}

			//System.out.println("Staff size: " + map.size());
			for (String ygId : map.keySet()) {
				List<ExpireJfqVO> expires = new ArrayList<ExpireJfqVO>();

				Map<String, ExpireJfqVO> jfqmap = map.get(ygId);

				for (String key : jfqmap.keySet()) {
					ExpireJfqVO vo = jfqmap.get(key);
					if (vo != null) {
						int verify = checkSend(runningDate, vo.getRefId(),
								vo.getJfqId(), vo.getHdExpireDate());
						if (verify > 0) {
							expires.add(vo);
//							System.out
//									.println("@@save staff refId: "
//											+ vo.getRefId() + " jfqId:"
//											+ vo.getJfqId());
							saveNotify(verify, vo.getRefId(), vo.getJfqId(), "");
						}
					}
				}

				// send mail .
				String name = "";
				String email = "";

				PreparedStatement st = connection
						.prepareStatement("select ygxm,email from tbl_qyyg where nid=?");
				st.setInt(1, Integer.valueOf(ygId));
				ResultSet staff = st.executeQuery();
				while (staff.next()) {
					name = staff.getString("ygxm");
					email = staff.getString("email");
				}

				if ((expires != null) && (expires.size() > 0)) {
					sendMailByNew(email, "0", ygId,
							"jfqstaffexpirenotify.vm", name,
							expires);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
			System.err
					.println("Runing YG jfq expire notification error,That error msg is: "
							+ e.getMessage());
		} finally {
			try {
				connection.commit();
				connection.close();
			} catch (SQLException e) {
				connection = null;
			}
		}
	}

	// public static void main(String[] arg) {
	//
	// Calendar calendar = Calendar.getInstance();
	// calendar.set(Calendar.HOUR_OF_DAY, 0);
	// calendar.set(Calendar.MINUTE, 0);
	// calendar.set(Calendar.SECOND, 0);
	// calendar.set(Calendar.MILLISECOND, 0);
	//
	// SimpleDateFormat fmt = new SimpleDateFormat(
	// "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
	//
	// System.out.println("####1" + fmt.format(calendar.getTime()));
	//
	// calendar.add(Calendar.DAY_OF_MONTH, 1);
	// System.out.println("####2" + fmt.format(calendar.getTime()));
	//
	// Date fdate = new Date();
	// try {
	// fmt = new SimpleDateFormat("yyyy-MM-dd");
	//
	// fdate = fmt.parse("2010-12-18");
	//
	// Date cdate = new Date();
	// cdate = fmt.parse("2010-12-25");
	//
	// long lfirst = fdate.getTime();
	//
	// long lcompareDate = cdate.getTime();
	//
	// if ((lcompareDate - lfirst) / 24 * 60 * 60 * 1000 >= 7) {
	// //System.out.println(">=7" + "value:" + (lcompareDate - lfirst)
	// // / (24 * 60 * 60 * 1000));
	// } else {
	// System.out.println("<7");
	// }
	// } catch (ParseException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// }

	public void sendMail(String mailTo, String qyId, String ygId,
			String tempalte, String name, List<ExpireJfqVO> expiryList) {
		try {

			VelocityContext context = new VelocityContext();
			context.put("name", name);
			context.put("expiryList", expiryList);

			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			context.put("fmt", fmt);

			Template template = Velocity.getTemplate(tempalte);
			StringWriter sw = new StringWriter();
			template.merge(context, sw);
			String mailContent = sw.toString();

			//System.out.println("mail to: " + mailTo);
			//System.out.println("mail content: " + mailContent);

			sendEmailBean.sendHtmlEmail(mailTo, mailContent, "福利券到期提醒");

			// SimpleDateFormat sf2 = new SimpleDateFormat("yyyy-MM-dd");
			// String strsql =
			// "insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'')";
			// PreparedStatement pstm = connection.prepareStatement(strsql);
			// pstm.setString(1, qyId);
			// pstm.setString(2, ygId);
			// pstm.setString(3, mailTo);
			// pstm.setString(4, "积分券到期提醒");
			// pstm.setString(5, mailContent);
			// pstm.setString(6, sf2.format(Calendar.getInstance().getTime()));
			// pstm.setString(7, "2");
			// pstm.setString(8, "0");
			// pstm.setString(9, "0");
			//
			// pstm.executeUpdate();
			// pstm.close();

		} catch (Exception e) {
			throw new IllegalStateException(e);
		}
	}


public void sendMailByNew(String mailTo, String qyId, String ygId, String tempalte, String name, List<ExpireJfqVO> expiryList)
  {
    try {
      VelocityContext context = new VelocityContext();
      context.put("name", name);
      context.put("expiryList", expiryList);

      SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
      context.put("fmt", fmt);

      Template template = EmailTemplate.getTemplate(tempalte);
      StringWriter sw = new StringWriter();
      template.merge(context, sw);
      String mailContent = sw.toString();

      this.sendEmailBean.sendHtmlEmail(mailTo, mailContent, "福利券到期提醒");
    }
    catch (Exception e)
    {
      throw new IllegalStateException(e);
    }
  }

	public void jiqExpireHrNofify(Date runningDate) {

		//System.out.println("Entrying jiqExpireHrNofify!");

		Map<String/* qyId */, Map<String, ExpireJfqVO>> map = new HashMap<String, Map<String, ExpireJfqVO>>();
		try {
			PreparedStatement statement = connection
					.prepareStatement("select jfq.nid jfq, mc.qy, jfq.mc,jfq.yxq,(mc.sl-mc.ffsl) quantity,hd.jssj from tbl_jfqddmc as mc,tbl_jfqdd as dd,tbl_jfq as jfq,tbl_jfqhd hd WHERE mc.jfqdd=dd.nid and mc.jfq=jfq.nid and hd.nid=jfq.hd and mc.sl>mc.ffsl and mc.zt=1 and hd.jssj>=? and hd.jssj<?");

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(runningDate);
			calendar.set(Calendar.HOUR_OF_DAY, 0);
			calendar.set(Calendar.MINUTE, 0);
			calendar.set(Calendar.SECOND, 0);
			calendar.set(Calendar.MILLISECOND, 0);

			// 　以当天运行为基准，七天前过期的活动
			calendar.add(Calendar.DAY_OF_MONTH, -7);
			Date rangeFrom = calendar.getTime();

			// 活动结束时间小于明天　／／过期活动条件
			calendar.add(Calendar.DAY_OF_MONTH, 8);
			Date rangeTo = calendar.getTime();

			statement.setDate(1, new java.sql.Date(rangeFrom.getTime()));
			statement.setDate(2, new java.sql.Date(rangeTo.getTime()));
			ResultSet rs = statement.executeQuery();
			while (rs.next()) {
				String qy = rs.getString("qy");
				if (!map.containsKey(qy)) {
					map.put(qy, new HashMap<String, ExpireJfqVO>());
				}

				String jfq = rs.getString("jfq");
				int qt = rs.getInt("quantity");
				if (map.get(qy).keySet().contains(jfq)) {
					int tl = map.get(qy).get(jfq).getQuantity();
					map.get(qy).get(jfq).setQuantity(tl + qt);
				} else {
					ExpireJfqVO vo = new ExpireJfqVO();
					vo.setExpireDate(rs.getDate("yxq"));
					vo.setName(rs.getString("mc"));
					vo.setQuantity(qt);
					vo.setRefId(qy);
					vo.setJfqId(jfq);
					vo.setHdExpireDate(rs.getDate("jssj"));
					map.get(qy).put(jfq, vo);
				}
			}

			//System.out.println("Hr size:" + map.size());
			for (String qy : map.keySet()) {
				List<ExpireJfqVO> expirejfqs = new ArrayList<ExpireJfqVO>();
				for (String jfq : map.get(qy).keySet()) {
					ExpireJfqVO vo = map.get(qy).get(jfq);
					int verify = checkSend(runningDate, vo.getRefId(),
							vo.getJfqId(), vo.getHdExpireDate());
					if (verify > 0) {
						expirejfqs.add(vo);
						//System.out.println("##verify refId:" + vo.getRefId()
						//		+ " jfqId:" + vo.getJfqId());
						saveNotify(verify, vo.getRefId(), vo.getJfqId(), "");
					}
				}
				// send mail .
				// send mail .
				String name = "";
				String email = "";

				PreparedStatement st = connection
						.prepareStatement("select lxr,lxremail from tbl_qy where nid=?");
				st.setInt(1, Integer.valueOf(qy));
				ResultSet staff = st.executeQuery();
				while (staff.next()) {
					name = staff.getString("lxr");
					email = staff.getString("lxremail");
				}
				if ((expirejfqs != null) && (expirejfqs.size() > 0)) {
					sendMailByNew(email, qy, "0",
							"jfqhrexpirenotify.vm", name,
							expirejfqs);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
			System.err
					.println("Runing HR jfq expire notification error,That error msg is: "
							+ e.getMessage());
		} finally {
			try {
				connection.commit();
				connection.close();
			} catch (SQLException e) {
				connection = null;
			}
		}
	}
}
