package com.chinarewards.metro.repository.shop;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.ConsumptionType;
import com.chinarewards.metro.domain.shop.Shop;

@Repository
public class ShopRepository {

	@Autowired
	HBDaoSupport hbDaoSupport;

	public Shop findShop(String posId) {
		Shop shop = hbDaoSupport
				.findTByHQL(
						"SELECT s FROM Shop s,PosBind b WHERE s.id = b.fId AND b.mark=? AND b.code=? ",
						1, posId);
		return shop;
	}

	public Shop findShopById(String shopId) {
		try {
			return hbDaoSupport.findTById(Shop.class, Integer.parseInt(shopId));
		} catch (NumberFormatException e) {
			return null;
		}
	}

	public List<ConsumptionType> getConsumptionTypes(int shopId) {
		List<ConsumptionType> result = hbDaoSupport.findTsByHQL(
				"FROM ConsumptionType c WHERE c.shopId=?", shopId);

		return result;
	}

	public PosBind findBindPos(String posId) {
		return hbDaoSupport.findTByHQL("FROM PosBind p WHERE p.code=?", posId);
	}
}
