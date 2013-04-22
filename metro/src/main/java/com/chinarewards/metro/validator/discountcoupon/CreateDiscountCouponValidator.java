package com.chinarewards.metro.validator.discountcoupon;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.shop.DiscountCoupon;
import com.chinarewards.metro.service.brand.IBrandService;
import com.chinarewards.metro.service.discountcoupon.IDiscountCouponService;

public class CreateDiscountCouponValidator implements Validator {

	private IDiscountCouponService discountCouponService;

	public CreateDiscountCouponValidator(IDiscountCouponService discountCouponService) {
		this.discountCouponService = discountCouponService;
	}
	
	public CreateDiscountCouponValidator() {
	}

	@Override
	public boolean supports(Class<?> clazz) {
		return clazz.equals(DiscountCoupon.class);
	}

	@Override
	public void validate(Object target, Errors errors) {

		DiscountCoupon coupon = (DiscountCoupon) target;

		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "description", "description",
				"描述");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "identifyCode", "identifyCode",
				"识别编号不能为空");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "sortCode",
				"sortCode", "排序编号不能为空");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "price",
				"price", "售价不能为空");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "comment",
				"comment", "备注不能为空");
		if(null == coupon.getShop().getId()){
			coupon.setShop(null);
		}
		if(null == coupon.getShopChain().getId()){
			coupon.setShopChain(null);
		}
		if (!errors.hasErrors()) {
			if(discountCouponService.checkIdentifyCodeExists(coupon)){
				errors.rejectValue("identifyCode", "identifyCode", "识别编号已存在");
			}
			if(discountCouponService.checkSortCodeExists(coupon)){
				errors.rejectValue("sortCode", "sortCode", "排序编号已存在");
			}
		}
	}

}
