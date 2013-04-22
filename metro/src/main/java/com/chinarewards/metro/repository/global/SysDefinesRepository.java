package com.chinarewards.metro.repository.global;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.domain.system.SYSVariable;

@Repository
public class SysDefinesRepository {

	@Autowired
	HBDaoSupport hbDaoSupport;

	@PostConstruct
	public void init() {

		try {
			// POS 机获取积分会员小票title
			createVariable(Dictionary.V_POSSALES_MEMBER_TITLE, "奖励积分");

			// pos 机获取积分会员小票 content
			createVariable(Dictionary.V_POSSALES_MEMBER_CONTENT,
					"商户编号：${merchantCode}\n" + "会员标识：${memberCode}\n"
							+ "消费金额：${amountConsume}\n"
							+ "奖励积分：${amountPoint}\n" 
							+ "备注：积分生效需1周时间\n\n\n"
							+ "客服热线：${serviceLine}"
							);

			// POS 机获取积分会员小票title
			createVariable(Dictionary.V_POSSALES_MERCHANT_TITLE, "奖励积分");

			// pos 机获取积分会员小票 content
			createVariable(Dictionary.V_POSSALES_MERCHANT_CONTENT,
					"商户编号：${merchantCode}\n" + "会员标识：${memberCode}\n"
							+ "消费金额：${amountConsume}\n"
							+ "奖励积分：${amountPoint}\n\n\n" 
							+ "备注：积分生效需1周时间\n"
							+ "客服热线：${serviceLine}\n"
							+ "会员签名：");

			createVariable("expresion", "1000~9999");

			// 客服热线
			createVariable(Dictionary.V_SERVICE_LINE, "400 6688 998");

		} catch (Exception e) {
			System.err.println("init system variables failed!");
			e.printStackTrace();
		}
	}

	protected SYSVariable createVariable(String key, String value) {

		String ev = getVariable(key);
		if (ev == null) {
			SYSVariable v = new SYSVariable();
			v.setKey(key);
			v.setValue(value);
			hbDaoSupport.save(v);
			return v;
		}
		return null;
	}

	public String getVariable(String key) {
		SYSVariable variable = hbDaoSupport.findTById(SYSVariable.class, key);
		if (null != variable) {
			return variable.getValue();
		}
		return null;
	}

}
