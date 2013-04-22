package com.chinarewards.metro.service.message.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import org.quartz.JobDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.control.message.SendMessage;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.dynamicquartz.CustomJob;
import com.chinarewards.metro.core.dynamicquartz.QuartzManager;
import com.chinarewards.metro.core.dynamicquartz.QuartzSendMessage;
import com.chinarewards.metro.core.dynamicquartz.SendMessageJob;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.message.MessageTask;
import com.chinarewards.metro.domain.message.MessageTelephone;
import com.chinarewards.metro.model.message.MessageCount;
import com.chinarewards.metro.service.message.IMessageService;
import com.chinarewards.metro.service.message.InitTelephoneTask;
import com.chinarewards.metro.sms.ICommunicationService;
import com.chinarewards.utils.StringUtil;



@Service
public class MessageService implements IMessageService {
	@Autowired
	private HBDaoSupport hbDaoSupport;
	
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	
	@Autowired  
    private TaskExecutor taskExecutor; 
	
	@Autowired  
	private ICommunicationService communicationservice;
	
	Logger logger = Logger.getLogger(this.getClass());
	
	public MessageTask add(MessageTask mTask, String telephones,ProgressBar progressBar,int telephoneCount) {
		if(!("").equals(telephones)){
			MessageTask mt=null;
			String[] t=telephones.split(",");
			int amount=0;
			int i=0;
			int currentExportSchedule=(telephoneCount/3)*2;
			telephoneCount+=1;
			if(mTask!=null){
				mTask.setCreatedAt(DateTools.dateToHour24());
			    mt=	hbDaoSupport.save(mTask);
			}
			for ( i = 0; i < t.length; i++) {
				if(!"".equals(t[i].trim())){
						MessageTelephone mtelephone=new MessageTelephone();
						mtelephone.setMessageTask(mTask);
						mtelephone.setTelephone(t[i]);
						hbDaoSupport.save(mtelephone);
						amount++;
						progressBar.setValue( (int) (((double) (currentExportSchedule+i))
								/ ((double) telephoneCount) * 100));
				}
			}
			this.updateMessageAmount(mTask.getTaskId(), amount);
			return mt;
		}		
		return null;
	}

	@Override
	public void updateMessageTaskSatats(String taskid, int taskStates) {
		//改变内存中短信状态
		if(taskStates== Dictionary.TASK_END||taskStates== Dictionary.TASK_CANCEL){
			InitTelephoneTask.messageTask_map.remove(taskid);
		}else{
			InitTelephoneTask.messageTask_map.put(taskid, taskStates);	
		}
		 //改变DB中短信状态
		String hql = "update MessageTask set taskStates=:taskStates where taskId=:taskId";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("taskStates", taskStates);
		map.put("taskId", taskid);
		hbDaoSupport.executeHQL(hql, map);
	}
	
	
	public void updateMessageAmount(String taskid, int amount){
		String hql = "update MessageTask set amount = :amount where taskId=:taskId";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("amount", amount);
		map.put("taskId", taskid);
		hbDaoSupport.executeHQL(hql, map);
	}

	@Override
	public List<MessageTask> listMessagesTask(MessageTask mt, Page page) {
	
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		sql.append("select taskId,taskName,content,planSendTime,actualSendTime,endTime,taskStates ,amount from MessageTask where 1=1");
		
		StringBuffer sqlCount = new StringBuffer();
		sqlCount.append("SELECT count(1) FROM MessageTask  WHERE 1=1");
		if(mt.getTaskStates()!=null&&!"".equals(mt.getTaskStates())){
			sql.append(" AND taskStates = ?");
			sqlCount.append(" and taskStates = ?");
			args.add(mt.getTaskStates());
			argsCount.add(mt.getTaskStates());
		}
		if(StringUtils.isNotEmpty(mt.getTaskName())){
			sql.append(" AND taskName like ?");
			sqlCount.append(" and taskName like ?");
			args.add("%"+mt.getTaskName()+"%");
			argsCount.add(mt.getTaskName());
		}
		sql.append(" order by createdAt desc");
		sql.append(" LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		logger.trace(sql);
		if(argsCount.size()>0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		logger.trace(sql.toString());
	//	RowMapper rowMapper = getRowMessageMapper();
		List<MessageTask> mtlist = jdbcDaoSupport.findTsBySQL(MessageTask.class, sql.toString(),args.toArray());
		//根据taskid获取发送成功号码数，失败号码数
		
		for(int i=0;i<mtlist.size();i++){
			MessageTask m=mtlist.get(i);
			MessageCount mc=this.selectMessageCount(m.getTaskId());
			if(mc!=null){
				mtlist.get(i).setSuccessAmount(mc.getSuccessAmount());
				mtlist.get(i).setFailureAmount(mc.getFailureAmount());
				mtlist.get(i).setNotSentAmount(mc.getNotSentAmount());
			}
		}
		return mtlist;
	}
	
	
	private RowMapper getRowMessageMapper() {
		RowMapper rowMapper = new RowMapper<MessageTask>() {
			@Override
			public MessageTask mapRow(ResultSet rs, int arg1)
					throws SQLException {
				MessageTask report = new MessageTask();
				 report.setTaskId(rs.getString("taskId"));
				 report.setTaskName(rs.getString("taskName"));
				 report.setActualSendTime(rs.getDate("actualSendTime"));
				 report.setAmount(rs.getInt("amount"));
				 report.setContent(rs.getString("content"));
				 report.setTaskStates(rs.getInt("taskStates"));
				 report.setPlanSendTime(rs.getDate("planSendTime"));
				// report.setNotSentAmount(rs.getInt("notSentAmount"));
				// report.setSuccessAmount(rs.getInt("successAmount"));
				// report.setFailureAmount(rs.getInt("failureAmount"));
				 report.setEndTime(rs.getDate("endTime"));
				// report.setCreatedAt(rs.getDate("createdAt"));
				return report;
			}
		};
		return rowMapper;
	}

	@Override
	public MessageTask viewMessageTask(String taskid) {
		MessageTask mt= hbDaoSupport.findTById(MessageTask.class, taskid);
		if(mt!=null){
			MessageCount mc=this.selectMessageCount(taskid);
			if(mc!=null){
				mt.setSuccessAmount(mc.getSuccessAmount());
				mt.setFailureAmount(mc.getFailureAmount());
				mt.setNotSentAmount(mc.getNotSentAmount());
			}	
			
		}
		return mt;
	}
	
	@Override
	public MessageTask findById(String taskid) {
		MessageTask mt= hbDaoSupport.findTById(MessageTask.class, taskid);
		return mt;
	}

	@Override
	public void updateMessageStates(String taskid, String telephone, int states) {
		String hql = "update MessageTelephone set states =:states , sendTime =:sendTime where messageTask_taskId=:messageTask_taskId and telephone=:telephone";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("states", states);
		map.put("telephone", telephone);
		map.put("messageTask_taskId", taskid);
		map.put("sendTime", DateTools.dateToHour());
		hbDaoSupport.executeHQL(hql, map);
	}

	@Override
	public List<MessageTelephone> selectMTelByTaskidStates(String taskId,int states) {
		StringBuffer hql = new StringBuffer();
		hql.append("from MessageTelephone where 1=1");
		
			hql.append(" and messageTask_taskId =?");
			hql.append(" and states =?");
		hql.append(" order by telephoneId desc");
		return hbDaoSupport.findTsByHQL(hql.toString(),taskId,states);
		
	}

	@Override
	public MessageCount selectMessageCount(String taskId) {
		String sql="select s.successAmount,f.failureAmount,n.notSentAmount from"+
		"("+
		  "select tp.messageTask_taskId as taskId,  count(tp.messageTask_taskId) as successAmount"+ 
		  " from MessageTelephone tp  "+
		  " where tp.states=1 and      tp.messageTask_taskId=?"+ 
		") s,"+
		"("+
		"	select tp.messageTask_taskId as taskId,  count(tp.messageTask_taskId) as failureAmount"+
		"	from MessageTelephone tp  "+
		" where tp.states=2 and      tp.messageTask_taskId=?"+	
		") f,"+
		"("+
		"select tp.messageTask_taskId as taskId,  count(tp.messageTask_taskId) as notSentAmount "+
		" from MessageTelephone tp "+ 
		" where tp.states=0 and   tp.messageTask_taskId=?"+
		")n";
		logger.trace("==================================="+sql);
		return jdbcDaoSupport.findTBySQL(MessageCount.class, sql, taskId,taskId,taskId);
	}

	@Override
	public List<MessageTask> listTaskByStates(int states) {
		Map<String,Object> map = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("from MessageTask where 1=1");
		hql.append(" and taskStates=?");
		map.put("taskStates",states);
	
		return hbDaoSupport.findTsByHQL(hql.toString(),states);
	}

	@Override
	public void deleteMessageTask(String taskid) {
		String thql = "delete from MessageTelephone where messageTask_taskId in(:taskid)";
		Map<String,Object> tmap = new HashMap<String, Object>();
		tmap.put("taskid", taskid);
		hbDaoSupport.executeHQL(thql, tmap);
		
		String hql = "delete from MessageTask where taskId in(:taskid)";
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("taskid", taskid);
		hbDaoSupport.executeHQL(hql, map);
	}

	@Override
	public List<MessageTelephone> listTelephoneByTaskid(String taskId,Page page,int states) {
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		sql.append("select telephoneId,telephone,states,messageTask_taskId,sendTime from MessageTelephone where 1=1");
		StringBuffer sqlCount = new StringBuffer();
		sqlCount.append("SELECT count(1) FROM MessageTelephone  WHERE 1=1");
			sql.append(" AND messageTask_taskId = ?");
			sqlCount.append(" and messageTask_taskId = ?");
			args.add(taskId);
			argsCount.add(taskId);
			if(states!=0){
				sql.append(" AND states = ?");
				sqlCount.append(" and states = ?");
				args.add(states);
				argsCount.add(states);
			}
			
		sql.append(" order by telephoneId desc");
		
		sql.append(" LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
	
		if(argsCount.size()>0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		return jdbcDaoSupport.findTsBySQL(MessageTelephone.class, sql.toString(),args.toArray());
	}

	@Override
	public void updateMessageTaskEndtime(String taskid, Date endTime) {
		String hql = "update MessageTask set endTime=:endTime where taskId=:taskId";
		Map<String,Object> map = new HashMap<String,Object>();
		 map.put("endTime", endTime);
		map.put("taskId", taskid);
		hbDaoSupport.executeHQL(hql, map);
		
	}

	
	@Override
	public void updateMessageTaskActualSendTime(String taskid, Date startTime) {
		String hql = "update MessageTask set actualSendTime=:actualSendTime where taskId=:taskId";
		Map<String,Object> map = new HashMap<String,Object>();
		 map.put("actualSendTime", startTime);
		map.put("taskId", taskid);
		hbDaoSupport.executeHQL(hql, map);
	}

	public Map checkTelephone(String sTelephone, List<MessageTelephone> listTelephone,ProgressBar progressBar,int telephoneCount) {
		//（重复；号码不足11位;不是数字）
		
		Map map=new HashMap();
	//	List<MessageTelephone> trueMT=new ArrayList<MessageTelephone>();
		StringBuffer sb=new StringBuffer();//合格号码
		int tel=0;
		int totle=0;//总数
		int failureCount=0;//失败数目
		int i=0;
		int currentExportSchedule=telephoneCount/3;
		if(!StringUtil.isEmptyString(sTelephone)){
			String[] t=sTelephone.split(",");
			String[] tl=sTelephone.split(",");
		logger.trace("t.length==============="+t.length);
		int l=t.length*3;
			for ( i = 0; i < t.length; i++) {
				if(!t[i].trim().equals("")){
					totle++;
					String tvalue=t[i];
					int count=0;
					for(int j = 0; j < tl.length; j++){
						if(!tl[j].trim().equals("")){
							if(tvalue.equals(tl[j])){
								count++;
							}
						}
					}
					if(count>=2){
						failureCount++;
						continue;
					}
					//号码不足11位
					if(t[i].length()!=11){
						failureCount++;
						continue;
					}
					//不是数字
					if(isInteger(t[i])==false){
						failureCount++;
						continue;
					}
					sb.append(t[i]+",");
					progressBar.setValue(( (int) (((double)i)
							/ ((double) l) * 100))+30);
				}
				
			}
		}
		map.put("totle", totle);
		map.put("failureCount", failureCount);
		map.put("qualifiedTele", sb);
		
		return map;
	}
	
	 public  boolean isInteger(String number) {
		 Pattern p = Pattern.compile("^[0-9]*$");
		  Matcher m = p.matcher(number);
		  return m.find();
	 }

	@Override
	public List<MessageTelephone> selectTelephoneList(String taskId,
			int states, int row, int start) {
	
		List<Object> args = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		sql.append("select telephone from MessageTelephone where 1=1");
		
		StringBuffer sqlCount = new StringBuffer();

		sql.append(" AND messageTask_taskId = ?");
		args.add(taskId);
		
		sql.append(" AND states = ?");
		args.add(states);

		sql.append(" order by telephoneId desc");
		sql.append(" LIMIT ?,?");
		args.add(start);
		args.add(row);

    	List<MessageTelephone> mtlist = jdbcDaoSupport.findTsBySQL(MessageTelephone.class, sql.toString(),args.toArray());
		return mtlist;
	}

	@Override
	public Member findMemberByPhone(String phone) {
		String hql="from Member where phone=? and status!=3";
		return hbDaoSupport.findTByHQL(hql, phone);
	}

	@Override
	public String saveAndSendMessage(File file, MessageTask mTask,String sendType,ProgressBar progressBar) {
		String encoding = "utf-8"; 
		String telephones="";
		Map map=new HashMap();
		String returnMessage="";
		  int  telephoneCount=0;
		if (file.isFile() && file.exists()) {  
		  try {
		
            InputStreamReader read = new InputStreamReader(  
                    new FileInputStream(file), encoding);  
            InputStreamReader read1 = new InputStreamReader(  
                    new FileInputStream(file), encoding);  
            BufferedReader bufferedReader = new BufferedReader(read);  
            BufferedReader br = new BufferedReader(read1);  
            String lineTXT = null;  
            String line = null;  
          
            while((line=br.readLine())!=null){  
            	telephoneCount++;
            } 
            
            logger.trace(telephoneCount);
            telephoneCount=telephoneCount*3;
            int i=0;
            while ((lineTXT = bufferedReader.readLine()) != null) {  
            	telephones+=lineTXT.toString().trim()+",";
            	progressBar.setValue( (int) (((double) i)
						/ ((double) telephoneCount) * 100));
            	i++;
           }  
       
            map=this.checkTelephone(telephones, null,progressBar,telephoneCount);
             read.close();  
		  } catch (Exception e) {
			  returnMessage="文件上传失败！";
		 }
        }else{  
            returnMessage="找不到指定的文件！";
        }
		MessageTask mt=null; 
		if (mTask!=null) { // insert
			mt=this.add(mTask, map.get("qualifiedTele").toString(),progressBar,telephoneCount);
			int successT=Integer.parseInt(map.get("totle").toString())-Integer.parseInt(map.get("failureCount").toString());
			if(Integer.valueOf(map.get("totle").toString())==successT){
				returnMessage="任务保存成功！&nbsp;&nbsp;&nbsp;&nbsp; <br>\r\n总记录数："+map.get("totle")+"<br>\r\n成功导入数："+successT;
			}else if(map.get("totle").equals(map.get("failureCount"))){
				returnMessage="任务保存失败！&nbsp;&nbsp;&nbsp;&nbsp; <br>\r\n号码总记录数："+map.get("totle")+"<br>\r\n导入失败数："+map.get("failureCount")+"个文件内容不规范" ;
			}else{
				returnMessage="任务保存成功！&nbsp;&nbsp;&nbsp;&nbsp; <br>\r\n号码总记录数："+map.get("totle")+"<br>\r\n成功导入数："+successT+"<br>\r\n导入失败数："+map.get("failureCount")+"个文件内容不规范" ;
			}
			
		}
		//立即发送短信，用线程池的方式
		if(!map.get("totle").equals(map.get("failureCount"))&&"1".equals(sendType)&&mt!=null){
			 this.updateMessageTaskSatats(mt.getTaskId(), Dictionary.TASK_NOTEXECUTE);
			 taskExecutor.execute(new SendMessage(mTask.getContent(),Constants.TASK_PRIORITY,mt.getTaskId(),0,this,communicationservice));  
		}
		
		//定时发送
		if(!map.get("totle").equals(map.get("failureCount"))&&"2".equals(sendType)&&mTask.getPlanSendTime()!=null){
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String time = formatter.format(mTask.getPlanSendTime());
			    CustomJob job = new CustomJob();
			    
			    String[] str=time.split(" ");
			    String[] str1=str[0].split("-");
			    String[] str2=str[1].split(":");
			    String timer=Integer.valueOf(str2[2])+" "+Integer.valueOf(str2[1])+" "+Integer.valueOf(str2[0])+" "+Integer.valueOf(str1[2])+" "+Integer.valueOf(str1[1])+" ? "+Integer.valueOf(str1[0]);
		
				JobDetail jobDetail = new JobDetail();  
	            jobDetail.setName(mt.getTaskId());  
	        	jobDetail.getJobDataMap().put("taskid", mt.getTaskId());
				jobDetail.getJobDataMap().put("content", mTask.getContent());
				jobDetail.getJobDataMap().put("priority", Constants.TASK_PRIORITY);
	        	QuartzSendMessage sendmessage = new QuartzSendMessage(); 
	        	sendmessage.setCommunicationService(communicationservice);
	        	sendmessage.setMessageservice(this);
	        	sendmessage.setTaskExecutor(taskExecutor);
	            jobDetail.getJobDataMap().put("sendmessage", sendmessage);  
	            jobDetail.setJobClass(SendMessageJob.class);  
	            QuartzManager.enableCronSchedule(jobDetail, mt.getTaskId(),timer);
	            this.updateMessageTaskSatats(mt.getTaskId(), Dictionary.TASK_NOTEXECUTE);
		}
		progressBar.setValue(100);
		return returnMessage;
	}
	
}
