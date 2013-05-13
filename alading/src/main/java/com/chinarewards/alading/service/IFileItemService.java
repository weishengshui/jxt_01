package com.chinarewards.alading.service;

import java.util.List;

import com.chinarewards.alading.domain.FileItem;

public interface IFileItemService {
	
	void save(FileItem fileItem);
	
	FileItem findFileItemById(Integer id);

	List<FileItem> searchFileItems(Integer page, Integer rows, FileItem fileItem);

	Integer countFileItems(Integer page, Integer rows, FileItem fileItem);
}	
