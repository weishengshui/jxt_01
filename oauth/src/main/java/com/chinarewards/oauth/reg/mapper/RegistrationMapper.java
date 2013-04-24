package com.chinarewards.oauth.reg.mapper;

import com.chinarewards.oauth.domain.Registration;

public interface RegistrationMapper {

	public Registration findUnique(Registration criteris);

	public void update(Registration reg);
}
