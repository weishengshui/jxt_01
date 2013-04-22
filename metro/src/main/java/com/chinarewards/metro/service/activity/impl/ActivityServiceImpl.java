package com.chinarewards.metro.service.activity.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.activity.BrandActivity;
import com.chinarewards.metro.domain.activity.BrandMode;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.model.integral.IntegralReport;
import com.chinarewards.metro.service.activity.IActivityService;

@Service
public class ActivityServiceImpl implements IActivityService {

	@Autowired
	private HBDaoSupport hbDaoSupport;
	
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public ActivityInfo saveActivity(ActivityInfo activity) {
		FileItem image = activity.getImage();
		if (null != image) {
			hbDaoSupport.save(image);
		}
		activity = hbDaoSupport.save(activity);
		return activity;
	}

	@Override
	public void updateActivity(ActivityInfo activity) {
		FileItem image = activity.getImage();
		if (null != image) {
			if (StringUtils.isEmpty(image.getId())) {
				hbDaoSupport.save(image);
			}
		}
		String hql = "update ActivityInfo set activityName = ? ,startDate = ?,endDate = ?,description = ?,hoster = ?,activityNet = ?,contacts = ?,conTel = ?,image = ? ,title = ?,descr = ?,posDescr = ? where id = ?";
		hbDaoSupport.executeHQL(hql, activity.getActivityName(),
				activity.getStartDate(), activity.getEndDate(),
				activity.getDescription(), activity.getHoster(),
				activity.getActivityNet(), activity.getContacts(),
				activity.getConTel(), image, activity.getTitle(),
				activity.getDescr(), activity.getPosDescr(), activity.getId());
	}

	@Override
	public List<ActivityInfo> findActivity(String activityName,
			String startDate, String endDate, String actStatus, Page page) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			StringBuffer hql = new StringBuffer();
			StringBuffer totalCount = new StringBuffer();
			totalCount.append("SELECT count(a) FROM ActivityInfo a WHERE 1=1 ");
			hql.append("SELECT a FROM ActivityInfo a WHERE 1=1 ");
			Map<String, Object> params = new HashMap<String, Object>();
			if (StringUtils.isNotEmpty(activityName)) {
				totalCount.append(" AND a.activityName LIKE :activityName");
				hql.append(" AND a.activityName LIKE :activityName");
				params.put("activityName", "%" + activityName + "%");
			}

			if (StringUtils.isNotEmpty(startDate)) {
				totalCount.append(" AND a.startDate >= :startDate");
				hql.append(" AND a.startDate >= :startDate");
				params.put("startDate", sdf.parse(startDate));
			}
			if (StringUtils.isNotEmpty(endDate)) {
				totalCount.append(" AND a.endDate <= :endDate");
				hql.append(" AND a.endDate <= :endDate");
				params.put("endDate", sdf.parse(endDate));
			}
			if (StringUtils.isNotEmpty(actStatus)) {
				Integer sta = Integer.valueOf(actStatus);
				Date nowDate = new Date();
				switch (sta) {
				case 1: // 已取消
					totalCount.append(" AND a.tag = :tagSta");
					hql.append(" AND a.tag = :tagSta");
					params.put("tagSta", 0);
					break;
				case 2: // 未开始
					totalCount.append(" AND a.startDate >= :nowDate");
					hql.append(" AND a.startDate >= :nowDate");
					params.put("nowDate", sdf.parse(sdf.format(nowDate)));
					totalCount.append(" AND a.tag != :tag_0");
					hql.append(" AND a.tag != :tag_0");
					params.put("tag_0", 0);
					break;
				case 3: // 已结束
					totalCount.append(" AND a.endDate <= :nowDate");
					hql.append(" AND a.endDate <= :nowDate");
					params.put("nowDate", sdf.parse(sdf.format(nowDate)));
					totalCount.append(" AND a.tag != :tag_1");
					hql.append(" AND a.tag != :tag_1");
					params.put("tag_1", 0);
					break;
				case 4: // 进行中
					totalCount.append(" AND a.startDate <= :nowDate");
					hql.append(" AND a.startDate <= :nowDate");
					params.put("nowDate", sdf.parse(sdf.format(nowDate)));
					totalCount.append(" AND a.endDate >= :nowDate");
					hql.append(" AND a.endDate >= :nowDate");
					params.put("nowDate", sdf.parse(sdf.format(nowDate)));
					totalCount.append(" AND a.tag != :tagSta");
					hql.append(" AND a.tag != :tagSta");
					params.put("tagSta", 0);
					break;
				default:
					break;
				}
			}
			totalCount.append(" AND a.tag != :tag");
			hql.append(" AND a.tag != :tag");
			params.put("tag", -1);
			totalCount.append(" order by id desc");
			hql.append(" order by id desc");
			List<Long> count = hbDaoSupport.executeQuery(totalCount.toString(),
					params, null);
			if (count == null || count.size() == 0 || count.get(0) == null) {
				page.setTotalRows(0);
			} else {
				page.setTotalRows(count.get(0).intValue());
			}

			List<ActivityInfo> list = hbDaoSupport.executeQuery(hql.toString(),
					params, page);
			return list;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public ActivityInfo findActivityById(String id) {
		return hbDaoSupport.findTById(ActivityInfo.class, Integer.valueOf(id));
	}

	@Override
	public List<BrandMode> findBrandAct(Brand brand, Page page) {
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("from BrandActivity b where 1=1");
		if (StringUtils.isNotEmpty(brand.getName())) {
			hql.append(" and b.brand.name like :name");
			map.put("name", "%" + brand.getName() + "%");
		}

		List<BrandMode> bms = new LinkedList<BrandMode>();

		List<BrandActivity> list = hbDaoSupport.findTsByHQLPage(hql.toString(),
				map, page);
		for (BrandActivity bm : list) {
			BrandMode b = new BrandMode(bm.getGid(), String.valueOf(bm
					.getBrand().getId()), bm.getActivityInfo().getId() + "", bm
					.getBrand().getName(), bm.getBrand().getCompanyName(),
					bm.getJoinTime());

			bms.add(b);
			logger.trace("##debug:   " + b.getName() + "companyname: "
					+ b.getCompanyName());
		}
		return bms;
	}

	@Override
	public List<Brand> findBrandNotBandAct(Brand brand, Page page, String id) {

		String sql = "from BrandActivity a where a.activityInfo.id = ?";
		List<BrandActivity> bat = new ArrayList<BrandActivity>();
		if (id != null) {
			bat = hbDaoSupport.findTsByHQL(sql, Integer.valueOf(id));
		}

		Map<String, Object> map = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		// SELECT b FROM Brand b WHERE NOT EXISTS (SELECT a.gid FROM
		// BrandActivity a WHERE a.brand.id = b.id)
		hql.append("FROM Brand b WHERE 1=1");

		if (bat != null && bat.size() > 0) {
			hql.append(" and b.id not in (");
			StringBuffer temphql = new StringBuffer();
			for (BrandActivity ba : bat) {
				temphql.append(ba.getBrand().getId());
				temphql.append(",");
			}
			temphql.deleteCharAt(temphql.lastIndexOf(","));
			hql.append(temphql);
			hql.append(")");
		}

		if (StringUtils.isNotEmpty(brand.getName())) {
			hql.append(" and b.name like :name");
			map.put("name", "%" + brand.getName() + "%");
		}

		if (StringUtils.isNotEmpty(brand.getCompanyName())) {
			hql.append(" and b.companyName like :companyName");
			map.put("companyName", "%" + brand.getCompanyName() + "%");
		}

		List<Brand> list = hbDaoSupport.findTsByHQLPage(hql.toString(), map,
				page);
		return list;
	}

	@Override
	public void deleteActAndBranByIds(String actId) {
		String hql = "delete from BrandActivity where gid = ? ";
		hbDaoSupport.executeHQL(hql, Integer.valueOf(actId));
	}

	@Override
	public void addBrandAct(String brandId, Integer actId, Date joinTime) {
		ActivityInfo activityInfo = hbDaoSupport.findTById(ActivityInfo.class,
				actId);
		
		Brand brandFromDb = hbDaoSupport.findTById(Brand.class,
				Integer.valueOf(brandId));
		BrandActivity bt = new BrandActivity();
		bt.setActivityInfo(activityInfo);
		bt.setBrand(brandFromDb);
		bt.setJoinTime(joinTime);
		hbDaoSupport.save(bt);
		
	}

	@Override
	public void deleteActivity(String id) {
		String hql = "update ActivityInfo set tag = ? where id = ?";
		hbDaoSupport.executeHQL(hql.toString(), -1, Integer.valueOf(id));
	}

	@Override
	public void cancerActivity(String id) {
		String hql = "update ActivityInfo set tag = ? where id = ?";
		hbDaoSupport.executeHQL(hql.toString(), 0, Integer.valueOf(id));
	}

	@Override
	public PosBind savePosBind(PosBind posBind) {

		return hbDaoSupport.save(posBind);
	}

	@Override
	public int checkPosBand(String code) {
		String hql = "from PosBind where code = ? ";
		List<PosBind> binds = hbDaoSupport.findTsByHQL(hql, code);
		return binds.size();
	}

	@Override
	public List<PosBind> queryPosBands(PosBind posBand, Page page) {
		String hql = "from PosBind where mark = 0";
		Map<String, Object> map = new HashMap<String, Object>();
		return hbDaoSupport.findTsByHQLPage(hql, map, page);
	}

	@Override
	public void delPosBand(String posId) {
		String hql = "delete from PosBind where id = ?";
		hbDaoSupport.executeHQL(hql, Integer.valueOf(posId));
	}

	@Override
	public List<BrandMode> findBrandAct(String name, Page page, Integer id) {
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("from BrandActivity b where 1=1 and b.activityInfo.id = :id");
		map.put("id", id);
		if (StringUtils.isNotEmpty(name)) {
			hql.append(" and b.brand.name like :name");
			map.put("name", "%" + name + "%");
		}

		List<BrandMode> bms = new LinkedList<BrandMode>();
		List<BrandActivity> list = hbDaoSupport.findTsByHQLPage(hql.toString(),
				map, page);
		for (BrandActivity bm : list) {
			BrandMode b = new BrandMode(bm.getGid(), String.valueOf(bm
					.getBrand().getId()), bm.getActivityInfo().getId() + "", bm
					.getBrand().getName(), bm.getBrand().getCompanyName(),
					bm.getJoinTime());

			bms.add(b);
		}
		return bms;
	}

	@Override
	public List<PosBind> queryPosBands(PosBind posBand, Page page, Integer id) {
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("from PosBind where mark = 0 and fId = :id");
		map.put("id", id);
		return hbDaoSupport.findTsByHQLPage(hql.toString(), map, page);
	}

	@Override
	public int checkActNameAndTime(String name, Date dTime,String id) {
		List<ActivityInfo> infos = null ;
		
		if(id != null && !id.equals("")){
			String hql = "from ActivityInfo where activityName = ? and startDate = ? and id != ?";
			infos = hbDaoSupport.findTsByHQL(hql, name, dTime,Integer.valueOf(id));
		}else{
			String hql = "from ActivityInfo where activityName = ? and startDate = ?";
			infos = hbDaoSupport.findTsByHQL(hql, name, dTime);
		}
		
		return (infos != null) ? infos.size() : 0;
	}

	@Override
	public void saveObj(IntegralReport report) {
		// TODO Auto-generated method stub
		String sql = "insert into IntegralReport (txid,memName, memberCard, type,integralCount, origin, status, exchangeHour,integralType) values(?,?,?,?,?,?,?,?,?)" ;
		jdbcDaoSupport.execute(sql,"20130408123456",report.getMemName(),report.getMemberCard(),report.getType(),report.getIntegralCount(),report.getOrigin(),report.getStatus(),report.getExchangeHour(),0);
	}

	@Override
	public Brand findBrand(int id) {
		String sql = "select * from Brand where id in (select brand_id from BrandActivity where gid = ?)" ;
		Brand brand = jdbcDaoSupport.findTBySQL(Brand.class, sql, id);
		return brand;
	}

	@Override
	public PosBind findPosBind(int id) {
		String sql = " select * from  PosBind where id = ?" ;
		PosBind posBind = jdbcDaoSupport.findTBySQL(PosBind.class, sql, id);
		return posBind;
	}

}
