package com.chinarewards.metro.control.message;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.common.ProgressBarMap;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.domain.message.MessageTask;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.service.message.IMessageService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.sms.ICommunicationService;
import com.chinarewards.utils.StringUtil;





@Controller
@RequestMapping("/message")
public class MessageControl {
	
	@Autowired
	private IMessageService messageservice;
	
	@Autowired  
    private TaskExecutor taskExecutor;  
	@Autowired  
	private ICommunicationService communicationservice;
	
	@Autowired
	private ISysLogService sysLogService;
	
	
	@RequestMapping("/add")
	public String add(){
		return "message/add";
	}
	
	@RequestMapping(value = "/addSave")
	@ResponseBody
	public void addSave(@RequestParam("telephoneFile") MultipartFile mFile,String taskName,HttpServletResponse response,String content,String planSendDate,String uuid,String sendType) throws Exception{
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		if("".equals(content)){
			  out.println(CommonUtil.toJson(new AjaxResponseCommonVo("请填写短信内容！")));
			  return;
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	   
		ProgressBar progressBar = new  ProgressBar(uuid, 0);
		ProgressBarMap.put(uuid, progressBar);
		
		MessageTask mTask = new MessageTask();
		try {
			
		
		if(!StringUtil.isEmptyString(taskName)){
			if(!StringUtil.isEmptyString(content)){
				mTask.setTaskName(taskName);
				mTask.setContent(content);
			}
			if (!StringUtil.isEmptyString(planSendDate)){
				
				mTask.setPlanSendTime(formatter.parse(planSendDate));
			}
			if("1".equals(sendType)){
				mTask.setPlanSendTime(null);
				mTask.setActualSendTime(DateTools.dateToHour24());
			}
		}
		String fileName = mFile.getOriginalFilename();
		File file=null;
		if("".equals(fileName)){
			  out.println(CommonUtil.toJson(new AjaxResponseCommonVo("请上传文件！")));
			  return;
		}
		String suffix = getSuffix(fileName);
		fileName = UUIDUtil.generate() + suffix;
		
		FileUtil.saveFile(mFile.getInputStream(), Constants.MESSAGETASK_CSV_DIR, fileName);
		file=new File(Constants.MESSAGETASK_CSV_DIR, fileName); 
		
		String  returnmessage=messageservice.saveAndSendMessage(file,mTask,sendType,progressBar);
		out.println(CommonUtil.toJson(new AjaxResponseCommonVo(returnmessage)));
		sysLogService.addSysLog("任务新增",taskName ,  OperationEvent.EVENT_SAVE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("任务新增",taskName ,  OperationEvent.EVENT_SAVE.getName(), "失败");
		}	
		
		out.flush();
	}
	
	@RequestMapping("/list")
	public String list(Model model)throws Exception{
		model.addAttribute("status", Dictionary.findMessageTaskStatus());
		model.addAttribute("statusJson", CommonUtil.toJson(Dictionary.findMessageTaskStatus()));
		model.addAttribute("test", 1);
		return "message/list";
	}
	
	/**
	 * 获取所有任务
	 * @param messageTask
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/listMessagesTask")
	public Map<String,Object> listMessagesTask(MessageTask messageTask,Page page,Model model)throws Exception{
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", messageservice.listMessagesTask(messageTask, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	/**
	 *  查看任务
	 * @param model
	 * @param taskid
	 * @return
	 */
	@RequestMapping("/viewTask")
	public String viewTask(Model model,String taskid){
		model.addAttribute("task", messageservice.viewMessageTask(taskid));
		model.addAttribute("statusJson", CommonUtil.toJson(Dictionary.findMessageTaskStatus()));
		return "message/viewTask";
	}
	/**
	 * 暂停任务
	 * @param taskId
	 */
	@ResponseBody
	@RequestMapping("/pauseTask")
	public void pauseTask(String taskId){
		MessageTask mt=messageservice.findById(taskId);
		try {
		 messageservice.updateMessageTaskSatats(taskId, Dictionary.TASK_PAUSE);
		 sysLogService.addSysLog("暂停任务",mt.getTaskName() , OperationEvent.EVENT_PAUSE.getName(), "成功");
		} catch (Exception e) {
			 sysLogService.addSysLog("暂停任务",mt.getTaskName() , OperationEvent.EVENT_PAUSE.getName(), "失败");
		}
		
	}
	
	/**
	 * 重启任务，通知发短信
	 * @param taskId
	 */
	@ResponseBody
	@RequestMapping("/restartTask")
	public void restartTask(String taskid){
		 messageservice.updateMessageTaskSatats(taskid, Dictionary.TASK_EXECUTING);
		 MessageTask mTask=messageservice.viewMessageTask(taskid);
		 try {
			 sysLogService.addSysLog("重启任务",mTask.getTaskName() , OperationEvent.EVENT_RESTART.getName(), "成功");
			 taskExecutor.execute(new SendMessage(mTask.getContent(),Constants.TASK_PRIORITY,taskid,0,messageservice,communicationservice));
		 } catch (Exception e) {
			 sysLogService.addSysLog("重启任务",mTask.getTaskName() , OperationEvent.EVENT_RESTART.getName(), "失败");
		}
	}
	
	
	/**
	 * 取消任务
	 * @param taskId
	 */
	@ResponseBody
	@RequestMapping("/cancelTask")
    public void cancelTask(String taskid){
		 MessageTask mt=messageservice.findById(taskid);
		 try {
			 messageservice.updateMessageTaskSatats(taskid, Dictionary.TASK_CANCEL);
			 sysLogService.addSysLog("取消任务",mt.getTaskName() , OperationEvent.EVENT_CANCEL.getName(), "成功");
			} catch (Exception e) {
				 sysLogService.addSysLog("取消任务",mt.getTaskName() , OperationEvent.EVENT_CANCEL.getName(), "失败");
			}
		
    }
	
	
	/**
	 * 删除任务
	 * @param taskId
	 * @throws IOException 
	 */
	@ResponseBody
	@RequestMapping("/deleteTask")
    public void deleteTask(String taskid,HttpServletResponse response) throws IOException{
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		 MessageTask mt=  messageservice.viewMessageTask(taskid);
		 String tn=mt.getTaskName()==null?"":mt.getTaskName();
		try {
			 messageservice.deleteMessageTask(taskid);
			 out.println(CommonUtil.toJson(new AjaxResponseCommonVo(tn)));
			 sysLogService.addSysLog("删除任务",tn ,OperationEvent.EVENT_DELETE.getName(), "成功");
		} catch (Exception e) {
			 out.println(CommonUtil.toJson(new AjaxResponseCommonVo(tn)));
			 sysLogService.addSysLog("删除任务",tn ,OperationEvent.EVENT_DELETE.getName(), "失败");
		}
	
    }

	
	/**
	 * 重置任务，通知发短信
	 * @param taskId
	 */
	@ResponseBody
	@RequestMapping("/resetTask")
	public void resetTask(String taskid){
		 messageservice.updateMessageTaskSatats(taskid, Dictionary.TASK_CRATING);
		 MessageTask mTask=messageservice.viewMessageTask(taskid);
		 try {
			 taskExecutor.execute(new SendMessage(mTask.getContent(),Constants.TASK_PRIORITY,taskid,1,messageservice,communicationservice));
			 sysLogService.addSysLog("重置任务",mTask.getTaskName() , OperationEvent.EVENT_RESET.getName(), "成功");
			} catch (Exception e) {
				 sysLogService.addSysLog("重置任务",mTask.getTaskName() , OperationEvent.EVENT_RESET.getName(), "失败");
			}
			
	}
	@ResponseBody
	@RequestMapping("/failureTel")
	public  Map<String,Object> failureTelephone(String taskid,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", messageservice.listTelephoneByTaskid(taskid, page,2));
		map.put("total", page.getTotalRows());
		return map;
	
	}
	
	
	/**
	 * 根据taskid获取telephone
	 * @param messageTask
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/listTel")
	public Map<String,Object>  listTelephone(String taskid,Page page)throws Exception{
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", messageservice.listTelephoneByTaskid(taskid, page,0));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	
	

	@RequestMapping("/sendFailureTel")
	@ResponseBody
	public void sendFailureTel(HttpSession session,
			HttpServletRequest request, HttpServletResponse response,String taskid) throws IOException{
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		//List<MessageTelephone> alllist=messageservice.selectMTelByTaskidStates(taskid,2);
		MessageTask mt=new MessageTask();
		mt=messageservice.viewMessageTask(taskid);
		 try {
			 messageservice.updateMessageTaskSatats(taskid, Dictionary.TASK_NOTEXECUTE);
			 taskExecutor.execute(new SendMessage(mt.getContent(),Constants.TASK_PRIORITY,taskid,1,messageservice,communicationservice)); 
			 sysLogService.addSysLog("重新发送失败任务",mt.getTaskName() , OperationEvent.EVENT_RESET.getName(), "成功");
			} catch (Exception e) {
				 sysLogService.addSysLog("重新发送失败任务",mt.getTaskName() ,"重新发送", "失败");
			}
			 

		out.println(CommonUtil.toJson(new AjaxResponseCommonVo("正在发送中...")));
		out.flush();
	}
	
	
	private String  getSuffix(String fileName) {
		return fileName.substring(fileName.lastIndexOf("."));
	} 	
}
