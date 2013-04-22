package com.wss.lsl.springmvc_demo.home.services;

import java.util.Comparator;

import org.springframework.stereotype.Service;

@Service
public class CaseInsensitiveComparator implements Comparator<String> {

	@Override
	public int compare(String o1, String o2) {
		System.out.println("o1 is "+o1+"\t\to2 is "+o2);
		assert o1!=null && o2 != null;
		return String.CASE_INSENSITIVE_ORDER.compare(o1, o2);
	}

}
