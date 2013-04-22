package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.PageDao;
import com.ssh.util.Page;

@Repository
public class PageDaoImpl implements PageDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(PageDaoImpl.class
			.getName());


	public List<Map<String,Object>> page(String sql,String page,String rp,String total) {
		String pagesql = Page.mysqlPageSql(sql, total, rp, page);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(pagesql);
		} catch (Exception e) {
			logger.error("PageDaoImpl--page", e);
		}
		return list;
	}
	
	public String getCount(String sql) {
		String total = "0";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("PageDaoImpl--getCount", e);
		}		
		if(list!=null&&list.size()>0){
			total = Long.toString((Long)list.get(0).get("count"));
		}
		return total;
	}
}
