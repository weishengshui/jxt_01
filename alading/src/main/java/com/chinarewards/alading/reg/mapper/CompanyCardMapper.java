package com.chinarewards.alading.reg.mapper;

import java.util.List;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.CompanyCard;

public interface CompanyCardMapper extends CommonMapper<CompanyCard> {
	
	List<Integer> selectAllPic();

	Card selectDefaultCard();
}
