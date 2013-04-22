package com.chinarewards.metro.domain.user;


import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;
/**
 * 资源
 * @author huangshan
 *
 */
@Entity
public class Resources implements Serializable{

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO )
	private Integer id;
		
	private String url;
		
	@Transient
	private Integer type;
	
	private String name;
	
	private Integer isLeaf;//是否有叶子节点 0无  1有
	
	private Integer seq; 	//排序
	
	@OneToMany(fetch = FetchType.EAGER,cascade = {CascadeType.ALL},mappedBy = "resource")
	private Set<ResourceOperation> opertions;
	
	@Transient
	private Integer accesss;
	
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER, mappedBy = "resources")
	private Set<Resources> set = new HashSet<Resources>(0);
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "type")
	private Resources resources;
	
	public Integer getSeq() {
		return seq;
	}

	public void setSeq(Integer seq) {
		this.seq = seq;
	}

	public Set<Resources> getSet() {
		return set;
	}

	public void setSet(Set<Resources> set) {
		this.set = set;
	}

	public Resources getResources() {
		return resources;
	}

	public void setResources(Resources resources) {
		this.resources = resources;
	}

	public Integer getIsLeaf() {
		return isLeaf;
	}

	public void setIsLeaf(Integer isLeaf) {
		this.isLeaf = isLeaf;
	}

	public Set<ResourceOperation> getOpertions() {
		return opertions;
	}

	public void setOpertions(Set<ResourceOperation> opertions) {
		this.opertions = opertions;
	}

	public Integer getAccesss() {
		return accesss;
	}

	public void setAccesss(Integer accesss) {
		this.accesss = accesss;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Resources other = (Resources) obj;
		if (id != other.id)
			return false;
		return true;
	}
	
	
}
