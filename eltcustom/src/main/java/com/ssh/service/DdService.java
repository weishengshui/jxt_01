package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblYgddmx;
import com.ssh.entity.TblYgddzb;

public interface DdService {

	public List<Map<String,Object>> page(String param,String page,String rp);
	public String count (String param);
	
	public List<Map<String, Object>> getJfqdhjl(String yg, int limit);
	public List<Map<String, Object>> getJfdhjl(String yg, int limit);
	public List<Map<String, Object>> getXdsp(int yg,int dd, int limit);
	public List<Map<String, Object>> getTsmsp(int yg,int qy, int limit);
	public List<Map<String, Object>> getZshy(String param, int limit);
	public String getSps(String ddh);
	public List<Map<String, Object>> getDdMx(int yg, String ddh);
	public List<Map<String, Object>> getDdByDdh(int yg,String dds);
	public List<Map<String, Object>> getDdZb(int yg,String param);
	public List<Map<String, Object>> getDdspl(int yg,String ddh);
	public List<Map<String, Object>> getDdCount(int yg);
	
	public int pay(String ddh);
	public int vertify(String ddh);
	
	public boolean save(TblYgddmx mx);
    public boolean[] save(TblYgddmx[] mx);
    public TblYgddmx findMxById(Integer id);
    public TblYgddmx[] findMxByIds(Integer[] ids);
    public List<TblYgddmx> findMxByDdh(String ddh);
    
	public boolean save(TblYgddzb zb);
    public boolean[] save(TblYgddzb[] zb);
    public TblYgddzb findZbById(Integer id);
    public TblYgddzb findZbByDdh(String ddh);
    public List<TblYgddzb> findZbByYg(Integer yg);
    public TblYgddzb[] findZbByIds(Integer[] ids);

    public int cancel(String ddh);
    public int remind(String ddh);
    public int confirm(String ddh);
    public int pingjia(String ddh);
}
