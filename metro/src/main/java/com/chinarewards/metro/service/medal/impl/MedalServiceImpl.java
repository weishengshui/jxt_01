package com.chinarewards.metro.service.medal.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.medal.Medal;
import com.chinarewards.metro.domain.medal.MedalRule;
import com.chinarewards.metro.service.medal.IMedalService;

@Service
public class MedalServiceImpl implements IMedalService {
	@Autowired
	private HBDaoSupport hbDaoSupport;

	@Override
	public Medal saveMedal(Medal medal) {
		FileItem mobiImage = medal.getMobiImage();
		FileItem websiteImage = medal.getWebsiteImage();
		if (null != mobiImage) {
			hbDaoSupport.save(mobiImage);
		}
		if (null != websiteImage) {
			hbDaoSupport.save(websiteImage);
		}
		medal = hbDaoSupport.save(medal);
		return medal;
	}

	@Override
	public List<Medal> findMedalList(String medalName, String obtainWay,
			Page page) {
		StringBuffer hql = new StringBuffer();
		StringBuffer totalCount = new StringBuffer();
		totalCount.append("SELECT count(a) FROM Medal a WHERE 1=1 ");
		hql.append("SELECT a FROM Medal a WHERE 1=1 ");
		Map<String, Object> params = new HashMap<String, Object>();
		if (StringUtils.isNotEmpty(medalName)) {
			totalCount.append(" AND a.medalName LIKE :medalName");
			hql.append(" AND a.medalName LIKE :medalName");
			params.put("medalName", "%" + medalName + "%");
		}
		if (StringUtils.isNotEmpty(obtainWay)) {
			totalCount.append(" AND a.obtainWay LIKE :obtainWay");
			hql.append(" AND a.obtainWay LIKE :obtainWay");
			params.put("obtainWay", "%" + obtainWay + "%");
		}
		totalCount.append(" order by id desc");
		hql.append(" order by id desc");
		List<Long> count = hbDaoSupport.executeQuery(totalCount.toString(),
				params, null);
		if (count == null || count.size() == 0 || count.get(0) == null) {
			page.setTotalRows(0);
		} else {
			page.setTotalRows(count.get(0).intValue());
		}

		List<Medal> list = hbDaoSupport.executeQuery(hql.toString(), params,
				page);
		return list;
	}

	@Override
	public Medal findMedalById(String id) {
		// TODO Auto-generated method stub
		return hbDaoSupport.findTById(Medal.class, Integer.valueOf(id));
	}

	@Override
	public void updateMedal(Medal medal) {

		FileItem mobiImage = medal.getMobiImage();
		FileItem websiteImage = medal.getWebsiteImage();

		if (null != mobiImage) {
			if (StringUtils.isEmpty(mobiImage.getId())) {
				hbDaoSupport.save(mobiImage);
			}
		}
		if (null != websiteImage) {
			if (StringUtils.isEmpty(websiteImage.getId())) {
				hbDaoSupport.save(websiteImage);
			}
		}
		try {
			String hql = "update Medal set medalName = ?, obtainWay = ?, obtainCondition = ?, validTime = ?, revealSort = ?, mobiImage = ?, websiteImage = ? where id = ? ";
			hbDaoSupport.executeHQL(hql, medal.getMedalName(),
					medal.getObtainWay(), medal.getObtainCondition(),
					medal.getValidTime(), medal.getRevealSort(),
					medal.getMobiImage(), medal.getWebsiteImage(), 
					medal.getId());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public void delMedal(String id) {
		String hql = "delete from Medal where id = ? ";
		hbDaoSupport.executeHQL(hql, Integer.valueOf(id));
	}


	@Override
	public boolean checkName(String name,String id) {
		boolean flag = false ;
		Medal medal = null ;
		if(id != null && !id.equals("")){
			String hql = "from Medal where medalName = ? and id != ?" ;
			medal = hbDaoSupport.findTByHQL(hql, name,Integer.valueOf(id));
		}else{
			String hql = "from Medal where medalName = ?" ;
			medal = hbDaoSupport.findTByHQL(hql, name);
		}
		if(medal != null){
			flag = true ;
		}
		return flag;
	}

	@Override
	public boolean checkRevealSort(int revealSort,String id) {
		boolean flag = false ;
		Medal medal = null ;
		if(id != null && !id.equals("")){
			String hql = "from Medal where revealSort = ?  and id != ?" ;
			medal = hbDaoSupport.findTByHQL(hql, revealSort,Integer.valueOf(id));
		}else{
			String hql = "from Medal where revealSort = ?" ;
			medal = hbDaoSupport.findTByHQL(hql, revealSort);
		}
		
		if(medal != null){
			flag = true ;
		}
		return flag;
	}

	@Override
	public MedalRule findMedalRule() {
		return hbDaoSupport.findTById(MedalRule.class, 1);
	}

	@Override
	public void updateMedalRule(String rule) {
		String hql = "update MedalRule set rule = ? where id = 1" ;
		hbDaoSupport.executeHQL(hql, rule);
	}

	@Override
	public MedalRule insertMedalRule(String rule) {
		MedalRule medalRule = new MedalRule();
		medalRule.setId(1);
		medalRule.setRule(rule);
		return hbDaoSupport.save(medalRule);
	}
}
