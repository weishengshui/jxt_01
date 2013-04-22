package com.chinarewards.metro.control.user;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.TreeNodes;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.system.SysLog;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.domain.user.Role;
import com.chinarewards.metro.domain.user.RoleResources;
import com.chinarewards.metro.domain.user.UserInfo;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.service.user.IUserService;

@Controller
public class UserControl {

	@Autowired
	private IUserService userService;
	@Autowired
	private ISysLogService sysLogService;
	
	@RequestMapping("/login")
	public String login(HttpServletRequest request){
		return "login";
	}
	
	@ResponseBody
	@RequestMapping("/validate")
	public String validate(String userName,String randCode,HttpServletRequest request){
		String rand = (String) request.getSession().getAttribute("rand");
		if(!rand.equals(randCode)){
			return "验证码不正确";
		}
		UserInfo userInfo = userService.findUserByName(userName);
		if(userInfo == null){
			return "用户名不存在";
		}else{
			if(Dictionary.USER_STATE_LOCKED == userInfo.getDisable()){
				return "该用户已经被锁定";
			}
		}
		return "0";
	}
	
	@RequestMapping("/index")
	public String index(HttpServletResponse response,Model model){
		response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        //时间
        Calendar c = Calendar.getInstance();
        c.setTime(new Date());
        model.addAttribute("year", c.get(Calendar.YEAR));
        model.addAttribute("month", c.get(Calendar.MONTH)+1);
        model.addAttribute("day", c.get(Calendar.DAY_OF_MONTH));
        model.addAttribute("hour", c.get(Calendar.HOUR_OF_DAY));
        model.addAttribute("minute", c.get(Calendar.MINUTE));
        model.addAttribute("second", c.get(Calendar.SECOND));
		return "index";
	}
	
	@ResponseBody
	@RequestMapping("user/findUserResources")
	public List<TreeNodes> findUserResources(){
		return userService.findUserResourcesJson();
	}
	
	/**
	 * 登录验证成功
	 **/
	@RequestMapping(value = "/authorize")
	public String authorize(HttpServletRequest request){
		SecurityContext context = SecurityContextHolder.getContext();
		UserDetails user = (UserDetails) context.getAuthentication().getPrincipal();
		UserInfo userInfo = userService.findUserByName(user.getUsername());
		UserContext.setSessionAttribute(request, UserContext.USER_ID, userInfo.getId());
		UserContext.setSessionAttribute(request, UserContext.USER_NAME, userInfo.getUserName());
		UserContext.setSessionAttribute(request, UserContext.LOGIN_IP, request.getRemoteHost());
		UserContext.setSessionAttribute(request, UserContext.LOGIN_TIME, new Date());
		UserContext.setSessionAttribute(request, UserContext.USER_RESOURCE, userService.findUserResources());
		sysLogService.addSysLog("系统管理", UserContext.getUserName(), OperationEvent.EVENT_LOGIN.getName(), "成功");
		return "redirect:/index";
	}
	
	@RequestMapping("user/userIndex")
	public String userIndex(Model model){
		return "user/userList";
	}
	
	/**
	 * 查询用户
	 * @param userInfo
	 * @param page
	 * @return
	 */
	@RequestMapping("user/findUserInfos")
	public Map<String,Object> findUserInfos(UserInfo userInfo,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", userService.findUserInfo(userInfo, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "user/save")
	public UserInfo create(UserInfo user){
		try{
			UserInfo u = userService.saveUser(user);
			sysLogService.addSysLog("用户管理", user.getUserName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			return u;
		}catch(Exception e){
			sysLogService.addSysLog("用户管理", user.getUserName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "user/findUserByName")
	public String findUserByName(String userName){
		UserInfo user = userService.findUserByName(userName);
		if(user != null){
			return "suc";
		}
		return "";
	}
	
	@ResponseBody
	@RequestMapping("user/resetPassword")
	public String resetPassword(String ids)throws Exception{
		userService.updatePassword(ids,Constants.RESET_PASSWORD);
		return Constants.RESET_PASSWORD;
	}
	
	
	@ResponseBody
	@RequestMapping("user/lockUser")
	public void lockUser(String ids,String names,Integer disable)throws Exception{
		try{
			userService.lockUser(ids, disable);
			for(String s:names.split(",")){
				//" "+(disable == Dictionary.USER_STATE_NORMAL ? "启用用户":"锁定用户")
				sysLogService.addSysLog("用户管理", s , OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
		}catch(Exception e){
			for(String s:names.split(",")){
				sysLogService.addSysLog("用户管理", s, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "user/validateOldPwd")
	public String validateOldPwd(String oldpwd,String newpwd){
		UserInfo userInfo = userService.findUserByName(UserContext.getUserName());
		if(MD5.MD5Encoder(oldpwd).equals(userInfo.getPassword())){
			try{
				userService.updatePassword(userInfo.getId().toString(),newpwd);
				//"  修改密码"
				sysLogService.addSysLog("系统管理", UserContext.getUserName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}catch(Exception e){
				sysLogService.addSysLog("系统管理", UserContext.getUserName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
				throw new RuntimeException(e);
			}
			
			return "suc";
		}else{
			return "";
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/user/updatePwds")
	public void updatePwds(String newpwd,String ids,String names){
		try{
			userService.updatePassword(ids,newpwd);
			for(String s : names.split(",")){
				//  修改密码
				sysLogService.addSysLog("用户管理", s, OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
		}catch(Exception e){
			for(String s : names.split(",")){
				sysLogService.addSysLog("用户管理", s , OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
		
	}
	
	@RequestMapping("user/deleteUser")
	@ResponseBody
	public void deleteUser(String ids,String names){
		try{
			userService.deleteUser(ids);
			for(String s : names.split(",")){
				sysLogService.addSysLog("用户管理", s, OperationEvent.EVENT_DELETE.getName(), "成功");
			}
		}catch(Exception e){
			for(String s : names.split(",")){
				sysLogService.addSysLog("用户管理", s, OperationEvent.EVENT_DELETE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
		
	}
	
	/*----------  ROLE  ------------*/
	
	@RequestMapping(value = "user/roleList")
	public String roleList(){
		return "user/roleList";
	}
	
	@ResponseBody
	@RequestMapping(value = "user/saveRole")
	public void saveRole(Role role){
		try {
			userService.saveRole(role);
			if(role.getId() == null){
				sysLogService.addSysLog("角色管理", role.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			}else{
				sysLogService.addSysLog("角色管理", role.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
		} catch (Exception e) {
			if(role.getId() == null){
				sysLogService.addSysLog("角色管理", role.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			}else{
				sysLogService.addSysLog("角色管理", role.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}
	
	@RequestMapping(value = "user/findRoles")
	public Map<String,Object> findRoles(Role role,Page page){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("rows", userService.findRoles(role, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	/**
	 * 查询角色名是否存在
	 * @param roleName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("user/findRoleByName")
	public String findRoleByName(String roleName,Integer id){
		Role role = userService.findRoleByName(roleName);
		if(role != null){
			if(!role.getId().equals(id)){
				return "suc";	
			}else{
				return "";
			}
		}
		return "";
	}
	
	/**
	 * 为角色添加权限
	 * @param model
	 * @param role
	 * @return
	 */
	@RequestMapping(value = "user/roleAuthority")
	public String roleAuthority(Model model,Role role){
		// 查询角色资源,用于保存时判断
		List<RoleResources> list = userService.findResourceByRole(role.getId());
		String s = "";
		for(RoleResources roleRes : list){
			if(!"".equals(s)) s += ",";
			s += roleRes.getResource().getId();
		}
		model.addAttribute("old", s);
		return "user/roleAuth";
	}
	
	@ResponseBody
	@RequestMapping(value = "user/findResources")
	public List<TreeNodes> findResources(Integer roleId) throws IOException{
		return userService.findResourcesByType(roleId);
	}
	
	@ResponseBody
	@RequestMapping(value = "user/saveRoleAuthority")
	public String saveRoleAuthority(String roleId,String resourceIds,String old,String name){
		
		try {
			String s = userService.saveRoleAuth(roleId, resourceIds, old);
			//"  添加权限"
			sysLogService.addSysLog("角色管理", name , OperationEvent.EVENT_UPDATE.getName(), "成功");
			return s;
		} catch (Exception e) {
			sysLogService.addSysLog("角色管理", name , OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	@RequestMapping("user/deleteRole")
	@ResponseBody
	public Integer deleteRole(String ids,String names){
		try {
			int i = userService.deleteRole(ids);
			sysLogService.addSysLog("角色管理", names, OperationEvent.EVENT_DELETE.getName(), "成功");
			return i;
		} catch (Exception e) {
			sysLogService.addSysLog("角色管理", names, OperationEvent.EVENT_DELETE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	
	/*---------- User Role --------------*/
	@RequestMapping(value = "/userRoleList")
	public String userRoleList(){
		return "/user/userRole";
	}
	
	@ResponseBody
	@RequestMapping(value = "user/saveUserRole")
	public void saveUserRole(String roleIds,Integer userId,String rname,String uname){
		try {
			userService.saveUserRole(roleIds, userId);
			//" 添加了"+rname+"角色"
			sysLogService.addSysLog("用户管理", uname, OperationEvent.EVENT_UPDATE.getName(),"成功");
		} catch (Exception e) {
			sysLogService.addSysLog("用户管理", uname, OperationEvent.EVENT_UPDATE.getName(),"失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "user/findUserRole")
	public List<Integer> findUserRole(Integer userId){
		return userService.findUserRole(userId);
	}
	
	/**
	 * 菜单管理
	 */
	@RequestMapping("/menu/menuIndex")
	public String menuIndex(){
		return "/user/menuList";
	}
	
	@ResponseBody
	@RequestMapping("/menu/findMenus")
	public List<TreeNodes> findMenus(){
		return userService.findMenus();
	}
	
	/**
	 * 修改编号
	 */
	@ResponseBody
	@RequestMapping("/menu/updateMenuSeq")
	public void updateMenuSeq(Integer id,Integer seq){
		userService.updateMenuSeq(id, seq);
	}
	
	@RequestMapping("/system/log")
	public String systemLog(){
		return "/user/systemLog";
	}
	
	@RequestMapping("/system/findLogs")
	public Map<String,Object> findSystemLogs(SysLog log,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", userService.findSystemLogs(log, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
}
