package com.chinarewards.metro.domain.user;

public enum OperationEvent {

	EVENT_SAVE("新增"),

	EVENT_UPDATE("修改"),

	EVENT_DELETE("删除"),

	EVENT_EXPORT("导出"),

	EVENT_PAUSE("暂停"),

	EVENT_RESTART("重启"),

	EVENT_RESET("重置"),
	
	EVENT_EXPIRY("失效"),

	EVENT_CANCEL("取消"),
	
	EVENT_LOGIN("登录"),
	
	EVENT_CONSUMPTION("储值卡消费"),
	
	EVENT_LOGOUT("注销");
	
	

	public String getName() {
		return this.name;
	}
	private String name;

	private OperationEvent(String name) {
		this.name = name;
	}
}
