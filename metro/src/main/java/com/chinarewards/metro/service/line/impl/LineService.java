package com.chinarewards.metro.service.line.impl;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;
import org.codehaus.jackson.type.TypeReference;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.supercsv.prefs.CsvPreference;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.account.TransactionQueue;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.domain.metro.LineFile;
import com.chinarewards.metro.domain.metro.MetroLine;
import com.chinarewards.metro.domain.metro.MetroLineSite;
import com.chinarewards.metro.domain.metro.MetroSite;
import com.chinarewards.metro.domain.metro.SiteFile;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.ConsumptionType;
import com.chinarewards.metro.domain.shop.DiscountCodeImport;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.domain.shop.ShopBrand;
import com.chinarewards.metro.domain.shop.ShopChain;
import com.chinarewards.metro.domain.shop.ShopFile;
import com.chinarewards.metro.model.integral.IntegralReport;
import com.chinarewards.metro.models.line.LineModel;
import com.chinarewards.metro.service.line.ILineService;

@Service
@SuppressWarnings("rawtypes")
public class LineService implements ILineService {
	
	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public List<MetroSite> findSites(MetroSite site, Page page) {
		StringBuffer sql = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		sql.append("SELECT ms.*,GROUP_CONCAT(ml. NAME) lineName, (SELECT COUNT(1) FROM Shop s WHERE ms.id = s.siteId) orderNo FROM MetroSite ms");
		sql.append(" LEFT JOIN MetroLineSite mls ON ms.id = mls.siteId LEFT JOIN MetroLine ml ON mls.lineId = ml.id WHERE 1=1");
		sqlCount.append("select count(*) from (SELECT COUNT(*) FROM MetroSite ms LEFT JOIN MetroLineSite mls ON ms.id = mls.siteId LEFT JOIN MetroLine ml ON mls.lineId = ml.id WHERE 1=1 ");
		if(StringUtils.isNotEmpty(site.getName())){
			sql.append(" AND ms.name like ?");
			sqlCount.append(" AND ms.name like ?");
			args.add("%"+site.getName()+"%");
			argsCount.add("%"+site.getName()+"%");
		}
		if(StringUtils.isNotEmpty(site.getLineName())){
			sql.append(" AND ml.name like ?");
			sqlCount.append(" AND ml.name like ?");
			args.add("%"+site.getLineName()+"%");
			argsCount.add("%"+site.getLineName()+"%");
		}
		sqlCount.append(" GROUP BY ms.id) a");
		sql.append(" GROUP BY ms.id ORDER BY ms.id DESC LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		if(argsCount.size() > 0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		return jdbcDaoSupport.findTsBySQL(MetroSite.class, sql.toString(),args.toArray());
	}
	
	@Override
	public List<MetroSite> findLineSites(String name,Integer lindId, Page page) {
		StringBuffer sql = new StringBuffer(); 
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		sql.append("SELECT ms.* FROM MetroSite ms WHERE ms.id NOT IN( SELECT mls.siteId FROM MetroLineSite mls LEFT JOIN MetroLine ml ON ml.id = mls.lineId WHERE lineId = ?)");
		args.add(lindId);
		argsCount.add(lindId);
		if(StringUtils.isNotEmpty(name)){
			sql.append(" and ms.name like ?");
			args.add("%"+name+"%");
		}
		sql.append(" ORDER BY ms.id DESC LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		
		StringBuffer sqlcount = new StringBuffer(); 
		sqlcount.append("SELECT count(1) FROM MetroSite ms WHERE ms.id NOT IN( SELECT mls.siteId FROM MetroLineSite mls LEFT JOIN MetroLine ml ON ml.id = mls.lineId WHERE lineId = ?)");
		if(StringUtils.isNotEmpty(name)){
			sqlcount.append(" and ms.name like ?");
			argsCount.add("%"+name+"%");
		}
		page.setTotalRows(jdbcDaoSupport.findCount(sqlcount.toString(), argsCount.toArray()));
		return jdbcDaoSupport.findTsBySQL(MetroSite.class, sql.toString(), args.toArray());
	}
	
	@Override
	public <T> void saveMetroLine(MetroLine line,String siteJson,String imageSessionName) throws Exception {
		
		String sql = "SELECT tq.* FROM TransactionQueue tq LEFT JOIN `Transaction` t ON tq.tx_txId = t.txId" +
				 " WHERE DATEDIFF(now(),t.transactionDate) >= 1";
		List<TransactionQueue> list = jdbcDaoSupport.findTsBySQL(TransactionQueue.class, sql);

		// Foreach debug info better don't submit .
		//		for(TransactionQueue tq : list){
//			logger.trace(String.valueOf(tq.getCreatedAt()));
//		}
		
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
		hbDaoSupport.save(line);
		if(StringUtils.isNotEmpty(siteJson)){
			List<MetroSite> sites = mapper.readValue(siteJson,new TypeReference<List<MetroSite>>(){});
			for(MetroSite s : sites){
				MetroLineSite lineSite = new MetroLineSite();
				lineSite.setLine(line);
				lineSite.setSite(s);
				lineSite.setOrderNo(s.getOrderNo());
				hbDaoSupport.save(lineSite);
			}
		}
		
		@SuppressWarnings("unchecked")
		Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
		if(images != null){
			for (Map.Entry<String, FileItem> entry : images.entrySet()) {
				FileItem fileItem = entry.getValue();
				if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
					fileItem.setUrl(FileUtil.moveFile(Constants.LINE_BUFFEREN_IMG,fileItem.getUrl(), Constants.LINE_IMG));
					hbDaoSupport.save(fileItem);
					LineFile lineFile = new LineFile();
					lineFile.setLine(line);
					lineFile.setFileItem(fileItem);
					hbDaoSupport.save(lineFile);
				}
			}
		}
	}
	
	@Override
	public MetroLine findMetroLineByName(MetroLine line) {
		String hql = "FROM MetroLine WHERE name = ?";
		return hbDaoSupport.findTByHQL(hql, line.getName());
	}
	
	@Override
	public MetroLine findMetroLineByNum(MetroLine line) {
		String hql = "FROM MetroLine WHERE numno = ?";
		return hbDaoSupport.findTByHQL(hql, line.getNumno());
	}
	
	@Override
	public List<MetroLine> findLines(MetroLine line, Page page) {
		StringBuffer sql = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		sql.append("SELECT ml.*,(SELECT COUNT(*) FROM MetroLineSite mss WHERE mss.lineId = ml.id) c FROM MetroLine ml where 1=1");
		sqlCount.append("SELECT COUNT(1) FROM MetroLine ml WHERE 1=1");
		if(StringUtils.isNotEmpty(line.getName())){
			sql.append(" AND ml.name like ?");
			sqlCount.append(" AND ml.name like ?");
			args.add("%" + line.getName() + "%");
			argsCount.add("%"+line.getName()+"%");
		}
		if(StringUtils.isNotEmpty(line.getNumno())){
			sql.append(" AND ml.numno like ?");
			sqlCount.append(" AND ml.numno like ?");
			args.add("%"+line.getNumno()+"%");
			argsCount.add("%"+line.getNumno()+"%");
		}
		sql.append(" ORDER BY ml.id DESC LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		if(argsCount.size()>0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		return jdbcDaoSupport.findTsBySQL(MetroLine.class, sql.toString(),args.toArray());
	}
	
	@Override
	public List<MetroLine> findSiteLines(MetroLine line, Page page) {
		StringBuffer sql = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		sql.append("SELECT ml.* FROM MetroLine ml WHERE ml.id NOT IN(SELECT mls.lineId FROM MetroLineSite mls LEFT JOIN MetroSite ms ON ms.id = mls.siteId WHERE mls.siteId = ?)");
		sqlCount.append("SELECT count(*) FROM MetroLine ml WHERE ml.id NOT IN(SELECT mls.lineId FROM MetroLineSite mls LEFT JOIN MetroSite ms ON ms.id = mls.siteId WHERE mls.siteId = ?)");
		args.add(line.getId());
		argsCount.add(line.getId());
		if(StringUtils.isNotEmpty(line.getName())){
			sql.append(" AND ml.name like ?");
			sqlCount.append(" AND ml.name like ?");
			args.add("%" + line.getName() + "%");
			argsCount.add("%"+line.getName()+"%");
		}
		if(StringUtils.isNotEmpty(line.getNumno())){
			sql.append(" AND ml.numno like ?");
			sqlCount.append(" AND ml.numno like ?");
			args.add("%"+line.getNumno()+"%");
			argsCount.add("%"+line.getNumno()+"%");
		}
		sql.append(" ORDER BY ml.id DESC LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(), argsCount.toArray()));
		return jdbcDaoSupport.findTsBySQL(MetroLine.class, sql.toString(), args.toArray());
	}
	
	@Override
	public MetroLine findLineByid(Integer id) {
		return hbDaoSupport.findTById(MetroLine.class, id);
	}
	
	@Override
	public List<MetroLineSite> findMetroLineByLindId(Integer lindId) {
		String hql = "from MetroLineSite where line.id = ?";
		return hbDaoSupport.findTsByHQL(hql,lindId);
	}
	
	@Override
	public List<MetroLineSite> findMetroLineBySiteId(Integer siteId) {
		String hql = "from MetroLineSite where site.id = ?";
		return hbDaoSupport.findTsByHQL(hql,siteId);
	}
	
	@Override
	public Integer updateMetroLine(MetroLine line, String inserted,String deleted, String updated) throws Exception {
		hbDaoSupport.saveOrUpdate(line);
		if(StringUtils.isNotEmpty(inserted)){//增加
			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
			List<MetroSite> list = mapper.readValue(inserted,new TypeReference<List<MetroSite>>(){});
			for(MetroSite s : list){
				MetroLineSite lineSite = new MetroLineSite();
				lineSite.setLine(line);
				lineSite.setSite(s);
				lineSite.setOrderNo(s.getOrderNo());
				hbDaoSupport.save(lineSite);
			}
		}
		if(StringUtils.isNotEmpty(updated)){//修改
			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
			List<MetroLineSite> list = mapper.readValue(updated,new TypeReference<List<MetroLineSite>>(){});
			for(MetroLineSite ms : list){
				String hql = "update MetroLineSite set orderNo = ? where id = ?";
				hbDaoSupport.executeHQL(hql, ms.getOrderNo(),ms.getId());
			}
		}
		if(StringUtils.isNotEmpty(deleted)){//删除
			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
			List<MetroLineSite> list = mapper.readValue(deleted,new TypeReference<List<MetroLineSite>>(){});
			for(MetroLineSite ms : list){
				String hql = "DELETE FROM MetroLineSite where id = ?";
				hbDaoSupport.executeHQL(hql,ms.getId());
			}
		}
		
		return line.getId();
	}
	
	@Override
	public Integer delMetroLine(String id) {
		boolean flag = true;
		for(String id_ : id.split(",")){
			String sql = "select * from MetroLineSite where lineId = ?";
			List<MetroLineSite> list = jdbcDaoSupport.findTsBySQL(MetroLineSite.class, sql, Integer.parseInt(id_));
			if(list.size() > 0){
				flag = false; break;
			}
		}
		if(flag){
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("id", CommonUtil.getIntegers(id));
			String hql = "DELETE FROM MetroLine where id in(:id)";
			hbDaoSupport.executeHQL(hql,map);
			return 0;
		}else{
			return 1;
		}
		
	}
	
	@Override
	public Integer saveMetroSite(MetroSite site, String lineJson,String shopJson) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
		List<MetroLine> lines = mapper.readValue(lineJson,new TypeReference<List<MetroLine>>(){});
		hbDaoSupport.save(site);
		for(MetroLine line : lines){
			MetroLineSite lineSite = new MetroLineSite();
			lineSite.setLine(line);
			lineSite.setSite(site);
			lineSite.setOrderNo(line.getOrderNo());
			hbDaoSupport.save(lineSite);
		}
		if(StringUtils.isNotEmpty(shopJson)){
			List<Shop> shops = mapper.readValue(shopJson,new TypeReference<List<Shop>>(){});
			for(Shop s : shops){
				String hql = "UPDATE Shop SET siteId = ?,orderNo=? WHERE id = ?";
				hbDaoSupport.executeHQL(hql, site.getId(),s.getOrderNo(),s.getId());
			}
		}
		
		return site.getId();
	}
	
	@Override
	public List<Shop> findShops(Shop shop,Page page) {
		DetachedCriteria criteria = DetachedCriteria.forClass(shop.getClass());
		if(StringUtils.isNotEmpty(shop.getName())){
			criteria.add(Restrictions.like("name", shop.getName(),MatchMode.ANYWHERE));
		}
		return hbDaoSupport.findPageByCriteria(page, criteria);
	}
	
	@Override
	public Integer delMetroSite(String id) {
		boolean flag = true;
		for(String id_ : id.split(",")){
			String sql1 = "select * from Shop where siteId = ?";
			List<Shop> listShop = jdbcDaoSupport.findTsBySQL(Shop.class, sql1, Integer.parseInt(id_));
			if(listShop.size() > 0){
				flag = false; break;
			}
		}
		
		if(flag){
			for(String id_ : id.split(",")){
				List<MetroLineSite> list = findMetroLineBySiteId(Integer.parseInt(id_));
				String hql = "DELETE FROM MetroSite where id = ?";
				for(MetroLineSite ms : list){
					String hqls = "DELETE FROM MetroLineSite where id = ?";
					hbDaoSupport.executeHQL(hqls,ms.getId());
				}
				hbDaoSupport.executeHQL(hql,Integer.parseInt(id_));
			}
			return 0;
		}else{
			return 1;
		}
	}
	
	@Override
	public MetroSite findSiteById(Integer id) {
		return hbDaoSupport.findTById(MetroSite.class, id);
	}
	
	@Override
	public MetroSite findSiteByName(String name) {
		String hql = "from MetroSite where name = ?";
		return hbDaoSupport.findTByHQL(hql, name);
	}
	
	@Override
	public List<MetroLine> findLineBySiteId(Integer id) {
		String sql = "SELECT mls.id,ml.id c, ml.name,mls.orderNo FROM MetroSite ms" +
					 " LEFT JOIN MetroLineSite mls ON ms.id = mls.siteId LEFT JOIN MetroLine ml ON mls.lineId = ml.id"+
					 " WHERE ms.id = ?";
		return jdbcDaoSupport.findTsBySQL(MetroLine.class, sql, id);
	}
	
	@Override
	public List<Shop> findShopBySiteId(Integer id) {
		String sql  = "SELECT id,name,orderNo FROM Shop WHERE siteId = ?";
		return jdbcDaoSupport.findTsBySQL(Shop.class, sql, id);
	}
	
	@Override
	public Integer updateMetroSite(MetroSite site, String lineinserted,
			String linedeleted, String lineupdated, String shopinserted,
			String shopdeleted, String shopupdated,String imageSessionName) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
		hbDaoSupport.saveOrUpdate(site);
		if(StringUtils.isNotEmpty(lineinserted)){//增加
			List<MetroLine> list = mapper.readValue(lineinserted,new TypeReference<List<MetroLine>>(){});
			for(MetroLine line : list){
				MetroLineSite lineSite = new MetroLineSite();
				lineSite.setLine(line);
				lineSite.setSite(site);
				lineSite.setOrderNo(line.getOrderNo());
				hbDaoSupport.save(lineSite);
			}
		}
		
		if(StringUtils.isNotEmpty(linedeleted)){//删除
			List<MetroLine> list = mapper.readValue(linedeleted,new TypeReference<List<MetroLine>>(){});
			for(MetroLine msl : list){//msl id
				String hql = "DELETE FROM MetroLineSite where id = ?";
				hbDaoSupport.executeHQL(hql,msl.getId());
			}
		}
		
		if(StringUtils.isNotEmpty(lineupdated)){//修改
			List<MetroLine> list = mapper.readValue(lineupdated,new TypeReference<List<MetroLine>>(){});
			for(MetroLine msl : list){//msl id
				String hql = "update MetroLineSite set orderNo = ? where id = ?";
				jdbcDaoSupport.execute(hql, msl.getOrderNo(),msl.getId());
			}
		}
		
		if(StringUtils.isNotEmpty(shopinserted)){//增加门店
			List<Shop> shops = mapper.readValue(shopinserted,new TypeReference<List<Shop>>(){});
			for(Shop s : shops){
				String hql = "UPDATE Shop SET siteId = ?,orderNo=? WHERE id = ?";
				hbDaoSupport.executeHQL(hql, site.getId(),s.getOrderNo(),s.getId());
			}
		}
		
		if(StringUtils.isNotEmpty(shopupdated)){//修改门店
			List<Shop> shops = mapper.readValue(shopupdated,new TypeReference<List<Shop>>(){});
			for(Shop s : shops){
				String hql = "UPDATE Shop SET siteId = ?,orderNo=? WHERE id = ?";
				hbDaoSupport.executeHQL(hql, site.getId(),s.getOrderNo(),s.getId());
			}
		}
		
		if(StringUtils.isNotEmpty(shopdeleted)){//删除门店
			List<Shop> shops = mapper.readValue(shopdeleted,new TypeReference<List<Shop>>(){});
			for(Shop s : shops){
				String hql = "UPDATE Shop SET siteId = null WHERE id = ?";
				hbDaoSupport.executeHQL(hql, s.getId());
			}
		}
		/*
		@SuppressWarnings("unchecked")
		Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
		if(images != null){
			for (Map.Entry<String, FileItem> entry : images.entrySet()) {
				FileItem fileItem = entry.getValue();
				if(fileItem.isDelete()){
					FileUtil.removeFile(Constants.SITE_IMG, fileItem.getUrl());
					String hql = "DELETE FROM FileItem WHERE id = ?";
					String hql1 = "DELETE FROM SiteFile WHERE fileItem.id = ?";
					hbDaoSupport.executeHQL(hql, fileItem.getId());
					hbDaoSupport.executeHQL(hql1, fileItem.getId());
				}else{
					if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
						fileItem.setUrl(FileUtil.moveFile(Constants.SITE_BUFFEREN_IMG,fileItem.getUrl(), Constants.SITE_IMG));
						hbDaoSupport.save(fileItem);
						SiteFile siteFile = new SiteFile();
						siteFile.setSite(site);
						siteFile.setFileItem(fileItem);
						hbDaoSupport.save(siteFile);
					}
				}
			}
		}*/
		return site.getId();
	}
	
	@Override
	public void readXmlSaveLineSiteService() throws DocumentException {
		
		String url = "http://map.baidu.com/subways/data/sw_shanghai.xml";
		SAXReader saxReader = new SAXReader();
		Document document = saxReader.read(url);
		Element rootElement = document.getRootElement();
		for(Iterator i = rootElement.elementIterator();i.hasNext();){
			Element e = (Element) i.next();
			
			MetroLine line = new MetroLine();
			line.setName(e.attributeValue("lid"));
			line.setDescs(e.attributeValue("lid"));
			line.setNumno(e.attributeValue("slb"));
			hbDaoSupport.save(line);
			int orderNo = 1;
			for(Iterator ii = e.elementIterator();ii.hasNext();){
				Element ee = (Element) ii.next();
				if(StringUtils.isNotEmpty(ee.attributeValue("sid"))){
					
					MetroSite site = new MetroSite();
					site.setName(ee.attributeValue("sid"));
					site.setDescs(line.getName());
					hbDaoSupport.save(site);
					
					MetroLineSite lineSite = new MetroLineSite();
					lineSite.setLine(line);
					lineSite.setSite(site);
					lineSite.setOrderNo(orderNo++);
					hbDaoSupport.save(lineSite);
				}
			}
		}
	}
	
	@Override
	public Shop saveShop(Shop shop,MultipartFile mFile,String imageSessionName) throws Exception {
		@SuppressWarnings("unchecked")
		List<String[]> list = (List<String[]>) FileUtil.readCSV(mFile.getInputStream(), CsvPreference.STANDARD_PREFERENCE, false);
		Integer suc = 0, err = 0 ,all=0;
		if(shop.getId() == null){
			Shop shop_ = hbDaoSupport.save(shop);
			Date importDate = new Date();
			List<Integer> repeatList = new ArrayList<Integer>();
			for(String[] ss : list){
				for(String s : ss){
					if(StringUtils.isNotEmpty(s)){
						all++;
						try{
							if(repeatList.contains(Integer.parseInt(s))){
								err++;
							}else{
								repeatList.add(Integer.parseInt(s));
								DiscountCodeImport dc = new DiscountCodeImport();
								dc.setImportDate(importDate);
								dc.setDiscountNum(s);
								dc.setIsRecived(0);
								dc.setShopId(shop.getId());
								dc.setNote(shop.getNote());
								dc.setDel(0); //0 正常,1删除
								hbDaoSupport.save(dc);
								suc++;
							}
						}catch(Exception e){
							err++;
						}
					}
				}
			}
			return shop_;
		}else{
			Date importDate = new Date();
			String hql2 = "UPDATE DiscountCodeImport SET del = 1 where shopId = ?";
			hbDaoSupport.executeHQL(hql2, shop.getId());
			List<Integer> repeatList = new ArrayList<Integer>();
			for(String[] ss : list){
				for(String s : ss){
					if(StringUtils.isNotEmpty(s)){
						all++;
						try{
							if(repeatList.contains(Integer.parseInt(s))){
								err++;
							}else{
								repeatList.add(Integer.parseInt(s));
								DiscountCodeImport dc = new DiscountCodeImport();
								dc.setImportDate(importDate);
								dc.setDiscountNum(s);
								dc.setIsRecived(0);
								dc.setShopId(shop.getId());
								dc.setDel(0); //0 正常,1删除
								dc.setNote(shop.getNote());
								hbDaoSupport.save(dc);
								suc++;
							}
						}catch(Exception e){
							err++;
						}
					}
				}
			}
			hbDaoSupport.update(shop);
			shop.setExportTip("优惠码总记录数:"+all+"nn成功导入数："+suc+"nn导入失败数:"+err+(err != 0 ? " (文件内容不规范或重复,请检查)":""));
			return shop;
		}
	}
	
	@Override
	public Shop saveShopWithOut(Shop shop,String imageSessionName) throws Exception {
		if(shop.getId() == null){
			hbDaoSupport.save(shop);
			/*
			Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
			if(images != null){
				for (Map.Entry<String, FileItem> entry : images.entrySet()) {
					FileItem fileItem = entry.getValue();
					if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
						fileItem.setUrl(FileUtil.moveFile(Constants.SHOP_BUFFEREN_IMG,fileItem.getUrl(), Constants.SHOP_IMG));
						hbDaoSupport.save(fileItem);
						ShopFile shopFile = new ShopFile();
						shopFile.setShop(shop);
						shopFile.setFileItem(fileItem);
						hbDaoSupport.save(shopFile);
					}
				}
			}*/
			return shop;
		}else{
			hbDaoSupport.update(shop);
			/*
			Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
			if(images != null){
				for (Map.Entry<String, FileItem> entry : images.entrySet()) {
					FileItem fileItem = entry.getValue();
					if(fileItem.isDelete()){
						FileUtil.removeFile(Constants.SHOP_IMG, fileItem.getUrl());
						String hql = "DELETE FROM FileItem WHERE id = ?";
						String hql1 = "DELETE FROM ShopFile WHERE fileItem.id = ?";
						hbDaoSupport.executeHQL(hql, fileItem.getId());
						hbDaoSupport.executeHQL(hql1, fileItem.getId());
					}else{
						if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
							fileItem.setUrl(FileUtil.moveFile(Constants.SHOP_BUFFEREN_IMG,fileItem.getUrl(), Constants.SHOP_IMG));
							hbDaoSupport.save(fileItem);
							ShopFile shopFile = new ShopFile();
							shopFile.setShop(shop);
							shopFile.setFileItem(fileItem);
							hbDaoSupport.save(shopFile);
						}
					}
				}
			}*/
			return shop;
		}
	}
	
	@Override
	public void saveShopFile(FileItem fileItem,ShopFile shopFile) {
		hbDaoSupport.save(fileItem);
		shopFile.setFileItem(fileItem);
		hbDaoSupport.save(shopFile);
	}
	
	@Override
	public void saveTypeAndPost(String typeinserted, String typedeleted,
			String typeupdated, String posinserted, String posdeleted,
			String posupdated,Integer shopId) throws Exception {
		
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
		/**
		 * 类型
		 */
		if(StringUtils.isNotEmpty(typeinserted)){
			List<ConsumptionType> list = mapper.readValue(typeinserted,new TypeReference<List<ConsumptionType>>(){});
			for(ConsumptionType type : list){
				
				type.setShopId(shopId);
				
				type.setCreatedAt(new Date());
				// FIXME 
				type.setCreatedBy("");
				type.setLastUpdatedAt(new Date());
				// FIXME 
				type.setLastUpdateBy("");
				
				hbDaoSupport.save(type);
				
			}
		}
		
		if(StringUtils.isNotEmpty(typedeleted)){
			List<ConsumptionType> list = mapper.readValue(typedeleted,new TypeReference<List<ConsumptionType>>(){});
			for(ConsumptionType type : list){
				String hql = "DELETE FROM ConsumptionType where id = ?";
				hbDaoSupport.executeHQL(hql,type.getId());
			}
		}
		
		if(StringUtils.isNotEmpty(typeupdated)){
			List<ConsumptionType> list = mapper.readValue(typeupdated,new TypeReference<List<ConsumptionType>>(){});
			for(ConsumptionType type : list){
				
				String hql = "UPDATE ConsumptionType SET name = ?,num = ?,lastUpdatedAt=? where id = ?";
				hbDaoSupport.executeHQL(hql,type.getName(),type.getNum(),new Date(),type.getId());
			}
		}
		/**
		 * pos机绑定
		 */
		if(StringUtils.isNotEmpty(posinserted)){
			List<PosBind> list = mapper.readValue(posinserted,new TypeReference<List<PosBind>>(){});
			for(PosBind pos : list){
				pos.setCreatedAt(DateTools.dateToHour());
				pos.setCreatedBy(UserContext.getUserName());
				pos.setLastModifiedAt(DateTools.dateToHour());
				pos.setfId(shopId);
				pos.setMark(1); //绑定门店
				hbDaoSupport.save(pos);
			}
		}
		
		if(StringUtils.isNotEmpty(posdeleted)){
			List<PosBind> list = mapper.readValue(posdeleted,new TypeReference<List<PosBind>>(){});
			for(PosBind pos : list){
				String hql = "DELETE FROM PosBind where id = ?";
				hbDaoSupport.executeHQL(hql,pos.getId());
			}
		}
		
		if(StringUtils.isNotEmpty(posupdated)){
			List<PosBind> list = mapper.readValue(posupdated,new TypeReference<List<PosBind>>(){});
			for(PosBind pos : list){
				String hql = "UPDATE PosBind SET code = ?,bindDate = ?,lastModifiedAt = ?,lastModifiedBy = ? where id = ?";
				hbDaoSupport.executeHQL(hql,pos.getCode(),pos.getBindDate(),DateTools.dateToHour(),UserContext.getUserName(),pos.getId());
			}
		}
	}
	
	@Override
	public List<ConsumptionType> findType(Integer shopId) {
		String hql = "from ConsumptionType where shopId = ?";
		return hbDaoSupport.findTsByHQL(hql, shopId);
	}
	
	@Override
	public List<PosBind> findPost(Integer shopId) {
		String hql = "from PosBind where fid = ?";
		return hbDaoSupport.findTsByHQL(hql, shopId);
	}
	
	@Override
	public void saveShopSite(Integer siteId, Integer orderNo,Integer shopId) {
		String hql = "UPDATE Shop SET siteId = ?,orderNo = ? WHERE id = ?";
		hbDaoSupport.executeHQL(hql, siteId,orderNo,shopId);
	}
	
	@Override
	public void saveShopBrand(String inserted, String deleted, String updated,Integer shopId) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
		if(StringUtils.isNotEmpty(inserted)){
//			List<Brand> list = mapper.readValue(inserted,new TypeReference<List<Brand>>(){});
			List<Brand> list = new ArrayList<Brand>();
			for(String s : inserted.split(",")){
				Brand b = new Brand();
				b.setId(Integer.parseInt(s));
				list.add(b);
			}
			for(Brand brand : list){
				ShopBrand shopBrand = new ShopBrand();
				shopBrand.setBrand(brand);
				shopBrand.setShopId(shopId);
				shopBrand.setJoinDate(DateTools.dateToHour());
				hbDaoSupport.save(shopBrand);
			}
		}
		
		if(StringUtils.isNotEmpty(deleted)){
			for(String s : deleted.split(",")){
				String hql = "DELETE FROM ShopBrand where id = ?";
				hbDaoSupport.executeHQL(hql,Integer.parseInt(s));
			}
		}
		
	}
	
	@Override
	public List<ShopBrand> findShopBrand(Integer shopId) {
		String hql = "from ShopBrand where shopId = ?";
		return hbDaoSupport.findTsByHQL(hql, shopId);
	}
	public static void main(String[] args) throws JsonGenerationException, JsonMappingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
		List<Date> l = new ArrayList<Date>();
		l.add(new Date());
		//logger.trace(mapper.writeValueAsString(l));
		String s = "[1357702722000]";
		List<Date> list = mapper.readValue(s, new TypeReference<List<Date>>(){});
		//logger.trace(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(list.get(0)));
	}
	@Override
	public List<Shop> findShopPromoCode(Integer shopId) {
		String sql = "SELECT d.importDate activeDate,d.note,COUNT(1) allCount,(SELECT COUNT(1) FROM DiscountCodeImport dc WHERE isRecived = 1 AND d.shopId = dc.shopId AND d.importDate = dc.importDate"+
					 ") validateCount FROM DiscountCodeImport d LEFT JOIN Shop s ON d.shopId = s.id WHERE d.shopId = ? GROUP BY importDate ORDER BY activeDate DESC";
		return jdbcDaoSupport.findTsBySQL(Shop.class, sql, shopId);
	}
	
	@Override
	public List<DiscountCodeImport> findShopPromoCodeDetail(String num,String importDate,Page page) {
		DetachedCriteria criteria = DetachedCriteria.forClass(DiscountCodeImport.class);
		criteria.addOrder(Order.desc("importDate"));
		criteria.add(Restrictions.eq("importDate", DateTools.stringToDate(importDate)));
		if(StringUtils.isNotEmpty(num)){
			criteria.add(Restrictions.like("discountNum", num,MatchMode.ANYWHERE));
		}
		return hbDaoSupport.findPageByCriteria(page, criteria);
	}
	
	@Override
	public List<Shop> findShopList(Shop shop, Page page) {
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		sql.append("SELECT sc.numno num,sc.`name` chainName,ms.`name` siteName,s.id,s.name,s.enName,s.city,s.province,s.region,s.address,s.linkman,s.workphone FROM Shop s");
		sql.append(" LEFT JOIN MetroSite ms ON s.siteId = ms.id LEFT JOIN ShopChain sc ON sc.id = s.chainId WHERE 1=1");
		sqlCount.append("SELECT count(1) FROM Shop s LEFT JOIN ShopChain sc ON sc.id = s.chainId WHERE 1=1");
		
		if(shop.getChainId() != null){
			sql.append(" AND s.chainId = ?");
			sqlCount.append(" AND s.chainId = ?");
			args.add(shop.getChainId());
			argsCount.add(shop.getChainId());
		}
		if(StringUtils.isNotEmpty(shop.getNum())){
			sql.append(" AND sc.numno = ?");
			sqlCount.append(" AND sc.numno = ?");
			args.add(shop.getNum());
			argsCount.add(shop.getNum());
		}
		if(StringUtils.isNotEmpty(shop.getName())){
			sql.append(" AND s.name like ?");
			sqlCount.append(" AND s.name like ?");
			args.add("%"+shop.getName()+"%");
			argsCount.add("%"+shop.getName()+"%");
		}
		if(StringUtils.isNotEmpty(shop.getEnName())){
			sql.append(" AND s.enName like ?");
			sqlCount.append(" AND s.enName like ?");
			args.add("%"+shop.getEnName()+"%");
			argsCount.add("%"+shop.getEnName()+"%");
		}
		if(StringUtils.isNotEmpty(shop.getLinkman())){
			sql.append(" AND s.linkman like ?");
			sqlCount.append(" AND s.linkman like ?");
			args.add("%"+shop.getLinkman()+"%");
			argsCount.add("%"+shop.getLinkman()+"%");
		}
		if(StringUtils.isNotEmpty(shop.getProvince())){
			sql.append(" AND s.province = ?");
			sqlCount.append(" AND s.province = ?");
			args.add(shop.getProvince());
			argsCount.add(shop.getProvince());
		}
		if(StringUtils.isNotEmpty(shop.getCity())){
			sql.append(" AND s.city = ?");
			sqlCount.append(" AND s.city = ?");
			args.add(shop.getCity());
			argsCount.add(shop.getCity());
		}
		if(StringUtils.isNotEmpty(shop.getRegion())){
			sql.append(" AND s.region = ?");
			sqlCount.append(" AND s.region = ?");
			args.add(shop.getRegion());
			argsCount.add(shop.getRegion());
		}
		if(shop.getShopType() != null && shop.getShopType() !=0){
			sql.append(" AND s.shopType = ?");
			sqlCount.append(" AND s.shopType = ?");
			args.add(shop.getShopType());
			argsCount.add(shop.getShopType());
		}
		if("site".equals(shop.getNote())){//站台选择门店时，过滤门店
			sql.append(" AND s.siteId is NULL");
			sqlCount.append(" AND s.siteId is NULL");
		}
		sql.append(" ORDER BY s.id DESC LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		if(argsCount.size()>0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		return jdbcDaoSupport.findTsBySQL(Shop.class, sql.toString(),args.toArray());
	}
	
	@Override
	public Shop findShopById(Integer id) {
		String sql = "select s.*,sc.numno num,sc.name chainName from Shop s LEFT JOIN ShopChain sc ON sc.id = s.chainId where s.id = ?";
		Shop s = jdbcDaoSupport.findTBySQL(Shop.class, sql, id);
		if(s != null){
			s.setId(id);
		}
		return s;
	}
	
	@Override
	public List<FileItem> findShopPic(Integer shopId) {
		String sql = "SELECT fi.* FROM ShopFile sf LEFT JOIN FileItem fi ON sf.fileItem_id = fi.id WHERE sf.shop_id = ?";
		return jdbcDaoSupport.findTsBySQL(FileItem.class, sql,shopId);
	}
	
	@Override
	public void delShopPic(String id,String fileName) {
		String hql = "DELETE FROM ShopFile WHERE fileItem.id = ?";
		FileUtil.removeFile(Constants.SHOP_IMG , fileName);
		hbDaoSupport.executeHQL(hql, id);
	}
	
	@Override
	public void delShop(String ids) throws Exception {
		String hql1 = "DELETE FROM Shop WHERE id = ?";
		String hql2 = "DELETE FROM ConsumptionType WHERE shopId = ?";
		String hql3 = "DELETE FROM PosBind WHERE fId = ?";
		String hql4 = "DELETE FROM ShopFile WHERE shop.id = ?";
		String hql5 = "DELETE FROM ShopBrand WHERE shopId = ?";
		String hql6 = "DELETE FROM DiscountCodeImport WHERE shopId = ?";
		Integer idss[] = CommonUtil.getIntegers(ids);
		for(Integer shopId : idss){
			hbDaoSupport.executeHQL(hql6, shopId);
			hbDaoSupport.executeHQL(hql5, shopId);
			hbDaoSupport.executeHQL(hql4, shopId);
			hbDaoSupport.executeHQL(hql3, shopId);
			hbDaoSupport.executeHQL(hql2, shopId);
			hbDaoSupport.executeHQL(hql1, shopId);
		}
	}
	
	@Override
	public Map<String, FileItem> findLineImg(Integer lineId) {
		String sql = "SELECT fi.* FROM LineFile sf LEFT JOIN FileItem fi ON sf.fileItem_id = fi.id WHERE sf.line_id = ?";
		List<FileItem> list = jdbcDaoSupport.findTsBySQL(FileItem.class, sql,lineId);
		Map<String, FileItem> files = new LinkedHashMap<String, FileItem>();
		if (null != list && list.size() > 0) {
			for (FileItem file : list) {
				files.put("A" + UUIDUtil.generate(), file);
			}
		}
		return files;
	}
	
	@Override
	public Map<String, FileItem> findSiteImg(Integer siteId) {
		String sql = "SELECT fi.* FROM SiteFile sf LEFT JOIN FileItem fi ON sf.fileItem_id = fi.id WHERE sf.site_id = ?";
		List<FileItem> list = jdbcDaoSupport.findTsBySQL(FileItem.class, sql,siteId);
		Map<String, FileItem> files = new LinkedHashMap<String, FileItem>();
		if (null != list && list.size() > 0) {
			for (FileItem file : list) {
				files.put("A" + UUIDUtil.generate(), file);
			}
		}
		return files;
	}
	
	@Override
	public List<Merchandise> findShopMerchandise(Integer shopId,Page page) {
		String sql = "SELECT m.*,ms.sort FROM Merchandise m LEFT JOIN MerchandiseShop ms ON m.id = ms.merchandise_id " +
					 "LEFT JOIN Shop s ON s.id = ms.shop_id WHERE s.id = ? LIMIT ?,?";
		String sqlCount = "SELECT count(1) FROM Merchandise m LEFT JOIN MerchandiseShop ms ON m.id = ms.merchandise_id " +
				 "LEFT JOIN Shop s ON s.id = ms.shop_id WHERE s.id = ?"; 
		page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(), shopId));
		return jdbcDaoSupport.findTsBySQL(Merchandise.class, sql, shopId,page.getStart(),page.getRows());
	}
	
	@Override
	public Map<String, FileItem> findShopImg(Integer shopId){
		String sql = "SELECT fi.* FROM ShopFile sf LEFT JOIN FileItem fi ON sf.fileItem_id = fi.id WHERE sf.shop_id = ?";
		List<FileItem> list = jdbcDaoSupport.findTsBySQL(FileItem.class, sql,shopId);
		Map<String, FileItem> files = new LinkedHashMap<String, FileItem>();
		if (null != list && list.size() > 0) {
			for (FileItem file : list) {
				files.put("A" + UUIDUtil.generate(), file);
			}
		}
		return files;
	}
	
	@Override
	public Integer findSiteOrderNo(Integer lineId, Integer orderNo,Integer orderNo_) {
		orderNo_ = orderNo_ == null ? 0 : orderNo_;
		if(orderNo_.equals(orderNo)){
			return 0;
		}else{
			String sql = "select * from MetroLineSite where lineId = ? and orderNo = ?";
			MetroLineSite mls = jdbcDaoSupport.findTBySQL(MetroLineSite.class, sql, lineId,orderNo);
			if(mls == null){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public Integer findShopSite(Integer shopId,Integer siteId) {
		Shop shop = findShopById(shopId);
		if(shop.getSiteId() == null){
			return 0;
		}else{
			if(shop.getSiteId().equals(siteId)){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public List<Shop> offExternalShopList() {
		String sql = "SELECT GROUP_CONCAT(b.name) brandName,s.*,s.id FROM Shop s LEFT JOIN ShopBrand sb ON sb.shop_id = s.id"+
					 " LEFT JOIN Brand b ON b.id = sb.brand_id GROUP BY s.id";
		return jdbcDaoSupport.findTsBySQL(Shop.class, sql);
	}
	
	@Override
	public List<MetroSite> offExternalSiteList() {
		String sql = "SELECT (SELECT GROUP_CONCAT(ml.NAME) FROM MetroLineSite mls LEFT JOIN MetroLine ml ON mls.lineId = ml.id WHERE ms.id = mls.siteId GROUP BY ms.id) lineName," +
				     "(SELECT GROUP_CONCAT(Convert(mls.orderNo, char)) FROM MetroLineSite mls LEFT JOIN MetroLine ml ON mls.lineId = ml.id WHERE ms.id = mls.siteId GROUP BY mls.siteId) orderNos,"+
					 "(SELECT MAX(case when fi.imageType='OVERVIEW' then fi.url else 0 end) FROM SiteFile sf LEFT JOIN FileItem fi ON sf.fileItem_id = fi.id WHERE ms.id = sf.site_id GROUP BY ms.id) pic ,"+
					 "(SELECT MAX(case when fi.imageType='IMAGE1' then fi.url else 0 end) FROM SiteFile sf LEFT JOIN FileItem fi ON sf.fileItem_id = fi.id WHERE ms.id = sf.site_id GROUP BY ms.id) smallPic,"+
					 "ms.* FROM MetroSite ms";
		return jdbcDaoSupport.findTsBySQL(MetroSite.class, sql);
	}
	
	@Override
	public Integer findPosBinByCode(String code,String oldCode) {
		String hql = "from PosBind WHERE code = ?";
		PosBind pb = hbDaoSupport.findTByHQL(hql, code);
		if(pb == null){
			return 0;
		}else{
			if(pb.getCode().equals(oldCode)){
				return 0;
			}
			return 1;
		}
	}

	@Override
	public List<LineModel> queryLineInfos() {
		String sql = "select l.id as lineId,l.name as lineName,l.numno as lineNum,max(case when i.imageType='OVERVIEW' then i.url else '' end) pic,max(case when i.imageType='IMAGE1' then i.url else '' end) smallPic from MetroLine l left join LineFile f on l.id = f.line_id left join FileItem i on f.fileItem_id = i.id group by l.id" ;
		RowMapper rowMapper = getRowMapper();
		return jdbcDaoSupport.findTsBySQL(rowMapper, sql);
	}
	
	private RowMapper getRowMapper() {
		RowMapper rowMapper = new RowMapper<LineModel>() {
			@Override
			public LineModel mapRow(ResultSet rs, int arg1)
					throws SQLException {
				LineModel model = new LineModel();
				model.setLineId(rs.getInt("lineId"));
				model.setLineName(rs.getString("lineName"));
				model.setLineNum(rs.getString("lineNum"));
				model.setPic(rs.getString("pic"));
				model.setSmallPic(rs.getString("smallPic"));
				return model;
			}
		};
		return rowMapper;
	}
	
	@Override
	public void saveSiteFile(String imageSessionName,Integer siteId) throws Exception {
		@SuppressWarnings("unchecked")
		Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
		MetroSite site = hbDaoSupport.findTById(MetroSite.class, siteId);
		if(images != null){
			for (Map.Entry<String, FileItem> entry : images.entrySet()) {
				FileItem fileItem = entry.getValue();
				if(fileItem.isDelete()){
					FileUtil.removeFile(Constants.SITE_IMG, fileItem.getUrl());
					String hql = "DELETE FROM FileItem WHERE id = ?";
					String hql1 = "DELETE FROM SiteFile WHERE fileItem.id = ?";
					hbDaoSupport.executeHQL(hql, fileItem.getId());
					hbDaoSupport.executeHQL(hql1, fileItem.getId());
				}else{
					if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
						fileItem.setUrl(FileUtil.moveFile(Constants.SITE_BUFFEREN_IMG,fileItem.getUrl(), Constants.SITE_IMG));
						hbDaoSupport.save(fileItem);
						SiteFile siteFile = new SiteFile();
						siteFile.setSite(site);
						siteFile.setFileItem(fileItem);
						hbDaoSupport.save(siteFile);
					}
				}
			}
		}
	}
	
	@Override
	public void saveLineFile(String imageSessionName, Integer lineId)throws Exception {
		@SuppressWarnings("unchecked")
		Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
		MetroLine line = hbDaoSupport.findTById(MetroLine.class, lineId);
		if(images != null){
			for (Map.Entry<String, FileItem> entry : images.entrySet()) {
				FileItem fileItem = entry.getValue();
				if(fileItem.isDelete()){
					FileUtil.removeFile(Constants.LINE_IMG, fileItem.getUrl());
					String hql = "DELETE FROM FileItem WHERE id = ?";
					String hql1 = "DELETE FROM LineFile WHERE fileItem.id = ?";
					hbDaoSupport.executeHQL(hql, fileItem.getId());
					hbDaoSupport.executeHQL(hql1, fileItem.getId());
				}else{
					if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
						fileItem.setUrl(FileUtil.moveFile(Constants.LINE_BUFFEREN_IMG,fileItem.getUrl(), Constants.LINE_IMG));
						hbDaoSupport.save(fileItem);
						LineFile lineFile = new LineFile();
						lineFile.setLine(line);
						lineFile.setFileItem(fileItem);
						hbDaoSupport.save(lineFile);
					}
				}
			}
		}
	}
	
	@Override
	public void saveShopFile(String imageSessionName, Integer shopId)throws Exception {
		@SuppressWarnings("unchecked")
		Map<String, FileItem> images = ((Map<String, FileItem>) CommonUtil.getRequest().getSession().getAttribute(imageSessionName));
		Shop shop = hbDaoSupport.findTById(Shop.class, shopId);
		if(images != null){
			for (Map.Entry<String, FileItem> entry : images.entrySet()) {
				FileItem fileItem = entry.getValue();
				if(fileItem.isDelete()){
					FileUtil.removeFile(Constants.SHOP_IMG, fileItem.getUrl());
					String hql = "DELETE FROM FileItem WHERE id = ?";
					String hql1 = "DELETE FROM ShopFile WHERE fileItem.id = ?";
					hbDaoSupport.executeHQL(hql, fileItem.getId());
					hbDaoSupport.executeHQL(hql1, fileItem.getId());
				}else{
					if (fileItem.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) { // 把临时文件移到正式目录
						fileItem.setUrl(FileUtil.moveFile(Constants.SHOP_BUFFEREN_IMG,fileItem.getUrl(), Constants.SHOP_IMG));
						hbDaoSupport.save(fileItem);
						ShopFile shopFile = new ShopFile();
						shopFile.setShop(shop);
						shopFile.setFileItem(fileItem);
						hbDaoSupport.save(shopFile);
					}
				}
			}
		}
	}
	
	@Override
	public void saveShopChain(ShopChain chain) {
		if(chain.getId() == null){
			chain.setCreatedAt(new Date());
			chain.setCreatedBy(UserContext.getUserId());
			chain.setLastModifiedAt(new Date());
			chain.setLastModifiedBy(UserContext.getUserId());
		}else{
			chain.setLastModifiedAt(new Date());
			chain.setLastModifiedBy(UserContext.getUserId());
		}
		hbDaoSupport.saveOrUpdate(chain);
	}
	
	@Override
	public List<ShopChain> findShopChain(ShopChain chain, Page page) {
		DetachedCriteria criteria = DetachedCriteria.forClass(chain.getClass());
		criteria.addOrder(Order.desc("id"));
		if(StringUtils.isNotEmpty(chain.getName())){
			criteria.add(Restrictions.like("name", chain.getName(),MatchMode.ANYWHERE));
		}
		if(StringUtils.isNotEmpty(chain.getNumno())){
			criteria.add(Restrictions.like("numno", chain.getNumno(),MatchMode.ANYWHERE));
		}
		return hbDaoSupport.findPageByCriteria(page, criteria);
	}
	
	@Override
	public ShopChain findShopChainByNo(String numno) {
		String hql = "from ShopChain where numno = ?";
		return hbDaoSupport.findTByHQL(hql, numno);
	}
	
	@Override
	public ShopChain findShopChainById(Integer id) {
		return hbDaoSupport.findTById(ShopChain.class, id);
	}
	
	@Override
	public List<Shop> findShopByChainId(Integer chainId) {
		String hql = "from Shop where chainId = ?";
		return hbDaoSupport.findTsByHQL(hql, chainId);
	}
	
	@Override
	public void delShopChain(String ids) {
		String hql = "DELETE ShopChain WHERE id in (:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", CommonUtil.getIntegers(ids));
		hbDaoSupport.executeHQL(hql, map);
	}
}
