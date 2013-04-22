package com.chinarewards.metro.control.medal;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.domain.activity.Token;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.medal.Medal;
import com.chinarewards.metro.domain.medal.MedalRule;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.service.medal.IMedalService;
import com.chinarewards.metro.service.system.ISysLogService;

@Controller
public class MedalControl {

	@Autowired
	private IMedalService medalService;

	@Autowired
	private ISysLogService sysLogService;
	
	@RequestMapping("/medal/medalList")
	public String medalList(Model model) {
		return "medal/medalList";
	}

	@RequestMapping("/medal/addMedal")
	public String medalAdd(Model model) {
		return "medal/addMedal";
	}
	
	@RequestMapping("/medal/medalRule")
	public String medalRule(Model model) {
		try {
			MedalRule medalRule = medalService.findMedalRule();
			model.addAttribute("medalRule", medalRule);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "medal/medalRule";
	}

	/**
	 * 分页查询活动信息
	 */
	@RequestMapping(value = "/medal/findMedalList")
	public String findMedalList(Integer page, Integer rows, Model model,
			String medalName, String obtainWay) throws Exception {
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);

		try {
			List<Medal> list = medalService.findMedalList(medalName, obtainWay,
					paginationDetail);
			model.addAttribute("rows", list);
			model.addAttribute("total", paginationDetail.getTotalRows());
			model.addAttribute("page", page);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "medal/medalList";
	}

	/**
	 * 查询对象，跳转到修改页面
	 */
	@RequestMapping(value = "/medal/queryMedal")
	public String queryMedal(HttpSession session, Model model, String id) {
		try {
			String imageSessionName = UUIDUtil.generate();
			model.addAttribute("imageSessionName", imageSessionName);
			if (id != null) {
				Medal medal = medalService.findMedalById(id);
				Map<String, com.chinarewards.metro.domain.file.FileItem> images = new HashMap<String, com.chinarewards.metro.domain.file.FileItem>();
				images.put("key1", medal.getMobiImage());
				images.put("key2", medal.getWebsiteImage());
				session.setAttribute(imageSessionName, images);
				model.addAttribute("images", CommonUtil.toJson(images));
				model.addAttribute("medal", medal);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "medal/updateMedal";
	}

	/**
	 * 删除勋章信息
	 */
	@RequestMapping(value = "/medal/delMedal", method = RequestMethod.POST)
	public String delMedal(HttpServletResponse response,String ids) {
		response.setContentType("text/html; charset=utf-8");
		Medal medal = null ;
		PrintWriter out = null ;
		try {
			out = response.getWriter();
			if (null != ids && ids.length() > 0) {
				String[] mIds = ids.split(",");
				if (null != mIds && mIds.length > 0) {
					for (String id : mIds) {
						medal = medalService.findMedalById(id);
						medalService.delMedal(id);
						sysLogService.addSysLog("勋章维护", medal.getMedalName(), OperationEvent.EVENT_DELETE.getName(), "成功");
					}
				}
			}
			out.print(CommonUtil.toJson(1));
			
		} catch (Exception e) {
			sysLogService.addSysLog("勋章维护", medal.getMedalName(), OperationEvent.EVENT_DELETE.getName(), "失败");
			out.print(CommonUtil.toJson(0));
			e.printStackTrace();
		}
		out.flush();
		out.close();
		return "medal/medalList";
	}

	/**
	 * 添加
	 */
	@RequestMapping("/medal/saveMedal")
	@ResponseBody
	public void saveMedal(HttpSession session, HttpServletRequest request,
			HttpServletResponse response, String imageSessionName,
			@ModelAttribute Medal medal, BindingResult result, Model model)
			throws IOException {
		String key1 = request.getParameter("key1");
		String key2 = request.getParameter("key2");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		try {
			Token token = Token.getInstance();
			if (token.isTokenValid(request)) {
				Map<String, com.chinarewards.metro.domain.file.FileItem> images = getFileItems(
						session, imageSessionName);
				if(images != null){
					FileItem image1 = images.get(key1);
					medal.setMobiImage(image1);
					FileItem image2 = images.get(key2);
					medal.setWebsiteImage(image2);
				}
				
				medalService.saveMedal(medal);
			}else{
				
				Map<String, com.chinarewards.metro.domain.file.FileItem> images = getFileItems(
						session, imageSessionName);
				if(images != null){
					FileItem image1 = images.get(key1);
					medal.setMobiImage(image1);
					FileItem image2 = images.get(key2);
					medal.setWebsiteImage(image2);
				}
				medalService.updateMedal(medal);
				token.saveToken(request);
			}
			sysLogService.addSysLog("勋章新增", medal.getMedalName(), OperationEvent.EVENT_SAVE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("勋章新增", medal.getMedalName(), OperationEvent.EVENT_SAVE.getName(), "失败");
			e.printStackTrace();
		}
		out.print(CommonUtil.toJson(medal.getId()));
		out.flush();
		out.close();
	}

	private Map<String, com.chinarewards.metro.domain.file.FileItem> getFileItems(
			HttpSession session, String imageSessionName) throws IOException {
		com.chinarewards.metro.domain.file.FileItem actImage = null;
		Map<String, com.chinarewards.metro.domain.file.FileItem> images = (HashMap<String, com.chinarewards.metro.domain.file.FileItem>) session
				.getAttribute(imageSessionName);
		if (null != images && images.size() > 0) {
			for (Map.Entry<String, com.chinarewards.metro.domain.file.FileItem> image : images
					.entrySet()) {
				actImage = image.getValue();
				if (null != actImage
						&& actImage.getUrl().startsWith(
								Constants.UPLOAD_TEMP_UID_PREFIX)) {
					actImage.setUrl(FileUtil.moveFile(
							Constants.ACTIVITY_IMAGE_BUFFER,
							actImage.getUrl(), Constants.ACTIVITY_IMAGE_DIR));
				}
			}
		}
		return images;
	}
	
	/**
	 * 添加勳章規則
	 */
	@RequestMapping(value = "/medal/addMedalRule", method = RequestMethod.POST)
	@ResponseBody
	public void addMedalRule(HttpSession session, String rule,
			HttpServletRequest request, HttpServletResponse response,
			Model model) throws IOException {
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		try {
			MedalRule medalRule = medalService.findMedalRule();
			if(medalRule != null){
				medalService.updateMedalRule(rule);
			}else{
				medalService.insertMedalRule(rule);
			}
			sysLogService.addSysLog("添加勋章规则", "勋章规则", OperationEvent.EVENT_SAVE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("添加勋章规则", "勋章规则", OperationEvent.EVENT_SAVE.getName(), "失败");
			e.printStackTrace();
		}
		out.print(CommonUtil.toJson(1));
		out.flush();
		out.close();
	}
	
	
	/**
	 * 修改
	 */
	@RequestMapping("/medal/updateMedal")
	@ResponseBody
	public void updateMedal(HttpSession session, HttpServletRequest request,
			HttpServletResponse response, String imageSessionName,
			@ModelAttribute Medal medal, BindingResult result, Model model)
			throws IOException {
		String key1 = request.getParameter("key1");
		String key2 = request.getParameter("key2");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		try {
			Map<String, com.chinarewards.metro.domain.file.FileItem> images = getFileItems(
					session, imageSessionName);
			if(images != null){
				FileItem image1 = images.get(key1);
				medal.setMobiImage(image1);
				FileItem image2 = images.get(key2);
				medal.setWebsiteImage(image2);
			}
			medalService.updateMedal(medal);
			sysLogService.addSysLog("修改勋章", medal.getMedalName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("修改勋章", medal.getMedalName(), OperationEvent.EVENT_UPDATE.getName(), "失败");
			e.printStackTrace();
		}
		out.print(CommonUtil.toJson(medal.getId()));
		out.flush();
		out.close();
	}
	
	
	/**
	 * 检测是否存在相同名称的勋章
	 */
	@RequestMapping("/medal/checkName")
	@ResponseBody
	public void checkName(HttpSession session, String name, String id,
			HttpServletRequest request, HttpServletResponse response,
			Model model) throws IOException {
		boolean flag = false ;
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		if(name != null){
			flag = medalService.checkName(name,id);
		}
		out.print(CommonUtil.toJson(flag));
		out.flush();
		out.close();
	}
	
	/**
	 * 检测是否存在相同显示排序
	 */
	@RequestMapping("/medal/checkRevealSort")
	@ResponseBody
	public void checkRevealSort(HttpSession session, String revealSort,String id,
			HttpServletRequest request, HttpServletResponse response,
			Model model) throws IOException {
		boolean flag = false ;
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		if(revealSort != null){
			flag = medalService.checkRevealSort(Integer.valueOf(revealSort),id);
		}
		out.print(CommonUtil.toJson(flag));
		out.flush();
		out.close();
	}
}
