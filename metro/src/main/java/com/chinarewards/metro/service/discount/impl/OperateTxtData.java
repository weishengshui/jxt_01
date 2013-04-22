package com.chinarewards.metro.service.discount.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.shop.Shop;
@Component
public class OperateTxtData {
	
	final static Logger logger = LoggerFactory.getLogger(OperateTxtData.class);
	
	/**
	 * 向文件中插入数据
	 */
	public static void insert(Map<String, String> data, 
	Shop shop, ActivityInfo activityInfo, int type) {
		logger.trace("*************inter OperateTxtData insert method *********");
		String filePath = OperateTxtData.getFilePath(shop, activityInfo, type);
		try {
			File file = new File(filePath);
			Set<Map.Entry<String, String>> set = data.entrySet();
			if (!file.exists()) {
				logger.trace("*************inter OperateTxtData file is not exists *********");
				file.createNewFile();
				FileWriter writer = new FileWriter(filePath);
				for (Iterator<Map.Entry<String, String>> it = set.iterator(); it
						.hasNext();) {
					Map.Entry<String, String> entry = (Map.Entry<String, String>) it
							.next();
//					logger.trace(entry.getKey() + "===============" + entry.getValue());
					writer.write(entry.getKey() + "=" + entry.getValue() + "\n");
				}
				writer.close();
			}else{
				
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 删除文件中指定的数据
	 */
	public static void delete(String key, String filePath, Shop shop,
			ActivityInfo activityInfo, int type) {
		try {
			Map<String, String> data = getDiscountData(filePath);
			data.remove(key);
			File file = new File(filePath);
			boolean flag = file.delete();
			logger.trace("data.size===>>>> "+data.size()+"    delFileflag  ======>>>> : " +flag);
			insert(data, shop, activityInfo, type);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 获得优惠码文件中的数据
	 */
	public static Map<String, String> getDiscountData(String filePath){
		Map<String, String> data = new HashMap<String, String>();
		try {
			File file = new File(filePath);
			if(file.exists()){
				InputStream in = new FileInputStream(file);
				Reader r = new InputStreamReader(in);
				BufferedReader br = new BufferedReader(r);
				String linedata = null;
				while ((linedata = br.readLine()) != null) {
					String[] s = linedata.split("=");
					data.put(s[0], s[1]);
				}
				br.close();
				r.close();
				in.close();
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return data;
	}

	public static String getFilePath(Shop shop, ActivityInfo activityInfo,
			int type) {
		String filePath = null ;
		String path = System.getProperty("user.dir") + "/discount/";
		logger.trace("$$$ discount path: "+path);
		File file = new File(path);
		if(!file.exists()){
			file.mkdir();
		}
		if (type == 0 && shop != null) {
			filePath = path + "shop_" + shop.getId()+"_"+ (shop.getDiscountModel().equals("0") ? "rand" : "imp")+ ".txt";
			return filePath;
		} else if (type == 1 && activityInfo != null) {
			filePath = path + "activityInfo_"
					+ activityInfo.getId() + ".txt";
			return filePath;
		}
		return filePath;
	}


	/**
	 * 对已过期的优惠码进行回收或区间内的
	 */
	public static void recoverDidcountCodeData(Map<String, String> recoverdata,
			String filePath){
		File file = new File(filePath);
		Set<Map.Entry<String, String>> set1 = recoverdata.entrySet();

		try {
			if (file.exists()) {
//				file.createNewFile();
				FileWriter writer = new FileWriter(filePath,true);
				for (Iterator<Map.Entry<String, String>> it = set1
						.iterator(); it.hasNext();) {
					Map.Entry<String, String> entry = (Map.Entry<String, String>) it
							.next();
					writer.write(entry.getKey() + "=" + entry.getValue()
							+ "\n");
				}
				writer.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
