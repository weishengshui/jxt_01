package com.chinarewards.metro.domain.user;


import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import org.codehaus.jackson.annotate.JsonIgnore;
/**
 * 角色
 * @author huangshan
 *
 */
@Entity
public class Role implements Serializable{

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO )
	private Integer id;
	
	@Column(name = "role_name")
	private String name;
	
	@Column(name = "role_desc")
	private String desc;
	
//	@ManyToMany(cascade={CascadeType.ALL})
//	@JoinTable(name="user_role",joinColumns=@JoinColumn(name="user_id"),inverseJoinColumns=@JoinColumn(name="role_id"))
//	private Set<UserInfo> users = new LinkedHashSet<UserInfo>();
	
//	@ManyToMany(cascade = {CascadeType.ALL},fetch = FetchType.LAZY)
//	@JoinTable(name="roles_resources",joinColumns=@JoinColumn(name="role_id"),inverseJoinColumns=@JoinColumn(name="resource_id"))
//	private Set<Resources> resources = new LinkedHashSet<Resources>();
	
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "role")
	@JsonIgnore
	private Set<RoleResources> roleResource = new HashSet<RoleResources>();
	
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "user")
	@JsonIgnore
	private Set<UserRole> userRole = new HashSet<UserRole>();

	public Set<RoleResources> getRoleResource() {
		return roleResource;
	}

	public void setRoleResource(Set<RoleResources> roleResource) {
		this.roleResource = roleResource;
	}

	public Set<UserRole> getUserRole() {
		return userRole;
	}

	public void setUserRole(Set<UserRole> userRole) {
		this.userRole = userRole;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
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
		Role other = (Role) obj;
		if (id != other.id)
			return false;
		return true;
	}
	
	
}
