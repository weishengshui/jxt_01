package com.chinarewards.alading.service;

import com.chinarewards.alading.domain.Unit;

public interface IUnitService {
	
	Unit findUnit();
	
	Integer createOrUpdateUnit(Unit unit);
}	
