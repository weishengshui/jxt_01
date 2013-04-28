package com.chinarewards.alading.reg.mapper;

import com.chinarewards.alading.domain.Registration;

public interface RegistrationMapper {

	public Registration findUnique(Registration criteris);

	public void update(Registration reg);
}
