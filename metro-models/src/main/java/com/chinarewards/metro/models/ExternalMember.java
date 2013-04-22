package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 1.1.	与POS进销存系统会员交互
 * @author daocao
 *
 */
@XmlRootElement
public class ExternalMember implements Serializable {

	private static final long serialVersionUID = 1L;

	List<ExternalMemberList> memberList;
	
	private Integer curPage;
	
	private Integer totalPage;

	private String result;
	
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		if (null != memberList && memberList.size() > 0) {
			ExternalMemberList m = memberList.get(0);
			sbf.append("memberId=" + m.getMemberId());
			sbf.append("&email=" + m.getEmail());
			sbf.append("&phone=" + m.getPhone());
			sbf.append("&createTime=" + m.getRegisterDate());
			sbf.append("&birth=" + m.getBirth());
		}
		return sbf.toString();
	}
	
	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}
	
	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public List<ExternalMemberList> getMemberList() {
		return memberList;
	}

	public void setMemberList(List<ExternalMemberList> memberList) {
		this.memberList = memberList;
	}

	public Integer getCurPage() {
		return curPage;
	}

	public void setCurPage(Integer curPage) {
		this.curPage = curPage;
	}

	public Integer getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(Integer totalPage) {
		this.totalPage = totalPage;
	}
	
}
