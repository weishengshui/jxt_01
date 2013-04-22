package com.chinarewards.metro.control.category;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.TreeNode;
import com.chinarewards.metro.domain.category.Category;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.service.category.ICategoryService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.validator.category.CreateCategoryValidator;

@Controller
@RequestMapping("/category")
public class CategoryControler {

	@Autowired
	private ICategoryService categoryService;
	@Autowired
	private ISysLogService sysLogService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/create")
	@ResponseBody
	public void createOrUpdateCategory(HttpServletResponse response,
			@ModelAttribute Category category, BindingResult result, Model model)
			throws Exception {

		AjaxResponseCommonVo ajaxResponseCommonVo = new AjaxResponseCommonVo(
				"保存成功");
		ajaxResponseCommonVo.setSuccess(false);

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		logger.trace("createOrUpdateCategory parent is "
				+ category.getParent().getId());
		logger.trace("createOrUpdateCategory id is " + category.getId());

		new CreateCategoryValidator(categoryService).validate(category, result);
		if (result.hasErrors()) {
			ajaxResponseCommonVo.setMsg(result.getAllErrors().get(0)
					.getDefaultMessage());
			out.println(CommonUtil.toJson(ajaxResponseCommonVo));
			out.flush();
			return;
		}

		if (StringUtils.isEmpty(category.getId())) { // insert
			Category category2 = categoryService.addCategory(category, category.getParent().getId());
			try {
				if(null == category2){
					sysLogService.addSysLog("商品类别新增", category.getName(), OperationEvent.EVENT_SAVE.getName(), "失败");
				} else{
					sysLogService.addSysLog("商品类别新增", category.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
				}
			} catch (Exception e) {
			}
		} else { // update
			categoryService.modifyCategory(category, category.getParent()
					.getId());
			try {
				sysLogService.addSysLog("商品类别维护", category.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			} catch (Exception e) {
			}
		}
		ajaxResponseCommonVo.setMsg("保存成功");
		ajaxResponseCommonVo.setSuccess(true);
		out.println(CommonUtil.toJson(ajaxResponseCommonVo));
		out.flush();
	}

	@RequestMapping("/add")
	public String add() {
		return "category/create";
	}

	@RequestMapping("/delete")
	@ResponseBody
	public void deleteCategory(HttpServletResponse response, String id,
			Model model) throws Exception {

		AjaxResponseCommonVo ajaxResponseCommonVo = new AjaxResponseCommonVo();
		ajaxResponseCommonVo.setSuccess(false);
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		Long childs = categoryService.countChildByParentId(id);
		logger.trace("childs is " + childs);
		if (childs > 0) {
			ajaxResponseCommonVo.setMsg("只能删除叶子节点");
			out.println(CommonUtil.toJson(ajaxResponseCommonVo));
			out.flush();
			return;
		}
		if (categoryService.hasMerchandiseCatagoryById(id)) {// 如果商品类别下关联这商品，也不能删除
			ajaxResponseCommonVo.setMsg("该商品类别下有商品，不能删除");
			out.println(CommonUtil.toJson(ajaxResponseCommonVo));
			out.flush();
			return;
		}
		categoryService.deleteCategoryById(id);
		ajaxResponseCommonVo.setMsg("删除成功");
		ajaxResponseCommonVo.setSuccess(true);
		out.println(CommonUtil.toJson(ajaxResponseCommonVo));
		out.flush();
	}

	@RequestMapping("/maintain")
	public String maintain() {
		return "category/show";
	}

	/**
	 * 获取商品类别下商品数
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping("/get_category_mercCount")
	public AjaxResponseCommonVo get_category_merc(String id, Model model) {

		return new AjaxResponseCommonVo(String.valueOf(1));
	}

	/**
	 * 获得页面商品树，全部关闭
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/get_tree_nodes")
	@ResponseBody
	public List<TreeNode> getTreeNodes(String id) {

		List<TreeNode> nodes = new ArrayList<TreeNode>();
		// getAllNodes(nodes, null);
		List<Category> categories = categoryService.getChildsByParentId(id);

		if (null != categories && categories.size() > 0) {
			logger.trace("categories.size() is " + categories.size());
			for (Category catagory : categories) {
				TreeNode tn = new TreeNode(catagory.getId(),
						catagory.getName(),
						// categoryService.countChildByParentId(catagory.getId())
						// > 0 ? "closed"
						// : "open");
						"closed", "{\'displaySort\':\'"
								+ catagory.getDisplaySort() + "\'}");
				nodes.add(tn);
			}
		}
		return nodes;
	}

	/**
	 * 获得页面商品树, 叶子展开
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/get_tree_nodes2")
	@ResponseBody
	public List<TreeNode> getTreeNodes2(String id) {

		List<TreeNode> nodes = new ArrayList<TreeNode>();
		// getAllNodes(nodes, null);
		List<Category> categories = categoryService.getChildsByParentId(id);

		if (null != categories && categories.size() > 0) {
			logger.trace("categories.size() is " + categories.size());
			for (Category catagory : categories) {
				TreeNode tn = new TreeNode(
						catagory.getId(),
						catagory.getName(),
						categoryService.countChildByParentId(catagory.getId()) > 0 ? "closed"
								: "open", "{\'displaySort\':\'"
								+ catagory.getDisplaySort() + "\'}");
				nodes.add(tn);
			}
		}
		return nodes;
	}

	@RequestMapping("/get_parents")
	@ResponseBody
	public List<TreeNode> getAllParents(String id, Model model) {
		List<TreeNode> nodes = new ArrayList<TreeNode>();
		List<Category> categories = categoryService.getAllParents(id);
		for (Category catagory : categories) {
			TreeNode tn = new TreeNode(catagory.getId(), catagory.getName(),
					"closed", "{\'displaySort\':\'" + catagory.getDisplaySort()
							+ "\'}");
			nodes.add(tn);
		}
		Collections.reverse(nodes);//让根成为第一个元素
		return nodes;
	}

	/**
	 * 检查商品类别下是否有商品，有商品就返回true，反之就返回false
	 * 
	 * @param response
	 * @param id
	 * @throws IOException
	 */
	@RequestMapping("/hasMerchandises")
	@ResponseBody
	public void hasMerchandises(HttpServletResponse response, String id)
			throws IOException {

		AjaxResponseCommonVo ajaxResponseCommonVo = new AjaxResponseCommonVo();
		ajaxResponseCommonVo.setSuccess(false);

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		if (categoryService.hasMerchandiseCatagoryById(id)) {
			ajaxResponseCommonVo.setSuccess(true);
		}
		out.write(CommonUtil.toJson(ajaxResponseCommonVo));
		out.flush();
	}
}
