package com.ssh.action;


import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.dao.TblSpDao;
import com.ssh.dao.TblSplDao;
import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblShdz;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblSpl;
import com.ssh.entity.TblYgddmx;
import com.ssh.entity.TblYgddzb;
import com.ssh.service.DdService;
import com.ssh.service.JfqService;
import com.ssh.service.QyygService;
import com.ssh.service.ShdzService;
import com.ssh.service.SpService;
import com.ssh.util.DateUtil;

@Controller
@Results( { @Result(name = "success", location = "/jsp/dd/comfirm.jsp"),
	@Result(name = "pay", location = "/jsp/dd/pay.jsp"),
	@Result(name = "detail", location = "/jsp/dd/detail.jsp"),
	@Result(name = "list", location = "/jsp/dd/list.jsp"),
	@Result(name = "payrs", location = "/jsp/dd/result.jsp")})
public class DdAction extends BaseAction {
	
	private static final long serialVersionUID = 857508946370915324L;
	private static Logger logger = Logger
			.getLogger(DdAction.class.getName());
	
	@Resource
	private DdService ddserv;
	@Resource
	private SpService spserv;
	@Resource
	private JfqService jfqserv;
	@Resource
	private QyygService qyyg;	
	@Resource
	private ShdzService shdzserv;	
	@Resource
	private TblSpDao tspDao;
	@Resource
	private TblSplDao tsplDao;

	private TblJfqmc jfqmc;
	private TblYgddzb ddzb;
	private String crddh;
	private String payrs;
	private int crdid;
	private int rs;
	private String bz;
	private String splist;
	private String dhlist;
	private String sllist;
	private int zjf;
	private double zje;
	private int zjfqsl;
	private int ddshdz;
	private TblQyyg user;
	private String dhfs;
	private int sl;
	private int jfqmcid;
	
	public void setDdzb(TblYgddzb ddzb) {
		this.ddzb = ddzb;
	}
	public TblYgddzb getDdzb() {
		return ddzb;
	}
	public void setCrdid(int crdid) {
		this.crdid = crdid;
	}
	public int getCrdid() {
		return crdid;
	}
	public void setCrddh(String crddh) {
		this.crddh = crddh;
	}
	public void setPayrs(String payrs) {
		this.payrs = payrs;
	}
	public String getPayrs() {
		return payrs;
	}
	public String getCrddh() {
		return crddh;
	}
	public void setRs(int rs) {
		this.rs = rs;
	}
	public int getRs() {
		return rs;
	}
	public String getBz() {
		return bz;
	}
	public void setBz(String bz) {
		this.bz = bz;
	}
	public String getSplist() {
		return splist;
	}
	public void setSplist(String splist) {
		this.splist = splist;
	}
	public String getDhlist() {
		return dhlist;
	}
	public void setDhlist(String dhlist) {
		this.dhlist = dhlist;
	}
	public String getSllist() {
		return sllist;
	}
	public void setSllist(String sllist) {
		this.sllist = sllist;
	}
	public int getZjf() {
		return zjf;
	}
	public void setZjf(int zjf) {
		this.zjf = zjf;
	}
	public double getZje() {
		return zje;
	}
	public void setZje(double zje) {
		this.zje = zje;
	}
	public int getZjfqsl() {
		return zjfqsl;
	}
	public void setZjfqsl(int zjfqsl) {
		this.zjfqsl = zjfqsl;
	}
	public int getDdshdz() {
		return ddshdz;
	}
	public void setDdshdz(int ddshdz) {
		this.ddshdz = ddshdz;
	}

	public void setUser(TblQyyg user) {
		this.user = user;
	}
	public TblQyyg getUser() {
		return user;
	}
	public void setSl(int sl) {
		this.sl = sl;
	}
	public int getSl() {
		return sl;
	}
	public void setDhfs(String dhfs) {
		this.dhfs = dhfs;
	}
	public String getDhfs() {
		return dhfs;
	}

	public void setJfqmc(TblJfqmc jfqmc) {
		this.jfqmc = jfqmc;
	}
	public TblJfqmc getJfqmc() {
		return jfqmc;
	}
	public void setJfqmcid(int jfqmcid) {
		this.jfqmcid = jfqmcid;
	}
	public int getJfqmcid() {
		return jfqmcid;
	}
	public String list() {
		TblQyyg tyg = (TblQyyg) session.get("user");
		setUser(qyyg.findById(tyg.getNid()));
		return "list";
	}
	
	public String confirm() {
		TblQyyg tyg = (TblQyyg) session.get("user");
		setUser(qyyg.findById(tyg.getNid()));
		return SUCCESS;
	}

	public String jfqdh() {
		TblQyyg tyg = (TblQyyg) session.get("user");
		setUser(qyyg.findById(tyg.getNid()));
		setSplist(splist);
		if(dhlist!=null&&!dhlist.equals("")){
			setJfqmc(jfqserv.findById(Integer.parseInt(dhlist)));
		}
		return "jfqdh";
	}
	
	public String detail(){
		ddzb = ddserv.findZbByDdh(crddh);
		return "detail";
	}
	
	public String gopay(){
		setCrddh(crddh);
		TblQyyg tyg = (TblQyyg) session.get("user");
		if(ddserv.findZbByDdh(crddh).getYg().intValue()!=tyg.getNid().intValue()){
			setPayrs("支付失败，订单没有找到。");
			return "payrs";
		}
		TblYgddzb zbc = ddserv.findZbByDdh(crddh);
		setCrddh(zbc.getDdh());
		setCrdid(zbc.getNid());
		setZje(zbc.getZje());
		setZjf(zbc.getZjf());
		setZjfqsl(zbc.getJfqsl());
		return "pay";
		
	}
	public String pay(){
		setCrddh(crddh);
		TblQyyg tyg = (TblQyyg) session.get("user");
		if(ddserv.findZbByDdh(crddh).getYg().intValue()!=tyg.getNid().intValue()){
			setPayrs("支付失败，订单没有找到。");
			return "payrs";
		}
		int ddprs = ddserv.pay(crddh);	
		if(ddprs==5){
			setPayrs("支付成功。");
		}
		if(ddprs==1){
			setPayrs("支付失败，现金支付结果未获取。");
		}
		if(ddprs==2){
			setPayrs("支付失败，剩余积分不足。");
		}
		if(ddprs==3){
			setPayrs("支付失败，剩余积分券不足。");
		}
		if(ddprs==4){
			setPayrs("支付失败，商品库存不足。");
		}
		this.setSplist(ddserv.getSps(crddh));
		return "payrs";
	}
	

	public String create() {
		boolean jfEnough = false;
		boolean jfqEnough = true;
		String[] tsp = splist.split(",");
		String[] tdh = dhlist.split(",");
		String[] tsl = sllist.split(",");
		Map<String,Long> jfqmap = new HashMap<String,Long>(); 
		Map<String,Long> jfqyfmap = new HashMap<String,Long>(); 
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		if(user.getJf()>=zjf){
			jfEnough = true;
		}
		if(dhlist.indexOf("jfq")==-1){
			jfqEnough = true;
		}
		else{
			List<Map<String, Object>> jfqlist = jfqserv.getJfqs(user.getNid());
			for(Map<String, Object> l:jfqlist){
				jfqmap.put(Long.toString((Long)l.get("jfq")), (Long) l.get("jfqcount"));
			}
			for(int i=0;i<tdh.length;i++){
				if(tdh[i].indexOf("jfq")!=-1){
					String yfjfq = tdh[i].substring(3);
					if(jfqyfmap.get(yfjfq)==null){
						jfqyfmap.put(yfjfq, Long.parseLong(tsl[i]));
					}
					else if(jfqyfmap.get(yfjfq)!=null){
						jfqyfmap.put(yfjfq, jfqyfmap.get(yfjfq)+Long.parseLong(tsl[i]));
					}
				}
			}
			for(Map.Entry<String, Long> entry : jfqyfmap.entrySet()){
				if(jfqmap.get(entry.getKey())==null||jfqmap.get(entry.getKey())<entry.getValue()){
						jfqEnough = false; 
						break;
					}				
			}
		}
		if(jfEnough&&jfqEnough){
			String ddh = DateUtil.dateToStr(DateUtil.yyyyMMddHHmmss, new Date())+user.getNid();
			TblYgddzb zb = new TblYgddzb();
			TblShdz shdzinfo = shdzserv.findById(ddshdz);
			zb.setCjrq(new Timestamp(System.currentTimeMillis()));
			zb.setDdh(ddh);
			zb.setState(0);
			zb.setZje(zje);
			zb.setZjf(zjf);
			zb.setJfqsl(zjfqsl);
			zb.setYg(user.getNid());
			zb.setShdz(ddshdz);
			zb.setShdzxx("<b>收货人：</b>"+shdzinfo.getShr()+"   <b>电话号码：</b>"+shdzinfo.getDh()+"<br /><b>地址：</b>"+shdzinfo.getSheng()+" "
					+shdzinfo.getShi()+" "+shdzinfo.getQu()+" "+shdzinfo.getDz()+" "+shdzinfo.getYb()+" ");
			zb.setDdbz(bz);
			ddserv.save(zb);
			TblYgddzb zbc = ddserv.findZbByDdh(ddh);
			
			TblYgddmx[] mxs = new TblYgddmx[tsp.length];
			for(int j=0;j<tsp.length;j++){				
				int spid = Integer.parseInt(tsp[j]);
				int sl = Integer.parseInt(tsl[j]);
				TblSp tblsp = spserv.findSpById(spid);
				mxs[j] = new TblYgddmx();
				mxs[j].setYg(user.getNid());
				mxs[j].setDd(zbc.getNid());
				mxs[j].setSp(tblsp.getNid());
				mxs[j].setSl(sl);
				mxs[j].setState(0);
				mxs[j].setDdh(ddh);
				mxs[j].setSpl(tblsp.getSpl());
				if(tdh[j].indexOf("jfq")!=-1){
					mxs[j].setJfq(Integer.parseInt(tdh[j].substring(3)));
				}
				else if(tdh[j].indexOf("_")!=-1){
					mxs[j].setJf(sl*Integer.parseInt(tdh[j].substring(0,tdh[j].indexOf("_"))));
					mxs[j].setJe(sl*Double.parseDouble(tdh[j].substring(tdh[j].indexOf("_")+1,tdh[j].length())));
				}
				else if(tdh[j]!=""){
					mxs[j].setJf(sl*Integer.parseInt(tdh[j]));
				}
			}
			ddserv.save(mxs);
			setCrddh(zbc.getDdh());
			setCrdid(zbc.getNid());
			setZje(zbc.getZje());
			setZjf(zbc.getZjf());
			setZjfqsl(zbc.getJfqsl());
			return "pay";
		}
		else {
			setRs(1);
			return "jfqdh";
		}
	}
}
