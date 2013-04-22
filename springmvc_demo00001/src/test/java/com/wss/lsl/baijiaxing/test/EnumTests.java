package com.wss.lsl.baijiaxing.test;

import static org.junit.Assert.*;

import org.junit.Test;

import com.wss.lsl.springmvc_demo.home.enum_demo.OperationEvent;

public class EnumTests {

	@Test
	public void test() {
		assertEquals("新增", OperationEvent.EVENT_SAVE.getName());
		assertEquals("修改", OperationEvent.EVENT_UPDATE.getName());
	}

}
