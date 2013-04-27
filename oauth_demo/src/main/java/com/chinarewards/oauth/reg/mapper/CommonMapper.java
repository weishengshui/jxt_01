package com.chinarewards.oauth.reg.mapper;

import java.util.List;

public interface CommonMapper<T> {

	Integer insert(T t);

	Integer update(T t);

	Integer delete(T t);

	Integer batchDelete(List<Integer> list);

	T select(Integer id);

	List<T> selectAll();
	
	Integer deleteAll();
}
