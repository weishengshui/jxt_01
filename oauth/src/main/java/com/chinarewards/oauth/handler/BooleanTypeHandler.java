package com.chinarewards.oauth.handler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

public class BooleanTypeHandler implements TypeHandler<Boolean> {

	@Override
	public void setParameter(PreparedStatement ps, int i, Boolean parameter,
			JdbcType jdbcType) throws SQLException {
		
		System.out.println(jdbcType);
		if(null == parameter){
		} else {
			boolean  value = (parameter.equals(new Boolean(true)))?false:true;
			ps.setBoolean(i, value);
		}
	}

	@Override
	public Boolean getResult(ResultSet rs, String columnName)
			throws SQLException {
		
		Boolean value = rs.getBoolean(columnName);
		return value.equals(new Boolean(true))?false:true;
	}

	@Override
	public Boolean getResult(ResultSet rs, int columnIndex) throws SQLException {
		
		Boolean value = rs.getBoolean(columnIndex);
		return value.equals(new Boolean(true))?false:true;
	}

	@Override
	public Boolean getResult(CallableStatement cs, int columnIndex)
			throws SQLException {
		
		Boolean value = cs.getBoolean(columnIndex);
		return value.equals(new Boolean(true))?false:true;
	}

}
