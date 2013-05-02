package com.chinarewards.alading.service;

import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.reg.mapper.FileItemMapper;
import com.google.inject.Inject;

public class FileItemService implements IFileItemService {
	
	@Inject
	private FileItemMapper fileItemMapper;
	
	@Override
	public void save(FileItem fileItem) {
		fileItemMapper.insert(fileItem);
	}

	@Override
	public FileItem findFileItemById(Integer id) {
		return fileItemMapper.select(id);
	}

}
