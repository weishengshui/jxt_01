package com.chinarewards.metro.client;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.chinarewards.metro.models.line.LineModel;
import com.chinarewards.metro.models.line.MetroLine;
import com.chinarewards.metro.models.request.MetroLineReq;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;

public class MetroLineClient extends AbstractClient {
	private String url;

	public MetroLineClient(String url) {
		this.url = url;
	}

	public static void main(String[] args) {
		MetroLine metroLine = new MetroLineClient("http://127.0.0.1:8080/metro/ws").getLineDataList("QQ","QQ","QQ",null);
		List<LineModel> models = metroLine.getModels();
		for(LineModel m : models){
			System.out.println("************ "+m.getLineName());
		}
	}

	public MetroLine getLineDataList(String table,String operateType,String description,Date operateTime) {
		MetroLineReq req = new MetroLineReq();
		req.setDescription(description);
		req.setOperateTime(operateTime);
		req.setOperateType(operateType);
		req.setTable(table);
		MetroLine lm = null ;
		WebResource resource = getClient().resource(url + "/line/lineDataList");
		try {
			lm = resource.accept("application/json").post(
					new GenericType<MetroLine>() {
					}, req);
		} catch (UniformInterfaceException e) {
			e.printStackTrace();
		}
		return lm;
	}
}
