package com.wss.lsl.springmvc_demo.home.control;

import java.util.Comparator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.wss.lsl.springmvc_demo.home.form.LoginForm;

@Controller
public class HomeController {
	
	@Autowired
	private Comparator<String> comparator;
	
	private Logger logger = LoggerFactory.getLogger(getClass()); 
	
	@RequestMapping("/")
	public String home(Model model, LoginForm loginForm) {
		if(logger.isInfoEnabled()){
			System.out.println("logger.isInfoEnabled");
		}
		logger.info("entrance home");
		logger.debug("ssssssssssssss debug");
		model.addAttribute("username", loginForm.getUsername());
		return "home";
	}

	@RequestMapping(value = "/compare", method = RequestMethod.GET)
	public String compare(String p1, String p2, Model model) {
		logger.info("entrance compare");
		int result = comparator.compare(p1, p2);
		String isEnglish = (result < 0)?"less than ":(result > 0?"greater than":"equal to");
		String output = "According to our Comparator, '"+p1 +"' is "+isEnglish+ " '"+p2+"'";
		model.addAttribute("output", output);
		
		return "compare";
	}
}
