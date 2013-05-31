package com.ssh.service;

import com.ssh.entity.TblYgddmx;
import com.ssh.entity.TblYgddzb;
import java.util.List;
import java.util.Map;

public abstract interface DdService
{
  public abstract List<Map<String, Object>> page(String paramString1, String paramString2, String paramString3);

  public abstract String count(String paramString);

  public abstract List<Map<String, Object>> getJfqdhjl(String paramString, int paramInt);

  public abstract List<Map<String, Object>> getJfdhjl(String paramString, int paramInt);

  public abstract List<Map<String, Object>> getXdsp(int paramInt1, int paramInt2, int paramInt3);

  public abstract List<Map<String, Object>> getTsmsp(int paramInt1, int paramInt2, int paramInt3);

  public abstract List<Map<String, Object>> getZshy(String paramString, int paramInt);

  public abstract String getSps(String paramString);

  public abstract List<Map<String, Object>> getDdMx(int paramInt, String paramString);

  public abstract List<Map<String, Object>> getDdByDdh(int paramInt, String paramString);

  public abstract List<Map<String, Object>> getDdZb(int paramInt, String paramString);

  public abstract List<Map<String, Object>> getDdspl(int paramInt, String paramString);

  public abstract List<Map<String, Object>> getDdCount(int paramInt);

  public abstract int pay(String paramString);

  public abstract int hrpay(String paramString, int paramInt);

  public abstract int vertify(String paramString);

  public abstract int hrvertify(String paramString, int paramInt);

  public abstract boolean save(TblYgddmx paramTblYgddmx);

  public abstract boolean[] save(TblYgddmx[] paramArrayOfTblYgddmx);

  public abstract TblYgddmx findMxById(Integer paramInteger);

  public abstract TblYgddmx[] findMxByIds(Integer[] paramArrayOfInteger);

  public abstract List<TblYgddmx> findMxByDdh(String paramString);

  public abstract boolean save(TblYgddzb paramTblYgddzb);

  public abstract boolean[] save(TblYgddzb[] paramArrayOfTblYgddzb);

  public abstract TblYgddzb findZbById(Integer paramInteger);

  public abstract TblYgddzb findZbByDdh(String paramString);

  public abstract List<TblYgddzb> findZbByYg(Integer paramInteger);

  public abstract TblYgddzb[] findZbByIds(Integer[] paramArrayOfInteger);

  public abstract int cancel(String paramString);

  public abstract int remind(String paramString);

  public abstract int confirm(String paramString);

  public abstract int pingjia(String paramString);
}