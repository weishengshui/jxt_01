package com.chinarewards.metro.control.system;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.SystemParamsConfig;
import com.chinarewards.metro.domain.system.SYSVariable;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.service.system.ISysLogService;

@Controller
@RequestMapping("/sysparams")
public class SystemParamsControl {
	
	@Autowired
	private ISysLogService sysLogService;
	
	@RequestMapping("/show")
	public String show(Model model) {
		model.addAttribute("systemParamNamesJSON", CommonUtil.toJson(Dictionary.findSystemParamNames()));
		return "sysparams/show";
	}
	
	@RequestMapping("/getAllParams")
	@ResponseBody
	public List<SYSVariable> getAllParams(Model model) {
		return SystemParamsConfig.getAllParams();
	}

	@RequestMapping(value = "/setSystemParam", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponseCommonVo setSystemParam(
			@ModelAttribute SYSVariable sysVariable, Model model) {
		
		SystemParamsConfig.setSYSVariable(sysVariable);
		SystemParamsConfig.refresh(sysVariable.getKey());
		try {
			sysLogService.addSysLog("系统参数维护", sysVariable.getKey(), OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
		}
		return new AjaxResponseCommonVo("保存成功");
	}
	
	@RequestMapping(value = "/refresh", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponseCommonVo refresh(){
		
		SystemParamsConfig.refresh();
		return new AjaxResponseCommonVo("刷新成功");
	}
	
}
