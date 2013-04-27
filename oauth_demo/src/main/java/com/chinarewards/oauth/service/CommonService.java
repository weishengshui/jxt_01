package com.chinarewards.oauth.service;

import java.util.List;

public interface CommonService<T> {
	
	Integer create(T t);
	
	Integer update(T t);
	
	T findById(Integer id);
	
	Integer delete(T t);
	
	Integer deleteAll();
	
	List<T> findAll();
	
	Integer batchDelete(List<Integer> list);
}
