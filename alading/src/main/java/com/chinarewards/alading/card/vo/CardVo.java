package com.chinarewards.alading.card.vo;

public class CardVo {

	// card
	private Integer id;
	private String cardName;
	private Boolean defaultCard; // 是否默认卡， 默认卡就一张

	// card image
	private Integer imageId;
	private String description;
	private long filesize;
	private String mimeType;
	private String originalFilename;
	private byte[] content;

	private Integer pointId;
	private String pointName;
	private Integer pointRate;

	// company id
	private Integer companyId;
	// company name
	private String companyName;
	// company code 编号
	private String companyCode;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCardName() {
		return cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public Boolean getDefaultCard() {
		return defaultCard;
	}

	public void setDefaultCard(Boolean defaultCard) {
		this.defaultCard = defaultCard;
	}

	public Integer getImageId() {
		return imageId;
	}

	public void setImageId(Integer imageId) {
		this.imageId = imageId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public long getFilesize() {
		return filesize;
	}

	public void setFilesize(long filesize) {
		this.filesize = filesize;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public String getOriginalFilename() {
		return originalFilename;
	}

	public void setOriginalFilename(String originalFilename) {
		this.originalFilename = originalFilename;
	}

	public byte[] getContent() {
		return content;
	}

	public void setContent(byte[] content) {
		this.content = content;
	}

	public Integer getPointId() {
		return pointId;
	}

	public void setPointId(Integer pointId) {
		this.pointId = pointId;
	}

	public String getPointName() {
		return pointName;
	}

	public void setPointName(String pointName) {
		this.pointName = pointName;
	}

	public Integer getPointRate() {
		return pointRate;
	}

	public void setPointRate(Integer pointRate) {
		this.pointRate = pointRate;
	}

	public Integer getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getCompanyCode() {
		return companyCode;
	}

	public void setCompanyCode(String companyCode) {
		this.companyCode = companyCode;
	}

}
