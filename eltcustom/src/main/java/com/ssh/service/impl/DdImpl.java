package com.ssh.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.genericdao.search.Search;
import com.ssh.dao.DdDao;
import com.ssh.dao.JfqDao;
import com.ssh.dao.JfqmcDao;
import com.ssh.dao.QyygDao;
import com.ssh.dao.TblPayDao;
import com.ssh.dao.TblSpDao;
import com.ssh.dao.TblSplDao;
import com.ssh.dao.TblYgddmxDao;
import com.ssh.dao.TblYgddzbDao;
import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblPay;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblSpl;
import com.ssh.entity.TblYgddmx;
import com.ssh.entity.TblYgddzb;
import com.ssh.service.DdService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class DdImpl implements DdService{
	@Resource
	private DdDao ddDao;
	@Resource
	private TblYgddmxDao ygddmxDao;
	@Resource
	private TblYgddzbDao ygddzbDao;
	@Resource
	private JfqmcDao jfqmcDao;
	@Resource
	private QyygDao qyygDao;
	@Resource
	private TblPayDao payDao;
	@Resource
	private JfqDao jfqDao;
	@Resource
	private TblSpDao tspDao;
	@Resource
	private TblSplDao tsplDao;
	


	public List<Map<String,Object>> page(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return ddDao.page(ddDao.pageSql(param), page, rp, this.count(param));
	}
	
	public String count (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  ddDao.getCount(ddDao.countSql(param));
	}
	
	public List<Map<String, Object>> getJfdhjl(String yg, int limit) {
		if(SecurityUtil.sqlCheck(yg)) return null;
		return ddDao.getJfdhjl(yg, limit);
	}

	public List<Map<String, Object>> getJfqdhjl(String yg, int limit) {
		if(SecurityUtil.sqlCheck(yg)) return null;
		return ddDao.getJfqdhjl(yg, limit);
	}

	public List<Map<String, Object>> getTsmsp(int yg, int qy, int limit) {
		return ddDao.getTsmsp(yg, qy, limit);
	}
	public List<Map<String, Object>> getZshy(String param, int limit){
		if(SecurityUtil.sqlCheck(param)) return null;
		return ddDao.getZshy(param, limit);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblYgddmx mx) {
		return ygddmxDao.save(mx);
	}
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
    public boolean[] save(TblYgddmx[] mx) {
		return ygddmxDao.save(mx);
	}
    public TblYgddmx findMxById(Integer id) {
		return ygddmxDao.find(id);
	}
    public TblYgddmx[] findMxByIds(Integer[] ids) {
		return ygddmxDao.find(ids);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblYgddzb zb) {
		return ygddzbDao.save(zb);
	}
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
    public boolean[] save(TblYgddzb[] zb) {
		return ygddzbDao.save(zb);
	}
    public TblYgddzb findZbById(Integer id) {
		return ygddzbDao.find(id);
	}
    public TblYgddzb[] findZbByIds(Integer[] ids){
		return ygddzbDao.find(ids);
	}

	public TblYgddzb findZbByDdh(String ddh) {
		Search search = new Search(TblYgddzb.class);
		search.setDistinct(true);
		search.addFilterEqual("ddh", ddh);
		return ygddzbDao.searchUnique(search);
	}

	public List<Map<String, Object>> getXdsp(int yg,int dd, int limit) {
		String param = " AND t.yg = "+yg +" AND t.dd = "+dd;
		return ddDao.getXdsp(param, limit);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public int vertify(String ddh) {
		
		TblYgddzb zb = this.findZbByDdh(ddh);
		if (zb == null || zb.getState() != 0)
			return 0;
		TblQyyg user = qyygDao.find(zb.getYg());
		if (user.getJf() < zb.getZjf())
			return 2;
		Map<String,Integer> jfqyfmap = new HashMap<String,Integer>();
		Map<String,Long> jfqmap = new HashMap<String,Long>();
		Search mxsearch = new Search(TblYgddmx.class);
		mxsearch.addFilterEqual("ddh", ddh);
		List<TblYgddmx> mxlist = ygddmxDao.search(mxsearch);
		for(TblYgddmx mx : mxlist){
			TblSp tsp = tspDao.find(mx.getSp());
			if(tsp.getWcdsl()<mx.getSl()) return 4;
			if(mx.getJfq()!=null&&mx.getJfq()>0){
				String yfjfq = Integer.toString(mx.getJfq());
				if(jfqyfmap.get(yfjfq)==null){
					jfqyfmap.put(yfjfq, mx.getSl());
				}
				else if(jfqyfmap.get(yfjfq)!=null){
					jfqyfmap.put(yfjfq, jfqyfmap.get(yfjfq)+mx.getSl());
				}
			}
		}
		String param = " AND t.qyyg = " + user.getNid();
		List<Map<String, Object>> jfqlist = jfqDao.getJfqs(param);
		for(Map<String, Object> l:jfqlist){
			jfqmap.put(Long.toString((Long)l.get("jfq")), (Long) l.get("jfqcount"));
		}
		for(Map.Entry<String, Integer> entry : jfqyfmap.entrySet()){
			if(jfqmap.get(entry.getKey())==null||jfqmap.get(entry.getKey())<entry.getValue()){
				return 3;	
			}				
		}
		return 5;
	};
		
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public int pay(String ddh) {
		
		TblYgddzb zb = this.findZbByDdh(ddh);
		if (zb == null || zb.getState() != 0)
			return 0;
		if(zb.getZje()>0){
			TblPay p = payDao.find(ddh);
			if (p == null || p.getStatus() != 1)
				return 1;			
		}
		TblQyyg user = qyygDao.find(zb.getYg());
		if (user.getJf() < zb.getZjf())
			return 2;
		Map<String,Integer> jfqyfmap = new HashMap<String,Integer>();
		Map<String,Long> jfqmap = new HashMap<String,Long>();
		Search mxsearch = new Search(TblYgddmx.class);
		mxsearch.addFilterEqual("ddh", ddh);
		List<TblYgddmx> mxlist = ygddmxDao.search(mxsearch);
		for(TblYgddmx mx : mxlist){
			TblSp tsp = tspDao.find(mx.getSp());
			if(tsp.getWcdsl()<mx.getSl()) return 4;
			if(mx.getJfq()!=null&&mx.getJfq()>0){
				String yfjfq = Integer.toString(mx.getJfq());
				if(jfqyfmap.get(yfjfq)==null){
					jfqyfmap.put(yfjfq, mx.getSl());
				}
				else if(jfqyfmap.get(yfjfq)!=null){
					jfqyfmap.put(yfjfq, jfqyfmap.get(yfjfq)+mx.getSl());
				}
			}
		}
		String param = " AND t.qyyg = " + user.getNid();
		List<Map<String, Object>> jfqlist = jfqDao.getJfqs(param);
		for(Map<String, Object> l:jfqlist){
			jfqmap.put(Long.toString((Long)l.get("jfq")), (Long) l.get("jfqcount"));
		}
		for(Map.Entry<String, Integer> entry : jfqyfmap.entrySet()){
			if(jfqmap.get(entry.getKey())==null||jfqmap.get(entry.getKey())<entry.getValue()){
				return 3;	
			}				
		}
		
		Timestamp tsnow = new Timestamp(System.currentTimeMillis());
		zb.setJsrq(tsnow);
		zb.setState(1);
		user.setJf(user.getJf()-zb.getZjf());
		TblYgddmx[] ddmx = new TblYgddmx[mxlist.size()];
		int mxpos = 0;
		for(TblYgddmx mx : mxlist){
			mx.setState(1);
			mx.setJssj(tsnow);
			ddmx[mxpos++] = mx;
		}
		List<TblJfqmc> jfqmclist = new ArrayList<TblJfqmc>();
		for(Map.Entry<String, Integer> entry : jfqyfmap.entrySet()){
			String jfq = entry.getKey();
			Integer jfqsl = entry.getValue();
			Search jfqsearch = new Search(TblJfqmc.class);
			jfqsearch.addFilterEqual("jfq", jfq);
			jfqsearch.addFilterEqual("zt", 0);
			jfqsearch.addFilterEqual("sflq", 1);
			jfqsearch.addFilterEqual("qyyg", user.getNid());
			jfqsearch.addFilterGreaterOrEqual("yxq", new Timestamp(System.currentTimeMillis()-24*3600*1000));
			jfqsearch.addSortAsc("yxq");
			jfqsearch.setMaxResults(jfqsl);
			List<TblJfqmc> tlist = jfqmcDao.search(jfqsearch);
			for(TblJfqmc tblmc:tlist){
				tblmc.setZt(1);
				tblmc.setDdh(ddh);
				tblmc.setSysj(tsnow);
				jfqmclist.add(tblmc);
			}
		}
		TblJfqmc[] jfqmcs = new TblJfqmc[jfqmclist.size()];
		int jmcpos = 0;
		for(TblJfqmc jmc:jfqmclist){
			jfqmcs[jmcpos++] = jmc;
		}
		for(TblYgddmx mx : mxlist){
			TblSp tsp = tspDao.find(mx.getSp());
			TblSpl tspl = tsplDao.find(tsp.getSpl());
			if(mx.getJfq()==null||mx.getJfq()==0){
				tsp.setWcdsl(tsp.getWcdsl()-mx.getSl());
			}
			tsp.setXsl(tsp.getXsl()+mx.getSl());
			tspl.setYdsl(tspl.getYdsl()+mx.getSl());
			tspDao.save(tsp);
			tsplDao.save(tspl);
		}
		jfqmcDao.save(jfqmcs);
		qyygDao.save(user);
		ygddzbDao.save(zb);
		ygddmxDao.save(ddmx);
		return 5;
	}

	public String getSps(String ddh) {
		String sps ="";
		Search mxsearch = new Search(TblYgddmx.class);
		mxsearch.addFilterEqual("ddh", ddh);
		List<TblYgddmx> mxlist = ygddmxDao.search(mxsearch);
		if(mxlist.size()>0){
			for(TblYgddmx mx : mxlist){
				sps +=mx.getSp()+",";
			}
			sps = sps.substring(0, sps.length()-1);
		}
		return sps;
	}

	public List<Map<String, Object>> getDdMx(int yg, String ddh) {
		if(SecurityUtil.sqlCheck(ddh)) return null;
		String param = " AND t.yg = "+yg +" AND t.ddh = "+ddh;
		return ddDao.getDdsp(param);
	}

	public List<TblYgddzb> findZbByYg(Integer yg) {
		Search search = new Search(TblYgddzb.class);
		search.addFilterEqual("yg", yg);
		search.addSortDesc("ddh");
		return ygddzbDao.search(search);
	}

	public List<TblYgddmx> findMxByDdh(String ddh) {
		Search search = new Search(TblYgddmx.class);
		search.addFilterEqual("ddh", ddh);
		search.addSortDesc("ddh");
		return ygddmxDao.search(search);
	}

	public List<Map<String, Object>> getDdByDdh(int yg,String dds) {
		if(SecurityUtil.sqlCheck(dds)) return null;
		String param = " AND t.yg = "+yg +" AND t.dd in (" +dds+") order by ddh desc";
		return ddDao.getDdsp(param);
	}

	public List<Map<String, Object>> getDdZb(int yg,String query) {
		if(SecurityUtil.sqlCheck(query)) return null;
		String param = " AND t.yg = "+yg+" "+query+" order by ddh desc";
		return ddDao.getDdZb(param);
	}

	public List<Map<String, Object>> getDdspl(int yg,String ddh) {
		if(SecurityUtil.sqlCheck(ddh)) return null;
		String param = " AND t.yg = "+yg+" AND t.ddh = '"+ddh+"'";
		return ddDao.getDdspl(param);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public int cancel(String ddh) {
		int rs = 0;
		TblYgddzb ddzb = this.findZbByDdh(ddh);
		if(ddzb.getState()!=0){
			return rs;
		}
		ddzb.setState(9);
		List<TblYgddmx> lmx = this.findMxByDdh(ddh);
		TblYgddmx[] ddmxs = new TblYgddmx[lmx.size()];
		for(int i =0;i<lmx.size();i++){
			lmx.get(i).setState(9);
			ddmxs[i]=lmx.get(i);
		}
		ygddzbDao.save(ddzb);
		ygddmxDao.save(ddmxs);
		rs = 2;
		return rs;
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public int pingjia(String ddh) {
		int rs = 0;
		TblYgddzb ddzb = this.findZbByDdh(ddh);
		if(ddzb.getState()!=4&&ddzb.getState()!=3){
			return rs;
		}
		ddzb.setState(5);
		List<TblYgddmx> lmx = this.findMxByDdh(ddh);
		TblYgddmx[] ddmxs = new TblYgddmx[lmx.size()];
		for(int i =0;i<lmx.size();i++){
			lmx.get(i).setState(5);
			ddmxs[i]=lmx.get(i);
		}
		ygddzbDao.save(ddzb);
		ygddmxDao.save(ddmxs);
		rs = 2;
		return rs;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public int confirm(String ddh) {
		int rs = 0;
		TblYgddzb ddzb = this.findZbByDdh(ddh);
		if(ddzb.getState()!=2&&ddzb.getState()!=3){
			return rs;
		}
		Timestamp tsnow = new Timestamp(System.currentTimeMillis());
		ddzb.setShrq(tsnow);
		ddzb.setState(4);
		List<TblYgddmx> lmx = this.findMxByDdh(ddh);
		TblYgddmx[] ddmxs = new TblYgddmx[lmx.size()];
		for(int i =0;i<lmx.size();i++){
			lmx.get(i).setState(4);
			ddmxs[i]=lmx.get(i);
		}
		ygddzbDao.save(ddzb);
		ygddmxDao.save(ddmxs);
		rs = 2;
		return rs;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public int remind(String ddh) {
		int rs = 0;
		TblYgddzb ddzb = this.findZbByDdh(ddh);
		if(ddzb.getState()!=1){
			return rs;
		}
		ddzb.setState(11);
		List<TblYgddmx> lmx = this.findMxByDdh(ddh);
		TblYgddmx[] ddmxs = new TblYgddmx[lmx.size()];
		for(int i =0;i<lmx.size();i++){
			lmx.get(i).setState(11);
			ddmxs[i]=lmx.get(i);
		}
		ygddzbDao.save(ddzb);
		ygddmxDao.save(ddmxs);
		rs = 2;
		return rs;
	}

	public List<Map<String, Object>> getDdCount(int yg) {
		String param = " AND yg = "+yg;
		return ddDao.getDdCount(param);
	}
}
