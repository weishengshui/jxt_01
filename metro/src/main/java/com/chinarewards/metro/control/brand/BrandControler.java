package com.chinarewards.metro.control.brand;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.common.ProgressBarMap;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.brand.BrandCriteria;
import com.chinarewards.metro.model.brand.BrandUnionMemberCriteria;
import com.chinarewards.metro.model.brand.UnionMemberVo;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.model.common.ImageInfo;
import com.chinarewards.metro.service.brand.IBrandService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.validator.brand.CreateBrandValidator;

@Controller
@RequestMapping("/brand")
public class BrandControler  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 309036467191425201L;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private IBrandService brandService;
	@Autowired
	private ISysLogService sysLogService;

	@RequestMapping("/show")
	public String show(HttpSession session, Model model, Integer id) {
		return "brand/show";
	}

	@RequestMapping("/edit")
	public String edit(HttpSession session, Model model, Integer id) {

		String imageSessionName = UUIDUtil.generate();
		if (null != id) {
			Brand brand = brandService.findBrandById(id);
			Map<String, FileItem> images = new HashMap<String, FileItem>();
			images.put("A"+UUIDUtil.generate(), brand.getLogo());
			session.setAttribute(imageSessionName, images);
			model.addAttribute("brand", brand);
			model.addAttribute("images", CommonUtil.toJson(images));
			model.addAttribute("imageSessionName", imageSessionName);
		}
		return "brand/edit";
	}

	@RequestMapping(value = "/list")
	public String listBrands(@ModelAttribute BrandCriteria criteria,
			Integer page, Integer rows, Model model) {

		logger.debug(
				"Entry list merchandise controller,That page is:{} criteria name is: {}",
				new Object[] { page, criteria.getName() });

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);

		criteria.setPaginationDetail(paginationDetail);

		List<Brand> brands = brandService.searchBrands(criteria);
		Long count = brandService.countBrands(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", brands);
		return "brand/list";
	}

	@RequestMapping(value = "/listUnionMember")
	public String listUnionMember(
			@ModelAttribute BrandUnionMemberCriteria criteria, Integer page,
			Integer rows, Model model) {

		logger.debug(
				"Entry list merchandise controller,That page is:{} criteria name is: {}",
				new Object[] { page, criteria.getMemberName() });

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);

		criteria.setPaginationDetail(paginationDetail);
		List<UnionMemberVo> list;
		int count;
		if (null == criteria.getBrandId()) {
			list = new ArrayList<UnionMemberVo>();
			count = 0;
		} else {
			long begin = System.currentTimeMillis();
			list = brandService.searchBrandUnionMembers(criteria, true);
			long page_time = System.currentTimeMillis();
			logger.trace("listUnionMember page time ====> "+((page_time-begin)/1000)+" seconds");
			count = brandService.countBrandUnionMembers(criteria);
		}

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", list);
		return "brand/edit";
	}

	/**
	 * 导出联合会员
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/exportUnionMember")
	public ModelAndView exportUnionMember(HttpServletResponse response,
			HttpServletRequest request,
			@ModelAttribute BrandUnionMemberCriteria criteria, Integer page,
			Integer rows, String uuid, Model model) throws Exception {
		
		ProgressBar progressBar = new ProgressBar(uuid, 0);
		ProgressBarMap.put(uuid, progressBar);
		brandService.exportUnionMember(response, request, criteria, progressBar);
		try {
			Brand brand = brandService.findBrandById(criteria.getBrandId());
			sysLogService.addSysLog("品牌联合会员", brand.getName(), OperationEvent.EVENT_EXPORT.getName(), "成功");
		} catch (Exception e) {
		}
		return null;
	}
	
	@RequestMapping("/create")
	@ResponseBody
	public void createOrUpdateBrand(HttpSession session,
			HttpServletResponse response,
			@ModelAttribute Brand brand, BindingResult result, Model model) throws IOException {
		PrintWriter out = null;
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		commonVo.setSuccess(false);
			response.setContentType("text/html; charset=utf-8");
			out = response.getWriter();
			logger.trace("enter createOrUpdateBrand()");

			logger.trace("brand name is " + brand.getName());
			logger.trace("brand unionInvited is "
					+ brand.getUnionInvited());
			new CreateBrandValidator(brandService).validate(brand, result);
			if (result.hasErrors()) {
				commonVo.setMsg(result.getAllErrors().get(0).getDefaultMessage());
				out.println(CommonUtil.toJson(commonVo));
			} else {
				if (null == brand.getId()) { // insert
					brandService.createBrand(brand);
					try {
						sysLogService.addSysLog("品牌新增", brand.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
					} catch (Exception e) {
					}
				} else {// update
					brandService.updateBrand(brand);
					try {
						sysLogService.addSysLog("品牌维护", brand.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
					} catch (Exception e) {
					}
				}
				commonVo.setMsg("保存成功");
				commonVo.setSuccess(true);
				commonVo.setId(brand.getId());
				out.println(CommonUtil.toJson(commonVo));
				out.flush();
			}
	}

	/**
	 * 将上传文件保存至临时文件夹
	 */
	@RequestMapping(value = "/imageUpload", method = RequestMethod.POST)
	@ResponseBody
	public void imageUpload(@RequestParam MultipartFile file, String path,
			String key, HttpSession session, String imageSessionName,
			HttpServletResponse response) {

		path = Dictionary.getPicPath(path);
		if (!"".equals(path)) {
			FileUtil.pathExist(path);
			PrintWriter out = null;
			if (null == imageSessionName || imageSessionName.isEmpty()) {
				imageSessionName = UUIDUtil.generate();
			}
			try {
				response.setContentType("text/html; charset=utf-8");
				out = response.getWriter();
				String fileName = file.getOriginalFilename();
				String suffix = getSuffix(fileName);
				String fileNewName = Constants.UPLOAD_TEMP_UID_PREFIX
						+ UUIDUtil.generate() + suffix;
				FileUtil.saveFile(file.getInputStream(), path, fileNewName);
				Map<String, FileItem> images = (HashMap<String, FileItem>) session
						.getAttribute(imageSessionName);
				if (null == images) {
					images = new HashMap<String, FileItem>();
				} else {
					FileItem image = images.get(key);
					if (null != image) { // 删除之前的遗留图片
						if (image.getUrl().startsWith(
								Constants.UPLOAD_TEMP_UID_PREFIX)) {
							File tempFile = new File(path, image.getUrl());
							tempFile.delete();
						}
						images.remove(key);
					}
				}

				FileItem image = new FileItem();
				logger.trace("image is " + image);
				ImageInfo imageInfo = FileUtil.getImageInfo(path, fileNewName);
				image.setWidth(imageInfo.getWidth());
				image.setHeight(imageInfo.getHeight());
				image.setCreatedAt(SystemTimeProvider.getCurrentTime());
				image.setCreatedBy(UserContext.getUserId());
				image.setFilesize(file.getSize());
				image.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
				image.setLastModifiedBy(UserContext.getUserId());
				image.setMimeType(file.getContentType());
				image.setOriginalFilename(fileName);
				image.setUrl(fileNewName);
				if(null == key || key.isEmpty()){
					key = "A"+UUIDUtil.generate();
				}
				images.put(key, image);

				session.setAttribute(imageSessionName, images);

				out.write("{url:\'" + image.getUrl() + "\',width:\'"
						+ image.getWidth() + "\',height:\'" + image.getHeight()
						+ "\',imageSessionName:\'" + imageSessionName
						+ "\',contentType:\'" + image.getMimeType() + "\',key:\'"+key+"\'}");
				out.flush();
			} catch (FileNotFoundException e) {
				out.write(CommonUtil.toJson(new AjaxResponseCommonVo("错误："
						+ e.getMessage())));
				out.flush();
				e.printStackTrace();
			} catch (IOException e) {
				out.write(CommonUtil.toJson(new AjaxResponseCommonVo("错误："
						+ e.getMessage())));
				out.flush();
				e.printStackTrace();
			} catch (Exception e) {
				out.write(CommonUtil.toJson(new AjaxResponseCommonVo("错误："
						+ e.getMessage())));
				out.flush();
				e.printStackTrace();
			}
		}
	}

	/**
	 * 批量删除品牌
	 * 
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponseCommonVo batchDeleteBrands(Integer[] ids) {
		
		AjaxResponseCommonVo ajaxResponseCommonVo = new AjaxResponseCommonVo();
		ajaxResponseCommonVo.setSuccess(false);
		if (null != ids && ids.length > 0) {
			for (Integer id : ids) {
				Brand brand = brandService.checkValidDelete(id);
				if (null != brand) {
					ajaxResponseCommonVo.setMsg("删除失败：品牌\"" + brand.getName()
							+ "\"下已经有联合会员，不能删除");
					return ajaxResponseCommonVo;
				}
				Brand brand2 = brandService.checkBrandHasMerchandise(id);
				if (null != brand2) {
					ajaxResponseCommonVo.setMsg("删除失败：品牌\"" + brand2.getName()
							+ "\"下已经有商品，不能删除");
					return ajaxResponseCommonVo;
				}
			}
			Integer count = brandService.batchDeleteBrands(ids);
			if (count == ids.length) {
				ajaxResponseCommonVo.setMsg("删除成功");
				ajaxResponseCommonVo.setSuccess(true);
				return ajaxResponseCommonVo;
			} else {
				ajaxResponseCommonVo.setMsg("删除出错");
				return ajaxResponseCommonVo;
			}
		} else {
			ajaxResponseCommonVo.setMsg("请选择要删除的品牌");
			return ajaxResponseCommonVo;
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/deleteImage")
	@ResponseBody
	public void deleteImage(HttpServletResponse response, HttpSession session,
			String imageSessionName, String key) throws Exception {

		Map<String, FileItem> images = (Map<String, FileItem>) session
				.getAttribute(imageSessionName);
		if(null!=images){
			images.remove(key);
		}

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.write("{msg:\'删除成功\'}");
		out.flush();
	}

	// return such as ".jpg"
	private String getSuffix(String fileName) {
		return fileName.substring(fileName.lastIndexOf("."));
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/saveImage")
	@ResponseBody 
	public AjaxResponseCommonVo saveImage(Integer id, String imageSessionName, HttpSession session){
		
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		
		Map<String, FileItem> images = (Map<String, FileItem>)session.getAttribute(imageSessionName);
		if(null == images || images.size() == 0){
			commonVo.setMsg("请先上传图片");
		}
		else{
			try {
				brandService.saveImages(id, images);
				try {
					Brand brand = brandService.findBrandById(id);
					sysLogService.addSysLog("品牌维护", brand.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
				} catch (Exception e) {
				}
				commonVo.setMsg("保存成功");
			} catch (IOException e) {
				commonVo.setMsg("错误："+e.getMessage());
				e.printStackTrace();
			}
		}
		
		return commonVo;
	}
	
}
