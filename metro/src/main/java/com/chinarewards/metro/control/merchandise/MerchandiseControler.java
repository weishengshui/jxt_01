package com.chinarewards.metro.control.merchandise;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
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

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.business.RedemptionDetail;
import com.chinarewards.metro.domain.category.Category;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.file.ImageType;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.domain.merchandise.MerchandiseCatalog;
import com.chinarewards.metro.domain.merchandise.MerchandiseFile;
import com.chinarewards.metro.domain.merchandise.MerchandiseImageType;
import com.chinarewards.metro.domain.merchandise.MerchandiseSaleform;
import com.chinarewards.metro.domain.merchandise.MerchandiseStatus;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.model.common.ImageInfo;
import com.chinarewards.metro.model.merchandise.CategoryVo;
import com.chinarewards.metro.model.merchandise.MerchandiseCatalogVo;
import com.chinarewards.metro.model.merchandise.MerchandiseCriteria;
import com.chinarewards.metro.model.merchandise.MerchandiseKeyVo;
import com.chinarewards.metro.model.merchandise.MerchandiseShopVo;
import com.chinarewards.metro.model.merchandise.MerchandiseVo;
import com.chinarewards.metro.model.merchandise.SaleFormVo;
import com.chinarewards.metro.service.category.ICategoryService;
import com.chinarewards.metro.service.merchandise.IMerchandiseService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.validator.merchandise.CreateMerchandiseValidator;

@Controller
@RequestMapping("/merchandise")
public class MerchandiseControler {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private IMerchandiseService merchandiseService;
	@Autowired
	private ICategoryService categoryService;
	@Autowired
	private ISysLogService sysLogService;

	/**
	 * 商品维护
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/show")
	public String showCreateMerchandise(HttpSession session, Model model,
			String id) {

		// prepare data
		Merchandise merchandise = merchandiseService.findMerchandiseById(id);
		List<MerchandiseSaleform> saleforms = merchandise
				.getMerchandiseSaleforms();
		List<CategoryVo> categoryVos = merchandiseService
				.findCategorysByMerchandise(merchandise);
		List<MerchandiseShopVo> shopVos = merchandiseService
				.getMerchandiseShopVosByMerchandise(merchandise);
		String imageSessionName = UUIDUtil.generate();
		Map<String, FileItem> images = merchandiseService
				.findMerchandiseFilesByMerchandise(merchandise);
		logger.trace("merchandise images size is " + images.size());
		List<MerchandiseKeyVo> keywords = merchandiseService.getKeywordsByMerchandise(merchandise);

		session.setAttribute(imageSessionName, images);

		model.addAttribute("images", CommonUtil.toJson(images));
		model.addAttribute("imageSessionName", imageSessionName);
		model.addAttribute("merchandise", merchandise);
		model.addAttribute("saleforms", CommonUtil.toJson(saleforms));
		model.addAttribute("categoryVos", CommonUtil.toJson(categoryVos));
		model.addAttribute("shopVos", CommonUtil.toJson(shopVos));
		model.addAttribute("keywords", CommonUtil.toJson(keywords));

		return "merchandise/create";
	}

	/**
	 * 新增商品
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("/add")
	public String add(Model model) {

		return "merchandise/create";
	}

	@RequestMapping("/maintain")
	public String maintain(Model model) {
		return "merchandise/show";
	}

	/**
	 * 商品类别与商品关系维护
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("merCate")
	public String merCate(Model model) {
		return "merchandise/merCate";
	}

	/**
	 * 创建商品
	 * 
	 * @param session
	 * @param request
	 * @param merchandise
	 * @param result
	 * @param mod
	 * @return
	 */
	@RequestMapping("/create")
	@ResponseBody
	public void createOrUpdateMerchandise(HttpServletResponse response,
			HttpSession session, @ModelAttribute Merchandise merchandise,
			BindingResult result, Model mod, String rmbUnitId,
			String binkeUnitId, Double rmbPrice, Double binkePrice,
			Boolean rmb, Boolean binke, Boolean rmbPreferential,
			Boolean binkePreferential, Double rmbPreferentialPrice,
			Double binkePreferentialPrice, String[] categId, String[] status,
			Long[] displaySort, Date[] on_offTime, Integer[] shopId,
			Integer[] merShopSort, String[] keywords) throws IOException {

		PrintWriter out = null;
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		commonVo.setId(merchandise.getId());
		response.setContentType("text/html; charset=utf-8");
		out = response.getWriter();

		logger.trace("enter CreateOrUpdateMerchandise()");

		// merchandise category
		List<CategoryVo> categoryVos = new ArrayList<CategoryVo>();
		if (null != categId) {
			for (int i = 0, length = categId.length; i < length; i++) {
				logger.trace("categId [] is " + categId[i]);
				categoryVos.add(new CategoryVo(categId[i], MerchandiseStatus
						.fromString(status[i]), on_offTime[i], displaySort[i],
						merchandise.getId()));
			}
		}
		logger.trace("categoryVos is " + categoryVos.toString());

		// merchandise sale forms
		List<SaleFormVo> saleFormVos = new ArrayList<SaleFormVo>(); // 兑换形式
		if (null != rmb) {// 正常售卖
			if (null == rmbPreferential) { // 没有优惠
				saleFormVos.add(new SaleFormVo(rmbUnitId, rmbPrice, null));
			} else {
				saleFormVos.add(new SaleFormVo(rmbUnitId, rmbPrice,
						rmbPreferentialPrice));
			}
		}
		if (null != binke) {// 积分兑换
			if (null == binkePreferential) {// 没有优惠
				saleFormVos.add(new SaleFormVo(binkeUnitId, binkePrice, null));
			} else {
				saleFormVos.add(new SaleFormVo(binkeUnitId, binkePrice,
						binkePreferentialPrice));
			}
		}

		// merchandise shop
		List<MerchandiseShopVo> merchandiseShopVos = new ArrayList<MerchandiseShopVo>();
		if (null != shopId && shopId.length > 0) {
			for (int i = 0, length = shopId.length; i < length; i++) {
				merchandiseShopVos.add(new MerchandiseShopVo(shopId[i], null,
						merShopSort[i]));
			}
		}

		// key words
		if (null != keywords && keywords.length > 0) {
			for (String key : keywords) {
				System.out
						.println("merchandise key words ==============================> "
								+ key);
			}
		}

		new CreateMerchandiseValidator(merchandiseService).validate(
				merchandise, result);
		if (result.hasErrors()) {
			commonVo.setMsg(result.getAllErrors().get(0).getDefaultMessage());
			out.println(CommonUtil.toJson(commonVo));
			out.flush();
			return;
		}

		logger.trace("merchandise.getId() is " + merchandise.getId());
		if (merchandiseService.checkCodeExists(merchandise)) {
			commonVo.setMsg("商品编号\"" + merchandise.getCode() + "\"已存在");
			out.println(CommonUtil.toJson(commonVo));
			out.flush();
			return;
		}
		if (merchandiseService.checkModelExists(merchandise)) {
			commonVo.setMsg("商品型号\"" + merchandise.getModel() + "\"已存在");
			out.println(CommonUtil.toJson(commonVo));
			out.flush();
			return;
		}
		if (null != categoryVos && categoryVos.size() > 0) { // 检查类别排序在指定的类别中是否已经存在
			for (CategoryVo categoryVo2 : categoryVos) {
				if (merchandiseService.checkDisplaySortExists(categoryVo2)) {
					Category category = categoryService
							.findCategoryById(categoryVo2.getCategoryId());
					String categoryFullName = merchandiseService
							.getCategoryFullName(category);
					commonVo.setMsg("\"" + categoryFullName + "\"类别中已存在该排序值");
					out.println(CommonUtil.toJson(commonVo));
					out.flush();
					return;
				}
			}
		}
		if (null == merchandise.getId() || merchandise.getId().isEmpty()) { // insert

			merchandiseService.createMerchandise(merchandise, saleFormVos,
					categoryVos, merchandiseShopVos, keywords);
			try {
				sysLogService.addSysLog("商品新增", merchandise.getName(),
						OperationEvent.EVENT_SAVE.getName(), "成功");
			} catch (Exception e) {
			}
		} else {// update

			merchandiseService.updateMerchandise(merchandise, saleFormVos,
					categoryVos, merchandiseShopVos, keywords);
			try {
				sysLogService.addSysLog("商品维护", merchandise.getName(),
						OperationEvent.EVENT_UPDATE.getName(), "成功");
			} catch (Exception e) {
			}
		}
		commonVo.setMsg("保存成功");
		commonVo.setId(merchandise.getId());
		out.println(CommonUtil.toJson(commonVo));
		out.flush();
	}

	@RequestMapping(value = "/list")
	public String listMerchandises(
			@ModelAttribute MerchandiseCriteria criteria, Integer page,
			Integer rows, Model model) {

		criteria.getName();
		logger.debug(
				"Entry list merchandise controller,That page is:{} criteria name is: {}",
				new Object[] { page, criteria.getName() });

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<MerchandiseVo> catalogs = merchandiseService
				.searchMerchandises(criteria);
		Long count = merchandiseService.countMerchandises(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", catalogs);
		return "merchandise/list";
	}

	/**
	 * 获取指定类别下的商品目录
	 */
	@RequestMapping("/getMerCatas")
	public String getMerCatas(@ModelAttribute MerchandiseCriteria criteria,
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

		List<MerchandiseCatalogVo> catalogs = merchandiseService
				.searchMerCatas(criteria);
		Long count = merchandiseService.countMerCatas(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", catalogs);
		return "merchandise/merCate";
	}

	/**
	 * 获取不是指定商品类别下的商品目录
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/getNotMerCatas")
	public String getNotMerCatas(@ModelAttribute MerchandiseCriteria criteria,
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

		List<MerchandiseCatalog> catalogs = merchandiseService
				.searchNotMerCatas(criteria);
		Long count = merchandiseService.countNotMerCatas(criteria);

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", catalogs);
		return "merchandise/merCate";
	}

	/**
	 * 改变商品目录的上下架状态
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping("/changeCataStatus")
	@ResponseBody
	public AjaxResponseCommonVo changeCataStatus(String id, String status,
			Model model) {

		merchandiseService.changeCataStatus(id, status);
		try {
			MerchandiseCatalog catalog = merchandiseService
					.findMerchandiseCatalogById(id);
			sysLogService.addSysLog("商品类别与商品维护", catalog.getCategory().getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
		}
		return new AjaxResponseCommonVo("修改成功");
	}

	/**
	 * 商品类别与商品维护中的“修改商品目录信息”
	 * 
	 * @return
	 */
	@RequestMapping("/updateCatalog")
	@ResponseBody
	public void updateCatalog(HttpServletResponse response, String catalogId,
			String status, Long displaySort, Model model) throws IOException {

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		MerchandiseCatalog catalog = merchandiseService
				.findMerchandiseCatalogById(catalogId);
		logger.trace("catalog.getId() is " + catalog.getId());
		
		CategoryVo categoryVo = new CategoryVo();
		categoryVo.setCatalogId(catalogId);
		categoryVo.setCategoryId(catalog.getCategory().getId());
		categoryVo.setDisplaySort(displaySort);
		
		if (merchandiseService.checkDisplaySortExists(categoryVo)) {
			AjaxResponseCommonVo ajaxResponseCommonVo = new AjaxResponseCommonVo();
			ajaxResponseCommonVo.setCategoryId(catalog.getCategory().getId());
			String categoryFullName = merchandiseService
					.getCategoryFullName(catalog.getCategory());
			ajaxResponseCommonVo.setMsg("\"" + categoryFullName
					+ "\"类别中已存在该排序值");
			out.println(CommonUtil.toJson(ajaxResponseCommonVo));
			out.flush();
			return;
		}
		catalog.setStatus(MerchandiseStatus.fromString(status));
		catalog.setDisplaySort(displaySort);
		merchandiseService.updateCatalog(catalog);
		try {
			sysLogService.addSysLog("商品类别与商品维护", catalog.getCategory().getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
		}

		out.println(CommonUtil.toJson(new AjaxResponseCommonVo("修改成功")));
		out.flush();
	}

	/**
	 * 解除商品目录与类别的关系
	 * 
	 * @param catalogIds
	 * @return
	 */
	@RequestMapping("/removeCataFromCategory")
	@ResponseBody
	public void removeCataFromCategory(HttpServletResponse response, String[] id)
			throws IOException {

		merchandiseService.removeCataFromCategory(id);

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.write(CommonUtil.toJson(new AjaxResponseCommonVo("删除成功")));
		out.flush();
	}

	@RequestMapping(value = "/checkMerchandiseCategorysCount", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponseCommonVo checkMerchandiseCategorysCount(Model model,
			String id) {
		
		if (merchandiseService.countMerchandiseCategorys(id).equals(new Integer(1))){
			return new AjaxResponseCommonVo("true");
		}else{
			return new AjaxResponseCommonVo("false");
		}
	}

	/**
	 * 批量删除商品
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public AjaxResponseCommonVo delete(String[] id, Model model) {
		logger.trace(String.valueOf(id));
		if (null != id && id.length > 0) {
			merchandiseService.batchDelete(id);
			return new AjaxResponseCommonVo("删除成功");
		} else {
			return new AjaxResponseCommonVo("请先选择要删除的行");
		}
	}

	/**
	 * 判断指定商品是否在该类别下
	 * 
	 * @param merCode
	 * @param cateId
	 * @param model
	 * @return
	 */
	@RequestMapping("/loadMerByMerCode")
	@ResponseBody
	public Merchandise loadMerByMerCode(String merCode, String cateId,
			Model model) {

		Merchandise merchandise = merchandiseService.loadMerByMerCode(merCode,
				cateId);

		return merchandise;
	}

	@RequestMapping(value = "/checkMerCodeExists")
	@ResponseBody
	public Merchandise checkMerCodeExists(String merCode, Model model) {

		Merchandise merchandise = merchandiseService
				.checkMerCodeExists(merCode);

		return merchandise;
	}

	private String getSuffix(String fileName) {
		return fileName.substring(fileName.lastIndexOf("."));
	}

	@RequestMapping("/addCatalog")
	@ResponseBody
	public void addCatalog(HttpServletResponse response, String[] merCode,
			String[] status, Long[] sort, String cateId, Model model)
			throws IOException {

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		try {
			if (null != merCode && merCode.length > 0 && null != cateId
					&& !cateId.isEmpty()) {
				List<CategoryVo> categoryVos = new ArrayList<CategoryVo>();
				for (int i = 0, length = merCode.length; i < length; i++) {
					if (!merCode[i].isEmpty()) {
						categoryVos.add(new CategoryVo(merCode[i],
								MerchandiseStatus.fromString(status[i]),
								sort[i]));
					}
				}
				merchandiseService
						.addMerchandiseToCategory(categoryVos, cateId);
				try {
					Category category = categoryService.findCategoryById(cateId);
					sysLogService.addSysLog("商品类别与商品维护", category.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
				} catch (Exception e) {
				}
				out.println(CommonUtil.toJson(new AjaxResponseCommonVo("添加成功")));
				out.flush();
				return;
			}
			out.println(CommonUtil
					.toJson(new AjaxResponseCommonVo("请先输入要添加的商品")));
			out.flush();
			return;
		} catch (Exception e) {
			out.println(CommonUtil.toJson(new AjaxResponseCommonVo(e
					.getMessage())));
			out.flush();
			return;
		}
	}

	@RequestMapping("/checkDisplaySortExists")
	@ResponseBody
	public String checkDisplaySortExists(String cateId, Long displaySort) {

		CategoryVo categoryVo = new CategoryVo(cateId, null, null, displaySort);
		if (merchandiseService.checkDisplaySortExists(categoryVo)) {
			return "{msg:" + true + "}";
		} else {
			return "{msg:" + false + "}";
		}
	}

	/**
	 * 将上传文件保存至临时文件夹
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/imageUpload", method = RequestMethod.POST)
	@ResponseBody
	public void imageUpload(
			@RequestParam(value = "file") MultipartFile file,
			String path, String key, String imageType, HttpSession session,
			String imageSessionName, HttpServletResponse response) {
		
		if (file.isEmpty()) {// 没有数据
			return;
		}

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
					images = new LinkedHashMap<String, FileItem>();
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
				image.setImageType(ImageType.fromString(imageType));
				
				if (null == key || key.isEmpty()) {
					key = "A" + UUIDUtil.generate();
				}
				images.put(key, image);

				logger.trace("images size is " + images.size()
						+ " key is " + key + " imageSessionName is "
						+ imageSessionName);
				session.setAttribute(imageSessionName, images);

				out.write("{url:\'" + image.getUrl() + "\',width:\'"
						+ image.getWidth() + "\',height:\'" + image.getHeight()
						+ "\',imageSessionName:\'" + imageSessionName
						+ "\',contentType:\'" + image.getMimeType()
						+ "\',key:\'" + key + "\'}");
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/saveImage")
	@ResponseBody 
	public AjaxResponseCommonVo saveImage(String id, String imageSessionName, HttpSession session){
		
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		
		Map<String, FileItem> images = (Map<String, FileItem>)session.getAttribute(imageSessionName);
		if(null == images || images.size() == 0){
			commonVo.setMsg("请先上传图片");
		}
		else{
			try {
				merchandiseService.saveImages(id, images);
				try {
					Merchandise merchandise = merchandiseService.findMerchandiseById(id);
					sysLogService.addSysLog("商品维护", merchandise.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
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
	
	@RequestMapping(value = "/checkDetails")
	public void checkPosBand(Integer orderInfoId, HttpServletResponse response) {
		response.setContentType("text/html; charset=utf-8");
		try {
			int count = 0 ;
			PrintWriter out = response.getWriter();
			List<RedemptionDetail> details = merchandiseService.getDetails(orderInfoId);
			if(details != null){
				count = details.size() ;
			}
			out.print(CommonUtil.toJson(count));
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/details")
	public String showMatchedRules(Integer orderInfoId, Model model) {

		List<RedemptionDetail> details = merchandiseService.getDetails(orderInfoId);
		model.addAttribute("rows", details);

		return "member/integralUseRecord";
	}
}
