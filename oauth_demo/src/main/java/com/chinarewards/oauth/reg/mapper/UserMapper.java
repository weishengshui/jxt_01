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

import java.util.List;

import com.chinarewards.oauth.domain.User;


/**
 * A org.mybatis.guice sample mapper.
 *
 * @version $Id: UserMapper.java,v 1.3 2013-04-25 04:25:13 weishengshui Exp $
 */
public interface UserMapper {
	
    User getUser(Integer userId);
    
    void updateUser(User user);
    
    void createUser(User user);
    
    void deleteAll();
    
    List<User> findAllUser();
    
    Integer batchDelete(List<Integer> list);
}
