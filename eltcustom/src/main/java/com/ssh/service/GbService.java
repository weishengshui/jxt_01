package com.ssh.service;

import java.util.List;
import java.util.Map;

public interface GbService {
	public List<Map<String, Object>> getGbbyQy(int qy,int yg, int limit);
	public List<Map<String,Object>> page(String param,String page,String rp);
	public String count (String param);
	public Long getYgGbwd(int yg,int qy);
	public int setYgGbyd(String param);
}
