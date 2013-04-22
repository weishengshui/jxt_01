package com.chinarewards.metro.service.discountcoupon;

import java.util.List;
import java.util.Map;

import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.shop.DiscountCoupon;
import com.chinarewards.metro.model.discountcoupon.DiscountCouponCriteria;
import com.chinarewards.metro.model.discountcoupon.DiscountCouponVo;

public interface IDiscountCouponService {
	
	/**
	 * 通过id查询优惠券
	 * 
	 * @param id
	 * @return
	 */
	DiscountCoupon findDiscountCouponById(Integer id);
	
	/**
	 * 创建优惠券
	 * 
	 * @param coupon
	 * @param fileItems
	 * @return
	 */
	void createDiscountCoupon(DiscountCoupon coupon,
			Map<String, FileItem> fileItems);
	
	/**
	 * 修改优惠券
	 * 
	 * @param coupon
	 * @param fileItems
	 * @return
	 */
	void updateDiscountCoupon(DiscountCoupon coupon,
			Map<String, FileItem> fileItems);
	
	/**
	 * 根据条件查询优惠券
	 * 
	 * @param criteria
	 * @return
	 */
	List<DiscountCoupon> searchDiscountCoupones(DiscountCouponCriteria criteria);
	
	/**
	 * 根据条件查询优惠券总数
	 * 
	 * @param criteria
	 * @return
	 */
	Long countDiscountCoupones(DiscountCouponCriteria criteria);
	
	/**
	 * 批量删除优惠券
	 * 
	 * @param id
	 */
	void batchDelete(Integer[] ids);
	
	/**
	 * 检查优惠券的识别编号是否存在
	 * 
	 * @param coupon
	 * @return
	 */
	boolean checkIdentifyCodeExists(DiscountCoupon coupon);
	
	/**
	 * 检查优惠券的排序编号是否存在
	 * 
	 * @param coupon
	 * @return
	 */
	boolean checkSortCodeExists(DiscountCoupon coupon);
	
	/**
	 * 根据连锁或门市的ID获得指定的有效期列表
	 * 
	 * @param criteria
	 * @return
	 */
	List<DiscountCouponVo> searchValidDateDiscountCoupones(
			DiscountCouponCriteria criteria);
	
}
