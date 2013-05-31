package com.ssh.action;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblLljl;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblSpl;
import com.ssh.service.LljlService;
import com.ssh.service.SpService;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

@Controller
@Results({@org.apache.struts2.convention.annotation.Result(name="success", location="/jsp/sp/list.jsp"), @org.apache.struts2.convention.annotation.Result(name="base", location="/jsp/sp/base.jsp"), @org.apache.struts2.convention.annotation.Result(name="detail", location="/jsp/sp/detail.jsp"), @org.apache.struts2.convention.annotation.Result(name="flsp", location="/jsp/sp/flsp.jsp")})
public class SpAction extends BaseAction
{
  private static final long serialVersionUID = 1950908825912457153L;
  private static Logger logger = Logger.getLogger(SpAction.class.getName());

  @Resource
  private SpService spserv;

  @Resource
  private LljlService lljlserv;
  private int userid;
  private String param;
  private String key;
  private String lm;
  private String order;
  private String query;
  private String jfq;
  private String jfqmcid;
  private int sp;
  private int spl;
  private String yxq;
  private int sflq;

  public void setKey(String key) { this.key = key; }

  public String getKey()
  {
    return this.key;
  }

  public void setLm(String lm) {
    this.lm = lm;
  }

  public String getLm() {
    return this.lm;
  }

  public void setSp(int sp) {
    this.sp = sp;
  }

  public void setQuery(String query) {
    this.query = query;
  }

  public String getQuery() {
    return this.query;
  }

  public void setOrder(String order) {
    this.order = order;
  }

  public String getOrder() {
    return this.order;
  }

  public void setSpl(int spl) {
    this.spl = spl;
  }

  public int getSpl() {
    return this.spl;
  }

  public int getSp() {
    return this.sp;
  }

  public void setParam(String param) {
    this.param = param;
  }

  public String getParam() {
    return this.param;
  }

  public void setUserid(int userid) {
    this.userid = userid;
  }

  public int getUserid() {
    return this.userid;
  }

  public void setJfqmcid(String jfqmcid) {
    this.jfqmcid = jfqmcid;
  }

  public String getJfqmcid() {
    return this.jfqmcid;
  }

  public void setJfq(String jfq) {
    this.jfq = jfq;
  }

  public String getJfq() {
    return this.jfq;
  }

  public String getYxq() {
    return this.yxq;
  }

  public void setYxq(String yxq) {
    this.yxq = yxq;
  }

  public int getSflq() {
    return this.sflq;
  }

  public void setSflq(int sflq) {
    this.sflq = sflq;
  }

  public String list() {
    if ((this.param != null) && (!this.param.equals(""))) {
      if (this.param.equals("zxsj")) {
        setParam("spl");
        setOrder(" t.rq desc ");
      }
      if (this.param.equals("fkqd")) {
        setParam("spl");
        setOrder(" ydsl desc ");
      }
      if (this.param.equals("tjsp")) {
        setParam(this.param);
        setOrder(" s.qbjf DESC ");
      }
      if (this.param.equals("rmdh")) {
        setParam("spl");
        setOrder("sftj desc , ydsl DESC ,t.nid desc ");
      }
      if (this.param.equals("zshy")) {
        setParam(this.param);
        setOrder(" splcount DESC, s.nid DESC  ");
      }
      if (this.param.equals("tszk")) {
        setParam(this.param);
        setOrder(" t.llsj DESC ");
      }
      if (this.param.equals("zjll")) {
        setParam(this.param);
        setOrder(" t.llsj DESC ");
      }
      if (this.param.equals("tszd")) {
        setParam(this.param);
        setOrder(" s.nid DESC ");
      } else {
        setParam(this.param);
      }
    } else {
      setParam("spl");
    }if ((this.query != null) && (!this.query.equals(""))) {
      setQuery("?query=" + this.query);
    }
    TblQyyg user = (TblQyyg)this.session.get("user");
    if (user != null) {
      setUserid(user.getNid().intValue());
    }
    setKey(this.key);
    setLm(this.lm);
    return "success";
  }

  public String base() {
    TblQyyg user = (TblQyyg)this.session.get("user");
    if (user != null) {
      setUserid(user.getNid().intValue());
    }
    return "base";
  }

  public String base2() {
    String jf = this.httpServletRequest.getParameter("hrqyjf");
    String ygid = this.httpServletRequest.getParameter("hrygid");
    String qyid = this.httpServletRequest.getParameter("hrqyid");
    String hrygxm = this.httpServletRequest.getParameter("hrygxm");
    if ((jf != null) && (!"".equals(jf))) {
      Pattern pattern = Pattern.compile("[0-9]*");
      Matcher m = pattern.matcher(jf);
      if (m.matches()) {
        int qyjf = Integer.parseInt(jf);
        this.session.clear();
        this.session.put("hrqyjf", Integer.valueOf(qyjf));
        this.session.put("hrygid", ygid);
        this.session.put("hrqyid", qyid);
        this.session.put("hrygxm", hrygxm);
      }
    }
    return "base";
  }
  public String detail() {
    Timestamp tsnow = new Timestamp(System.currentTimeMillis());
    setJfq(this.jfq);
    TblQyyg user = (TblQyyg)this.session.get("user");
    if (this.sp != 0) {
      setSp(this.sp);
      TblSp tsp = this.spserv.findSpById(Integer.valueOf(this.sp));
      int ttspl = tsp.getSpl().intValue();
      setSpl(ttspl);

      if (user != null) {
        List ll = this.lljlserv.findBySpYg(user.getNid(), Integer.valueOf(this.sp), Integer.valueOf(ttspl));
        if (ll.size() > 0) {
          TblLljl tl = (TblLljl)ll.get(0);
          tl.setLlsj(tsnow);
          this.lljlserv.save(tl);
        }
        else {
          TblLljl tl = new TblLljl();
          tl.setQy(user.getQy());
          tl.setYg(user.getNid());
          tl.setSp(Integer.valueOf(this.sp));
          tl.setSpl(Integer.valueOf(ttspl));
          tl.setLlsj(tsnow);
          this.lljlserv.save(tl);
        }
      }
      return "detail";
    }
    if (this.spl != 0) {
      setSp(this.spl);
      TblSpl tspl = this.spserv.findSplById(Integer.valueOf(this.spl));
      int ttsp = tspl.getSp().intValue();
      setSp(ttsp);

      if (user != null) {
        List ll = this.lljlserv.findBySpYg(user.getNid(), Integer.valueOf(ttsp), Integer.valueOf(this.spl));
        if (ll.size() > 0) {
          TblLljl tl = (TblLljl)ll.get(0);
          tl.setLlsj(tsnow);
          this.lljlserv.save(tl);
        }
        else {
          TblLljl tl = new TblLljl();
          tl.setQy(user.getQy());
          tl.setYg(user.getNid());
          tl.setSp(Integer.valueOf(ttsp));
          tl.setSpl(Integer.valueOf(this.spl));
          tl.setLlsj(tsnow);
          this.lljlserv.save(tl);
        }
      }
      return "detail";
    }
    return "success";
  }

  public String flsp() {
    Timestamp tsnow = new Timestamp(System.currentTimeMillis());
    setJfq(this.jfq);
    TblQyyg user = (TblQyyg)this.session.get("user");
    if (this.sp != 0) {
      setSp(this.sp);
      TblSp tsp = this.spserv.findSpById(Integer.valueOf(this.sp));
      int ttspl = tsp.getSpl().intValue();
      setSpl(ttspl);
      List ll = this.lljlserv.findBySpYg(user.getNid(), Integer.valueOf(this.sp), Integer.valueOf(ttspl));
      if (ll.size() > 0) {
        TblLljl tl = (TblLljl)ll.get(0);
        tl.setLlsj(tsnow);
        this.lljlserv.save(tl);
      }
      else {
        TblLljl tl = new TblLljl();
        tl.setQy(user.getQy());
        tl.setYg(user.getNid());
        tl.setSp(Integer.valueOf(this.sp));
        tl.setSpl(Integer.valueOf(ttspl));
        tl.setLlsj(tsnow);
        this.lljlserv.save(tl);
      }
      return "flsp";
    }
    if (this.spl != 0) {
      setSp(this.spl);
      TblSpl tspl = this.spserv.findSplById(Integer.valueOf(this.spl));
      int ttsp = tspl.getSp().intValue();
      setSp(ttsp);
      List ll = this.lljlserv.findBySpYg(user.getNid(), Integer.valueOf(ttsp), Integer.valueOf(this.spl));
      if (ll.size() > 0) {
        TblLljl tl = (TblLljl)ll.get(0);
        tl.setLlsj(tsnow);
        this.lljlserv.save(tl);
      }
      else {
        TblLljl tl = new TblLljl();
        tl.setQy(user.getQy());
        tl.setYg(user.getNid());
        tl.setSp(Integer.valueOf(ttsp));
        tl.setSpl(Integer.valueOf(this.spl));
        tl.setLlsj(tsnow);
        this.lljlserv.save(tl);
      }
      return "flsp";
    }
    return "success";
  }
}