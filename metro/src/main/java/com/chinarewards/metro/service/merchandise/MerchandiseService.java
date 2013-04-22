package com.chinarewards.metro.service.merchandise;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.business.RedemptionDetail;
import com.chinarewards.metro.domain.category.Category;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.domain.merchandise.MerchandiseCatalog;
import com.chinarewards.metro.domain.merchandise.MerchandiseFile;
import com.chinarewards.metro.domain.merchandise.MerchandiseKeywords;
import com.chinarewards.metro.domain.merchandise.MerchandiseSaleform;
import com.chinarewards.metro.domain.merchandise.MerchandiseShop;
import com.chinarewards.metro.domain.merchandise.MerchandiseStatus;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.merchandise.CategoryVo;
import com.chinarewards.metro.model.merchandise.MerchandiseCatalogVo;
import com.chinarewards.metro.model.merchandise.MerchandiseCriteria;
import com.chinarewards.metro.model.merchandise.MerchandiseKeyVo;
import com.chinarewards.metro.model.merchandise.MerchandiseShopVo;
import com.chinarewards.metro.model.merchandise.MerchandiseVo;
import com.chinarewards.metro.model.merchandise.SaleFormVo;
import com.chinarewards.metro.models.brand.Brand;
import com.chinarewards.metro.models.merchandise.Catalog;
import com.chinarewards.metro.models.request.MerchandiseReq;
import com.chinarewards.metro.service.system.ISysLogService;

@Service
public class MerchandiseService implements IMerchandiseService {

	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private ISysLogService sysLogService;

	@Override
	public List<MerchandiseVo> searchMerchandises(
			MerchandiseCriteria merchandiseCriteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMerchandisesHQL(merchandiseCriteria, params,
				false);
		List<MerchandiseVo> list = hbDaoSupport.executeQuery(hql, params,
				merchandiseCriteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countMerchandises(MerchandiseCriteria merchandiseCriteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMerchandisesHQL(merchandiseCriteria, params,
				true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	@Override
	public List<Category> getLeafs() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<MerchandiseCatalog> findMercCatalogsByMercId(String id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteMercFileById(String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		MerchandiseFile file = hbDaoSupport.executeQuery(
				"FROM MerchandiseFile WHERE id=:id", map, null);
		if (null != file) {
			// FileItem fileItem = file.getFileItem();
			// new File(fileItem.getUrl()).delete(); //物理删除
		}
		hbDaoSupport
				.executeHQL("DELETE FROM MerchandiseFile WHERE id=:id", map); // 删除数据库记录
	}

	@Override
	public void createMerchandise(Merchandise merchandise,
			List<SaleFormVo> saleFormVos,
			List<CategoryVo> categoryVos,
			List<MerchandiseShopVo> merchandiseShopVos, String[] keywords)
			throws IOException {
		
		if (null != saleFormVos && saleFormVos.size() > 0) {
			for (SaleFormVo saleFormVo : saleFormVos) {
				if(saleFormVo.getUnitId().equals(Dictionary.INTEGRAL_RMB_ID)){
					merchandise.setRmbPrcie(saleFormVo.getPrice());
					merchandise.setRmbPreferentialPrcie(saleFormVo.getPreferentialPrice());
				}else if(saleFormVo.getUnitId().equals(Dictionary.INTEGRAL_BINKE_ID)){
					merchandise.setBinkePrcie(saleFormVo.getPrice());
					merchandise.setBinkePreferentialPrcie(saleFormVo.getPreferentialPrice());
				}
			}
		}
		merchandise.setCreatedAt(SystemTimeProvider.getCurrentTime());
		merchandise.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		merchandise.setCreatedBy(UserContext.getUserId());
		merchandise.setLastModifiedBy(UserContext.getUserId());
		hbDaoSupport.save(merchandise);

		// save merchandise sale forms
		if (null != saleFormVos && saleFormVos.size() > 0) {
			for (SaleFormVo saleFormVo : saleFormVos) {
				MerchandiseSaleform merchandiseSaleform = new MerchandiseSaleform();

				merchandiseSaleform.setCreatedAt(SystemTimeProvider
						.getCurrentTime());
				merchandiseSaleform.setCreatedBy(UserContext.getUserId());
				merchandiseSaleform.setLastModifiedAt(SystemTimeProvider
						.getCurrentTime());
				merchandiseSaleform.setLastModifiedBy(UserContext.getUserId());
				merchandiseSaleform.setMerchandise(merchandise);
				merchandiseSaleform.setPreferentialPrice(saleFormVo
						.getPreferentialPrice());
				merchandiseSaleform.setPrice(saleFormVo.getPrice());
				merchandiseSaleform.setUnitId(saleFormVo.getUnitId());

				hbDaoSupport.save(merchandiseSaleform);
			}
		}

		// save merchandise catalogs
		if (null != categoryVos && categoryVos.size() > 0) {
			for (CategoryVo categoryVo : categoryVos) {
				Category category = hbDaoSupport.findTById(Category.class,
						categoryVo.getCategoryId());
				if (null != category) { // 为安全起见
					MerchandiseCatalog catalog = new MerchandiseCatalog();

					catalog.setCategory(category);
					catalog.setCreatedAt(SystemTimeProvider.getCurrentTime());
					catalog.setCreatedBy(UserContext.getUserId());
					catalog.setDisplaySort(categoryVo.getDisplaySort());
					catalog.setLastModifiedAt(SystemTimeProvider
							.getCurrentTime());
					catalog.setLastModifiedBy(UserContext.getUserId());
					catalog.setMerchandise(merchandise);
					catalog.setOn_offTIme(categoryVo.getOn_offTime());
					catalog.setStatus(categoryVo.getStatus());

					hbDaoSupport.save(catalog);
				}
			}
		}

		// save merchandise shop relations
		if (null != merchandiseShopVos && merchandiseShopVos.size() > 0) {
			for (MerchandiseShopVo merchandiseShopVo : merchandiseShopVos) {
				Shop shop = hbDaoSupport.findTById(Shop.class,
						merchandiseShopVo.getShopId());
				hbDaoSupport.save(new MerchandiseShop(merchandise, shop,
						merchandiseShopVo.getMerShopSort()));
			}
		}

		// save key words
		if (null != keywords && keywords.length > 0) {
			for (String key : keywords) {
				MerchandiseKeywords merchandiseKeywords = new MerchandiseKeywords();
				merchandiseKeywords.setKeywords(key);
				merchandiseKeywords.setMerchandise(merchandise);
				hbDaoSupport.save(merchandiseKeywords);
			}
		}
	}

	@Override
	public boolean checkCodeExists(Merchandise merchandise) {

		Merchandise merchandise2 = hbDaoSupport.findTByHQL(
				"FROM Merchandise WHERE code=?", merchandise.getCode());
		if (null == merchandise2) {
			return false;
		}
		if (merchandise2.getId().equals(merchandise.getId())) {
			return false;
		}
		return true;
	}

	@Override
	public boolean checkModelExists(Merchandise merchandise) {

		Merchandise merchandise2 = hbDaoSupport.findTByHQL(
				"FROM Merchandise WHERE model=?", merchandise.getModel());
		if (null == merchandise2) {
			return false;
		}
		if (merchandise2.getId().equals(merchandise.getId())) {
			return false;
		}
		return true;
	}

	@Override
	public boolean checkDisplaySortExists(CategoryVo categoryVo) {

		String categoryId = categoryVo.getCategoryId();
		Long displaySort = categoryVo.getDisplaySort();
		String catalogId = categoryVo.getCatalogId();
		String merchandiseId = categoryVo.getMerchandiseId();

		MerchandiseCatalog catalog = hbDaoSupport
				.findTByHQL(
						"FROM MerchandiseCatalog m WHERE m.category.id=? AND m.displaySort=?  ",
						categoryId, displaySort);
		if (null == catalog) {
			return false;
		} else if (!StringUtils.isEmpty(merchandiseId)) {
			Merchandise merchandise = hbDaoSupport.findTById(Merchandise.class,
					merchandiseId);
			Set<MerchandiseCatalog> catalogs = merchandise
					.getMerchandiseCatalogs();
			if (null != catalogs && catalogs.size() > 0) {
				for (MerchandiseCatalog catalog2 : catalogs) {
					if (catalog2.getCategory().getId()
							.equals(catalog.getCategory().getId())) {
						if (catalog2.getId().equals(catalog.getId())) {
							return false;
						}
						break;
					}
				}
			}
		} else if (catalog.getId().equals(catalogId)) {
			return false;
		}
		return true;
	}

	protected String buildSearchMerchandisesHQL(
			MerchandiseCriteria merchandiseCriteria,
			Map<String, Object> params, boolean isCount) {

		StringBuffer strBuffer = new StringBuffer();
		String unitId = merchandiseCriteria.getUnitId();
		String name = merchandiseCriteria.getName();
		String code = merchandiseCriteria.getCode();
		String model = merchandiseCriteria.getModel();
		Integer brandId = merchandiseCriteria.getBrandId();
		Double rmbPrcieFrom = merchandiseCriteria.getRmbPrcieFrom();
		Double rmbPrcieTo = merchandiseCriteria.getRmbPrcieTo();
		Double rmbPreferentialPrcieFrom = merchandiseCriteria.getRmbPreferentialPrcieFrom();
		Double rmbPreferentialPrcieTo = merchandiseCriteria.getRmbPreferentialPrcieTo();
		Double binkePrcieFrom = merchandiseCriteria.getBinkePrcieFrom();
		Double binkePrcieTo = merchandiseCriteria.getBinkePrcieTo();
		Double binkePreferentialPrcieFrom = merchandiseCriteria.getBinkePreferentialPrcieFrom();
		Double binkePreferentialPrcieTo = merchandiseCriteria.getBinkePreferentialPrcieTo();  

		if (isCount) {
			strBuffer.append("SELECT COUNT(m) ");
		} else {
			strBuffer
					.append("SELECT new com.chinarewards.metro.model.merchandise.MerchandiseVo(m) ");
		}

		if (StringUtils.isEmpty(unitId)) {// 查询所有售卖形式

			strBuffer.append("FROM Merchandise m WHERE 1=1  "); // 很奇妙

			if (null != name && !name.isEmpty()) {
				strBuffer.append(" AND m.name like :name");
				params.put("name", "%" + name + "%");
			}
			if (null != code && !code.isEmpty()) {
				strBuffer.append(" AND m.code like :code");
				params.put("code", "%" + code + "%");
			}
			if (null != model && !model.isEmpty()) {
				strBuffer.append(" AND m.model like :model");
				params.put("model", "%" + model + "%");
			}
			if (null != brandId) {
				strBuffer.append(" AND m.brand.id=:brandId");
				params.put("brandId", brandId);
			}
			
			if(null != rmbPrcieFrom){
				strBuffer.append(" AND m.rmbPrcie >= :rmbPrcieFrom");
				params.put("rmbPrcieFrom", rmbPrcieFrom);
			}
			if(null != rmbPrcieTo){
				strBuffer.append(" AND m.rmbPrcie <= :rmbPrcieTo");
				params.put("rmbPrcieTo", rmbPrcieTo);
			}
			if(null != rmbPreferentialPrcieFrom){
				strBuffer.append(" AND m.rmbPreferentialPrcie >= :rmbPreferentialPrcieFrom");
				params.put("rmbPreferentialPrcieFrom", rmbPreferentialPrcieFrom);
			}
			if(null != rmbPreferentialPrcieTo){
				strBuffer.append(" AND m.rmbPreferentialPrcie <= :rmbPreferentialPrcieTo");
				params.put("rmbPreferentialPrcieTo", rmbPreferentialPrcieTo);
			}
			if(null != binkePrcieFrom){
				strBuffer.append(" AND m.binkePrcie >= :binkePrcieFrom");
				params.put("binkePrcieFrom", binkePrcieFrom);
			}
			if(null != binkePrcieTo){
				strBuffer.append(" AND m.binkePrcie <= :binkePrcieTo");
				params.put("binkePrcieTo", binkePrcieTo);
			}
			if(null != binkePreferentialPrcieFrom){
				strBuffer.append(" AND m.binkePreferentialPrcie >= :binkePreferentialPrcieFrom");
				params.put("binkePreferentialPrcieFrom", binkePreferentialPrcieFrom);
			}
			if(null != binkePreferentialPrcieTo){
				strBuffer.append(" AND m.binkePreferentialPrcie <= :binkePreferentialPrcieTo");
				params.put("binkePreferentialPrcieTo", binkePreferentialPrcieTo);
			}
			strBuffer.append(" ORDER BY m.lastModifiedAt DESC");
			// TODO
		} else {

			strBuffer
					.append("FROM MerchandiseSaleform m INNER JOIN m.merchandise mer WHERE 1=1  "); // 很奇妙

			if (null != name && !name.isEmpty()) {
				strBuffer.append(" AND mer.name like :name");
				params.put("name", "%" + name + "%");
			}
			if (null != code && !code.isEmpty()) {
				strBuffer.append(" AND mer.code like :code");
				params.put("code", "%" + code + "%");
			}
			if (null != model && !model.isEmpty()) {
				strBuffer.append(" AND mer.model like :model");
				params.put("model", "%" + model + "%");
			}
			if (null != brandId) {
				strBuffer.append(" AND mer.brand.id=:brandId");
				params.put("brandId", brandId);
			}
			strBuffer.append(" AND m.unitId=:unitId");
			params.put("unitId", unitId);
			if(unitId.equals(Dictionary.INTEGRAL_RMB_ID)){
				if(null != rmbPrcieFrom){
					strBuffer.append(" AND m.price >= :rmbPrcieFrom");
					params.put("rmbPrcieFrom", rmbPrcieFrom);
				}
				if(null != rmbPrcieTo){
					strBuffer.append(" AND m.price <= :rmbPrcieTo");
					params.put("rmbPrcieTo", rmbPrcieTo);
				}
				if(null != rmbPreferentialPrcieFrom){
					strBuffer.append(" AND m.preferentialPrice >= :rmbPreferentialPrcieFrom");
					params.put("rmbPreferentialPrcieFrom", rmbPreferentialPrcieFrom);
				}
				if(null != rmbPreferentialPrcieTo){
					strBuffer.append(" AND m.preferentialPrice <= :rmbPreferentialPrcieTo");
					params.put("rmbPreferentialPrcieTo", rmbPreferentialPrcieTo);
				}
			}else if(unitId.equals(Dictionary.INTEGRAL_BINKE_ID)){
				if(null != binkePrcieFrom){
					strBuffer.append(" AND m.price >= :binkePrcieFrom");
					params.put("binkePrcieFrom", binkePrcieFrom);
				}
				if(null != binkePrcieTo){
					strBuffer.append(" AND m.price <= :binkePrcieTo");
					params.put("binkePrcieTo", binkePrcieTo);
				}
				if(null != binkePreferentialPrcieFrom){
					strBuffer.append(" AND m.preferentialPrice >= :binkePreferentialPrcieFrom");
					params.put("binkePreferentialPrcieFrom", binkePreferentialPrcieFrom);
				}
				if(null != binkePreferentialPrcieTo){
					strBuffer.append(" AND m.preferentialPrice <= :binkePreferentialPrcieTo");
					params.put("binkePreferentialPrcieTo", binkePreferentialPrcieTo);
				}
			}

			strBuffer.append(" ORDER BY mer.lastModifiedAt DESC");
			// TODO
		}
		return strBuffer.toString();
	}

	@Override
	public void batchDelete(String[] ids) {
		for (String id : ids) {
			Merchandise merchandise = hbDaoSupport.findTById(Merchandise.class,
					id);

			hbDaoSupport.executeHQL(
					"DELETE MerchandiseSaleform m WHERE m.merchandise=? ",
					merchandise);
			List<MerchandiseFile> files = hbDaoSupport
					.findTsByHQL(
							"FROM MerchandiseFile m WHERE m.merchandise=?",
							merchandise);
			if (null != files && files.size() > 0) {
				for (MerchandiseFile file : files) {
					(new File(Constants.MERCHANDISE_IMAGE_DIR, file.getUrl()))
							.delete();// 物理删除
				}
			}
			hbDaoSupport.executeHQL(
					"DELETE MerchandiseFile m WHERE m.merchandise=?",
					merchandise);
			hbDaoSupport.executeHQL(
					"DELETE MerchandiseCatalog m WHERE m.merchandise=? ",
					merchandise);
			hbDaoSupport.delete(merchandise);
			try {
				sysLogService.addSysLog("商品维护", merchandise.getName(),
						OperationEvent.EVENT_DELETE.getName(), "成功");
			} catch (Exception e) {
			}

		}

	}

	@Override
	public MerchandiseCatalog findMercCatalogsByMercCataId(String id) {
		return hbDaoSupport.findTById(MerchandiseCatalog.class, id);
	}

	@Override
	public Merchandise findMerchandiseByMercCataId(String id) {
		MerchandiseCatalog catalog = findMercCatalogsByMercCataId(id);
		if (null != catalog) {
			return catalog.getMerchandise();
		}
		return null;
	}

	@Override
	public List<MerchandiseCatalog> findMercCatalogsByMercIdAndNuit(String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		return hbDaoSupport
				.executeQuery(
						"FROM MerchandiseCatalog m WHERE m.merchandise.id=:id GROUP BY m.unitId",
						map, null);
	}

	@Override
	public void updateMerchandise(Merchandise merchandise,
			List<SaleFormVo> saleFormVos,
			List<CategoryVo> categoryVos,
			List<MerchandiseShopVo> merchandiseShopVos, String[] keywords)
			throws IOException {

		Merchandise merchandiseFromDB = hbDaoSupport.findTById(
				Merchandise.class, merchandise.getId());
		if (null != saleFormVos && saleFormVos.size() > 0) {
			for (SaleFormVo saleFormVo : saleFormVos) {
				if(saleFormVo.getUnitId().equals(Dictionary.INTEGRAL_RMB_ID)){
					merchandiseFromDB.setRmbPrcie(saleFormVo.getPrice());
					merchandiseFromDB.setRmbPreferentialPrcie(saleFormVo.getPreferentialPrice());
				}else if(saleFormVo.getUnitId().equals(Dictionary.INTEGRAL_BINKE_ID)){
					merchandiseFromDB.setBinkePrcie(saleFormVo.getPrice());
					merchandiseFromDB.setBinkePreferentialPrcie(saleFormVo.getPreferentialPrice());
				}
			}
		}
		merchandiseFromDB.setName(merchandise.getName());
		merchandiseFromDB.setCode(merchandise.getCode());
		merchandiseFromDB.setPurchasePrice(merchandise.getPurchasePrice());
		merchandiseFromDB.setModel(merchandise.getModel());
		merchandiseFromDB.setDescription(merchandise.getDescription());
		merchandiseFromDB
				.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		merchandiseFromDB.setLastModifiedBy(UserContext.getUserId());
		merchandiseFromDB.setBrand(merchandise.getBrand());
		merchandiseFromDB.setFreight(merchandise.getFreight());
		merchandiseFromDB.setShowInSite(merchandise.isShowInSite());
		hbDaoSupport.update(merchandiseFromDB);

		// delete merchandise sale form
		hbDaoSupport.executeHQL(
				"DELETE MerchandiseSaleform WHERE merchandise=?",
				merchandiseFromDB);
		// save merchandise sale from
		if (null != saleFormVos && saleFormVos.size() > 0) {
			for (SaleFormVo saleFormVo : saleFormVos) {
				MerchandiseSaleform saleform = new MerchandiseSaleform();

				saleform.setCreatedAt(SystemTimeProvider.getCurrentTime());
				saleform.setCreatedBy(UserContext.getUserId());
				saleform.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
				saleform.setLastModifiedBy(UserContext.getUserId());
				saleform.setMerchandise(merchandiseFromDB);
				saleform.setPreferentialPrice(saleFormVo.getPreferentialPrice());
				saleform.setPrice(saleFormVo.getPrice());
				saleform.setUnitId(saleFormVo.getUnitId());

				hbDaoSupport.save(saleform);
			}
		}

		if (null != categoryVos && categoryVos.size() > 0) { // update
																// on_offTime
			for (CategoryVo categoryVo : categoryVos) {
				Category category = hbDaoSupport.findTById(Category.class,
						categoryVo.getCategoryId());
				MerchandiseCatalog catalog = hbDaoSupport
						.findTByHQL(
								"FROM MerchandiseCatalog WHERE category=? AND merchandise=?",
								new Object[] { category, merchandiseFromDB });
				/**
				 * status changed, update on_offTime
				 */
				if (null != catalog
						&& !catalog.getStatus().equals(categoryVo.getStatus())) {
					categoryVo.setOn_offTime(SystemTimeProvider
							.getCurrentTime());
				}
			}
		}

		// delete catalogs
		hbDaoSupport.executeHQL(
				"DELETE MerchandiseCatalog m WHERE m.merchandise=? ",
				merchandiseFromDB);
		// save catalogs
		if (null != categoryVos && categoryVos.size() > 0) {
			for (CategoryVo categoryVo : categoryVos) {
				Category category = hbDaoSupport.findTById(Category.class,
						categoryVo.getCategoryId());
				if (null != category) { // 为安全起见
					MerchandiseCatalog catalog = new MerchandiseCatalog();

					catalog.setCategory(category);
					catalog.setCreatedAt(SystemTimeProvider.getCurrentTime());
					catalog.setCreatedBy(UserContext.getUserId());
					catalog.setDisplaySort(categoryVo.getDisplaySort());
					catalog.setLastModifiedAt(SystemTimeProvider
							.getCurrentTime());
					catalog.setLastModifiedBy(UserContext.getUserId());
					catalog.setMerchandise(merchandiseFromDB);
					catalog.setOn_offTIme(categoryVo.getOn_offTime());
					catalog.setStatus(categoryVo.getStatus());

					hbDaoSupport.save(catalog);
				}
			}
		}

		// update merchandise shop relations
		hbDaoSupport.executeHQL("DELETE MerchandiseShop WHERE merchandise=?",
				merchandiseFromDB);
		if (null != merchandiseShopVos && merchandiseShopVos.size() > 0) {
			for (MerchandiseShopVo merchandiseShopVo : merchandiseShopVos) {
				Shop shop = hbDaoSupport.findTById(Shop.class,
						merchandiseShopVo.getShopId());
				hbDaoSupport.save(new MerchandiseShop(merchandiseFromDB, shop,
						merchandiseShopVo.getMerShopSort()));
			}
		}

		// update key words
		hbDaoSupport.executeHQL(
				"DELETE MerchandiseKeywords WHERE merchandise=?",
				merchandiseFromDB);
		if (null != keywords && keywords.length > 0) {
			for (String key : keywords) {
				MerchandiseKeywords merchandiseKeywords = new MerchandiseKeywords();
				merchandiseKeywords.setKeywords(key);
				merchandiseKeywords.setMerchandise(merchandise);
				hbDaoSupport.save(merchandiseKeywords);
			}
		}
	}

	@Override
	public List<MerchandiseCatalogVo> searchMerCatas(
			MerchandiseCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMerCatasHQL(criteria, params, false);
		List<MerchandiseCatalogVo> list = hbDaoSupport.executeQuery(hql,
				params, criteria.getPaginationDetail());
		return list;

	}

	@Override
	public Long countMerCatas(MerchandiseCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMerCatasHQL(criteria, params, true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && list.get(0) > 0) {
			return list.get(0);
		}
		return 0l;

	}

	/**
	 * 构建查询指定类别下商品目录的HQL
	 * 
	 * @param merchandiseCriteria
	 * @param params
	 * @param isCount
	 * @return
	 */
	protected String buildSearchMerCatasHQL(
			MerchandiseCriteria merchandiseCriteria,
			Map<String, Object> params, boolean isCount) {

		StringBuffer strBuffer = new StringBuffer();
		if (isCount) {
			strBuffer.append("SELECT COUNT( m  ) ");
		} else {
			strBuffer
					.append("SELECT new com.chinarewards.metro.model.merchandise.MerchandiseCatalogVo(m) ");
		}

		strBuffer.append("FROM MerchandiseCatalog m WHERE 1=1 "); // 很奇妙

		if (merchandiseCriteria != null) {

			String categoryId = merchandiseCriteria.getCategoryId();
			if (null == categoryId) {
				categoryId = "";
			}
			strBuffer.append(" AND m.category.id=:categoryId");
			params.put("categoryId", categoryId);

			String name = merchandiseCriteria.getName();
			String code = merchandiseCriteria.getCode();

			if (null != name && !name.isEmpty()) {
				strBuffer.append(" AND m.merchandise.name like :name");
				params.put("name", "%" + name + "%");
			}
			if (null != code && !code.isEmpty()) {
				strBuffer.append(" AND m.merchandise.code like :code");
				params.put("code", "%" + code + "%");
			}
			// TODO
			strBuffer.append(" ORDER BY m.displaySort ASC");
		}
		return strBuffer.toString();
	}

	/**
	 * 构建查询不是指定类别下商品目录的HQL
	 * 
	 * @param merchandiseCriteria
	 * @param params
	 * @param isCount
	 * @return
	 */
	protected String buildSearchNotMerCatasHQL(
			MerchandiseCriteria merchandiseCriteria,
			Map<String, Object> params, boolean isCount) {

		StringBuffer strBuffer = new StringBuffer();
		if (isCount) {
			strBuffer.append("SELECT COUNT(m) ");
		} else {
			strBuffer.append("SELECT m ");
		}

		String categoryId = merchandiseCriteria.getCategoryId();
		if (null == categoryId) {
			categoryId = "";
		}
		params.put("categoryId", categoryId);
		strBuffer
				.append("FROM MerchandiseCatalog m WHERE 1=1 AND m.category.id!=:categoryId"); // 很奇妙

		if (merchandiseCriteria != null) {
			String name = merchandiseCriteria.getName();
			String code = merchandiseCriteria.getCode();

			if (null != name && !name.isEmpty()) {
				strBuffer.append(" AND m.merchandise.name like :name");
				params.put("name", "%" + name + "%");
			}
			if (null != code && !code.isEmpty()) {
				strBuffer.append(" AND m.merchandise.code like :code");
				params.put("code", "%" + code + "%");
			}
			// TODO
		}
		strBuffer.append(" GROUP BY m.merchandise.id, m.unitId");
		return strBuffer.toString();
	}

	@Override
	public void changeCataStatus(String merchandiseCatalogId, String status) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", merchandiseCatalogId);
		map.put("status", MerchandiseStatus.fromString(status));
		hbDaoSupport
				.executeHQL(
						"UPDATE MerchandiseCatalog m SET m.status=:status WHERE m.id=:id ",
						map);

	}

	@Override
	public void updateCatalog(MerchandiseCatalog catalog) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", catalog.getId());
		map.put("status", catalog.getStatus());
		map.put("displaySort", catalog.getDisplaySort());
		hbDaoSupport
				.executeHQL(
						"UPDATE MerchandiseCatalog m SET m.status=:status, m.displaySort=:displaySort WHERE m.id=:id ",
						map);
	}

	@Override
	public void removeCataFromCategory(String[] catalogIds) {
		
		Category category = null;
		try {
			category = findMerchandiseCatalogById(catalogIds[0]).getCategory();
		} catch (Exception e) {
		}
		for (String id : catalogIds) {
			MerchandiseCatalog catalog = findMerchandiseCatalogById(id);
			hbDaoSupport.delete(catalog);
		}
		try {
			sysLogService.addSysLog("商品类别与商品维护", category.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
		}
	}

	@Override
	public List<MerchandiseCatalog> searchNotMerCatas(
			MerchandiseCriteria criteria) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long countNotMerCatas(MerchandiseCriteria criteria) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Merchandise loadMerByMerCode(String merCode, String cateId) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cateId", cateId);
		map.put("merCode", merCode);
		List<Merchandise> list = hbDaoSupport
				.executeQuery(
						"SELECT m.merchandise FROM MerchandiseCatalog m WHERE m.merchandise.code=:merCode AND m.category.id=:cateId",
						map, null);
		if (null != list && list.size() > 0) {
			return list.get(0);
		}
		return null;
	}

	@Override
	public Merchandise checkMerCodeExists(String merCode) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("merCode", merCode);

		List<Merchandise> list = hbDaoSupport
				.executeQuery(
						"SELECT m FROM Merchandise m WHERE m.code=:merCode ",
						map, null);
		if (null != list && list.size() > 0) {
			return list.get(0);
		}
		return null;
	}

	@Override
	public void addMerchandiseToCategory(List<CategoryVo> categoryVos,
			String cateId) {

		Category category = hbDaoSupport.findTById(Category.class, cateId);
		if (null != categoryVos && categoryVos.size() > 0 && null != category) {
			for (CategoryVo categoryVo : categoryVos) {
				Merchandise merchandise = hbDaoSupport.findTByHQL(
						"FROM Merchandise WHERE code=?",
						categoryVo.getMerCode());

				// hbDaoSupport.findTById(
				// Merchandise.class, categoryVo.getMerchandiseId());
				if (null != merchandise) {
					MerchandiseCatalog catalog = new MerchandiseCatalog();

					catalog.setCategory(category);
					catalog.setCreatedAt(SystemTimeProvider.getCurrentTime());
					catalog.setCreatedBy(UserContext.getUserId());
					catalog.setDisplaySort(categoryVo.getDisplaySort());
					catalog.setLastModifiedAt(SystemTimeProvider
							.getCurrentTime());
					catalog.setLastModifiedBy(UserContext.getUserId());
					catalog.setMerchandise(merchandise);
					catalog.setOn_offTIme(categoryVo.getOn_offTime());
					catalog.setStatus(categoryVo.getStatus());

					hbDaoSupport.save(catalog);
				}
			}
		}
	}

	@Override
	public List<MerchandiseCatalog> findCatalogByMerId(String id) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		List<MerchandiseCatalog> list = hbDaoSupport
				.executeQuery(
						"FROM MerchandiseCatalog m WHERE m.merchandise.id=:id AND m.category IS null",
						params, null);
		return list;
	}

	@Override
	public boolean deleteMerchandiseSaleform(
			MerchandiseSaleform merchandiseSaleform) {

		List<MerchandiseCatalog> list = hbDaoSupport.findTsByHQL(
				"FROM MerchandiseCatalog WHERE merchandise=?",
				merchandiseSaleform.getMerchandise());
		if (null != list && list.size() > 0) {
			return false;
		}
		hbDaoSupport.delete(merchandiseSaleform);
		return true;
	}

	@Override
	public List<CategoryVo> findCategorysByMerchandise(Merchandise merchandise) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("merchandise", merchandise);
		List<CategoryVo> list = hbDaoSupport
				.executeQuery(
						"SELECT new com.chinarewards.metro.model.merchandise.CategoryVo(m) FROM MerchandiseCatalog m WHERE m.merchandise=:merchandise",
						params, null);
		if (null != list && list.size() > 0) {
			for (CategoryVo vo : list) {
				Category category = vo.getCategory();
				vo.setFullName(getCategoryFullName(category));
			}
		}
		return list;
	}

	@Override
	public String getCategoryFullName(Category category) {
		String fullName = "";
		while (category.getParent() != null) {
			fullName = category.getName() + "/" + fullName;
			category = category.getParent();
		}
		if (fullName.length() > 0) {
			fullName = fullName.substring(0, fullName.length() - 1);
		}
		return fullName;
	}

	@Override
	public Map<String, FileItem> findMerchandiseFilesByMerchandise(
			Merchandise merchandise) {

		List<MerchandiseFile> list = hbDaoSupport.findTsByHQL(
				"FROM MerchandiseFile WHERE merchandise=? ORDER BY id ASC",
				merchandise);
		Map<String, FileItem> files = new LinkedHashMap<String, FileItem>();
		if (null != list && list.size() > 0) {
			for (MerchandiseFile file : list) {
				files.put("A" + UUIDUtil.generate(), file.toFileItem());
			}
		}
		return files;
	}

	@Override
	public List<MerchandiseSaleform> findSaleFormsByMerchandise(
			Merchandise merchandise) {

		List<MerchandiseSaleform> list = hbDaoSupport.findTsByHQL(
				"FROM MerchandiseSaleform WHERE merchandise=?", merchandise);
		return list;
	}

	@Override
	public boolean deleteSaleForm(MerchandiseSaleform saleform) {

		List<MerchandiseCatalog> list = hbDaoSupport.findTsByHQL(
				"FROM MerchandiseCatalog WHERE merchandise=?",
				saleform.getMerchandise());
		if (null != list && list.size() > 0) {// 商品已经与商品类别关联了，不能删除？
			return false;
		}
		hbDaoSupport.delete(saleform);
		return true;
	}

	@Override
	public Merchandise findMerchandiseById(String id) {
		return hbDaoSupport.findTById(Merchandise.class, id);
	}

	@Override
	public Merchandise checkMerchandiseCanDelete(String merchandiseId) {

		Merchandise merchandise = hbDaoSupport.findTById(Merchandise.class,
				merchandiseId);
		MerchandiseCatalog catalog = hbDaoSupport.findTByHQL(
				"FROM MerchandiseCatalog WHERE merchandise=?", merchandise);
		if (null == catalog) {
			return null;
		} else {
			return merchandise;
		}
	}

	@Override
	public MerchandiseCatalog findMerchandiseCatalogById(String id) {

		return hbDaoSupport.findTById(MerchandiseCatalog.class, id);
	}

	@Override
	public List<MerchandiseShopVo> getMerchandiseShopVosByMerchandise(
			Merchandise merchandise) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("merchandise", merchandise);

		List<MerchandiseShopVo> list = hbDaoSupport
				.executeQuery(
						"SELECT new com.chinarewards.metro.model.merchandise.MerchandiseShopVo(m) FROM MerchandiseShop m WHERE m.merchandise=:merchandise",
						params, null);
		return list;
	}

	@Override
	public Integer countMerchandiseCategorys(String merchandiseCatalogId) {

		MerchandiseCatalog merchandiseCatalog = hbDaoSupport.findTById(
				MerchandiseCatalog.class, merchandiseCatalogId);
		if (null != merchandiseCatalog) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("merchandise", merchandiseCatalog.getMerchandise());
			List<Long> list = hbDaoSupport
					.executeQuery(
							"SELECT COUNT(m) FROM MerchandiseCatalog m WHERE m.merchandise=:merchandise",
							params, null);
			if (null != list && list.size() > 0 && null != list.get(0)) {
				return list.get(0).intValue();
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}

	@Override
	public List<com.chinarewards.metro.models.merchandise.Merchandise> getMerchandiseForClient(MerchandiseReq req,
			HttpServletRequest request) {
		Integer page = req.getPage();
		Integer pageSize = req.getPageSize();
		if(null == page || page.intValue() < 1){
			page = new Integer(0);
			pageSize = new Integer(0);
		}
		if( null == pageSize || pageSize.intValue() < 1){
			pageSize = new Integer(0);
		}
		Page pageDetail = new Page();
		pageDetail.setPage(page);
		pageDetail.setRows(pageSize);
		List<Merchandise> list = hbDaoSupport.findTsByHQLPage("FROM Merchandise m ORDER BY m.id DESC", new HashMap<String, Object>(), pageDetail);
		List<com.chinarewards.metro.models.merchandise.Merchandise> merchandises = new ArrayList<com.chinarewards.metro.models.merchandise.Merchandise>();
		if (null != list && list.size() > 0) {
			for (Merchandise merchandise : list) {
				List<MerchandiseFile> files = merchandise.getMerchandiseFiles();
				Set<MerchandiseCatalog> catalogs = merchandise
						.getMerchandiseCatalogs();
				List<MerchandiseSaleform> saleforms = merchandise
						.getMerchandiseSaleforms();
				com.chinarewards.metro.models.merchandise.Merchandise temp = new com.chinarewards.metro.models.merchandise.Merchandise(
						merchandise.getId(), merchandise.getName(),
						merchandise.getFreight());

				// brand
				com.chinarewards.metro.domain.brand.Brand b = merchandise
						.getBrand();
				if (null != b) {
					temp.setBrand(new Brand(b.getId(), b.getName()));
				}

				// images
				List<com.chinarewards.metro.models.merchandise.MerchandiseFile> pics = new ArrayList<com.chinarewards.metro.models.merchandise.MerchandiseFile>();
				String rootPath = request.getRequestURL().substring(0,
						request.getRequestURL().indexOf("/", 7))
						+ request.getContextPath()
						+ "/archive/imageShow?formalPath=MERCHANDISE_IMAGE_DIR&tempPath=MERCHANDISE_IMAGE_BUFFER&fileName=";
				if (null != files && files.size() > 0) {
					for (MerchandiseFile file : files) {
						pics.add(new com.chinarewards.metro.models.merchandise.MerchandiseFile(
								file.getId(), file.getMimeType(), rootPath
										+ file.getUrl(), file.getWidth(), file
										.getHeight(),
								(file.getImageType().toString())));
					}
				}
				temp.setPic(pics);

				// saleform
				if (null != saleforms && saleforms.size() > 0) {
					if(saleforms.size() ==2){
						temp.setSellWay(3);
					}
					for (MerchandiseSaleform saleform : saleforms) {
						if(saleforms.size() == 1){
							if(saleform.getUnitId().equals(Dictionary.INTEGRAL_RMB_ID)){
								temp.setSellWay(2);
							}else if( saleform.getUnitId().equals(Dictionary.INTEGRAL_BINKE_ID)){
								temp.setSellWay(1);
							}
						}
						if(saleform.getUnitId().equals(Dictionary.INTEGRAL_RMB_ID)){
							temp.setPrice(saleform.getPrice());
							temp.setPreferentialPrice(saleform.getPreferentialPrice());
						}else if(saleform.getUnitId().equals(Dictionary.INTEGRAL_BINKE_ID)){
							temp.setPointPrice(saleform.getPrice());
							temp.setPointPreferentialPrice(saleform.getPreferentialPrice());
						}
					}
				}

				// catalogs
				List<Catalog> cg = new ArrayList<Catalog>();
				if (null != catalogs && catalogs.size() > 0) {
					for (MerchandiseCatalog catalog : catalogs) {
						Category category = catalog.getCategory();
						com.chinarewards.metro.models.merchandise.Category category2 = new com.chinarewards.metro.models.merchandise.Category(
								category.getId(), category.getName(), null);
						com.chinarewards.metro.models.merchandise.Category cate = category2;
						List<com.chinarewards.metro.models.merchandise.Category> parents = new ArrayList<com.chinarewards.metro.models.merchandise.Category>();
						while (null != category.getParent()) {
							category = category.getParent();
							parents.add(new com.chinarewards.metro.models.merchandise.Category(
									category.getId(), category.getName(), null));
						}
						for (com.chinarewards.metro.models.merchandise.Category parent : parents) {
							category2.setParent(parent);
							category2 = category2.getParent();
						}

						cg.add(new Catalog(catalog.getStatus().equals(
								MerchandiseStatus.ON) ? true : false, catalog
								.getOn_offTIme(), cate));
					}
				}
				temp.setCatalogs(cg);

				merchandises.add(temp);
			}
		}
		return merchandises;
	}

	@Override
	public List<MerchandiseKeyVo> getKeywordsByMerchandise(
			Merchandise merchandise) {

		List<MerchandiseKeywords> merchandiseKeywords = hbDaoSupport
				.findTsByHQL(
						"FROM MerchandiseKeywords WHERE merchandise=? ORDER BY keywords ASC",
						merchandise);
		List<MerchandiseKeyVo> list = new ArrayList<MerchandiseKeyVo>();
		if (null != merchandiseKeywords && merchandiseKeywords.size() > 0) {
			for (MerchandiseKeywords keywords : merchandiseKeywords) {
				list.add(new MerchandiseKeyVo(CommonUtil
						.replaceSomeChar(keywords.getKeywords())));
			}
		}
		return list;
	}

	@Override
	public void saveImages(String id, Map<String, FileItem> images) throws IOException{
		
		Merchandise merchandise = hbDaoSupport.findTById(Merchandise.class, id);
		if(null != merchandise){
			if (null != images && images.size() > 0) {
				Iterator<Map.Entry<String, FileItem>> it = images.entrySet()
						.iterator();
				while (it.hasNext()) {
					Map.Entry<String, FileItem> entry = it.next();
					FileItem image = entry.getValue();
					MerchandiseFile file = new MerchandiseFile(image);
					if (file.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) {
						file.setUrl(FileUtil.moveFile(
								Constants.MERCHANDISE_IMAGE_BUFFER, file.getUrl(),
								Constants.MERCHANDISE_IMAGE_DIR));// 把图片转移至正式目录
						file.setMerchandise(merchandise);
						file.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
						file.setLastModifiedBy(UserContext.getUserId());
						hbDaoSupport.save(file);
						image.setId(file.getId());
						image.setUrl(file.getUrl());
					}
					if (image.isDelete()) {// 被删除的图片
						new File(Constants.MERCHANDISE_IMAGE_DIR, file.getUrl())
						.delete();// 物理删除图片
						hbDaoSupport.delete(file);
						it.remove();
					}
				}
			}
		}
	}

	@Override
	public List<RedemptionDetail> getDetails(Integer orderInfoId) {

		return hbDaoSupport.findTsByHQL("FROM RedemptionDetail rd WHERE rd.orderInfo.id=?", orderInfoId);
	}

}
