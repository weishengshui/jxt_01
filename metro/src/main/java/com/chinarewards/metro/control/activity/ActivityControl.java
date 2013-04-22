package com.chinarewards.metro.control.activity;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
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
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.activity.Token;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.service.activity.IActivityService;
import com.chinarewards.metro.service.brand.IBrandService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.utils.StringUtil;

@Controller
public class ActivityControl {

	@Autowired
	private IActivityService activityService;

	@Autowired
	private IBrandService brandService;
	
	@Autowired
	private ISysLogService sysLogService;

	Logger log = Logger.getLogger(this.getClass());

	/**
	 * 跳转列表页面
	 * 
	 * @return
	 */
	@RequestMapping("/activity/activityList")
	public String activityList() {
		return "activity/activityList";
	}

	/**
	 * 分页查询活动信息
	 */
	@RequestMapping(value = "/activity/findActivities")
	public String findActivities(Integer page, Integer rows, Model model,
			String activityName, String startDate, String endDate,
			String actStatus) throws Exception {
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);

		List<ActivityInfo> list = activityService.findActivity(activityName,
				startDate, endDate, actStatus, paginationDetail);
		model.addAttribute("rows", list);
		model.addAttribute("total", paginationDetail.getTotalRows());
		model.addAttribute("page", page);

		return "activity/activityList";
	}

	/**
	 * 查询参加活动的品牌信息
	 */
	@RequestMapping("/activity/findBrandAct")
	public Map<String, Object> findBrandAct(Brand bm, Page page)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("rows", activityService.findBrandAct(bm, page));
			map.put("total", page.getTotalRows());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * 查询没有参加活动的品牌信息
	 */
	@RequestMapping("/activity/findBrandNotBandAct")
	public Map<String, Object> findBrandNotBandAct(Brand bm, Page page,
			String id, String companyName, String name) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		bm = new Brand();
		try {
			if (StringUtils.isNotEmpty(name)) {
				bm.setName(name);
			}

			if (StringUtils.isNotEmpty(companyName)) {
				bm.setCompanyName(companyName);
			}
			map.put("rows", activityService.findBrandNotBandAct(bm, page, id));
			map.put("total", page.getTotalRows());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}

	@RequestMapping("/activity/addActivity")
	public String actMaintain() {
		return "activity/actMaintain";
	}

	/**
	 * 删除参加活动的品牌信息
	 */
	@RequestMapping(value = "/activity/delActAndBran", method = RequestMethod.POST)
	public String delActAndBran(HttpServletResponse response, String ids,String tag) {
		response.setContentType("text/html; charset=utf-8");
		Brand brand = null;
		PrintWriter out = null;
		try {
			out = response.getWriter();
			if (null != ids && ids.length() > 0) {
				String[] actIds = ids.split(",");
				for (String id : actIds) {
					brand = activityService.findBrand(Integer.valueOf(id));
					activityService.deleteActAndBranByIds(id);
					if("add".equals(tag)){
						sysLogService.addSysLog("活动新增--删除品牌", brand.getName(),
								OperationEvent.EVENT_DELETE.getName(), "成功");
					}else if("update".equals(tag)){
						sysLogService.addSysLog("活动修改--删除品牌", brand.getName(),
								OperationEvent.EVENT_DELETE.getName(), "成功");
					}
					
				}
			}
			out.print(CommonUtil.toJson(1));
		} catch (Exception e) {
			out.print(CommonUtil.toJson(0));
			if("add".equals(tag)){
				sysLogService.addSysLog("活动新增--删除品牌", brand.getName(),
						OperationEvent.EVENT_DELETE.getName(), "失败");
			}else if("update".equals(tag)){
				sysLogService.addSysLog("活动修改--删除品牌", brand.getName(),
						OperationEvent.EVENT_DELETE.getName(), "失败");
			}
			e.printStackTrace();
		}
		out.flush();
		out.close();
		return "activity/activityList";
	}

	/**
	 * 删除活动信息
	 */
	@RequestMapping(value = "/activity/deleteActivity", method = RequestMethod.POST)
	public String deleteActivity(HttpServletResponse response, String ids) {

		response.setContentType("text/html; charset=utf-8");

		PrintWriter out = null;
		ActivityInfo activityInfo = null;

		try {
			out = response.getWriter();
			if (null != ids && ids.length() > 0) {
				String[] actIds = ids.split(",");
				for (String id : actIds) {
					activityInfo = activityService.findActivityById(id);
					activityService.deleteActivity(id);
					sysLogService.addSysLog("活动维护",
							activityInfo.getActivityName(),
							OperationEvent.EVENT_DELETE.getName(), "成功");
				}
			}
			out.print(CommonUtil.toJson(1));
		} catch (Exception e) {
			out.print(CommonUtil.toJson(0));
			sysLogService.addSysLog("活动维护", activityInfo.getActivityName(),
					OperationEvent.EVENT_DELETE.getName(), "失败");
			e.printStackTrace();
		}
		out.flush();
		out.close();
		return "activity/activityList";
	}

	/**
	 * 删除绑定活动的POS机
	 */
	@RequestMapping(value = "/activity/delPosBand", method = RequestMethod.POST)
	public String delPosBand(HttpServletResponse response, String ids,String tag) {
		response.setContentType("text/html; charset=utf-8");
		PosBind posBind = null;
		PrintWriter out = null;
		try {
			out = response.getWriter();
			if (null != ids && ids.length() > 0) {
				String[] posIds = ids.split(",");
				if (null != posIds && posIds.length > 0) {
					for (String id : posIds) {
						posBind = activityService.findPosBind(Integer.valueOf(id));
						activityService.delPosBand(id);
						if("add".equals(tag)){
							sysLogService.addSysLog("活动新增--删除POS机", posBind.getCode(),
									OperationEvent.EVENT_DELETE.getName(), "成功");
						}else if("update".equals(tag)){
							sysLogService.addSysLog("活动修改--删除POS机", posBind.getCode(),
									OperationEvent.EVENT_DELETE.getName(), "成功");
						}
						
					}
				}
			}
			out.print(CommonUtil.toJson(1));
		} catch (Exception e) {
			if("add".equals(tag)){
				sysLogService.addSysLog("活动新增--删除POS机", posBind.getCode(),
						OperationEvent.EVENT_DELETE.getName(), "失败");
			}else if("update".equals(tag)){
				sysLogService.addSysLog("活动修改--删除POS机", posBind.getCode(),
						OperationEvent.EVENT_DELETE.getName(), "失败");
			}
			out.print(CommonUtil.toJson(0));
			e.printStackTrace();
		}
		out.flush();
		out.close();
		return "activity/activityList";
	}

	/**
	 * 添加参加活动的品牌信息
	 */
	@RequestMapping(value = "/activity/addBrandAct", method = RequestMethod.POST)
	public String addBrandAct(String ids, String actId,String tag) {
		Brand brand = null ;
		if (null != ids && ids.length() > 0) {
			String[] brandIds = ids.split(",");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try {
				Date joinTime = sdf.parse(sdf.format(new Date()));
				if (null != brandIds && brandIds.length > 0) {
					for (String id : brandIds) {
						if (id != null) {
							brand = brandService.findBrandById(Integer.valueOf(id));
							activityService.addBrandAct(id,
									Integer.valueOf(actId), joinTime);
							if("add".equals(tag)){
								sysLogService.addSysLog("活动新增--添加品牌", brand.getName(),
										OperationEvent.EVENT_SAVE.getName(), "成功");
							}else if("update".equals(tag)){
								sysLogService.addSysLog("活动修改--添加品牌", brand.getName(),
										OperationEvent.EVENT_SAVE.getName(), "成功");
							}
						}
					}
				}
			} catch (ParseException e) {
				if("add".equals(tag)){
					sysLogService.addSysLog("活动新增--添加品牌", brand.getName(),
							OperationEvent.EVENT_SAVE.getName(), "失败");
				}else if("update".equals(tag)){
					sysLogService.addSysLog("活动修改--添加品牌", brand.getName(),
							OperationEvent.EVENT_SAVE.getName(), "失败");
				}
				e.printStackTrace();
			}
		}
		return "activity/activityList";
	}

	/**
	 * 添加绑定的Pos机
	 */
	@RequestMapping(value = "/activity/savePos", method = RequestMethod.POST)
	@ResponseBody
	public void savePos(PosBind posBind, String code, String actId,
			String bindDate,String tag) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			Date d = sdf.parse(sdf.format(new Date()));
			posBind.setCode(code);
			posBind.setBindDate(sdf.parse(bindDate));
			posBind.setfId(Integer.valueOf(actId));
			posBind.setMark(0);
			posBind.setCreatedAt(d);
			posBind.setLastModifiedAt(d);
			activityService.savePosBind(posBind);
			if("add".equals(tag)){
				sysLogService.addSysLog("活动新增--添加Pos机", posBind.getCode(),
						OperationEvent.EVENT_SAVE.getName(), "成功");
			}else if("update".equals(tag)){
				sysLogService.addSysLog("活动修改--添加Pos机", posBind.getCode(),
						OperationEvent.EVENT_SAVE.getName(), "成功");
			}
			
		} catch (ParseException e) {
			if("add".equals(tag)){
				sysLogService.addSysLog("活动新增--添加Pos机", posBind.getCode(),
						OperationEvent.EVENT_SAVE.getName(), "失败");
			}else if("update".equals(tag)){
				sysLogService.addSysLog("活动修改--添加Pos机", posBind.getCode(),
						OperationEvent.EVENT_SAVE.getName(), "失败");
			}
			e.printStackTrace();
		}
	}

	/**
	 * 检测pos机是否绑定门店
	 */
	@RequestMapping(value = "/activity/checkPosBand", method = RequestMethod.POST)
	public void checkPosBand(String code, HttpServletResponse response) {
		response.setContentType("text/html; charset=utf-8");
		try {
			PrintWriter out = response.getWriter();

			int count = activityService.checkPosBand(code);

			out.print(CommonUtil.toJson(count));
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 查询绑定活动的POS机
	 */
	@RequestMapping(value = "/activity/queryPosBands", method = RequestMethod.POST)
	public Map<String, Object> queryPosBands(PosBind posBind, Page page)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("rows", activityService.queryPosBands(posBind, page));
			map.put("total", page.getTotalRows());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * 查询单个活动所绑定的品牌
	 */
	@RequestMapping(value = "/activity/query_actBands", method = RequestMethod.POST)
	public Map<String, Object> queryactBands(String name, Page page, String id)
			throws Exception {
		if (id == null) {
			return null;
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("rows",
					activityService.findBrandAct(name, page,
							Integer.valueOf(id)));
			map.put("total", page.getTotalRows());
			return map;
		}

	}

	/**
	 * 查询单个活动所绑定的POS机
	 */
	@RequestMapping(value = "/activity/query_posBands", method = RequestMethod.POST)
	public Map<String, Object> queryposBands(PosBind posBind, Page page,
			String id) throws Exception {
		if (id == null) {
			return null;
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("rows",
					activityService.queryPosBands(posBind, page,
							Integer.valueOf(id)));
			map.put("total", page.getTotalRows());
			return map;
		}
	}

	/**
	 * 查询对象，跳转到修改页面
	 */
	@RequestMapping(value = "/activity/queryActivity")
	public String queryActivity(HttpSession session, Model model, String id) {
		getActInfo(session, model, id);
		return "activity/updateActivity";
	}

	/**
	 * 查询对象，跳转到查看页面
	 */
	@RequestMapping(value = "/activity/lookActivity")
	public String lookActivity(HttpSession session, Model model, String id) {
		getActInfo(session, model, id);
		return "activity/lookActivity";
	}

	/**
	 * 修改活动
	 */
	@RequestMapping("/activity/update")
	@ResponseBody
	public void updateActivity(HttpSession session, String id,
			String imageSessionName, HttpServletRequest request,
			HttpServletResponse response,
			@ModelAttribute ActivityInfo activity, BindingResult result,
			Model model) throws IOException {
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		activityService.updateActivity(activity);
		out.print(CommonUtil.toJson(1));
		sysLogService.addSysLog("活动修改", activity.getActivityName(),
				OperationEvent.EVENT_UPDATE.getName(), "成功");
		out.flush();
		out.close();
	}

	private com.chinarewards.metro.domain.file.FileItem getFileItems(
			HttpSession session, String imageSessionName) throws IOException {
		com.chinarewards.metro.domain.file.FileItem actImage = null;
		Map<String, com.chinarewards.metro.domain.file.FileItem> images = (HashMap<String, com.chinarewards.metro.domain.file.FileItem>) session
				.getAttribute(imageSessionName);
		if (null != images && images.size() > 0) {
			for (Map.Entry<String, com.chinarewards.metro.domain.file.FileItem> image : images
					.entrySet()) {
				actImage = image.getValue();
				break;
			}
		}
		if (null != actImage
				&& actImage.getUrl().startsWith(
						Constants.UPLOAD_TEMP_UID_PREFIX)) {
			actImage.setUrl(FileUtil.moveFile(Constants.ACTIVITY_IMAGE_BUFFER,
					actImage.getUrl(), Constants.ACTIVITY_IMAGE_DIR));
		}
		return actImage;
	}

	@RequestMapping("/activity/checkActNameAndTime")
	@ResponseBody
	public void checkActNameAndTime(HttpServletResponse response, String name,
			String dTime, String id) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = null;
		int count = 0;
		try {
			out = response.getWriter();
			count = activityService.checkActNameAndTime(name, sdf.parse(dTime),
					id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (count > 0) {
			out.print(CommonUtil.toJson(1));
		} else {
			out.print(CommonUtil.toJson(0));
		}
		out.flush();
		out.close();
	}

	@RequestMapping("/activity/savePic")
	@ResponseBody
	public void savePic(HttpSession session, HttpServletResponse response,
			String actId, String imageSessionName) {
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = null;
		ActivityInfo activity = null ; 
		try {
			if (!StringUtil.isEmptyString(imageSessionName)) {
				out = response.getWriter();
				activity = activityService.findActivityById(actId);
				com.chinarewards.metro.domain.file.FileItem actImage = getFileItems(
						session, imageSessionName);
				activity.setImage(actImage);
				activityService.updateActivity(activity);
				sysLogService.addSysLog("活动图片上传", activity.getActivityName(),
						"图片上传", "成功");
				out.print(CommonUtil.toJson(1));
			}
		} catch (Exception e) {
			sysLogService.addSysLog("活动图片上传", activity.getActivityName(),
					"图片上传", "失败");
			e.printStackTrace();
		}
		out.flush();
		out.close();
	}

	/**
	 * 添加活动
	 */
	@RequestMapping("/activity/saveActivity")
	@ResponseBody
	public void saveActivity(HttpSession session, HttpServletRequest request,
			HttpServletResponse response, String imageSessionName,
			@ModelAttribute ActivityInfo activity, BindingResult result,
			Model model) throws IOException {

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		Token token = Token.getInstance();
		if (token.isTokenValid(request)) {

			activity.setTag(1);
			activityService.saveActivity(activity);

		} else {
			activityService.updateActivity(activity);

			token.saveToken(request);
		}
		sysLogService.addSysLog("活动新增", activity.getActivityName(),
				OperationEvent.EVENT_SAVE.getName(), "成功");
		out.print(CommonUtil.toJson(activity.getId()));
		out.flush();
		out.close();

	}

	/**
	 * 字符串截取
	 */
	private String getSuffix(String fileName) {
		return fileName.substring(fileName.lastIndexOf("."));
	}

	/**
	 * 获取单个活动的信息
	 */
	private void getActInfo(HttpSession session, Model model, String id) {
		try {
			String imageSessionName = UUIDUtil.generate();
			model.addAttribute("imageSessionName", imageSessionName);
			if (id != null) {
				ActivityInfo activity = activityService.findActivityById(id);
				Map<String, com.chinarewards.metro.domain.file.FileItem> images = new HashMap<String, com.chinarewards.metro.domain.file.FileItem>();
				images.put("A" + UUIDUtil.generate(), activity.getImage());
				session.setAttribute(imageSessionName, images);
				model.addAttribute("images", CommonUtil.toJson(images));
				model.addAttribute("activity", activity);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 取消活动
	 */
	@RequestMapping(value = "/activity/cancerActivity", method = RequestMethod.POST)
	public String cancerActivity(String ids) {
		ActivityInfo activityInfo = null;
		try {
			if (null != ids && ids.length() > 0) {
				String[] actIds = ids.split(",");
				for (String id : actIds) {
					activityInfo = activityService.findActivityById(id);
					activityService.cancerActivity(id);
					sysLogService.addSysLog("活动取消",
							activityInfo.getActivityName(),
							OperationEvent.EVENT_CANCEL.getName(), "成功");
				}
			}
		} catch (Exception e) {
			sysLogService.addSysLog("活动取消", activityInfo.getActivityName(),
					OperationEvent.EVENT_CANCEL.getName(), "失败");
			e.printStackTrace();
		}
		return "activity/activityList";
	}

	@RequestMapping(value = "/showPicture")
	public void shopPicUpload(HttpServletResponse response) {
		try {
			PrintWriter writer = response.getWriter();
			response.setContentType("text/html;charset=utf-8");
			// writer.write(CommonUtil.toJson(list));
			writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
