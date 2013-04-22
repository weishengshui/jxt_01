package com.chinarewards.metro.service.category;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.category.Category;
import com.chinarewards.metro.domain.merchandise.MerchandiseCatalog;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.service.system.ISysLogService;

@Service
public class CategoryService implements ICategoryService {

	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private ISysLogService sysLogService;

	@Override
	public void modifyCategory(Category category, String parentId) {

		// String parentId = catagory.getParent().getId();
		String id = category.getId();
		if (null == parentId || parentId.isEmpty()) {
			throw new IllegalArgumentException(
					"updateCategory parentId could't be null!");
		}
		// find parent
		Category newParent = hbDaoSupport.findTById(Category.class, parentId);

		Category categoryFromDb = hbDaoSupport.findTById(Category.class, id);
		categoryFromDb.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		categoryFromDb.setLastModifiedBy(UserContext.getUserId());
		categoryFromDb.setName(category.getName());
		categoryFromDb.setDisplaySort(category.getDisplaySort());
		// categoryFromDb.setParent(parent);
		Category nowParent = categoryFromDb.getParent();
		if (!newParent.getId().equals(nowParent.getId())) { // 商品类别更换一个父节点
															// update rgt,
			categoryFromDb.setParent(newParent);
		}

		hbDaoSupport.update(categoryFromDb);

	}

	@Override
	public Category addCategory(Category category, String id) {

		if (null == id || id.isEmpty()) {
			return null;
		}

		// find parent
		Category parent = hbDaoSupport.findTById(Category.class, id);
		// long parentRgt = parent.getRgt();

		if(null == parent){
			return null;
		}
		category.setParent(parent);
		category.setCreatedAt(SystemTimeProvider.getCurrentTime());
		category.setCreatedBy(UserContext.getUserId());
		category.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		category.setLastModifiedBy(UserContext.getUserId());
		/*
		 * category.setLft(parentRgt); category.setRgt(parentRgt + 1);
		 */
		hbDaoSupport.save(category);

		return category;
	}

	@Override
	public List<Category> getChildsByParentId(String id) {

		if (null == id || id.isEmpty()) {
			List<Category> list = hbDaoSupport.findTsByHQL(
					"SELECT m FROM Category m WHERE m.id = ?",
					Constants.CATEGORY_ROOT_ID);
			if (null != list && list.size() == 0) {
				Category category = new Category();
				category.setCreatedAt(SystemTimeProvider.getCurrentTime());
				category.setCreatedBy(UserContext.getUserId());
				category.setDescription("商品类别根节点");
				category.setId(Constants.MERCHANDISE_CATEGORY_ROOT);
				category.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
				category.setLastModifiedBy(UserContext.getUserId());
				category.setLft(1);
				category.setName("根节点");
				category.setRgt(2);
				hbDaoSupport.save(category);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("rootId",
						Constants.CATEGORY_ROOT_ID);
				map.put("id", category.getId());
				hbDaoSupport.executeHQL(
						"UPDATE Category SET id=:rootId WHERE id=:id", map);
				list = hbDaoSupport.findTsByHQL(
						"SELECT m FROM Category m WHERE m.id = ?",
						Constants.CATEGORY_ROOT_ID);
			}
			return list;
		} else {
			List<Category> list = hbDaoSupport
					.findTsByHQL(
							"SELECT m FROM Category m WHERE m.parent.id = ? ORDER BY m.displaySort ASC",
							id);
			return list;
		}
	}

	@Override
	public Long countChildByParentId(String id) {
		List<Long> list = hbDaoSupport.findTsByHQL(
				"SELECT COUNT(m) FROM Category m WHERE m.parent.id = ?", id);
		return list.get(0);
	}

	@Override
	public void deleteCategoryById(String id) {

		Category category = hbDaoSupport.findTById(Category.class, id);
		Category parent = category.getParent();
		if (parent == null) { // catagory 是商品类别树的根
			return;
		}// 当删除的数据的表与其它的表有关联时，用一下语句删除
		hbDaoSupport.executeHQL("DELETE Category c where c.id=?", id);
		try {
			sysLogService.addSysLog("商品类别维护", category.getName(), OperationEvent.EVENT_DELETE.getName(), "成功");
		} catch (Exception e) {
		}

	}

	@Override
	public List<Category> getAllParents(String id) {
		
		Category category = hbDaoSupport.findTById(Category.class, id);
		List<Category> parents = new ArrayList<Category>();
		if(null != category){
			while(null != category.getParent()){
				parents.add(category.getParent());
				category = category.getParent();
			}
		}
		return parents;
	}

	@Override
	public boolean checkAddNameExists(String name) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("name", name);
		List<Category> list = hbDaoSupport.executeQuery(
				"FROM Category WHERE name=:name", params, null);
		if (null != list && list.size() > 0) {
			return true;
		}
		return false;
	}

	@Override
	public boolean checkUpdateNameExists(Category category) {
		Category categoryFromDB = hbDaoSupport.findTById(Category.class,
				category.getId());
		if (null != categoryFromDB) {
			if (category.getName().equals(categoryFromDB.getName())) {
				return false;
			} else {
				return checkAddNameExists(category.getName());
			}
		} else {
			return false;
		}
	}

	@Override
	public boolean hasMerchandiseCatagoryById(String id) {
		Category category = hbDaoSupport.findTById(Category.class, id);
		if (null != category) {
			List<MerchandiseCatalog> list = hbDaoSupport.findTsByHQL(
					"FROM MerchandiseCatalog m WHERE m.category=?", category);
			if (null != list && list.size() > 0) {
				return true;
			} else {
				return false;
			}
		}
		return false;
	}

	@Override
	public Category findCategoryById(String id) {

		return hbDaoSupport.findTById(Category.class, id);
	}

	@Override
	public boolean checkDisplaySortExists(Category category) {

		List<Category> categories = hbDaoSupport.findTsByHQL("FROM Category c WHERE c.parent.id=?", category.getParent().getId());
		for(Category category2 : categories){
			if(!category2.getId().equals(category.getId()) && category2.getDisplaySort().equals(category.getDisplaySort())){
				return true;
			}
		}
		return false;
	}

}
