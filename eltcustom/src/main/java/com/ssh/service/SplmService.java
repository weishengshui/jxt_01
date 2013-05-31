package com.ssh.service;

import com.ssh.dao.impl.SpDaoImpl;
import com.ssh.entity.TblSplm;
import com.ssh.util.DbPool;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.apache.log4j.Logger;

public class SplmService {
	private static Logger logger = Logger.getLogger(SpDaoImpl.class.getName());

	public static List<TblSplm> listSplm() {
		List<TblSplm> list = new ArrayList<TblSplm>();
		Connection conn = null;
		try {
			conn = DbPool.getInstance().getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = null;
			String sql = "SELECT t1.nid lm1, t1.mc lm1mc, t1.xswz lm1wz, t1.lmtp lm1tp,  t2.nid lm2, t2.mc lm2mc, t2.xswz lm2wz, t3.nid lm3, t3.mc lm3mc, t3.xswz lm3wz  FROM tbl_splm t1  LEFT JOIN tbl_splm t2 ON t2.flm=t1.nid and t2.sfxs=1  LEFT JOIN tbl_splm t3 ON t3.flm=t2.nid and t3.sfxs=1  WHERE t1.flm=0 and t1.sfxs=1  GROUP BY t1.nid, t2.nid, t3.nid, t1.mc, t1.lmtp, t2.mc, t3.mc";

			rs = stmt.executeQuery(sql);
			int lastlm1 = 0;
			int lastlm2 = 0;
			int lastlm3 = 0;
			while (rs.next()) {
				if (rs.getInt("lm1") != 0) {
					if (rs.getInt("lm1") != lastlm1) {
						TblSplm lm1 = new TblSplm();
						lm1.setNid(Integer.valueOf(rs.getInt("lm1")));
						lm1.setMc(rs.getString("lm1mc"));
						lm1.setLmtp(rs.getString("lm1tp"));
						lm1.setXswz(Integer.valueOf(rs.getInt("lm1wz")));
						List lm1Children = new ArrayList();
						lm1.setChildren(lm1Children);
						list.add(lm1);

						if (rs.getInt("lm2") != 0) {
							if (rs.getInt("lm2") != lastlm2) {
								TblSplm lm2 = new TblSplm();
								lm2.setNid(Integer.valueOf(rs.getInt("lm2")));
								lm2.setMc(rs.getString("lm2mc"));
								lm2.setXswz(Integer.valueOf(rs.getInt("lm2wz")));
								List lm2Children = new ArrayList();
								lm2.setChildren(lm2Children);
								lm1.getChildren().add(lm2);

								if ((rs.getInt("lm3") != 0)
										&& (rs.getInt("lm3") != lastlm3)) {
									TblSplm lm3 = new TblSplm();
									lm3.setNid(Integer.valueOf(rs.getInt("lm3")));
									lm3.setMc(rs.getString("lm3mc"));
									lm3.setXswz(Integer.valueOf(rs
											.getInt("lm3wz")));
									lm2.getChildren().add(lm3);
								}

							} else if ((rs.getInt("lm3") != 0)
									&& (rs.getInt("lm3") != lastlm3)) {
								TblSplm lm3 = new TblSplm();
								lm3.setNid(Integer.valueOf(rs.getInt("lm3")));
								lm3.setMc(rs.getString("lm3mc"));
								lm3.setXswz(Integer.valueOf(rs.getInt("lm3wz")));
								((TblSplm) lm1.getChildren().get(
										lm1.getChildren().size() - 1))
										.getChildren().add(lm3);
							}
						}
					} else {
						List lastLm1Children = ((TblSplm) list
								.get(list.size() - 1)).getChildren();
						if (rs.getInt("lm2") != 0) {
							if (rs.getInt("lm2") != lastlm2) {
								TblSplm lm2 = new TblSplm();
								lm2.setNid(Integer.valueOf(rs.getInt("lm2")));
								lm2.setMc(rs.getString("lm2mc"));
								lm2.setXswz(Integer.valueOf(rs.getInt("lm2wz")));
								List lm2Children = new ArrayList();
								lm2.setChildren(lm2Children);
								lastLm1Children.add(lm2);
							}
							if ((rs.getInt("lm3") != 0)
									&& (rs.getInt("lm3") != lastlm3)) {
								TblSplm lm3 = new TblSplm();
								lm3.setNid(Integer.valueOf(rs.getInt("lm3")));
								lm3.setMc(rs.getString("lm3mc"));
								lm3.setXswz(Integer.valueOf(rs.getInt("lm3wz")));
								((TblSplm) lastLm1Children.get(lastLm1Children
										.size() - 1)).getChildren().add(lm3);
							}
						}

					}

					lastlm1 = rs.getInt("lm1");
					lastlm2 = rs.getInt("lm2");
					lastlm3 = rs.getInt("lm3");
				}
			}
			rs.close();
		} catch (Exception e) {
			logger.error("SplmService--listSplm", e);
		} finally {
			try {
				if ((conn != null) && (!conn.isClosed()))
					conn.close();
			} catch (Exception e) {
				logger.error("SplmService--listSplm", e);
			}
		}
		Collections.sort(list);
		for (TblSplm lm1 : list) {
			Collections.sort(lm1.getChildren());
			for (TblSplm lm2 : lm1.getChildren()) {
				Collections.sort(lm2.getChildren());
			}
		}
		return list;
	}
}