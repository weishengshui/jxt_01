package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.SpDao;
import com.ssh.dao.TblSpDao;
import com.ssh.dao.TblSplDao;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblSpl;
import com.ssh.service.SpService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class SpImpl implements SpService{
	@Resource
	private SpDao spDao;
	@Resource
	private TblSpDao tspDao;
	@Resource
	private TblSplDao tsplDao;
	public List<Map<String, Object>> getTjsp(Long jf, int limit){
		return spDao.getTjsp(jf, limit);
	}
	public List<Map<String, Object>> getRmsp(int limit){
		return spDao.getRmsp(limit);
	}
	public List<Map<String, Object>> getSpByJfq(String jfq){
		if(SecurityUtil.sqlCheck(jfq)) return null;
		String param = " AND r.jfq = "+jfq;
		return spDao.getSpByJfq(param);
	}

	public List<Map<String, Object>> getSpBySpJfq(int jfq,int sp) {
		String param = " AND r.jfq = "+jfq+"  AND r.sp = "+sp;
		return spDao.getSpByJfq(param);
	}
	public List<Map<String, Object>> getSplb1() {
		return spDao.getSplb1();
	}
	//热门推荐
	public List<Map<String, Object>> getSplb2() {
		return spDao.getSplb2();
	}
	public List<Map<String, Object>> getFkqd(String param, int limit) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getFkqd(param, limit);
	}
	public List<Map<String, Object>> getNew(String param,int limit){
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getNew(param, limit);
	}
	public List<Map<String,Object>> pagesp(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.page(spDao.pageSqlsp(param), page, rp, this.countsp(param));
	}
	public String countsp (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getCount(spDao.countSqlsp(param));
	}
	public List<Map<String,Object>> pagespl(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.page(spDao.pageSqlspl(param), page, rp, this.countspl(param));
	}
	public String countspl (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getCount(spDao.countSqlspl(param));
	}
	public List<Map<String,Object>> pagetszd(String order,int qy,int yg,String page,String rp) {
		String param = " AND t.qy = "+qy+" AND t.nid != "+yg  + order;
		return spDao.page(spDao.pageSqltszd(param), page, rp, this.counttszd(qy,yg));
	}
	public String counttszd (int qy,int yg) {
		String param = " AND t.qy = "+qy+" AND t.nid != "+yg;
		return spDao.getCount(spDao.countSqltszd(param));
	}
	public List<Map<String,Object>> pagezjll(String order,int yg,String page,String rp) {
		String param = " AND t.yg = "+yg + order;
		return spDao.page(spDao.pageSqlzjll(param), page, rp, this.countzjll(yg));
	}
	public String countzjll (int yg) {
		String param = " AND t.yg = "+yg;
		return spDao.getCount(spDao.countSqlzjll(param));
	}
	public List<Map<String,Object>> pagetjsp(String order,String jf,String page,String rp) {
		String param = " AND s.qbjf <= "+jf + order;
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.page(spDao.pageSqltjsp(param), page, rp, this.counttjsp(jf));
	}
	public String counttjsp (String jf) {
		String param = " AND s.qbjf <= "+jf;
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getCount(spDao.countSqltjsp(param));
	}
	public List<Map<String,Object>> pagermdh(String param,String page,String rp) {
		return spDao.page(spDao.pageSqlrmdh(param), page, rp, this.countrmdh(param));
	}
	public String countrmdh (String param) {
		return spDao.getCount(spDao.countSqlrmdh(param));
	}
	public List<Map<String,Object>> pagezshy(String order,int xb,String page,String rp) {
		String param = " AND u.xb = "+xb;
		return spDao.page(spDao.pageSqlzshy(param,order), page, rp, this.countzshy(xb));
	}
	public String countzshy (int xb) {
		String param = " AND u.xb = "+xb;
		return spDao.getCount(spDao.countSqlzshy(param));
	}
	public List<Map<String,Object>> pagetszk(String query,int qy,int yg,String page,String rp) {
		String param = " AND t.qy = "+qy+" AND t.nid != "+yg+query;
		return spDao.page(spDao.pageSqltszk(param), page, rp, this.counttszk(qy,yg));
	}
	public String counttszk (int qy,int yg) {
		String param = " AND t.qy = "+qy+" AND t.nid != "+yg;
		return spDao.getCount(spDao.countSqltszk(param));
	}
	public TblSp findSpById(Integer id) {
		return tspDao.find(id);
	}
	public TblSpl findSplById(Integer id) {
		return tsplDao.find(id);
	}

	public List<Map<String, Object>> getSplInfo(String spl) {
		String param = " AND t.nid = "+spl;
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getSplInfo(param);
	}
	
	public List<Map<String, Object>> getSpInfo(String sp) {
		String param = " AND t.nid = "+sp;
		if(SecurityUtil.sqlCheck(param)) return null;
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getSpInfo(param);
	}

	public List<Map<String, Object>> getSpBySpl(String spl) {
		String param = " AND t.spl = "+spl;
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getSpInfo(param);
	}
	
	public List<Map<String, Object>> getDhfs(int sp) {
		String param = " AND t.sp = " + sp;
		return spDao.getDhfs(param);
	}

	public List<Map<String, Object>> getSpsDhfs(String sps) {
		String param = " AND t.sp in (" + sps +")";
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getDhfs(param);
	}
	
	public List<Map<String, Object>> getGmsp(String sps, int limit) {
		return spDao.getGmsp(sps, limit);
	}
	public List<Map<String, Object>> getSpQuery(String sps){
		String param = " AND t.nid in (" + sps +")  ORDER BY FIND_IN_SET(t.nid, '"+sps+"')";
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getSpQuery(param);
	}

	public List<Map<String, Object>> getSpTp(String sp) {
		String param = " AND t.sp = "+sp;
		if(SecurityUtil.sqlCheck(param)) return null;
		return spDao.getSpTp(param);
	}
	public List<Map<String, Object>> getLmxsl(int lm, int limit) {
		String param = " AND t.lb3 = "+lm +" order by t.ydsl desc";
		return spDao.querySpl(param, limit);
	}
	public List<Map<String, Object>> getLmtjw(int lm,int jf, int limit) {
		String param = " AND t.lb3 = "+lm +" and (s.qbjf - "+jf+" <=100" +
				" or  "+jf+"- s.qbjf <= 100) order by s.qbjf";
		return spDao.querySpl(param, limit);
	}
}
