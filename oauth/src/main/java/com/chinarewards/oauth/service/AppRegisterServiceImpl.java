package com.chinarewards.oauth.service;

import org.slf4j.Logger;

import com.chinarewards.oauth.domain.Registration;
import com.chinarewards.oauth.log.InjectLogger;
import com.chinarewards.oauth.reg.mapper.RegistrationMapper;
import com.google.inject.Inject;

public class AppRegisterServiceImpl implements AppRegisterService {
	
	@InjectLogger
	private Logger logger;

	final RegistrationMapper registrationMapper;

	@Inject
	public AppRegisterServiceImpl(RegistrationMapper registrationMapper) {
		this.registrationMapper = registrationMapper;
	}

	public String authenticate(String appId, String macAddress) {
		Registration criteria = new Registration();
		criteria.appId = appId;
		criteria.macAddress = macAddress;
		Registration obj = registrationMapper.findUnique(criteria);
		if (obj != null) {
			return "000";
		}
		return "001";
	}

	@Override
	public String register(String appId, String regCode, String macAddress) {
		Registration criteria = new Registration();
		criteria.appId = appId;
		criteria.regCode = regCode;
		Registration obj = registrationMapper.findUnique(criteria);

		if (obj == null) {
//			System.out.println("find null !!!");
			logger.info("find null !!!");
			return "002";
		}

		if (obj.macAddress != null && !macAddress.isEmpty()) {
			if (macAddress.equals(obj.macAddress)) {
				return "001";
			}
			System.out.println("mac address not null ");
			return "002";
		}

		// set macAddress to update
		obj.macAddress = macAddress;
		registrationMapper.update(obj);

		return "000";
	}
}
