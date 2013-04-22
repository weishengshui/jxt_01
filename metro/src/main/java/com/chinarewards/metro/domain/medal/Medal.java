package com.chinarewards.metro.domain.medal;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.OneToOne;

import com.chinarewards.metro.domain.file.FileItem;

@Entity
public class Medal {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Integer id;
	private String medalName;
	private String obtainWay;
	private String obtainCondition;
	private String validTime;
	private int revealSort;
	@OneToOne(cascade = CascadeType.ALL)
	private FileItem mobiImage;
	@OneToOne(cascade = CascadeType.ALL)
	private FileItem websiteImage;
	@Lob
	private String rule;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getMedalName() {
		return medalName;
	}

	public void setMedalName(String medalName) {
		this.medalName = medalName;
	}

	public String getObtainWay() {
		return obtainWay;
	}

	public void setObtainWay(String obtainWay) {
		this.obtainWay = obtainWay;
	}

	public String getObtainCondition() {
		return obtainCondition;
	}

	public void setObtainCondition(String obtainCondition) {
		this.obtainCondition = obtainCondition;
	}

	public String getValidTime() {
		return validTime;
	}

	public void setValidTime(String validTime) {
		this.validTime = validTime;
	}

	public int getRevealSort() {
		return revealSort;
	}

	public void setRevealSort(int revealSort) {
		this.revealSort = revealSort;
	}

	public FileItem getMobiImage() {
		return mobiImage;
	}

	public void setMobiImage(FileItem mobiImage) {
		this.mobiImage = mobiImage;
	}

	public FileItem getWebsiteImage() {
		return websiteImage;
	}

	public void setWebsiteImage(FileItem websiteImage) {
		this.websiteImage = websiteImage;
	}

	public String getRule() {
		return rule;
	}

	public void setRule(String rule) {
		this.rule = rule;
	}
}
