package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.TblTaskDao;
import com.ssh.entity.TblTask;
import com.ssh.service.TaskService;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class TaskImpl implements TaskService{
	@Resource
	private TblTaskDao taskDao;

	public List<TblTask> findAll() {
		return taskDao.findAll();
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblTask task) {
		return taskDao.save(task);
	}
}
