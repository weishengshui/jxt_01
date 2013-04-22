package jxt.elt.mail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Date;

import jxt.elt.common.DbPool;

public class TransferExpiredJFQ {

	Connection connection;

	public TransferExpiredJFQ() throws SQLException {
		connection = DbPool.getInstance().getConnection();
		connection.setAutoCommit(false);
	}

	public void staffJfq(Date runningDate) {

		//System.out.println("JFQ staff expire notification!");

		try {
			// yxq , ffly->发放来源 ffyy->发放缘由
			PreparedStatement statement = connection
					.prepareStatement("select mc.nid,mc.qy,mc.qyyg,mc.ffly,mc.ffyy,mc.jfq,jfq.jf,jfq.mc from tbl_jfqmc mc,tbl_jfq jfq where mc.jfq=jfq.nid and mc.qy<>0 and mc.zt=0 and mc.ffzt=1 and (mc.yxq>((curdate() +INTERVAL 1 day) -INTERVAL 30 MINUTE) or (to_days(curdate())-to_days(mc.yxq))>=1) and mc.yxq<?");

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(runningDate);
			calendar.set(Calendar.HOUR_OF_DAY, 0);
			calendar.set(Calendar.MINUTE, 0);
			calendar.set(Calendar.SECOND, 0);
			calendar.set(Calendar.MILLISECOND, 0);

			calendar.add(Calendar.DAY_OF_MONTH, 1);
			Date dateflag = calendar.getTime();

			statement.setDate(1, new java.sql.Date(dateflag.getTime()));

			ResultSet rs = statement.executeQuery();

			PreparedStatement creationst = connection
					.prepareStatement("insert into tbl_jfffmc (qy,hqr,ffjf,ffsj,sfff,ffly,sflq,bz,ffyy,ref) values (?,?,?,?,?,?,1,?,?,?)");
			PreparedStatement updatest = connection
					.prepareStatement("update tbl_jfqmc set zt=7 where nid =?");

			PreparedStatement queryAccount = connection
					.prepareStatement("select nid,jf from tbl_qyyg where nid =?");
			PreparedStatement updateAccount = connection
					.prepareStatement("update tbl_qyyg set jf= ? where nid =?");
			while (rs.next()) {

				//System.out.println("###staffJfq nid :" + rs.getInt("nid"));

				// update disable
				updatest.setInt(1, rs.getInt("nid"));

				// insert transfer jfq to jf
				creationst.setInt(1, rs.getInt("qy"));
				creationst.setInt(2, rs.getInt("qyyg"));
				creationst.setInt(3, rs.getInt("jf"));
				creationst.setDate(4, new java.sql.Date(new Date().getTime()));
				creationst.setInt(5, 1);
				creationst.setString(6, rs.getString("ffly"));// rs.getString("ffly")
				
				creationst.setString(7, "福利券  \""+rs.getString("mc")+"\" 过期转换成积分");// 备注
				creationst.setString(8, rs.getString("ffyy"));// 名目
				creationst.setString(9, rs.getString("nid"));// 转入积分券明细Id
				
				//库存回收
				int jfqnid = rs.getInt("jfq");
				Statement stmt = connection.createStatement();
				String strsql="update tbl_sp set kcsl=kcsl+1,wcdsl=wcdsl+1 where nid in (select sp from tbl_jfqspref where jfq="+jfqnid+")";
				stmt.executeUpdate(strsql);
				
				//修改积分券库存  XXX 以发放给员工的积分券过期不更新积分券的库存
				//				strsql="update tbl_jfq set kcsl=kcsl-1 where nid="+jfqnid;
				//				stmt.executeUpdate(strsql);
				//　库存回收结束
				
				//
				int jf = 0;
				queryAccount.setInt(1, rs.getInt("qyyg"));
				ResultSet accrs = queryAccount.executeQuery();
				while (accrs.next()) {
					jf = accrs.getInt("jf");
					//System.out.println("###staffJfq jf :" + jf);
				}

				updateAccount.setInt(1, jf + rs.getInt("jf"));
				updateAccount.setInt(2, rs.getInt("qyyg"));

				updatest.executeUpdate();
				creationst.execute();
				updateAccount.executeUpdate();
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

	public void qyjfq(Date runningDate) {

		//System.out.println("Entrying qyjfq!");
		try {
			PreparedStatement statement = connection
					.prepareStatement("select mc.nid from tbl_jfqddmc as mc,tbl_jfq as jfq WHERE mc.jfq=jfq.nid and mc.sl>mc.ffsl and mc.zt=1 and (jfq.yxq>((curdate() +INTERVAL 1 day) -INTERVAL 30 MINUTE) or (to_days(curdate())-to_days(jfq.yxq))>=1) and jfq.yxq<?");

			PreparedStatement updateStatement = connection
					.prepareStatement("update tbl_jfqddmc set zt=7 where nid=?");

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(runningDate);
			calendar.set(Calendar.HOUR_OF_DAY, 0);
			calendar.set(Calendar.MINUTE, 0);
			calendar.set(Calendar.SECOND, 0);
			calendar.set(Calendar.MILLISECOND, 0);

			calendar.add(Calendar.DAY_OF_MONTH, 1);
			Date flagDate = calendar.getTime();
			statement.setDate(1, new java.sql.Date(flagDate.getTime()));

			ResultSet rs = statement.executeQuery();
			while (rs.next()) {
				//System.out.println("### tbl_jfqddmc nid: " + rs.getInt("nid"));
				updateStatement.setInt(1, rs.getInt("nid"));

				updateStatement.executeUpdate();
			}
			//System.out.println("###End QY expired jfq");
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println("Runing qyjfq expire error,That error msg is: "
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
