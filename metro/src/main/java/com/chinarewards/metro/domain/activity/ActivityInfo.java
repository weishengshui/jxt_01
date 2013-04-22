package com.chinarewards.metro.domain.activity;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;

import com.chinarewards.metro.domain.file.FileItem;

@Entity
public class ActivityInfo {
	@Id 
	@GeneratedValue(strategy=GenerationType.AUTO)
	private Integer id;
	@Column(nullable = false)
	private String activityName ;
	@Column(nullable = false)
	private Date startDate ;
	@Column(nullable = false)
	private Date endDate ;
	@Column(columnDefinition = "text")
	private String description;
	private String hoster ;
	private String activityNet ;
	private String contacts ;
	private String conTel ;
	@OneToOne(cascade=CascadeType.ALL)
	private FileItem image;
	//1:默认，0：取消，-1：逻辑删除
	private int tag ;
	
	private String title;
	
	@Lob
	private String descr;
	
	@Lob
	private String posDescr;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getActivityName() {
		return activityName;
	}
	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getHoster() {
		return hoster;
	}
	public void setHoster(String hoster) {
		this.hoster = hoster;
	}
	public String getActivityNet() {
		return activityNet;
	}
	public void setActivityNet(String activityNet) {
		this.activityNet = activityNet;
	}
	public String getContacts() {
		return contacts;
	}
	public void setContacts(String contacts) {
		this.contacts = contacts;
	}
	public String getConTel() {
		return conTel;
	}
	public void setConTel(String conTel) {
		this.conTel = conTel;
	}
	public int getTag() {
		return tag;
	}
	public void setTag(int tag) {
		this.tag = tag;
	}
	public FileItem getImage() {
		return image;
	}
	public void setImage(FileItem image) {
		this.image = image;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescr() {
		return descr;
	}
	public void setDescr(String descr) {
		this.descr = descr;
	}
	public String getPosDescr() {
		return posDescr;
	}
	public void setPosDescr(String posDescr) {
		this.posDescr = posDescr;
	}
	
}
