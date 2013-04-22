package com.ssh.service;

import java.util.List;
import com.ssh.entity.TblTask;

public interface TaskService {	
	public List<TblTask> findAll();
    public boolean save(TblTask task);
}
