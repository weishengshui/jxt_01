package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface LljlDao{
	public List<Map<String, Object>> getLljjTitle(String yg, int limit);
	public List<Map<String, Object>> getTszk(int yg, int qy, int limit);	
}
