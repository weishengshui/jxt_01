package com.chinarewards.metro.domain.shop;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.chinarewards.metro.domain.file.FileItem;

/**
 * 优惠券
 * 
 * @author weishengshui
 * 
 */
@Entity
public class DiscountCoupon implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4280550646584036656L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Integer id;

	@ManyToOne
	private Shop shop;

	@ManyToOne
	private ShopChain shopChain;

	// 有效期
	@Temporal(TemporalType.DATE)
	private Date validDateFrom;
	@Temporal(TemporalType.DATE)
	private Date validDateTo;

	@Column(columnDefinition = "text")
	private String instruction;// 优惠说明

	private String identifyCode;// 识别编号

	private Long sortCode;// 排序编号

	private Double price;// 售价

	private String description;

	private String comment;// 备注

	@OneToOne
	private FileItem fileItem; // 图片

	@Column(nullable = false, updatable = false)
	private Date createdAt;
	@Column(nullable = false, updatable = false)
	private String createdBy;

	@Column(nullable = false)
	private Date lastModifiedAt;
	@Column(nullable = false)
	private String lastModifiedBy;

	public DiscountCoupon() {
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Shop getShop() {
		return shop;
	}

	public void setShop(Shop shop) {
		this.shop = shop;
	}

	public ShopChain getShopChain() {
		return shopChain;
	}

	public void setShopChain(ShopChain shopChain) {
		this.shopChain = shopChain;
	}

	public Date getValidDateFrom() {
		return validDateFrom;
	}

	public void setValidDateFrom(Date validDateFrom) {
		this.validDateFrom = validDateFrom;
	}

	public Date getValidDateTo() {
		return validDateTo;
	}

	public void setValidDateTo(Date validDateTo) {
		this.validDateTo = validDateTo;
	}

	public String getInstruction() {
		return instruction;
	}

	public void setInstruction(String instruction) {
		this.instruction = instruction;
	}

	public String getIdentifyCode() {
		return identifyCode;
	}

	public void setIdentifyCode(String identifyCode) {
		this.identifyCode = identifyCode;
	}

	public Long getSortCode() {
		return sortCode;
	}

	public void setSortCode(Long sortCode) {
		this.sortCode = sortCode;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public FileItem getFileItem() {
		return fileItem;
	}

	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public Date getLastModifiedAt() {
		return lastModifiedAt;
	}

	public void setLastModifiedAt(Date lastModifiedAt) {
		this.lastModifiedAt = lastModifiedAt;
	}

	public String getLastModifiedBy() {
		return lastModifiedBy;
	}

	public void setLastModifiedBy(String lastModifiedBy) {
		this.lastModifiedBy = lastModifiedBy;
	}

}
