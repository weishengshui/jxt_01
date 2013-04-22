package com.chinarewards.metro.control.discountcoupon;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.shop.DiscountCoupon;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.model.discountcoupon.DiscountCouponCriteria;
import com.chinarewards.metro.model.discountcoupon.DiscountCouponVo;
import com.chinarewards.metro.service.discountcoupon.IDiscountCouponService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.validator.discountcoupon.CreateDiscountCouponValidator;

@Controller
@RequestMapping("/discountcoupon")
public class DiscountCouponControler {

	@Autowired
	private IDiscountCouponService discountCouponService;
	@Autowired
	private ISysLogService sysLogService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 优惠码维护
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/show")
	public String showCreateDiscountCoupon(HttpSession session, Model model,
			Integer id) {

		DiscountCoupon coupon = discountCouponService
				.findDiscountCouponById(id);
		String imageSessionName = UUIDUtil.generate();
		if (null != coupon) {
			Map<String, FileItem> images = new LinkedHashMap<String, FileItem>();
			images.put("A" + UUIDUtil.generate(), coupon.getFileItem());
			session.setAttribute(imageSessionName, images);
			model.addAttribute("images", CommonUtil.toJson(images));
			model.addAttribute("imageSessionName", imageSessionName);
		}
		model.addAttribute("coupon", coupon);

		return "coupon/create";
	}

	/**
	 * 新增优惠码
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("/add")
	public String add(Model model) {

		return "coupon/create";
	}

	/**
	 * 创建优惠码
	 * 
	 * @param response
	 * @param coupon
	 * @param result
	 * @param model
	 * @param session
	 * @param imageSessionName
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/create")
	@ResponseBody
	public void createOrUpdateDiscountCoupon(HttpServletResponse response,
			@ModelAttribute DiscountCoupon coupon, BindingResult result,
			Model model, HttpSession session, String imageSessionName)
			throws IOException {

		PrintWriter out = null;
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		commonVo.setId(coupon.getId());
		commonVo.setSuccess(false);// 表单不需要清空
		response.setContentType("text/html; charset=utf-8");
		out = response.getWriter();

		logger.trace("enter createOrUpdateDiscountCoupon()");

		new CreateDiscountCouponValidator(discountCouponService).validate(
				coupon, result);
		if (result.hasErrors()) {
			commonVo.setMsg(result.getAllErrors().get(0).getDefaultMessage());
			out.println(CommonUtil.toJson(commonVo));
			out.flush();
			return;
		}

		Map<String, FileItem> fileItems = (LinkedHashMap<String, FileItem>) session
				.getAttribute(imageSessionName);
		logger.trace("coupon.getId() is " + coupon.getId());
		if (null == coupon.getId()) { // insert

			discountCouponService.createDiscountCoupon(coupon, fileItems);
			commonVo.setSuccess(true);// 表单需要清空
			try {
				sysLogService.addSysLog("优惠券新增", coupon.getIdentifyCode(),
						OperationEvent.EVENT_SAVE.getName(), "成功");
			} catch (Exception e) {
			}
		} else {// update

			discountCouponService.updateDiscountCoupon(coupon, fileItems);
			try {
				sysLogService.addSysLog("优惠券维护", coupon.getIdentifyCode(),
						OperationEvent.EVENT_UPDATE.getName(), "成功");
			} catch (Exception e) {
			}
		}
		commonVo.setMsg("保存成功");
		commonVo.setId(coupon.getId());
		out.println(CommonUtil.toJson(commonVo));
		out.flush();
	}

	@RequestMapping(value = "/list")
	public String listDiscountCoupones(
			@ModelAttribute DiscountCouponCriteria criteria, Integer page,
			Integer rows, Model model) {

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<DiscountCoupon> list = discountCouponService
				.searchDiscountCoupones(criteria);
		Long count = discountCouponService.countDiscountCoupones(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", list);
		return "coupon/list";
	}

	/**
	 * 批量删除优惠码
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public AjaxResponseCommonVo delete(Integer[] ids, Model model) {
		logger.trace(String.valueOf(ids));
		if (null != ids && ids.length > 0) {
			discountCouponService.batchDelete(ids);
			return new AjaxResponseCommonVo("删除成功");
		} else {
			return new AjaxResponseCommonVo("请先选择要删除的行");
		}
	}
	
	/**
	 * 通过门市或连锁的ID获得相应优惠券的有效期列表
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping(value="getCouponValidDateListById", method=RequestMethod.POST)
	public String getCouponValidDateListById(
			@ModelAttribute DiscountCouponCriteria criteria, Integer page,
			Integer rows, Model model) {

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<DiscountCouponVo> list = discountCouponService
				.searchValidDateDiscountCoupones(criteria);

		model.addAttribute("total", (paginationDetail.getTotalRows()==null?0:paginationDetail.getTotalRows()));
		model.addAttribute("page", page);

		model.addAttribute("rows", list);
		return "coupon/create";
	}

	// @SuppressWarnings("unchecked")
	// @RequestMapping("/saveImage")
	// @ResponseBody
	// public AjaxResponseCommonVo saveImage(String id, String imageSessionName,
	// HttpSession session) {
	//
	// AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
	//
	// Map<String, FileItem> images = (Map<String, FileItem>) session
	// .getAttribute(imageSessionName);
	// if (null == images || images.size() == 0) {
	// commonVo.setMsg("请先上传图片");
	// } else {
	// try {
	// merchandiseService.saveImages(id, images);
	// commonVo.setMsg("保存成功");
	// } catch (IOException e) {
	// commonVo.setMsg("错误：" + e.getMessage());
	// e.printStackTrace();
	// }
	// }
	//
	// return commonVo;
	// }
}
