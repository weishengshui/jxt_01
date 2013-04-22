package com.chinarewards.metro.domain.user;


import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
/**
 * 角色资源
 * @author huangshan
 *
 */
@Entity
public class RoleResources implements Serializable{

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO )
	private Integer id;
	
//	@Column(name = "role_id")
//	private Integer roleId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "role_id")
	private Role role;
	
//	@Column(name = "resources_id")
//	private Integer resourcesId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "resources_id")
	private Resources resource;
	
	private Integer rights;
	
	public Integer getRights() {
		return rights;
	}

	public void setRights(Integer rights) {
		this.rights = rights;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}


	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public Resources getResource() {
		return resource;
	}

	public void setResource(Resources resource) {
		this.resource = resource;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		RoleResources other = (RoleResources) obj;
		if (id != other.id)
			return false;
		return true;
	}
	
	
}
