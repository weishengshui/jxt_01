package com.chinarewards.metro.domain.file;

import java.util.HashMap;
import java.util.Map;

public enum ImageType {
	
	OVERVIEW,//基本图片
	OTHERS,
	IMAGE1,//图片1
	IMAGE2,//图片2
	IMAGE3,//图片3
	IMAGE4,//图片4
	IMAGE5,//图片5
	IMAGE6;//图片6
	
	private static final Map<String, ImageType> stringToEnum = new HashMap<String, ImageType>();
	static{
		for(ImageType imageType: values()){
			stringToEnum.put(imageType.toString(), imageType);
		}
	}
	
	public static ImageType fromString(String str){
		return stringToEnum.get(str);
	}
	
	@Override
	public String toString() {
		return super.toString();
	}
	
}
