package com.chinarewards.metro.models.line;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MetroLine  implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6331880223943004666L;

	private String checkStr;

	private List<LineModel> models  = new ArrayList<LineModel>();

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<LineModel> getModels() {
		return models;
	}

	public void setModels(List<LineModel> models) {
		this.models = models;
	}

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		if (models != null && models.size() > 0) {
			for (LineModel lm : models) {
				str.append("lineId=" + lm.getLineId() + "&lineName=" + lm.getLineName()
						+ "&smallPic=" + lm.getSmallPic() + "&pic=" + lm.getPic() + "&lineNum="
						+ lm.getLineNum());
			}
		}
		return str.toString();
	}

}
