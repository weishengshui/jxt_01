package com.chinarewards.alading.service;

import java.util.List;

import com.chinarewards.alading.domain.Card;

public interface ICompanyCardService {
	
	List<Integer> findAllPic();

	Card findDefaultCard();
}
