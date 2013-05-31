package com.ssh.base;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class SqlDao {
	@Autowired
	private DataSource dataSource;

	public DataSource executeTestSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public List<Map<String, Object>> query(final String sql)
			throws Exception {
		 Map<Integer,String> namemap = new HashMap<Integer,String>();
		return this.query(sql, namemap);
	}

	public List<Map<String, Object>> query(final String sql,final Map<Integer,String> namemap)
			throws Exception {
		final List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			JdbcTemplate jt = new JdbcTemplate(executeTestSource());
			jt.query(sql, new RowCallbackHandler() {
				public void processRow(ResultSet rs) throws SQLException {
					ResultSetMetaData rsmd = rs.getMetaData();
					int cols = rsmd.getColumnCount();
					do {
						Map<String, Object> map = new HashMap<String, Object>();
						for (int i = 1; i <= cols; i++) {
							String tabName = rsmd.getColumnName(i)
									.toLowerCase();
							if (namemap.get(i) != null)
								tabName = (String) namemap.get(i);
							Object txt = rs.getObject(i);
							if (txt == null) {
								txt = "";
							}
							map.put(tabName, txt);
						}
						list.add(map);
					} while (rs.next());
				}
			});

		} catch (Exception e) {
			throw new Exception("System e exception: " + e.getMessage());
		}
		return list;
	}
	public int update(String sql) throws Exception {
		int result = 0;
		try {
			JdbcTemplate jt = new JdbcTemplate(executeTestSource());
			result = jt.update(sql);
		} catch (Exception e) {
			throw new Exception("System e exception: " + e.getMessage());
		}
		return result;
	}

	@Transactional(propagation = Propagation.REQUIRED)
	public int update(String[] sql) {
		int result = 0;
		JdbcTemplate jt = new JdbcTemplate(executeTestSource());
		for (int i = 0; i < sql.length; i++) {
			result += jt.update(sql[i]);
		}
		return result;
	}
}
