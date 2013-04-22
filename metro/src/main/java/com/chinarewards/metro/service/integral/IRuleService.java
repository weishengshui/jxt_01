package com.chinarewards.metro.service.integral;

import java.util.List;
import java.util.Map;

import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.rules.BirthRule;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.model.integral.IntegralQueryConditionVo;
import com.chinarewards.metro.model.integral.IntegralReport;

public interface IRuleService {

	/**
	 * 查询积分规则
	 * 
	 * @param page
	 * @param rule
	 * @return
	 */
	public List<IntegralRule> findIntegralRule(Page page, IntegralRule rule)
			throws Exception;

	/**
	 * 获取所有有效的积分规则
	 * 
	 * @return
	 */
	public List<IntegralRule> findAll();

	/**
	 * 保存积分规则
	 * 
	 * @param rule
	 */
	public IntegralRule saveIntegralRule(IntegralRule rule) throws Exception;

	/**
	 * 查询规则名称是否存在
	 * 
	 * @param ruleName
	 * @return
	 */
	public IntegralRule findRuleByName(String ruleName);

	/**
	 * 查询规则是否存在
	 * 
	 * @param rule
	 * @return
	 */
	public IntegralRule findRuleByRule(IntegralRule rule);

	/**
	 * 根据Id查询
	 * 
	 * @param id
	 * @return
	 */
	public IntegralRule findRuleById(Integer id);

	/**
	 * 修改积分规则
	 * 
	 * @param rule
	 */
	public void updateIntegralRule(IntegralRule rule) throws Exception;

	/**
	 * 删除
	 * 
	 * @param ids
	 */
	public void removeRule(String ids);

	/**
	 * 保存生日倍数
	 * 
	 * @param birthRule
	 */
	public BirthRule saveBirthRule(BirthRule birthRule);

	public void updateBirthRule(BirthRule birthRule);

	/**
	 * 根据ID查询生日倍数
	 * 
	 * @param Id
	 * @return
	 */
	public List<BirthRule> findBirthRule();

	/**
	 * 查出会员分析报表数据
	 * 
	 * @param vo
	 *            查询条件对象
	 * @param page
	 *            分页对象
	 * @return List<IntegralReport>
	 */
	public List<IntegralReport> queryIntegralReportData(
			IntegralQueryConditionVo vo, Page page);

	/**
	 * 获得积分总额
	 */
	public Long getIntegralTotalCount(IntegralQueryConditionVo vo);

	/**
	 * 使用积分总额
	 */
	public Long useIntegralTotalCount(IntegralQueryConditionVo vo);

	/**
	 * 导出数据
	 * 
	 * @param vo
	 *            查询条件对象
	 */
	public List<IntegralReport> getIntegralReportData(
			IntegralQueryConditionVo vo);

	/**
	 * 检索积分分析报表数据
	 * 
	 * @param criteria
	 *            检索条件，如果为null　or empty 不计入检索条件
	 * @param page
	 *            如果不为空，获取分页数据，如果为空获取符合条件的所有数据
	 * @return
	 */
	public List<IntegralReport> getIntegralReport(
			IntegralQueryConditionVo criteria, Page page);

	/**
	 * 检索积分分析报表数据，获取符合条件的记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countIntegralReport(IntegralQueryConditionVo criteria);

	/**
	 * 汇总条件内的使用积分数量和获取积分数量
	 * 
	 * @param vo
	 * @return
	 */
	public Map<String/* consume->消耗积分;obtain->获取积分 */, Object> sumIntegralPoint(
			IntegralQueryConditionVo criteria);

}
