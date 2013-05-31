package com.ssh.action;

import com.ssh.base.BaseAction;
import com.ssh.dao.TblSpDao;
import com.ssh.dao.TblSplDao;
import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblShdz;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblYgddmx;
import com.ssh.entity.TblYgddzb;
import com.ssh.service.DdService;
import com.ssh.service.JfqService;
import com.ssh.service.QyService;
import com.ssh.service.QyygService;
import com.ssh.service.ShdzService;
import com.ssh.service.SpService;
import com.ssh.util.DateUtil;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

@Controller
@Results({
		@org.apache.struts2.convention.annotation.Result(name = "success", location = "/jsp/dd/comfirm.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "pay", location = "/jsp/dd/pay.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "detail", location = "/jsp/dd/detail.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "list", location = "/jsp/dd/list.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "payrs", location = "/jsp/dd/result.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "fldetail", location = "/jsp/dd/fldetail.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "flconfirm", location = "/jsp/dd/flconfirm.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "hrconfirm", location = "/jsp/dd/hrconfirm.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "hrpay", location = "/jsp/dd/hrpay.jsp") })
public class DdAction extends BaseAction {
	private static final long serialVersionUID = 857508946370915324L;
	private static Logger logger = Logger.getLogger(DdAction.class.getName());

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
		return this.ddzb;
	}

	public void setCrdid(int crdid) {
		this.crdid = crdid;
	}

	public int getCrdid() {
		return this.crdid;
	}

	public void setCrddh(String crddh) {
		this.crddh = crddh;
	}

	public void setPayrs(String payrs) {
		this.payrs = payrs;
	}

	public String getPayrs() {
		return this.payrs;
	}

	public String getCrddh() {
		return this.crddh;
	}

	public void setRs(int rs) {
		this.rs = rs;
	}

	public int getRs() {
		return this.rs;
	}

	public String getBz() {
		return this.bz;
	}

	public void setBz(String bz) {
		this.bz = bz;
	}

	public String getSplist() {
		return this.splist;
	}

	public void setSplist(String splist) {
		this.splist = splist;
	}

	public String getDhlist() {
		return this.dhlist;
	}

	public void setDhlist(String dhlist) {
		this.dhlist = dhlist;
	}

	public String getSllist() {
		return this.sllist;
	}

	public void setSllist(String sllist) {
		this.sllist = sllist;
	}

	public int getZjf() {
		return this.zjf;
	}

	public void setZjf(int zjf) {
		this.zjf = zjf;
	}

	public double getZje() {
		return this.zje;
	}

	public void setZje(double zje) {
		this.zje = zje;
	}

	public int getZjfqsl() {
		return this.zjfqsl;
	}

	public void setZjfqsl(int zjfqsl) {
		this.zjfqsl = zjfqsl;
	}

	public int getDdshdz() {
		return this.ddshdz;
	}

	public void setDdshdz(int ddshdz) {
		this.ddshdz = ddshdz;
	}

	public void setUser(TblQyyg user) {
		this.user = user;
	}

	public TblQyyg getUser() {
		return this.user;
	}

	public void setSl(int sl) {
		this.sl = sl;
	}

	public int getSl() {
		return this.sl;
	}

	public void setDhfs(String dhfs) {
		this.dhfs = dhfs;
	}

	public String getDhfs() {
		return this.dhfs;
	}

	public void setJfqmc(TblJfqmc jfqmc) {
		this.jfqmc = jfqmc;
	}

	public TblJfqmc getJfqmc() {
		return this.jfqmc;
	}

	public void setJfqmcid(int jfqmcid) {
		this.jfqmcid = jfqmcid;
	}

	public int getJfqmcid() {
		return this.jfqmcid;
	}

	public String list() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		setUser(this.qyyg.findById(tyg.getNid()));
		return "list";
	}

	public String confirm() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		setUser(this.qyyg.findById(tyg.getNid()));
		return "success";
	}

	public String hrconfirm() {
		return "hrconfirm";
	}

	public String flconfirm() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		setUser(this.qyyg.findById(tyg.getNid()));
		return "flconfirm";
	}

	public String jfqdh() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		setUser(this.qyyg.findById(tyg.getNid()));
		setSplist(this.splist);
		if ((this.dhlist != null) && (!this.dhlist.equals(""))) {
			setJfqmc(this.jfqserv.findById(Integer.valueOf(Integer
					.parseInt(this.dhlist))));
		}
		return "jfqdh";
	}

	public String detail() {
		this.ddzb = this.ddserv.findZbByDdh(this.crddh);
		return "detail";
	}

	public String fldetail() {
		this.ddzb = this.ddserv.findZbByDdh(this.crddh);
		return "fldetail";
	}

	public String gopay() {
		setCrddh(this.crddh);
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		if (this.ddserv.findZbByDdh(this.crddh).getYg().intValue() != tyg
				.getNid().intValue()) {
			setPayrs("支付失败，订单没有找到。");
			return "payrs";
		}
		TblYgddzb zbc = this.ddserv.findZbByDdh(this.crddh);
		setCrddh(zbc.getDdh());
		setCrdid(zbc.getNid().intValue());
		setZje(zbc.getZje().doubleValue());
		setZjf(zbc.getZjf().intValue());
		setZjfqsl(zbc.getJfqsl().intValue());
		return "pay";
	}

	public String pay() {
		setCrddh(this.crddh);
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		if (this.ddserv.findZbByDdh(this.crddh).getYg().intValue() != tyg
				.getNid().intValue()) {
			setPayrs("支付失败，订单没有找到。");
			return "payrs";
		}
		int ddprs = this.ddserv.pay(this.crddh);
		if (ddprs == 5) {
			setPayrs("支付成功。");
		}
		if (ddprs == 1) {
			setPayrs("支付失败，现金支付结果未获取。");
		}
		if (ddprs == 2) {
			setPayrs("支付失败，剩余积分不足。");
		}
		if (ddprs == 3) {
			setPayrs("支付失败，剩余福利券不足。");
		}
		if (ddprs == 4) {
			setPayrs("支付失败，商品库存不足。");
		}
		setSplist(this.ddserv.getSps(this.crddh));
		return "payrs";
	}

	public String hrpay() {
		setCrddh(this.crddh);
		int ygid = Integer.parseInt(this.session.get("hrygid").toString());
		if (this.ddserv.findZbByDdh(this.crddh).getYg().intValue() != ygid) {
			setPayrs("支付失败，订单没有找到。");
			return "payrs";
		}
		if (this.session.get("hrqyid") != null) {
			int qyid = Integer.parseInt(this.session.get("hrqyid").toString());
			int ddprs = this.ddserv.hrpay(this.crddh, qyid);
			if (ddprs == 5) {
				setPayrs("支付成功。");
				int qyjf = QyService.getQyJf(qyid);
				this.session.put("hrqyjf", Integer.valueOf(qyjf));
			}
			if (ddprs == 1) {
				setPayrs("支付失败，现金支付结果未获取。");
			}
			if (ddprs == 2) {
				setPayrs("支付失败，剩余积分不足。");
			}
			if (ddprs == 3) {
				setPayrs("支付失败，剩余福利券不足。");
			}
			if (ddprs == 4)
				setPayrs("支付失败，商品库存不足。");
		} else {
			setPayrs("购买超时，支付失败。");
		}
		setSplist(this.ddserv.getSps(this.crddh));
		return "payrs";
	}

	public String create() {
		boolean jfEnough = false;
		boolean jfqEnough = true;
		String[] tsp = this.splist.split(",");
		String[] tdh = this.dhlist.split(",");
		String[] tsl = this.sllist.split(",");
		Map<String,Long> jfqmap = new HashMap<String,Long>();
		Map<String,Long> jfqyfmap = new HashMap<String,Long>();
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		TblQyyg user = this.qyyg.findById(tyg.getNid());
		if (user.getJf().longValue() >= this.zjf) {
			jfEnough = true;
		}
		if (this.dhlist.indexOf("jfq") == -1) {
			jfqEnough = true;
		} else {
			List<Map<String, Object>> jfqlist = this.jfqserv.getJfqs(user
					.getNid().intValue());
			for (Map<String, Object> l : jfqlist) {
				jfqmap.put(Long.toString(((Long) l.get("jfq")).longValue()),
						(Long) l.get("jfqcount"));
			}
			for (int i = 0; i < tdh.length; i++) {
				if (tdh[i].indexOf("jfq") != -1) {
					String yfjfq = tdh[i].substring(3);
					if (jfqyfmap.get(yfjfq) == null) {
						jfqyfmap.put(yfjfq,
								Long.valueOf(Long.parseLong(tsl[i])));
					} else if (jfqyfmap.get(yfjfq) != null) {
						jfqyfmap.put(
								yfjfq,
								Long.valueOf(((Long) jfqyfmap.get(yfjfq))
										.longValue() + Long.parseLong(tsl[i])));
					}
				}
			}
			for (Map.Entry<String, Long> entry : jfqyfmap.entrySet()) {
				if ((jfqmap.get(entry.getKey()) == null)
						|| (((Long) jfqmap.get(entry.getKey())).longValue() < ((Long) entry
								.getValue()).longValue())) {
					jfqEnough = false;
					break;
				}
			}
		}
		if ((jfEnough) && (jfqEnough)) {
			String ddh = DateUtil.dateToStr("yyyyMMddHHmmss", new Date())
					+ user.getNid();
			TblYgddzb zb = new TblYgddzb();
			TblShdz shdzinfo = this.shdzserv.findById(Integer
					.valueOf(this.ddshdz));
			zb.setCjrq(new Timestamp(System.currentTimeMillis()));
			zb.setDdh(ddh);
			zb.setState(Integer.valueOf(0));
			zb.setZje(Double.valueOf(this.zje));
			zb.setZjf(Integer.valueOf(this.zjf));
			zb.setJfqsl(Integer.valueOf(this.zjfqsl));
			zb.setYg(user.getNid());
			zb.setShdz(Integer.valueOf(this.ddshdz));
			zb.setShdzxx("<b>收货人：</b>" + shdzinfo.getShr() + "   <b>电话号码：</b>"
					+ shdzinfo.getDh() + "<br /><b>地址：</b>"
					+ shdzinfo.getSheng() + " " + shdzinfo.getShi() + " "
					+ shdzinfo.getQu() + " " + shdzinfo.getDz() + " "
					+ shdzinfo.getYb() + " ");

			zb.setDdbz(this.bz);
			this.ddserv.save(zb);
			TblYgddzb zbc = this.ddserv.findZbByDdh(ddh);

			TblYgddmx[] mxs = new TblYgddmx[tsp.length];
			for (int j = 0; j < tsp.length; j++) {
				int spid = Integer.parseInt(tsp[j]);
				int sl = Integer.parseInt(tsl[j]);
				TblSp tblsp = this.spserv.findSpById(Integer.valueOf(spid));
				mxs[j] = new TblYgddmx();
				mxs[j].setYg(user.getNid());
				mxs[j].setDd(zbc.getNid());
				mxs[j].setSp(tblsp.getNid());
				mxs[j].setSl(Integer.valueOf(sl));
				mxs[j].setState(Integer.valueOf(0));
				mxs[j].setDdh(ddh);
				mxs[j].setSpl(tblsp.getSpl());
				if (tdh[j].indexOf("jfq") != -1) {
					mxs[j].setJfq(Integer.valueOf(Integer.parseInt(tdh[j]
							.substring(3))));
				} else if (tdh[j].indexOf("_") != -1) {
					mxs[j].setJf(Integer.valueOf(sl
							* Integer.parseInt(tdh[j].substring(0,
									tdh[j].indexOf("_")))));
					mxs[j].setJe(Double.valueOf(sl
							* Double.parseDouble(tdh[j].substring(
									tdh[j].indexOf("_") + 1, tdh[j].length()))));
				} else if (tdh[j] != "") {
					mxs[j].setJf(Integer.valueOf(sl * Integer.parseInt(tdh[j])));
				}
			}
			this.ddserv.save(mxs);
			setCrddh(zbc.getDdh());
			setCrdid(zbc.getNid().intValue());
			setZje(zbc.getZje().doubleValue());
			setZjf(zbc.getZjf().intValue());
			setZjfqsl(zbc.getJfqsl().intValue());
			return "pay";
		}

		setRs(1);
		return "jfqdh";
	}

	public String hrcreate() {
		boolean jfEnough = false;
		String[] tsp = this.splist.split(",");
		String[] tdh = this.dhlist.split(",");
		String[] tsl = this.sllist.split(",");
		int nid = Integer.parseInt(this.session.get("hrygid").toString());
		TblQyyg user = this.qyyg.findById(Integer.valueOf(nid));
		String qyjf = this.session.get("hrqyjf").toString();
		if (Integer.parseInt(qyjf) >= this.zjf) {
			jfEnough = true;
		}
		if ((user != null) && (jfEnough)) {
			String ddh = DateUtil.dateToStr("yyyyMMddHHmmss", new Date())
					+ user.getNid();
			TblYgddzb zb = new TblYgddzb();
			TblShdz shdzinfo = this.shdzserv.findById(Integer
					.valueOf(this.ddshdz));
			zb.setCjrq(new Timestamp(System.currentTimeMillis()));
			zb.setDdh(ddh);
			zb.setState(Integer.valueOf(0));
			zb.setZje(Double.valueOf(this.zje));
			zb.setZjf(Integer.valueOf(this.zjf));
			zb.setJfqsl(Integer.valueOf(this.zjfqsl));
			zb.setYg(user.getNid());
			zb.setShdz(Integer.valueOf(this.ddshdz));
			zb.setShdzxx("<b>收货人：</b>" + shdzinfo.getShr() + "   <b>电话号码：</b>"
					+ shdzinfo.getDh() + "<br /><b>地址：</b>"
					+ shdzinfo.getSheng() + " " + shdzinfo.getShi() + " "
					+ shdzinfo.getQu() + " " + shdzinfo.getDz() + " "
					+ shdzinfo.getYb() + " ");

			zb.setDdbz(this.bz);
			zb.setDdtype(user.getQy());
			this.ddserv.save(zb);
			TblYgddzb zbc = this.ddserv.findZbByDdh(ddh);

			TblYgddmx[] mxs = new TblYgddmx[tsp.length];
			for (int j = 0; j < tsp.length; j++) {
				int spid = Integer.parseInt(tsp[j]);
				int sl = Integer.parseInt(tsl[j]);
				TblSp tblsp = this.spserv.findSpById(Integer.valueOf(spid));
				mxs[j] = new TblYgddmx();
				mxs[j].setYg(user.getNid());
				mxs[j].setDd(zbc.getNid());
				mxs[j].setSp(tblsp.getNid());
				mxs[j].setSl(Integer.valueOf(sl));
				mxs[j].setState(Integer.valueOf(0));
				mxs[j].setDdh(ddh);
				mxs[j].setSpl(tblsp.getSpl());
				if (tdh[j].indexOf("jfq") != -1) {
					mxs[j].setJfq(Integer.valueOf(Integer.parseInt(tdh[j]
							.substring(3))));
				} else if (tdh[j].indexOf("_") != -1) {
					mxs[j].setJf(Integer.valueOf(sl
							* Integer.parseInt(tdh[j].substring(0,
									tdh[j].indexOf("_")))));
					mxs[j].setJe(Double.valueOf(sl
							* Double.parseDouble(tdh[j].substring(
									tdh[j].indexOf("_") + 1, tdh[j].length()))));
				} else if (tdh[j] != "") {
					mxs[j].setJf(Integer.valueOf(sl * Integer.parseInt(tdh[j])));
				}
			}
			this.ddserv.save(mxs);
			setCrddh(zbc.getDdh());
			setCrdid(zbc.getNid().intValue());
			setZje(zbc.getZje().doubleValue());
			setZjf(zbc.getZjf().intValue());
			setZjfqsl(zbc.getJfqsl().intValue());
			return "hrpay";
		}

		setRs(1);
		return "jfqdh";
	}
}