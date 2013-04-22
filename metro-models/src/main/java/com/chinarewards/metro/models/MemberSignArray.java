package com.chinarewards.metro.models;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MemberSignArray {

	private String checkStr;

	private List<Member> list;

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<Member> getList() {
		return list;
	}

	public void setList(List<Member> list) {
		this.list = list;
	}

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		if (null != list && list.size() > 0) {
			Member member = list.get(0);
			str.append("userName=" + member.getUserName() + "&gender="
					+ member.getGender() + "&address=" + member.getAddress());
		}
		return str.toString();
	}
}
