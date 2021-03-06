package com.chinarewards.alading.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.guice.transactional.Transactional;
import org.slf4j.Logger;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.FileItemMapper;
import com.google.inject.Inject;

public class FileItemService implements IFileItemService {
	
	@InjectLogger
	private Logger logger;
	
	@Inject
	private FileItemMapper fileItemMapper;
	
	@Transactional
	@Override
	public void save(FileItem fileItem) {
		fileItemMapper.insert(fileItem);
	}

	@Override
	public FileItem findFileItemById(Integer id) {
		return fileItemMapper.select(id);
	}

	@Override
	public List<FileItem> searchFileItems(Integer page, Integer rows,
			FileItem fileItem) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("startIndex", (page-1)*rows);
		params.put("pageSize", rows);
		params.put("description", fileItem.getDescription());
		
		return fileItemMapper.selectFileItems(params);
	}

	@Override
	public Integer countFileItems(Integer page, Integer rows, FileItem fileItem) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("description", fileItem.getDescription());

		return fileItemMapper.countFileItems(params);
	}

	@Override
	public int deleteFileItemById(Integer id) {
		return fileItemMapper.delete(id);
	}

	@Override
	public Integer updateDescContent(FileItem fileItem) {

		return fileItemMapper.updateDescContent(fileItem);
	}

	@Override
	public Boolean checkDeleteFileItemById(Integer id) {
		
		List<Card> list = fileItemMapper.selectCardByImageId(id);
		if(null != list && list.size() > 0){
			return false;
		}
		return true;
	}

}
