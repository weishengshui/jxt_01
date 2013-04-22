package com.chinarewards.client;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.ws.rs.core.MultivaluedMap;

import com.chinarewards.metro.models.line.LineModel;
import com.chinarewards.metro.models.line.ShopModel;
import com.chinarewards.metro.models.line.SiteModel;
import com.chinarewards.metro.models.request.MetroLineReq;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;

public class MetroLineClient extends AbstractClient {
	private String url;

	public MetroLineClient(String url) {
		this.url = url;
	}

	public static void main(String[] args) {
//		List<LineModel> models = new MetroLineClient("http://127.0.0.1:8080/metro/ws").getLineDataList("QQ","QQ","QQ",null);
//		for(LineModel m : models){
//			System.out.println("************ "+m.getLineName());
//		}
		
		List<SiteModel> models = new MetroLineClient("http://127.0.0.1:8081/metro/ws").getSiteModel();
		for(SiteModel m : models){
			System.out.print("  站点ID：" + m.getStationId());
			System.out.print("  站点名称：" + m.getName());
			System.out.print("  线路：" + m.getLineName());
			System.out.print("  描述：" + m.getDescription());
			System.out.print("  图片：" + m.getPic());
			System.out.print("  排序号：" + m.getOrderNumber());
			System.out.print("  热点区域：" + m.getHotArea());
			System.out.print("  站点小图：" + m.getSmallPic()+"\n");
		}
		
//		List<ShopModel> models = new MetroLineClient("http://127.0.0.1:8081/metro/ws").getShopModel();
//		for(ShopModel m : models){
//			System.out.print("  门店ID：" + m.getShopId());
//			System.out.print("  中文名称：" + m.getChineseName());
//			System.out.print("  英文名称：" + m.getEnglishName());
//			System.out.print("  站点ID：" + m.getStationed());
//			System.out.print("  地址：" + m.getAddress());
//			System.out.print("  经纬度：" + m.getPosition());
//			System.out.print("  电话：" + m.getTelephone());
//			System.out.print("  所属品牌：" + m.getBrand());
//			System.out.print("  类型：" + m.getType()+"\n");
//		}
		
	}

	public List<LineModel> getLineDataList(String table,String operateType,String description,Date operateTime) {
		List<LineModel> models = new ArrayList<LineModel>();
		MetroLineReq req = new MetroLineReq();
		req.setDescription(description);
		req.setOperateTime(operateTime);
		req.setOperateType(operateType);
		req.setTable(table);
		WebResource resource = getClient().resource(url + "/line/lineDataList");
		try {
			models = resource.accept("application/json").post(
					new GenericType<List<LineModel>>() {
					},req);
			return models;
		} catch (UniformInterfaceException e) {
			e.printStackTrace();
		}
		return models;
	}
	
	public List<SiteModel> getSiteModel() {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
//		params.add("table", "table");
//		params.add("operateType", "operateType");
//		params.add("description", "description");
//		params.add("operateTime", "");
		WebResource resource = getClient().resource(url + "/line/site/list").queryParams(params);
		return resource.accept("application/json").get(new GenericType<List<SiteModel>>(){});

	}
	
	public List<ShopModel> getShopModel() {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("table", "table");
		params.add("operateType", "operateType");
		params.add("description", "description");
		params.add("operateTime", "");
		WebResource resource = getClient().resource(url + "/line/shop/list").queryParams(params);
		return resource.accept("application/json").get(new GenericType<List<ShopModel>>(){});

	}
}
