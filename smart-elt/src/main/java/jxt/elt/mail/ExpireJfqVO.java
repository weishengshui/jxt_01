package jxt.elt.mail;

import java.util.Date;

public class ExpireJfqVO {

	private String refId ;
	
	private String jfqId ;
	
	private String name ;
	
	private int quantity ;
	
	private Date expireDate ;
	
	private Date hdExpireDate;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public Date getExpireDate() {
		return expireDate;
	}

	public void setExpireDate(Date expireDate) {
		this.expireDate = expireDate;
	}

	public String getJfqId() {
		return jfqId;
	}

	public void setJfqId(String jfqId) {
		this.jfqId = jfqId;
	}

	public String getRefId() {
		return refId;
	}

	public void setRefId(String refId) {
		this.refId = refId;
	}

	public Date getHdExpireDate() {
		return hdExpireDate;
	}

	public void setHdExpireDate(Date hdExpireDate) {
		this.hdExpireDate = hdExpireDate;
	}  
}
