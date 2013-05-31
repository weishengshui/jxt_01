package com.ssh.action;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblShdz;
import com.ssh.service.ShdzService;
import java.sql.Timestamp;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

@Controller
@Results({@org.apache.struts2.convention.annotation.Result(name="success", location="/jsp/shdz/list.jsp"), @org.apache.struts2.convention.annotation.Result(name="pop", location="/jsp/shdz/pop.jsp")})
public class ShdzAction extends BaseAction
{
  private static final long serialVersionUID = 3372630938495018033L;
  private static Logger logger = Logger.getLogger(ShdzAction.class.getName());

  @Resource
  private ShdzService shdzService;
  private int rs;
  private int userid;
  private int nid;
  private String shdzshr;
  private TblShdz shdz;

  public void setShdzshr(String shdzshr) { this.shdzshr = shdzshr; }

  public String getShdzshr()
  {
    return this.shdzshr;
  }

  public void setShdz(TblShdz shdz) {
    this.shdz = shdz;
  }

  public void setNid(int nid) {
    this.nid = nid;
  }

  public int getNid() {
    return this.nid;
  }

  public TblShdz getShdz() {
    return this.shdz;
  }

  public void setUserid(int userid) {
    this.userid = userid;
  }

  public int getUserid() {
    return this.userid;
  }

  public void setRs(int rs) {
    this.rs = rs;
  }

  public int getRs() {
    return this.rs;
  }

  public String list() {
    TblQyyg tyq = (TblQyyg)this.session.get("user");
    setUserid(tyq.getNid().intValue());
    return "success";
  }
  public String pop() {
    TblShdz dz = new TblShdz();
    if (this.nid != 0) {
      dz = this.shdzService.findById(Integer.valueOf(this.nid));
    }
    setShdz(dz);
    setShdzshr(dz.getShr());
    return "pop";
  }

  public String popchg() {
    TblQyyg tyq = (TblQyyg)this.session.get("user");
    this.shdz.setShr(this.shdzshr);
    if (tyq != null) {
      this.shdz.setYg(tyq.getNid());
    } else if (this.session.get("hrygid") != null) {
      int nid = Integer.parseInt(this.session.get("hrygid").toString());
      this.shdz.setYg(Integer.valueOf(nid));
    }
    this.shdz.setRq(new Timestamp(System.currentTimeMillis()));
    this.shdzService.save(this.shdz);
    setRs(2);
    return pop();
  }

  public String chg() {
    TblQyyg tyq = (TblQyyg)this.session.get("user");
    this.shdz.setShr(this.shdzshr);
    this.shdz.setYg(tyq.getNid());
    this.shdz.setRq(new Timestamp(System.currentTimeMillis()));
    this.shdzService.save(this.shdz);
    setRs(2);
    return list();
  }
}