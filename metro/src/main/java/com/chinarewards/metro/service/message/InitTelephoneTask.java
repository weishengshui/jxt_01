package com.chinarewards.metro.service.message;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;

import com.chinarewards.metro.control.message.SendMessage;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.domain.message.MessageTask;
import com.chinarewards.metro.sms.ICommunicationService;
import com.chinarewards.utils.StringUtil;

public class InitTelephoneTask {

	@Autowired
	private IMessageService messageservice;
	
	@Autowired  
	private ICommunicationService communicationservice;
	
	@Autowired  
    private TaskExecutor taskExecutor;  
	
	


	//初始化短信状态
	public static Map<String , Object>  messageTask_map;
	
	@PostConstruct
	public void init() {
		  messageTask_map=new HashMap<String, Object>();
			
    //	从数据库中读取执行中的短信状态
			   List<MessageTask> mtlist=new ArrayList<MessageTask>();
			   mtlist= messageservice.listTaskByStates(Dictionary.TASK_EXECUTING);
			    if(mtlist!=null){
				for(MessageTask mt : mtlist){
					messageTask_map.put(mt.getTaskId(), mt.getTaskStates());	
					//获取任务为执行中的电话号码，开始发送信息，号码类型为0（没有发送的号码）
					 MessageTask mTask=messageservice.viewMessageTask(mt.getTaskId());
					 if(!StringUtil.isEmptyString(mTask.getContent())){
						 taskExecutor.execute(new SendMessage(mTask.getContent(),Constants.TASK_PRIORITY,mt.getTaskId(),0,messageservice,communicationservice));
					 }
				}
			}	    
	}

	@PreDestroy
	public void destroy() {
	}

}
