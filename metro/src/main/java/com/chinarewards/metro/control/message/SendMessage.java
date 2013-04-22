package com.chinarewards.metro.control.message;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.message.MessageTask;
import com.chinarewards.metro.domain.message.MessageTelephone;
import com.chinarewards.metro.service.message.IMessageService;
import com.chinarewards.metro.service.message.InitTelephoneTask;
import com.chinarewards.metro.sms.ICommunicationService;



public class SendMessage implements Runnable{
	
	public static final int row=30;
    private Logger logger = LoggerFactory.getLogger(SendMessage.class);
	
	private IMessageService messageservice;
	private ICommunicationService communicationservice;

//	private String telephones;//电话号码,考虑到电话号码很多，内存不足，不能一次取出所有任务号码
	private String content;//短信内容
	private int priority;//优先级
	private String taskid;//任务id
	private int teletype;//发送号码类型：0-没有发送；1-发送失败；
	
	/**
	 * @param telephones
	 * @param content
	 * @param priority
	 * @param taskid
	 */
	public SendMessage(String content,int priority,String taskid,int teletype,IMessageService messageservice,ICommunicationService communicationservice){
		this.content=content;
		this.priority=priority;
		this.teletype=teletype;
		this.taskid=taskid;
		this.messageservice=messageservice;
		this. communicationservice= communicationservice;
	}
	

	
	/* 对当前任务里所有号码发送短信
	 * (non-Javadoc)
	 * @see java.lang.Runnable#run()
	 */
	@Override
	public void run() {
		
	
		 int num=1;
		 List<MessageTelephone> pretlist=new ArrayList<MessageTelephone>();
		 while (true) {
		   try {
				 List<MessageTelephone> telephonelist=null;
				 telephonelist=this.getTelephone(num);
				 pretlist=telephonelist;
				 MessageTask mt=messageservice.viewMessageTask(taskid);
				 if(num==1){
					//当前任务状态变为执行中
						messageservice.updateMessageTaskSatats(taskid, Dictionary.TASK_EXECUTING);	
						if(mt.getActualSendTime()==null){
							messageservice.updateMessageTaskActualSendTime(taskid, DateTools.dateToHour24());
						}
						
				 }
				 if(telephonelist.size()==0){
					 messageservice.updateMessageTaskSatats(taskid, Dictionary.TASK_END);
					 if(mt.getEndTime()==null){
						 messageservice.updateMessageTaskEndtime(taskid, DateTools.dateToHour24());
					 }
					
					 break;
				 }
				 if(telephonelist.size()!=0){
						for(MessageTelephone t:telephonelist){
							if(t!=null){
								try {
									if(!t.getTelephone().trim().equals("")){
										this.send(taskid, t.getTelephone());
									//	Thread.sleep(200);
									}
								} catch (Exception e) {
									messageservice.updateMessageStates(taskid,t.getTelephone(), 2);
								}
							}
						}
						
						 num++;
					}
		   } catch (Exception e) {
				logger.debug(e.getMessage());
			}
		}
	}
	
	public void send(String taskid,String tp){
		//检查当前任务状态
		if((Integer)InitTelephoneTask.messageTask_map.get(taskid)==Dictionary.TASK_EXECUTING){
				//调用短信接口，发送短信
			 Long isSucess=null;
			 try {
				   Member m=messageservice.findMemberByPhone(tp);
				   if(m!=null){
					   isSucess= communicationservice.queueSMS("",m.getId().toString(), tp, content,priority,null);   
				   }else{
					   isSucess= communicationservice.queueSMS("","非会员", tp, content,priority,null);   
				   }
			} catch (Exception e) {
				isSucess=null;
			}
			 //修改号码状态
			int states=0;
			states=(isSucess!=null)?1:2;
			messageservice.updateMessageStates(taskid, tp, states);
		}
	}
	
	public List<MessageTelephone>  getTelephone(int num){
		List<MessageTelephone> mtplist=null;
		if(teletype==0){
				mtplist=messageservice.selectTelephoneList(taskid,0,row,0);
		}else if(teletype==1){
				mtplist=messageservice.selectTelephoneList(taskid,2,row,0);//
		}
		return mtplist;
	}
	

}
