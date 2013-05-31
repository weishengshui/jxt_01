package com.ssh.entity;

import com.ssh.base.BaseEntity;
import java.util.ArrayList;
import java.util.List;

public class TblSplm extends BaseEntity implements Comparable<TblSplm> {
	private static final long serialVersionUID = 1L;
	private Integer nid;
	private String mc;
	private String lmtp;
	private Integer xswz;
	List<TblSplm> children = new ArrayList();

	public TblSplm() {
	}

	public TblSplm(String mc, String lmtp, List<TblSplm> children) {
		this.mc = mc;
		this.lmtp = lmtp;
		this.children = children;
	}

	public Integer getNid() {
		return this.nid;
	}

	public void setNid(Integer nid) {
		this.nid = nid;
	}

	public String getMc() {
		return this.mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getLmtp() {
		return this.lmtp;
	}

	public void setLmtp(String lmtp) {
		this.lmtp = lmtp;
	}

	public Integer getXswz() {
		return this.xswz;
	}

	public void setXswz(Integer xswz) {
		this.xswz = xswz;
	}

	public List<TblSplm> getChildren() {
		return this.children;
	}

	public void setChildren(List<TblSplm> children) {
		this.children = children;
	}

	public int compareTo(TblSplm o) {
		if (this.xswz.intValue() > o.xswz.intValue())
			return -1;
		if (this.xswz == o.xswz) {
			return 0;
		}
		return 1;
	}

	public boolean equals(Object o) {
		if ((o instanceof TblSplm)) {
			TblSplm other = (TblSplm) o;

			return this.nid == other.nid;
		}

		return false;
	}
}