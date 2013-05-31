package jxt.elt.jobs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import jxt.elt.common.DbPool;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

//积分和积分券定时发放
//积分券过期回收

public class JfSend implements Job {

	public void execute(JobExecutionContext context)
			throws JobExecutionException {

		Connection conn = DbPool.getInstance().getConnection();

		try {
			conn.setAutoCommit(false);
			Statement stmt = conn.createStatement();
			ResultSet rs = null;

			StringBuffer qystr = new StringBuffer();
			StringBuffer jfstr = new StringBuffer();
			StringBuffer jfupid = new StringBuffer();
			StringBuffer jfqupid = new StringBuffer();
			// 积分发放,修改发放状态，员工积分在员工端领取时才更新表,这里更新冻结积分
			// 按企业分组冻结积分，这里部门发放没有定时所以不用考虑
			String strsql = "select m.qy,sum(m.ffjf) as djjf from tbl_jfffmc m inner join tbl_jfff f on m.jfff=f.nid where m.ffsj<SYSDATE() and m.sfff=0 and f.ffzt=0 group by m.qy";

			rs = stmt.executeQuery(strsql);
			while (rs.next()) {
				qystr.append(rs.getString("qy") + ",");
				jfstr.append(rs.getString("djjf") + ",");
			}
			rs.close();

			// 更新冻结积分
			if (qystr != null && qystr.length() > 0) {
				String[] qyarr = qystr.toString().split(",");
				String[] jfarr = jfstr.toString().split(",");
				for (int i = 0; i < qyarr.length; i++) {
					if (qyarr[i] != null && qyarr[i].length() > 0) {
						strsql = "update tbl_qy set djjf=djjf-" + jfarr[i]
								+ " where nid=" + qyarr[i];
						stmt.executeUpdate(strsql);
					}
				}

				// 取要更改明细中的编号
				strsql = "select m.nid from tbl_jfffmc m inner join tbl_jfff f on m.jfff=f.nid where m.ffsj<SYSDATE() and m.sfff=0 and f.ffzt=0";
				rs = stmt.executeQuery(strsql);
				while (rs.next()) {
					if (rs.isLast())
						jfupid.append(rs.getString("nid"));
					else
						jfupid.append(rs.getString("nid") + ",");
				}
				rs.close();

				// 更新发放总表中的状态
				strsql = "update tbl_jfff set ffzt=1 where ffzt=0 and nid in (select jfff from tbl_jfffmc where  ffsj<SYSDATE() and sfff=0 group by jfff)";
				stmt.executeUpdate(strsql);

				// 更新明细中发放状态
				strsql = "update tbl_jfffmc set sfff=1 where nid in ("
						+ jfupid.toString() + ")";
				stmt.executeUpdate(strsql);

			}

			// --------------------------------------------
			// 积分券发放

			// 更改冻结数量
			StringBuffer qy = new StringBuffer();
			StringBuffer jfq = new StringBuffer();
			StringBuffer ffjf = new StringBuffer();
			strsql = "select m.qy,m.jfq,m.ffjf from tbl_jfqffmc m inner join tbl_jfqff f on m.jfqff=f.nid where m.ffsj<SYSDATE() and m.sfff=0 and f.ffzt=0";
			System.out.println(strsql);
			rs = stmt.executeQuery(strsql);
			while (rs.next()) {
				qy.append(rs.getString("qy") + ",");
				jfq.append(rs.getString("jfq") + ",");
				ffjf.append(rs.getString("ffjf") + ",");
			}
			rs.close();

			if (qy != null && qy.length() > 0) {
				String[] qya = qy.toString().split(",");
				String[] jfqa = jfq.toString().split(",");
				String[] ffjfa = ffjf.toString().split(",");
				int nid = 0, djsl = 0, oneffjf = 0;
				for (int i = 0; i < qya.length; i++) {
					if ((jfqa[i] == null) || (jfqa.length <= 0))
						continue;
					oneffjf = Integer.valueOf(ffjfa[i]).intValue();
					while (oneffjf > 0) {
						nid = 0;
						djsl = 0;
						strsql = "select nid,sl,ffsl,djsl from tbl_jfqddmc where qy="
								+ qya[i]
								+ " and jfq="
								+ jfqa[i]
								+ " and zt=1 and djsl>0 order by nid limit 1";

						rs = stmt.executeQuery(strsql);
						if (rs.next()) {
							nid = rs.getInt("nid");
							djsl = rs.getInt("djsl");
						}
						rs.close();

						if (djsl >= oneffjf) {
							strsql = "update tbl_jfqddmc set djsl=djsl-"
									+ ffjfa[i] + " where nid=" + nid;

							stmt.executeUpdate(strsql);
						} else {
							strsql = "update tbl_jfqddmc set djsl=0 where nid="
									+ nid;

							stmt.executeUpdate(strsql);
						}

						oneffjf -= djsl;

						if (djsl == 0) {
							break;
						}
					}
				}

				// 更新积分券明细表
				strsql = "update tbl_jfqmc set ffzt=1 where jfqffmc in (select nid from (select m.nid from tbl_jfqffmc m inner join tbl_jfqff f on m.jfqff=f.nid where m.ffsj<SYSDATE() and m.sfff=0 and f.ffzt=0) a)";
				stmt.executeUpdate(strsql);

				// 获取发放明细表编号
				strsql = "select m.nid from tbl_jfqffmc m inner join tbl_jfqff f on m.jfqff=f.nid where m.ffsj<SYSDATE() and m.sfff=0 and f.ffzt=0";
				rs = stmt.executeQuery(strsql);
				while (rs.next()) {
					if (rs.isLast())
						jfqupid.append(rs.getString("nid"));
					else
						jfqupid.append(rs.getString("nid") + ",");
				}
				rs.close();

				// 更改发放总表
				strsql = "update tbl_jfqff set ffzt=1 where ffzt=0 and nid in (select jfqff from tbl_jfqffmc where  ffsj<SYSDATE() and sfff=0 group by jfqff)";
				stmt.executeUpdate(strsql);

				// 更改明细表
				strsql = "update tbl_jfqffmc set sfff=1 where nid in ("
						+ jfqupid.toString() + ")";
				stmt.executeUpdate(strsql);

			}

			// ---------------------------------------------------------
			// 过期未售出积分券回收库存
			// 过期未使用（包括未发放）的未处理

			// 活动过期归还未使用积分券库存 modified by windy
			//System.out.println("HD expired, updating warehourse ..");
			StringBuffer jfqstr = new StringBuffer();
			StringBuffer jfqnstr = new StringBuffer();

			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.DAY_OF_MONTH, 1);
			strsql = "select jfq,count(*) as jfqn from tbl_jfqmc mc where zt=0 and qy=0 and exists(select 1 from tbl_jfqhd hd inner join tbl_jfq jfq on hd.nid=jfq.hd where jfq.nid=mc.jfq and (hd.jssj>((curdate() +INTERVAL 1 day) -INTERVAL 30 MINUTE) or (to_days(curdate())-to_days(hd.jssj))>=1) and hd.jssj<'"
					+ fmt.format(calendar.getTime()) + "')  group by jfq";

			//System.out.println(strsql);

			rs = stmt.executeQuery(strsql);
			while (rs.next()) {
				jfqstr.append(rs.getString(1) + ",");
				jfqnstr.append(rs.getString(2) + ",");
			}
			rs.close();

			if (jfqstr != null && jfqstr.length() > 0) {
				String[] jfqarr = jfqstr.toString().split(",");
				String[] jfqnarr = jfqnstr.toString().split(",");
				for (int i = 0; i < jfqarr.length; i++) {
					if ((jfqarr[i] == null) || (jfqarr[i].length() <= 0)) {
						continue;
					}
					List<Spvo> sps = new ArrayList<Spvo>();
					ResultSet sprs = stmt
							.executeQuery("select sp.nid,sp.kcsl,sp.wcdsl from tbl_jfqspref ref right join tbl_sp sp on sp.nid=ref.sp where ref.jfq="
									+ jfqarr[i] + "");

					while (sprs.next()) {
						sps.add(new Spvo(sprs.getInt("nid"), sprs
								.getInt("kcsl"), sprs.getInt("wcdsl")));
					}

					for (Spvo sp : sps) {
						strsql = "update tbl_sp set kcsl=?,wcdsl=? where nid=?";

						PreparedStatement pstatmt = conn
								.prepareStatement(strsql);

						pstatmt.setInt(1,
								Integer.parseInt(jfqnarr[i]) + sp.getKcsl());

						pstatmt.setInt(2,
								Integer.parseInt(jfqnarr[i]) + sp.getWcdsl());

						pstatmt.setInt(3, sp.getSpId());

						pstatmt.executeUpdate();
					}

					strsql = "select kcsl from tbl_jfq where nid =" + jfqarr[i];
					ResultSet jfqrs = stmt.executeQuery(strsql);
					int kcsl = 0;
					while (jfqrs.next()) {
						kcsl = jfqrs.getInt("kcsl");
					}
					PreparedStatement updateJFQSt = conn
							.prepareStatement("update tbl_jfq set kcsl=? where nid =?");

					int newkcsl = kcsl - Integer.parseInt(jfqnarr[i]) < 0 ? 0
							: kcsl - Integer.parseInt(jfqnarr[i]);
					updateJFQSt.setInt(1, newkcsl);
					updateJFQSt.setInt(2, Integer.parseInt(jfqarr[i]));
					updateJFQSt.executeUpdate();

					strsql = "update tbl_jfqmc set zt=7 where zt=0 and qy=0 and jfq="
							+ jfqarr[i];

					stmt.executeUpdate(strsql);
				}
			}

			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (Exception ee) {
			}
		} finally {
			try {
				if (!conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

}
