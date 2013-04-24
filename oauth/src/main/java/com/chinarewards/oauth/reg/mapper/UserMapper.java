/*
 *    Copyright 2010-2012 The MyBatis Team
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package com.chinarewards.oauth.reg.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.chinarewards.oauth.domain.User;


/**
 * A org.mybatis.guice sample mapper.
 *
 * @version $Id: UserMapper.java,v 1.1 2013-04-24 03:19:03 qingminzou Exp $
 */
public interface UserMapper {
	final String SELECT_BY_ID = "SELECT * FROM users WHRER id = #{userId}";
	
//	@Select(SELECT_BY_ID)
    User getUser(/*@Param("userId")*/ String userId);

}
