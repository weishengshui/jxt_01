package com.chinarewards.alading.reg.mapper;

public interface CommonMapper<T> {
	
	void insert(T t);
	
	void update(T t);
	
	void delete(Integer id);
	
	T select(Integer id);
}
