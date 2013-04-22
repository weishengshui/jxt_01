package com.chinarewards.metro.service.user.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.TreeNodes;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.system.SysLog;
import com.chinarewards.metro.domain.user.ResourceOperation;
import com.chinarewards.metro.domain.user.Resources;
import com.chinarewards.metro.domain.user.Role;
import com.chinarewards.metro.domain.user.RoleResources;
import com.chinarewards.metro.domain.user.UserInfo;
import com.chinarewards.metro.domain.user.UserRole;
import com.chinarewards.metro.service.user.IUserService;

public class UserService implements IUserService,UserDetailsService{

	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	
	/*------------UserInfo----------*/
	
	@Override
	public UserDetails loadUserByUsername(String username)throws UsernameNotFoundException {
		UserInfo userInfo = findUserByName(username);
        if(userInfo == null){
             throw new UsernameNotFoundException("用户没找到!");
        } else{
            List<GrantedAuthority> auths = new ArrayList<GrantedAuthority>();
            for (UserRole ur : userInfo.getUserRoles()) {
                 SimpleGrantedAuthority authImpl = new SimpleGrantedAuthority(ur.getRole().getName());
                 auths.add(authImpl);
            }
            boolean enables = true;  
            boolean accountNonExpired = true;  
            boolean credentialsNonExpired = true;  
            boolean accountNonLocked = userInfo.getDisable() == Dictionary.USER_STATE_NORMAL;  
            User user = new User(username, userInfo.getPassword(), enables , 
            		accountNonExpired, credentialsNonExpired, accountNonLocked, auths);
            return user;
        }
	}
	
	@Override
	public UserInfo findUserByName(String userName) {
		return hbDaoSupport.findTByHQL("from UserInfo where userName = ? AND disable <> "+Dictionary.USER_STATE_DELETE,userName);
	}

	@Override
	public List<UserInfo> findUserInfo(UserInfo userInfo, Page page) {
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		sql.append("SELECT ui.id,ui.disable,ui.`password`,ui.username,group_concat(r.role_name) userRole FROM ");
		sql.append("UserInfo ui LEFT JOIN UserRole ur ON ur.user_id = ui.id LEFT JOIN Role r ON ur.role_id = r.id WHERE disable <>" + Dictionary.USER_STATE_DELETE);
		
		sqlCount.append("SELECT COUNT(1) FROM UserInfo ui WHERE disable <>" + Dictionary.USER_STATE_DELETE);
		
		if(StringUtils.isNotEmpty(userInfo.getUserName())){
			sql.append(" AND ui.username like ?");
			sqlCount.append(" AND ui.username like ?");
			args.add("%"+userInfo.getUserName()+"%");
			argsCount.add("%"+userInfo.getUserName()+"%");
		}
		sql.append(" GROUP BY ui.username,ui.id ORDER BY ui.id desc LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		if(argsCount.size() > 0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(), argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		return jdbcDaoSupport.findTsBySQL(UserInfo.class, sql.toString(),args.toArray());
	}
	
	@Override
	public void removeUser(String id) {
		String hql = "delete from UserInfo where id = :id";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("id", id);
		hbDaoSupport.executeHQL(hql, map);
	}
	
	@Override
	public UserInfo saveUser(UserInfo user) {
		user.setDisable(Dictionary.USER_STATE_NORMAL);
		user.setPassword(MD5.MD5Encoder(user.getPassword()));
		hbDaoSupport.save(user);
		if(CommonUtil.getIntegers(user.getRoleIds())!=null){
			for(Integer roleId : CommonUtil.getIntegers(user.getRoleIds())){
				UserRole ur = new UserRole();
				Role role = hbDaoSupport.findTById(Role.class, roleId);
				ur.setRole(role);
				ur.setUser(user);
				hbDaoSupport.save(ur);
			}
		}
		return user;
	}
	
	@Override
	public void updatePassword(String ids,String password) {
		String hql = "update UserInfo set password = :password where id in(:ids)";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("password", MD5.MD5Encoder(password));
		map.put("ids", CommonUtil.getIntegers(ids));
		hbDaoSupport.executeHQL(hql, map);
	};
	
	
	@Override
	public void lockUser(String ids, Integer disable) {
		String hql = "update UserInfo set disable = :disable where id in(:ids)";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("disable", disable);
		map.put("ids", CommonUtil.getIntegers(ids));
		hbDaoSupport.executeHQL(hql, map);
	}
	
	/**
	 * Role
	 */
	
	public List<TreeNodes> findResourcesByType(Integer roleId) {
		String hql = "from Resources r where r.resources = 0 order by r.seq";
		List<Resources> list = hbDaoSupport.findTsByHQL(hql);
		List<TreeNodes> treeNodeList = new ArrayList<TreeNodes>();
		List<RoleResources> roleResList = findResourceByRole(roleId);
		for(Resources res : list){
			treeNodeList.add(tree(res,roleResList));
		}
		return treeNodeList;
	};
	
	private TreeNodes tree(Resources res,List<RoleResources> roleResList) {
		TreeNodes node = new TreeNodes();
		for(RoleResources r : roleResList){
			if(r.getResource().getId().equals(res.getId()) && res.getIsLeaf() == 0 && res.getOpertions().size() == 0){
				node.setChecked(true);
				break;
			}
		}
		node.setId(res.getId().toString());
		node.setText(res.getName());
		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("url", res.getUrl());
		node.setAttributes(attributes);
		if (res.getSet() != null && res.getSet().size() > 0) {
			List<TreeNodes> children = new ArrayList<TreeNodes>();
			List<Resources> l = new ArrayList<Resources>();
			for(Resources r : res.getSet()){
				l.add(r);
			}
			Collections.sort(l, new Comparator<Resources>(){
				@Override
				public int compare(Resources o1, Resources o2) {
					int i1 = o1.getSeq() != null ? o1.getSeq().intValue() : -1;
					int i2 = o2.getSeq() != null ? o2.getSeq().intValue() : -1;
					return i1 - i2;
				}
			});
			for(int i=0;i<l.size();i++) {
				TreeNodes tn = tree(l.get(i),roleResList);
				children.add(tn);
				if(l.get(i).getIsLeaf() == 0){ //资源 / 按钮
					if(l.get(i).getOpertions() != null){
						List<TreeNodes> bChildren = new ArrayList<TreeNodes>();
						for(ResourceOperation ro:l.get(i).getOpertions()){
							TreeNodes button = new TreeNodes();
							button.setText(ro.getOperation());
							attributes.put("url", ro.getUrl());
							button.setAttributes(attributes);
							button.setId(l.get(i).getId()+"_"+ro.getLimitValue());
							
							for(RoleResources r : roleResList){
								if(r.getResource().getId().equals(l.get(i).getId()) && r.getRights() != null && l.get(i).getIsLeaf() == 0){
									int value = (int) Math.pow(2, Integer.parseInt(ro.getLimitValue()));
									if(((int) r.getRights() & value) == value){
										button.setChecked(true);break;
									}
								}
							}
							bChildren.add(button);
						}
						tn.setChildren(bChildren);
					}
				}
			}
			
			node.setChildren(children);
			node.setState("closed");
		}
		return node;
	}
	
	@Override
	public List<Role> findRoles(Role role, Page page) {
		DetachedCriteria criteria = DetachedCriteria.forClass(role.getClass());
		criteria.addOrder(Order.desc("id"));
		if(StringUtils.isNotEmpty(role.getName())){
			criteria.add(Restrictions.like("name", role.getName(),MatchMode.ANYWHERE));
		}
		if("user".equals(role.getDesc())){ // 添加User时选择Role
			return hbDaoSupport.findTsByCriteria(criteria);
		}
		return hbDaoSupport.findPageByCriteria(page, criteria);
	}
	
	@Override
	public void saveRole(Role role) {
		hbDaoSupport.saveOrUpdate(role);
	}
	
	@Override
	public Role findRoleByName(String roleName) {
		String hql = "from Role where name = ?";
		return hbDaoSupport.findTByHQL(hql, roleName);
	}
	
	@Override
	public List<Resources> findResources() {
		return hbDaoSupport.findAll(Resources.class);
	}
	
	@Override
	public List<RoleResources> findResourceByRole(Integer roleId) {
		String hql = "from RoleResources where role.id = ?";
		return hbDaoSupport.findTsByHQL(hql, roleId);
	}
	
	@Override
	public void delRoleAuth(Integer roleId, Integer resourceId) {
		String hql = "delete from RoleResources where role.id = :roleId and resource.id = :resourceId";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("roleId", roleId);
		map.put("resourceId", resourceId);
		hbDaoSupport.executeHQL(hql, map);
	}
	
	@Override
	public String saveRoleAuth(String roleId, String resourceIds, String old) {
		String newIds = ""; 							//保存用户最新设置的权限ID 需要返回到页面
		String[] resourceIdss = resourceIds.split(","); //最新设置的权限
		String[] olds = old.split(",");				    //设置之前的权限
		List<Integer> delIds = new ArrayList<Integer>();  //保存要删除的ID
		List<Integer> addIds = new ArrayList<Integer>();  //保存要保存的ID
		Map<String,Integer> rightsMap = new HashMap<String, Integer>(); // 保存按钮权限值
		String flag = "";
		//传过来的resourceIds如：2_1,2_4,3_1,5   2_1 表示2是资源菜单的ID, 1表选中的操作(如添加)。需要解析
		Integer rightsInt = 0,n = 0;
		for(String resourcesId : resourceIdss){			//判断添加
			boolean isAdd = true;
			String rightss[] = resourcesId.split("_");
			if(n != Integer.parseInt(rightss[0])) rightsInt = 0; //如：2_1,2_4,3_1 循环到'3_1'时 需要把 rightsInt清零
			n = Integer.parseInt(rightss[0]);
			if(rightss.length > 1){
				rightsInt += (int)Math.pow(2, Integer.parseInt(rightss[1]));
				rightsMap.put(rightss[0], rightsInt);
			}
			if(flag.equals(rightss[0])) continue;
			flag = rightss[0];
			if(!"".equals(newIds)) newIds += ",";
			newIds += rightss[0];
			for(String oldId : olds){
				if(rightss[0].equals(oldId)){
					isAdd = false;break;
				}
			}
			if(isAdd){
				addIds.add(Integer.parseInt(rightss[0]));
			}
		}
		
		for(String oldId : olds){						//判断删除
			boolean isDel = true;
			flag = "";
			for(String resourcesId : resourceIdss){
				String rightss[] = resourcesId.split("_");
				if(flag.equals(rightss[0])) continue;
				flag = rightss[0];
				if(oldId.equals(rightss[0])){
					isDel = false;break;
				}
			} 
			if(isDel && !"".equals(oldId)){
				delIds.add(Integer.parseInt(oldId));
			}
		}
		
		if(addIds.size() > 0){
			Role role = hbDaoSupport.findTById(Role.class, Integer.parseInt(roleId));
			for(Integer resourceId : addIds){               //添加
				RoleResources rr = new RoleResources();
				rr.setRole(role);
				rr.setResource(hbDaoSupport.findTById(Resources.class,resourceId));
				hbDaoSupport.save(rr);
			}
		}
		if(delIds.size() > 0){
			for(Integer resourceId : delIds){               //删除
				delRoleAuth(Integer.parseInt(roleId), resourceId);
			}
		}
		//保存权限值
		Set<Entry<String, Integer>> set = rightsMap.entrySet(); 
		for (Iterator<Entry<String, Integer>> iterator = set.iterator(); iterator.hasNext();) {
			Entry<String, Integer> entry = (Entry<String, Integer>) iterator.next();
			updateRights(Integer.parseInt(roleId), Integer.parseInt(entry.getKey()), entry.getValue());
		}
		return newIds;
	}
	
	@Override
	public void updateRights(Integer roleId,Integer resourcesId, Integer rights) {
		String hql = "update RoleResources set rights = :rights where resource.id = :resourcesId and role.id = :roleId";
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rights", rights);
		map.put("resourcesId", resourcesId);
		map.put("roleId", roleId);
		hbDaoSupport.executeHQL(hql, map);
	}
	
	@Override
	public List<Integer> findUserRole(Integer userId) {
		String hql = "from UserRole where user.id = ?";
		List<UserRole> urlist = hbDaoSupport.findTsByHQL(hql, userId);
		List<Integer> list = new ArrayList<Integer>();
		for(UserRole ur : urlist){
			list.add(ur.getRole().getId());
		}
		return list;
	}
	
	@Override
	public void saveUserRole(String roleIds, Integer userId) {
		String hql = "delete from UserRole where user.id = :userId";
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		hbDaoSupport.executeHQL(hql, map);
		
		UserInfo user = hbDaoSupport.findTById(UserInfo.class, userId);
		String roleIdss[] = roleIds.split(",");
		if(StringUtils.isNotEmpty(roleIds)){
			for(String roleId : roleIdss){
				 UserRole ur = new UserRole();
				 ur.setRole(hbDaoSupport.findTById(Role.class, Integer.parseInt(roleId)));
				 ur.setUser(user);
				 hbDaoSupport.save(ur);
			}
		}
	}
	
	private TreeNodes userTree(Resources res,List<Resources> list) {
		TreeNodes node = new TreeNodes();
		node.setId(res.getId().toString());
		node.setText(res.getName());
		Map<String, Object> attributes = new HashMap<String, Object>();
		if(StringUtils.isNotEmpty(res.getUrl())){
			attributes.put("url", res.getUrl()+"?access="+res.getAccesss());
		}else{
			attributes.put("url", null);
		}
		node.setAttributes(attributes);
		if (res.getSet() != null && res.getSet().size() > 0) {
			List<TreeNodes> children = new ArrayList<TreeNodes>();
			List<Resources> l = new ArrayList<Resources>();
			for(Resources r : res.getSet()){
				l.add(r);
			}
			Collections.sort(l, new Comparator<Resources>(){
				@Override
				public int compare(Resources o1, Resources o2) {
					int i1 = o1.getSeq() != null ? o1.getSeq().intValue() : -1;
					int i2 = o2.getSeq() != null ? o2.getSeq().intValue() : -1;
					return i1 - i2;
				}
			});
			for (Resources r : l) {
				if(res.getIsLeaf() != 0){
					boolean b = false;
					for(Resources rs : list){
						if(rs.getId().equals(r.getId())){
							b = true; break;
						}
					}
					if(b){
						TreeNodes tn = userTree(r,list);
						children.add(tn);
					}
				}else{
					TreeNodes tn = userTree(r,list);
					children.add(tn);
				}
			}
			node.setChildren(children);
			node.setState("closed");
		}
		return node;
	}
	
	@Override
	public List<TreeNodes> findUserResourcesJson() {
		List<Resources> resourcesList = UserContext.getUserResource();
		if(resourcesList.size() == 0){
			resourcesList = findUserResources();
		}
		List<TreeNodes> treeNodeList = new ArrayList<TreeNodes>();
		for(Resources res : resourcesList){
			if(res.getType() == 0){
				treeNodeList.add(userTree(res,resourcesList));
			}
		}
		return treeNodeList;
	}
	
	@Override
	public List<Resources> findUserResources() {
		List<Resources> resList = new ArrayList<Resources>();
		List<String> stringList = new ArrayList<String>();
		String hql = "from UserInfo where id = ?";
		List<UserInfo> list = hbDaoSupport.findTsByHQL(hql, UserContext.getUserId());
		for(UserInfo u : list){
			Set<UserRole> sets = u.getUserRoles();
			for(UserRole r : sets){
				Role role = r.getRole();
				Set<RoleResources> ress =  role.getRoleResource();
				for(RoleResources re : ress){
					Resources rrr = re.getResource();
					rrr.setAccesss(re.getRights());
					try{
						Resources rs = rrr.getResources();
						rs.getId();
						rrr.setType(1);
					}catch(Exception e){
						rrr.setType(0);
					}
					if(!stringList.contains(rrr.getName())){
						resList.add(rrr);
					}
					stringList.add(rrr.getName());
				}
			}
		}
		Collections.sort(resList, new Comparator<Resources>(){
			@Override
			public int compare(Resources o1, Resources o2) {
				int i1 = o1.getSeq() != null ? o1.getSeq().intValue() : -1;
				int i2 = o2.getSeq() != null ? o2.getSeq().intValue() : -1;
				return i1 - i2;
			}
		});
		return resList;
	}
	
	@Override
	public void deleteUser(String ids) {
		String hql = "UPDATE UserInfo SET disable = "+Dictionary.USER_STATE_DELETE+" where id in(:ids)";
		String hql1 = "DELETE FROM UserRole WHERE user.id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", CommonUtil.getIntegers(ids));
		hbDaoSupport.executeHQL(hql, map);
		hbDaoSupport.executeHQL(hql1,map);
	}
	
	@Override
	public Integer deleteRole(String ids) {
		boolean flag = false;
		Integer idss[] = CommonUtil.getIntegers(ids);
		for(Integer roleId : idss){
			String sql = "SELECT * FROM UserRole where role_id = ?";
			UserRole userRole = jdbcDaoSupport.findTBySQL(UserRole.class, sql,roleId);
			if(userRole != null){
				flag = true;break;
			}
		}
		if(flag){
			return 1;
		}else{
			for(Integer roleId : idss){
				String hql= "DELETE FROM Role where id = ?";
				hbDaoSupport.executeHQL(hql, roleId);
				hql = "DELETE FROM RoleResources where role.id = ?";
				hbDaoSupport.executeHQL(hql, roleId);
			}
			return 0;
		}
	}
	
	private TreeNodes menuTree(Resources res) {
		TreeNodes node = new TreeNodes();
		node.setId(res.getId().toString());
		node.setText(res.getName());
		Map<String, Object> attributes = new HashMap<String, Object>();
		attributes.put("url", res.getUrl());
		node.setAttributes(attributes);
		node.setSeq(res.getSeq()==null?0:res.getSeq());
		if (res.getSet() != null && res.getSet().size() > 0) {
			List<TreeNodes> children = new ArrayList<TreeNodes>();
			List<Resources> l = new ArrayList<Resources>();
			for(Resources r : res.getSet()){
				l.add(r);
			}
			Collections.sort(l, new Comparator<Resources>(){
				@Override
				public int compare(Resources o1, Resources o2) {
					int i1 = o1.getSeq() != null ? o1.getSeq().intValue() : -1;
					int i2 = o2.getSeq() != null ? o2.getSeq().intValue() : -1;
					return i1 - i2;
				}
			});

			for (Resources r : l) {
				TreeNodes tn = menuTree(r);
				children.add(tn);
			}
			node.setChildren(children);
			node.setState("open");
		}
		return node;
	}
	
	@Override
	public List<TreeNodes> findMenus() {
		String hql = "from Resources r where r.resources = 0 order by r.seq";
		List<Resources> list = hbDaoSupport.findTsByHQL(hql);
		List<TreeNodes> treeNodeList = new ArrayList<TreeNodes>();
		for(Resources res : list){
			treeNodeList.add(menuTree(res));
		}
		return treeNodeList;
	}
	
	@Override
	public void updateMenuSeq(Integer id, Integer seq) {
		String hql = "UPDATE Resources SET seq = ? WHERE id = ?";
		hbDaoSupport.executeHQL(hql, seq, id);
	}
	
	@Override
	public List<SysLog> findSystemLogs(SysLog log, Page page) {
		DetachedCriteria criteria = DetachedCriteria.forClass(log.getClass());
		criteria.addOrder(Order.desc("id"));
		if(StringUtils.isNotEmpty(log.getName())){
			criteria.add(Restrictions.like("operator", log.getName(),MatchMode.ANYWHERE));
		}
		if(StringUtils.isNotEmpty(log.getStartTime())){
			criteria.add(Restrictions.ge("time", log.getStartTime()));
		}
		if(StringUtils.isNotEmpty(log.getEndTime())){
			criteria.add(Restrictions.le("time", log.getEndTime()));
		}
		return hbDaoSupport.findPageByCriteria(page, criteria);
	}
	
	public void setHbDaoSupport(HBDaoSupport hbDaoSupport) {
		this.hbDaoSupport = hbDaoSupport;
	}

	public void setJdbcDaoSupport(JDBCDaoSupport jdbcDaoSupport) {
		this.jdbcDaoSupport = jdbcDaoSupport;
	}
}
