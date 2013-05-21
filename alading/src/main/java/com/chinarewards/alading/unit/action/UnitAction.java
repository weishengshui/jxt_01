package com.chinarewards.alading.unit.action;

import org.slf4j.Logger;

import com.chinarewards.alading.action.BaseAction;
import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.IUnitService;
import com.google.inject.Inject;

/**
 * 积分单位 action
 * 
 * @author weishengshui
 * 
 */
public class UnitAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3601200997458213419L;
	@InjectLogger
	private Logger logger;
	@Inject
	private IUnitService unitService;

	// 进入页面为1，提交表单为2，成功为3，失败为4
	private Integer type;

	// create or update unit
	private Integer pointId;
	private String pointName;
	private Integer pointRate;

	// get unit json
	private Unit unit;

	public Integer getPointId() {
		return pointId;
	}

	public void setPointId(Integer pointId) {
		this.pointId = pointId;
	}

	public String getPointName() {
		return pointName;
	}

	public void setPointName(String pointName) {
		this.pointName = pointName;
	}

	public Integer getPointRate() {
		return pointRate;
	}

	public void setPointRate(Integer pointRate) {
		this.pointRate = pointRate;
	}

	public Unit getUnit() {
		return unit;
	}

	public void setUnit(Unit unit) {
		this.unit = unit;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	// create or update unit
	public String unitShow() throws Exception {
		logger.info("pointId={}, pointName={}, pointRate={}", new Object[] {
				pointId, pointName, pointRate });
		if (null == type || type.equals(new Integer(1))) { // 进入页面
			unit = unitService.findUnit();// prepare data
			return "enter";
		}

		try {
			Unit unit = new Unit();
			unit.setPointId(pointId);
			unit.setPointName(pointName);
			unit.setPointRate(pointRate);
			unitService.createOrUpdateUnit(unit);
			type = 3; // success
		} catch (Exception e) {
			type = 4; // failure
		}

		return SUCCESS;
	}

	// get unit json
	public String unitJson() throws Exception {

		unit = unitService.findUnit();

		return SUCCESS;
	}
}
