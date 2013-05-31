package com.ssh.service;

import com.ssh.util.DbPool;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class QyService {
	public static int getQyJf(int qy) {
		int qyjf = 0;
		Connection conn = null;
		try {
			conn = DbPool.getInstance().getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = null;
			String strsql = "SELECT jf FROM tbl_qy where nid=" + qy;
			rs = stmt.executeQuery(strsql);
			if (rs.next()) {
				qyjf = rs.getInt("jf");
				rs.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if ((conn != null) && (!conn.isClosed()))
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return qyjf;
	}

	public static int updateQyJf(int qy, int qyjf) {
		Connection conn = null;
		try {
			conn = DbPool.getInstance().getConnection();
			Statement stmt = conn.createStatement();
			String strsql = "UPDATE tbl_qy SET jf=" + qyjf + " where nid=" + qy;
			int i = stmt.executeUpdate(strsql);
			return i;
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if ((conn != null) && (!conn.isClosed()))
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return 0;
	}
}