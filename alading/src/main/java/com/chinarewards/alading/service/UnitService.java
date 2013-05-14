package com.chinarewards.alading.service;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.UnitMapper;
import com.google.inject.Inject;

public class UnitService implements IUnitService {
	
	@InjectLogger
	private Logger logger;
	
	@Inject
	private UnitMapper unitMapper;
	
	@Override
	public Unit findUnit() {
		
		return unitMapper.selectUnit();
	}

	@Override
	public Integer createOrUpdateUnit(Unit unit) {
		if(null == unit.getPointId()){
			return unitMapper.insert(unit);
		}
		return unitMapper.update(unit);
	}

}
