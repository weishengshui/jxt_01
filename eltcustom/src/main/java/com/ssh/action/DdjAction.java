package com.ssh.action;

import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblYgddzb;
import com.ssh.service.DdService;
import com.ssh.service.JfqService;
import com.ssh.service.QyygService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.annotation.Resource;
import net.sf.json.JSON;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;

@Controller
public class DdjAction extends PageAction {
	private static final long serialVersionUID = -1575018137004936842L;

	@Resource
	private DdService dd;

	@Resource
	private JfqService jfqserv;

	@Resource
	private QyygService qyyg;
	private String qybm;
	private String dhlist;
	private String sllist;
	private int zjf;

	public void setZjf(int zjf) {
		this.zjf = zjf;
	}

	public int getZjf() {
		return this.zjf;
	}

	public void setSllist(String sllist) {
		this.sllist = sllist;
	}

	public String getSllist() {
		return this.sllist;
	}

	public void setDhlist(String dhlist) {
		this.dhlist = dhlist;
	}

	public String getDhlist() {
		return this.dhlist;
	}

	public String getQybm() {
		return this.qybm;
	}

	public void setQybm(String qybm) {
		this.qybm = qybm;
	}

	public String page() {
		List list = this.dd.page(getParam(), getPage(), getRp());
		String total = this.dd.count(getParam());
		return super.pagelist(list, total);
	}

	public String cancel() {
		String oprs = "";
		int rs = 0;
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		if (this.dd.findZbByDdh(getParam()).getYg().intValue() != tyg.getNid()
				.intValue()) {
			oprs = "订单没有找到。";
		} else {
			rs = this.dd.cancel(getParam());
			if (rs == 2)
				oprs = "订单取消成功。";
			else {
				oprs = "操作失败。";
			}
		}
		Map map = new HashMap();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String confirm() {
		String oprs = "";
		int rs = 0;
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		if (this.dd.findZbByDdh(getParam()).getYg().intValue() != tyg.getNid()
				.intValue()) {
			oprs = "订单没有找到。";
		} else {
			rs = this.dd.confirm(getParam());
			if (rs == 2)
				oprs = "订单确认成功。";
			else {
				oprs = "操作失败。";
			}
		}
		Map map = new HashMap();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String remind() {
		String oprs = "";
		int rs = 0;
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		if (this.dd.findZbByDdh(getParam()).getYg().intValue() != tyg.getNid()
				.intValue()) {
			oprs = "订单没有找到。";
		} else {
			rs = this.dd.remind(getParam());
			if (rs == 2)
				oprs = "提醒商家发货成功。";
			else {
				oprs = "操作失败。";
			}
		}
		Map map = new HashMap();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String ddv() {
		String oprs = "";
		int ddvrs = this.dd.vertify(getParam());
		if (ddvrs == 5) {
			oprs = "success";
		}
		if (ddvrs == 2) {
			oprs = "无法支付，剩余积分不足。";
		}
		if (ddvrs == 3) {
			oprs = "无法支付，剩余福利券不足。";
		}
		if (ddvrs == 4) {
			oprs = "无法支付，商品库存不足。";
		}
		Map map = new HashMap();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String hrddv() {
		String oprs = "";
		if (this.session.get("hrqyid") != null) {
			int qyid = Integer.parseInt(this.session.get("hrqyid").toString());
			int ddvrs = this.dd.hrvertify(getParam(), qyid);
			if (ddvrs == 5) {
				oprs = "success";
			}
			if (ddvrs == 2) {
				oprs = "无法支付，剩余积分不足。";
			}
			if (ddvrs == 3) {
				oprs = "无法支付，剩余福利券不足。";
			}
			if (ddvrs == 4)
				oprs = "无法支付，商品库存不足。";
		} else {
			oprs = "购买超时，支付失败。";
		}
		Map map = new HashMap();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String vertify() {
		boolean jfEnough = false;
		boolean jfqEnough = true;
		String rs = "success";
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
			String[] tdh = this.dhlist.split(",");
			String[] tsl = this.sllist.split(",");
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
		if ((jfEnough) && (!jfqEnough)) {
			rs = "您的福利券不足，请选择其他兑换方式，或者减少兑换数量。";
		} else if ((!jfEnough) && (jfqEnough)) {
			rs = "您的积分不足，请选择其他兑换方式，或者减少兑换数量。";
		} else if ((!jfEnough) && (!jfqEnough)) {
			rs = "您的福利券和积分不足，请选择其他兑换方式，或者减少兑换数量。";
		}
		Map map = new HashMap();
		map.put("rs", rs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String verify() {
		boolean jfEnough = false;
		String rs = "success";
		String qyjf = this.session.get("hrqyjf").toString();
		if (Integer.parseInt(qyjf) >= this.zjf) {
			jfEnough = true;
		}
		if (!jfEnough) {
			rs = "您的积分不足，请减少兑换数量。";
		}
		Map map = new HashMap();
		map.put("rs", rs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String mxspl() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows", this.dd.getDdspl(tyg.getNid().intValue(), getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String ddmx() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows", this.dd.getDdMx(tyg.getNid().intValue(), getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String hrddmx() {
		Map map = new HashMap();
		if (this.session.get("hrygid") != null) {
			int ygid = Integer.parseInt(this.session.get("hrygid").toString());
			map.put("rows", this.dd.getDdMx(ygid, getParam()));
		}
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String ddc() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows", this.dd.getDdCount(tyg.getNid().intValue()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String listzb() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows", this.dd.getDdZb(tyg.getNid().intValue(), getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String listmx() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows", this.dd.getDdByDdh(tyg.getNid().intValue(), getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String jfdhjl() {
		Map map = new HashMap();
		map.put("rows", this.dd.getJfdhjl(getParam(), 5));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String jfqdhjl() {
		Map map = new HashMap();
		map.put("rows", this.dd.getJfqdhjl(getParam(), 6));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String tsmsp() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows", this.dd.getTsmsp(tyg.getNid().intValue(), tyg.getQy()
				.intValue(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}

	public String xdsp() {
		TblQyyg tyg = (TblQyyg) this.session.get("user");
		Map map = new HashMap();
		map.put("rows",
				this.dd.getXdsp(tyg.getNid().intValue(),
						Integer.parseInt(getParam()), 0));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return "success";
	}
}