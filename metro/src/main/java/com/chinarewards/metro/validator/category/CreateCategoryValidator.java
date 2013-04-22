package com.chinarewards.metro.validator.category;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.chinarewards.metro.domain.category.Category;
import com.chinarewards.metro.service.category.ICategoryService;

public class CreateCategoryValidator implements Validator {
	
	private ICategoryService categoryService;
	
	public CreateCategoryValidator(ICategoryService categoryService) {
		this.categoryService = categoryService;
	}
	
	@Override
	public boolean supports(Class<?> clazz) {
		return clazz.equals(Category.class);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "name", "请输入类别名称");
		ValidationUtils.rejectIfEmpty(errors, "displaySort", "displaySort", "请输入排序编号");
		
		Category category = (Category)target;
		String name = category.getName();
		Long displaySort = category.getDisplaySort();
		if(!errors.hasErrors() && null != name && !name.trim().isEmpty() ){
			if(null == category.getId()  || category.getId().isEmpty()){
				if(categoryService.checkAddNameExists(category.getName())){
					errors.rejectValue("name", "name", "类别名称\""+name+"\"已存在, 请重新输入");
				}
			}else if(null != category.getId() && !category.getId().isEmpty()){
				if(categoryService.checkUpdateNameExists(category)){
					errors.rejectValue("name", "name", "类别名称\""+name+"\"已存在, 请重新输入");
				}
			}
		}
		if(!errors.hasErrors() && null != displaySort && displaySort.longValue() <= 0){
			errors.rejectValue("displaySort", "displaySort", "排序编号必须大于0");
		}
		if(!errors.hasErrors() && categoryService.checkDisplaySortExists(category)){
			errors.rejectValue("displaySort", "displaySort", "该排序编号已存在");
		}
	}

}
