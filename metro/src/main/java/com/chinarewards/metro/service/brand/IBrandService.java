package com.chinarewards.metro.service.brand;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.model.brand.BrandCriteria;
import com.chinarewards.metro.model.brand.BrandUnionMemberCriteria;
import com.chinarewards.metro.model.brand.UnionMemberVo;

/**
 * 
 * @author weishengshui
 * 
 */
public interface IBrandService {

	/**
	 * 创建品牌
	 * 
	 * @param brand
	 * @param logo
	 * @return
	 */
	Brand createBrand(Brand brand);

	/**
	 * 更新品牌
	 * 
	 * @param brand
	 * @param logo
	 * @return
	 */
	Brand updateBrand(Brand brand);

	/**
	 * 根据条件查询品牌
	 * 
	 * @param brandCriteria
	 * @return
	 */
	List<Brand> searchBrands(BrandCriteria brandCriteria);

	/**
	 * 根据条件查询品牌总数
	 * 
	 * @param brandCriteria
	 * @return
	 */
	Long countBrands(BrandCriteria brandCriteria);

	/**
	 * 根据id查询品牌信息
	 * 
	 * @param id
	 * @return
	 */
	Brand findBrandById(Integer id);

	/**
	 * 检查是否可以删除指定的品牌，如果品牌下有联合会员将返回null
	 * 
	 * @param id
	 * @return
	 */
	Brand checkValidDelete(Integer id);

	/**
	 * 批量删除品牌，并返回删除的行数
	 * 
	 * @param ids
	 * @return
	 */
	Integer batchDeleteBrands(Integer[] ids);

	/**
	 * 根据条件查询联合会员
	 * 
	 * @param criteria
	 * @return
	 */
	List<UnionMemberVo> searchBrandUnionMembers(
			BrandUnionMemberCriteria brandUnionMemberCriteria, boolean isDESC);

	/**
	 * 根据条件查询联合会员总数
	 * 
	 * @param criteria
	 * @return
	 */
	int countBrandUnionMembers(
			BrandUnionMemberCriteria brandUnionMemberCriteria);

	/**
	 * 导出联合会员到EXCEL
	 * 
	 * @param response
	 * @param request
	 * @param criteria
	 */
	void exportUnionMember(HttpServletResponse response,
			HttpServletRequest request, BrandUnionMemberCriteria criteria, ProgressBar progressBar)
			throws Exception;

	/**
	 * 检查品牌名称是否已存在
	 * 
	 * @param brand
	 * @return
	 */
	boolean checkNameExists(Brand brand);

	/**
	 * 检查公司名称是否已存在
	 * 
	 * @param brand
	 * @return
	 */
	boolean checkCompanyNameExists(Brand brand);

	/**
	 * 检查公司网址是否已存在
	 * 
	 * @param brand
	 * @return
	 */
	boolean checkCompanyWebSiteExists(Brand brand);

	/**
	 * 检查联系电话是否已存在
	 * 
	 * @param brand
	 * @return
	 */
	boolean checkPhoneNumberExists(Brand brand);

	/**
	 * 查询品牌下是否有商品，没有就返回null，有就返回brand
	 * 
	 * @param id
	 * @return
	 */
	Brand checkBrandHasMerchandise(Integer id);

	/**
	 * 根据id保存品牌图片
	 * 
	 * @param id
	 * @param images
	 */
	void saveImages(Integer id, Map<String, FileItem> images)
			throws IOException;
	
}
