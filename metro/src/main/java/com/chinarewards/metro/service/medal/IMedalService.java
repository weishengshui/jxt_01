package com.chinarewards.metro.service.medal;

import java.util.List;

import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.medal.Medal;
import com.chinarewards.metro.domain.medal.MedalRule;

public interface IMedalService {
	/**
	 * 添加勋章
	 * @param medal
	 * @return
	 */
	public Medal saveMedal(Medal medal);
	
	/**
	 * 分页查询勋章
	 * @param medalName
	 * @param obtainWay
	 * @param page
	 * @return
	 */
	public List<Medal> findMedalList(String medalName,String obtainWay,Page page);
	
	/**
	 * 根据ID查询单条勋章信息
	 * @param id
	 * @return
	 */
	public Medal findMedalById(String id);
	
	/**
	 * 修改
	 * @param medal
	 */
	public void updateMedal(Medal medal);
	
	/**
	 * 查询勋章规则
	 */
	public MedalRule findMedalRule();
	
	/**
	 * 修改勋章规则
	 */
	public void updateMedalRule(String rule);
	
	/**
	 * 插入勋章规则
	 */
	public MedalRule insertMedalRule(String rule);
	
	/**
	 * 删除
	 * @param id
	 */
	public void delMedal(String id);
	
	/**
	 * 检测是否存在相同名称的勋章
	 * @param name
	 * @return
	 */
	public boolean checkName(String name,String id) ;
	
	/**
	 * 检测是否存在相同显示排序号
	 * @param name
	 * @return
	 */
	public boolean checkRevealSort(int revealSort,String id) ;
}
