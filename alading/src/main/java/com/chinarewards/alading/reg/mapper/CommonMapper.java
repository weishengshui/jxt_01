package com.chinarewards.alading.reg.mapper;

public interface CommonMapper<T> {
	
	Integer insert(T t);
	
	Integer update(T t);
	
	Integer delete(Integer id);
	
	T select(Integer id);
}
