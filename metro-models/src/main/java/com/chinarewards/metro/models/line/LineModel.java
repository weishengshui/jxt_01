package com.chinarewards.metro.models.line;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class LineModel implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3484732247849406575L;

	private Integer lineId ;
	
	private String lineName ;
	
	private String smallPic ;
	
	private String pic ;
	
	private String lineNum ;
	
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("lineId=" + lineId + "&lineName=" + lineName
				+ "&smallPic=" + smallPic + "&pic=" + pic
				+ "&lineNum=" + lineNum);

		return str.toString();
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public Integer getLineId() {
		return lineId;
	}

	public void setLineId(Integer lineId) {
		this.lineId = lineId;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getSmallPic() {
		return smallPic;
	}

	public void setSmallPic(String smallPic) {
		this.smallPic = smallPic;
	}

	public String getPic() {
		return pic;
	}

	public void setPic(String pic) {
		this.pic = pic;
	}

	public String getLineNum() {
		return lineNum;
	}

	public void setLineNum(String lineNum) {
		this.lineNum = lineNum;
	}
	
	
}
