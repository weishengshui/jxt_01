package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 获取门店消费类型响应vo
 * 
 * @author qingminzou
 * 
 */
@XmlRootElement
public class ObtainConsumeTypeResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1842038330424678186L;

	/**
	 * result 0：成功,3：无效的终端编号, 其他：待定
	 */
	private String result;

	/**
	 * 判断门店的消费类型有没有改变，如果改变了这个值就不一样,Pos 机才会更新客户端的信息
	 */
	private String consumeTypeToken;

	/**
	 * 门店消费类型列表 <code>GenericEntry -> key=consumeId,value=consumeName</code>
	 */
	private List<GenericEntry> details = new LinkedList<GenericEntry>();

	/**
	 * 0、什么都没绑定。 1、只绑定到门店。 2、只绑定到活动
	 */
	private String bindType;

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getConsumeTypeToken() {
		return consumeTypeToken;
	}

	public void setConsumeTypeToken(String consumeTypeToken) {
		this.consumeTypeToken = consumeTypeToken;
	}

	public List<GenericEntry> getDetails() {
		return details;
	}

	public void setDetails(List<GenericEntry> details) {
		this.details = details;
	}

	public String getBindType() {
		return bindType;
	}

	public void setBindType(String bindType) {
		this.bindType = bindType;
	}

}
