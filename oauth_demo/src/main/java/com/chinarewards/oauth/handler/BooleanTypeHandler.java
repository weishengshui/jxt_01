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
		
		System.out.println(jdbcType+"\t"+parameter);
		if(null == parameter){
			ps.setString(i, null);
		} else {
			ps.setBoolean(i, parameter);
		}
	}

	@Override
	public Boolean getResult(ResultSet rs, String columnName)
			throws SQLException {
		
		String str = rs.getString(columnName);
		return (str==null)?null:(str.equals("0")?false:true);
	}

	@Override
	public Boolean getResult(ResultSet rs, int columnIndex) throws SQLException {
		
		String str = rs.getString(columnIndex);
		return (str==null)?null:(str.equals("0")?false:true);
	}

	@Override
	public Boolean getResult(CallableStatement cs, int columnIndex)
			throws SQLException {
		
		String str = cs.getString(columnIndex);
		return (str==null)?null:(str.equals("0")?false:true);
	}

}
