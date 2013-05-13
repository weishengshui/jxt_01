package com.chinarewards.alading.reg.mapper;

import java.util.List;
import java.util.Map;

import com.chinarewards.alading.domain.FileItem;

public interface FileItemMapper extends CommonMapper<FileItem>{
	
	
	List<FileItem> selectFileItems(Map<String, Object> params);

	Integer countFileItems(Map<String, Object> params);
	
	
}
