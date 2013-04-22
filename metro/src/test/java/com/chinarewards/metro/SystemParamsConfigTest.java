//package com.chinarewards.metro;
//
//import javax.validation.constraints.AssertTrue;
//
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//import org.springframework.test.context.transaction.TransactionConfiguration;
//import static org.junit.Assert.*;
//
//import com.chinarewards.metro.core.common.SystemParamsConfig;
//
//
//@RunWith(SpringJUnit4ClassRunner.class)
//@TransactionConfiguration(defaultRollback = false)
//@ContextConfiguration(locations = { "classpath:systemParams_test.xml" })
//public class SystemParamsConfigTest {
//	
//	@Test
//	public void test_sysparams_config(){
//		assertEquals("dev", SystemParamsConfig.getSysVariable("environment").getValue());
//	}
//}
