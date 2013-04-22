package com.chinarewards.metro.resources;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.ObtainConsumeTypeCode;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.ConsumptionType;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.models.GenericEntry;
import com.chinarewards.metro.models.ObtainConsumeTypeResp;
import com.chinarewards.metro.repository.shop.ShopRepository;

@Component
@Path("/pos")
public class POSResource {

	@Autowired
	private ShopRepository shopRepository;

	@GET
	@Path("/{posId}/dl")
	@Produces({ "application/xml", "application/json" })
	public ObtainConsumeTypeResp getConsumeTypes(
			@PathParam("posId") String posId) {
		ObtainConsumeTypeResp result = new ObtainConsumeTypeResp();
		result.setBindType("0");
		try {
			PosBind pos = shopRepository.findBindPos(posId);
			if (null == pos) {
				result.setResult(ObtainConsumeTypeCode.INVALID_POS);
				return result ;
			}

			// 绑定到活动
			if (pos.getMark() == 0) {
				result.setBindType("2");
			} else {
				result.setBindType("1");

				Shop shop = shopRepository.findShop(posId);

				List<ConsumptionType> list = shopRepository
						.getConsumptionTypes(shop.getId());
				List<GenericEntry> details = new LinkedList<GenericEntry>();

				Date maxLastUpdateTime = null;
				for (ConsumptionType c : list) {
					if (null != c.getLastUpdatedAt()) {
						if (maxLastUpdateTime == null) {
							maxLastUpdateTime = c.getLastUpdatedAt();
						} else {
							if (c.getLastUpdatedAt().getTime() > maxLastUpdateTime
									.getTime()) {
								maxLastUpdateTime = c.getLastUpdatedAt();
							}
						}
					}
					GenericEntry it = new GenericEntry();
					it.setKey(String.valueOf(c.getId()));
					it.setValue(c.getName());
					details.add(it);
				}
				String consumeTypeToken = maxLastUpdateTime == null ? String
						.valueOf(list.size()) : String.valueOf(list.size())
						+ String.valueOf(maxLastUpdateTime.getTime());
				result.setConsumeTypeToken(consumeTypeToken);
				result.setDetails(details);
			}
			result.setResult(ObtainConsumeTypeCode.SUCCESS);
		} catch (Exception e) {
			result.setResult(ObtainConsumeTypeCode.OTHERS);
			e.printStackTrace();
			System.err.println("ObtainConsumeTypeResp error!");
		}
		return result;
	}

	public ShopRepository getShopRepository() {
		return shopRepository;
	}

	public void setShopRepository(ShopRepository shopRepository) {
		this.shopRepository = shopRepository;
	}
}
