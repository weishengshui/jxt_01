package com.chinarewards.alading.service;

import com.chinarewards.alading.domain.FileItem;

public interface IFileItemService {
	
	void save(FileItem fileItem);
	
	FileItem findFileItemById(Integer id);
}	
