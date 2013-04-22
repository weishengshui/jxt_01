package com.chinarewards.metro.control.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.common.ProgressBarMap;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;

@Controller
public class ProgressBarControler {

	@RequestMapping("/getProgress")
	@ResponseBody
	public Integer getProcess(String key) {
		ProgressBar progressBar = ProgressBarMap.get(key);
		if (null == progressBar) {
			return 0;
		}
		return progressBar.getValue();
	}

	@RequestMapping("/removeProgress")
	@ResponseBody
	public AjaxResponseCommonVo removeProcess(String key) {

		ProgressBarMap.remove(key);
		return new AjaxResponseCommonVo("success");
	}
}
