package com.chinarewards.metro.service.discountcoupon;

import java.io.File;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.shop.DiscountCoupon;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.domain.shop.ShopChain;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.discountcoupon.DiscountCouponCriteria;
import com.chinarewards.metro.model.discountcoupon.DiscountCouponVo;
import com.chinarewards.metro.service.system.ISysLogService;

@Service
public class DiscountCouponService implements IDiscountCouponService {

	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	@Autowired
	private ISysLogService sysLogService;

	@Override
	public DiscountCoupon findDiscountCouponById(Integer id) {

		return hbDaoSupport.findTById(DiscountCoupon.class, id);
	}

	@Override
	public void createDiscountCoupon(DiscountCoupon coupon,
			Map<String, FileItem> fileItems) {

		FileItem fileItem = null;
		if (null != fileItems && fileItems.size() > 0) {
			for (Map.Entry<String, FileItem> entry : fileItems.entrySet()) {
				fileItem = entry.getValue();
				break;
			}
		}
		if (null != fileItem) {
			try {
				fileItem.setUrl(FileUtil.moveFile(
						Constants.COUPON_IMAGE_BUFFER, fileItem.getUrl(),
						Constants.COUPON_IMAGE_DIR));//由临时目录转移到正式目录
				hbDaoSupport.save(fileItem);
			} catch (IOException e) {
				fileItem = null;
				// ignore IOException
			}
		}
		coupon.setFileItem(fileItem);
		coupon.setCreatedAt(SystemTimeProvider.getCurrentTime());
		coupon.setCreatedBy(UserContext.getUserName());
		coupon.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		coupon.setLastModifiedBy(UserContext.getUserName());

		hbDaoSupport.save(coupon);

	}

	@Override
	public void updateDiscountCoupon(DiscountCoupon coupon,
			Map<String, FileItem> fileItems) {

		FileItem fileItem = null;
		coupon.setFileItem(null);
		if (null != fileItems && fileItems.size() > 0) {
			for (Map.Entry<String, FileItem> entry : fileItems.entrySet()) {
				FileItem tempItem = entry.getValue();
				if (null != tempItem) {
					if (tempItem.isDelete()) {
						new File(Constants.COUPON_IMAGE_DIR, tempItem.getUrl())
								.delete();
						hbDaoSupport.delete(tempItem);
					} else {
						if (tempItem.getUrl().startsWith(
								Constants.UPLOAD_TEMP_UID_PREFIX)) {
							try {
								tempItem.setUrl(FileUtil.moveFile(
										Constants.COUPON_IMAGE_BUFFER, tempItem.getUrl(),
										Constants.COUPON_IMAGE_DIR));//由临时目录转移到正式目录
								hbDaoSupport.save(tempItem);
							} catch (IOException e) {
								tempItem = null;
							}
						}
						fileItem = tempItem;
					}
				}
			}
		}
		coupon.setFileItem(fileItem);
		coupon.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		coupon.setLastModifiedBy(UserContext.getUserName());
		
		hbDaoSupport.update(coupon);
	}

	@Override
	public List<DiscountCoupon> searchDiscountCoupones(
			DiscountCouponCriteria criteria) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchDiscountCouponesHQL(criteria, params,
				false);
		List<DiscountCoupon> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countDiscountCoupones(DiscountCouponCriteria criteria) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchDiscountCouponesHQL(criteria, params,
				true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	@Override
	public void batchDelete(Integer[] ids) {
		
		if(null != ids && ids.length > 0){
			for(Integer id : ids){
				DiscountCoupon coupon = hbDaoSupport.findTById(DiscountCoupon.class, id);
				FileItem fileItem = coupon.getFileItem();
				hbDaoSupport.delete(coupon);
				try {
					sysLogService.addSysLog("优惠券维护", coupon.getIdentifyCode(), OperationEvent.EVENT_DELETE.getName(), "成功");
				} catch (Exception e) {
				}
				if(null != fileItem){
					new File(Constants.COUPON_IMAGE_DIR, fileItem.getUrl()).delete();
					hbDaoSupport.delete(fileItem);
				}
			}
		}
	}
	
	protected String buildSearchDiscountCouponesHQL(
			DiscountCouponCriteria criteria,
			Map<String, Object> params, boolean isCount) {

		StringBuffer strBuffer = new StringBuffer();
		Integer shopId = criteria.getShopId(); // 门市ID
		Integer shopChainId = criteria.getShopChainId(); // 连锁ID
		Integer queryType = criteria.getQueryType(); // 查询类型：1 表示查询所有门市；2 表示查询所有连锁

		if (isCount) {
			strBuffer.append("SELECT COUNT(d) ");
		} else {
			strBuffer
					.append("SELECT d ");
		}
		strBuffer.append("FROM DiscountCoupon d WHERE 1=1 ");
		if(null!= queryType){
			if(queryType.equals(new Integer(1))){
				strBuffer.append(" AND d.shop IS NOT NULL");
			}
			if(queryType.equals(new Integer(2))){
				strBuffer.append(" AND d.shopChain IS NOT NULL");
			}
		}else{
			if(null != shopId){
				strBuffer.append(" AND d.shop=:shop");
				params.put("shop", hbDaoSupport.findTById(Shop.class, shopId));
			}
			if(null != shopChainId){
				strBuffer.append(" AND d.shopChain=:shopChain");
				params.put("shopChain", hbDaoSupport.findTById(ShopChain.class, shopChainId));
			}
		}

		strBuffer.append(" ORDER BY d.lastModifiedAt DESC");
		// TODO

		return strBuffer.toString();
	}

	@Override
	public boolean checkIdentifyCodeExists(DiscountCoupon coupon) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("identifyCode", coupon.getIdentifyCode());
		
		StringBuffer hql = new StringBuffer("SELECT COUNT(d) FROM DiscountCoupon d WHERE d.identifyCode = :identifyCode ");
		if(null == coupon.getId()){
			hql.append(" AND d.id IS NOT null");
		}else{
			hql.append(" AND d.id <> :id ");
			params.put("id", coupon.getId());
		}
		List<Long> count = hbDaoSupport.executeQuery(hql.toString(), params, null);
		if(null == count || count.size() == 0 || null == count.get(0) || count.get(0).equals(new Long(0))){
			return false;
		}
		return true;
	}

	@Override
	public boolean checkSortCodeExists(DiscountCoupon coupon) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sortCode", coupon.getSortCode());
		
		StringBuffer hql = new StringBuffer("SELECT COUNT(d) FROM DiscountCoupon d WHERE d.sortCode = :sortCode ");
		if(null != coupon.getId()){
			hql.append(" AND d.id <> :id ");
			params.put("id", coupon.getId());
		}
		List<Long> count = hbDaoSupport.executeQuery(hql.toString(), params, null);
		if(null == count || count.size() == 0 || null == count.get(0) || count.get(0).equals(new Long(0))){
			return false;
		}
		return true;
	}

	@Override
	public List<DiscountCouponVo> searchValidDateDiscountCoupones(
			DiscountCouponCriteria criteria) {
		// TODO Auto-generated method stub
		List<Object> params = new ArrayList<Object>();
		StringBuffer sqlBuffer = new StringBuffer();
		Integer shopId = criteria.getShopId();
		Integer shopChainId = criteria.getShopChainId();
		
		sqlBuffer.append("SELECT DISTINCT d.validDateFrom, d.validDateTo, d.createdAt, d.instruction FROM  DiscountCoupon d WHERE 1=1");
		if(null != shopId){
			sqlBuffer.append(" AND d.shop_id = ?");
			params.add(shopId);
		}else if(null != shopChainId){
			sqlBuffer.append(" AND d.shopChain_id = ?");
			params.add(shopChainId);
		}else{
			sqlBuffer.append(" AND 1=0");
		}
		sqlBuffer.append(" AND d.validDateTo >= ?");
		params.add(DateTools.dateToYear());
		
		List<DiscountCouponVo> list = jdbcDaoSupport.findTsPageBySQL(new RowMapper<DiscountCouponVo>() {
			@Override
			public DiscountCouponVo mapRow(ResultSet rs, int rowNum) throws SQLException {
				return new DiscountCouponVo(rs.getDate(1), rs.getDate(2), rs.getDate(3), rs.getString(4));
			}
		}, criteria.getPaginationDetail(), "", sqlBuffer.toString(), params.toArray());
		return list;
	}

}
