package com.chinarewards.metro.model.member;

import java.util.Date;

import javax.swing.plaf.DesktopIconUI;

import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.shop.Shop;

/**
 * 会员使用优惠码记录VO
 * 
 * @author weishengshui
 * 
 */
public class MemberDiscountNumberVo {

	private Integer txId; // 交易编号
	private Date transactionDate; // 交易时间
	private String discountNum; // 优惠码
	private String content; // 优惠内容
	private String sources; // 来源
	private int status; // 状态
	
	public MemberDiscountNumberVo(int txId, Date generatedDate, Date usedDate, String discountNum, String content, String sources, int status) {
		this.txId = txId;
		if(null != usedDate){  // 交易时间
			this.transactionDate = usedDate;
		}else{
			this.transactionDate = generatedDate;
		}
		this.discountNum = discountNum;
		this.content = content;
		this.sources = "";//sources==null?"":sources; // TODO
		this.status = status;
	}
	
	public MemberDiscountNumberVo(int txId, Date generatedDate, Date expiredDate, String discountNum, String content, Shop shop, ActivityInfo activityInfo, Integer status, int type) {//type: 0表示从DiscountNumber表查出 1表示从DiscountNumberHistory表查出
		this.txId = txId;

		if(0 == type){
			if(expiredDate.before(new Date())){
				this.transactionDate = expiredDate;
			}else{
				this.transactionDate = generatedDate;
			}
		}else{
			if(null != generatedDate){  // 交易时间
				this.transactionDate = generatedDate;
			}else{
				this.transactionDate = expiredDate;
			}
		}
		this.discountNum = discountNum;
		this.content = content;
		if(null != shop){
			this.sources = shop.getName();
		}else if(null != activityInfo){
			this.sources = activityInfo.getActivityName();
		}else{
			this.sources = "";
		}
		if(type == 0){// 会员领取了优惠码，还没移进历史表
			if(new Integer(0).equals(status)){
				if(expiredDate.before(new Date())){
					this.status = Dictionary.MEMBER_DISCOUNT_NUMBER_EXPIRED;
				}else{
					this.status = Dictionary.MEMBER_DISCOUNT_NUMBER_NOT_USED;
				}
			} else if(new Integer(1).equals(status)){
				this.status = Dictionary.MEMBER_DISCOUNT_NUMBER_USED;
			}else{
				this.status = -1;
			}
		}else if(type == 1){
			if(new Integer(1).equals(status)){
				this.status = Dictionary.MEMBER_DISCOUNT_NUMBER_USED;
			}else if(new Integer(0).equals(status)){
				this.status = Dictionary.MEMBER_DISCOUNT_NUMBER_EXPIRED;
			}else{
				this.status = -1; //未知状态
			}
		}else{
			this.status = -1; //未知状态
		}
	}

	public Integer getTxId() {
		return txId;
	}
	public void setTxId(Integer txId) {
		this.txId = txId;
	}
	public Date getTransactionDate() {
		return transactionDate;
	}
	public void setTransactionDate(Date transactionDate) {
		this.transactionDate = transactionDate;
	}
	public String getDiscountNum() {
		return discountNum;
	}
	public void setDiscountNum(String discountNum) {
		this.discountNum = discountNum;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getSources() {
		return sources;
	}
	public void setSources(String sources) {
		this.sources = sources;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
	

}
