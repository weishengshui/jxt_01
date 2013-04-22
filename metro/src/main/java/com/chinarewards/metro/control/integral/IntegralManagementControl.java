package com.chinarewards.metro.control.integral;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.account.Unit;
import com.chinarewards.metro.domain.account.UnitLedger;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.model.integral.IntegralCriteria;
import com.chinarewards.metro.service.account.ITransactionService;
import com.chinarewards.metro.service.integralManagement.IIntegralManagementService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.validator.integral.CreateUnitValidator;
import com.chinarewards.metro.vo.integral.ExpiryBalanceUnits;
import com.chinarewards.metro.vo.integral.GroupExpiryBalanceUnits;

/**
 * 积分管理control
 * 
 * @author weishengshui
 * 
 */
@Controller
@RequestMapping("/integralManagement")
public class IntegralManagementControl {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private IIntegralManagementService integralManagementService;

	@Autowired
	ITransactionService transactionService;
	@Autowired
	private ISysLogService sysLogService;

	/**
	 * 积分基本信息维护页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping("/show")
	public String showUnit(Model model) {

		Unit unit = integralManagementService
				.findUnitById(Dictionary.INTEGRAL_BINKE_ID);
		model.addAttribute("unit", unit);

		return "integralManagement/show";
	}

	@RequestMapping("/create")
	@ResponseBody
	public void createOrupdateUnit(HttpServletResponse response,
			@ModelAttribute Unit unit, BindingResult result, Model model)
			throws IOException {

		PrintWriter out = null;
		response.setContentType("text/html; charset=utf-8");
		out = response.getWriter();

		new CreateUnitValidator().validate(unit, result);
		if (result.hasErrors()) {
			out.println(CommonUtil.toJson(new AjaxResponseCommonVo(result
					.getAllErrors().get(0).getDefaultMessage())));
			out.flush();
			return;
		}
		if (null == unit.getUnitId() || unit.getUnitId().isEmpty()) {
			integralManagementService.createBinkeUnit(unit);
			try {
				sysLogService.addSysLog("积分基本信息维护", "积分信息",
						OperationEvent.EVENT_SAVE.getName(), "成功");
			} catch (Exception e) {
			}
		} else {
			integralManagementService.updateUnit(unit);
			try {
				sysLogService.addSysLog("积分基本信息维护", "积分信息",
						OperationEvent.EVENT_UPDATE.getName(), "成功");
			} catch (Exception e) {
			}
		}
		AjaxResponseCommonVo ajaxResponseCommonVo = new AjaxResponseCommonVo(
				"保存成功");
		ajaxResponseCommonVo.setId(unit.getUnitId());
		out.println(CommonUtil.toJson(ajaxResponseCommonVo));
		out.flush();
	}

	/**
	 * 积分信息历史页面
	 * 
	 * @return
	 */
	@RequestMapping("/unitLedger")
	public String listUnitLedger(@ModelAttribute IntegralCriteria criteria,
			Integer page, Integer rows, Model model) {

		logger.debug(
				"Entry list IntegralManagementControl controller,That page is:{} criteria name is: {}",
				new Object[] { page, criteria.getOperationPeople() });

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);

		criteria.setPaginationDetail(paginationDetail);

		List<UnitLedger> unitLedgers = integralManagementService
				.searchUnitLedgers(criteria);
		Long count = integralManagementService.countUnitLedgers(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);

		model.addAttribute("rows", unitLedgers);
		return "integralManagement/unitLedger";
	}

	/**
	 * 统计积分(积分失效操作前)
	 * 
	 * @return
	 */
	@RequestMapping("/list")
	public String listBalanceUnits(Date from, Date to, Integer page,
			Integer rows, Model model) {

		logger.debug(
				"Entry listBalanceUnits IntegralManagementControl controller,That page is:{} rows is: {}",
				new Object[] { page, rows });

		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;

		Page paginationDetail = new Page();
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);

		Calendar calendar = Calendar.getInstance();
		if (from != null) {
			calendar.setTime(from);
			calendar.set(Calendar.HOUR, 00);
			calendar.set(Calendar.MINUTE, 00);
			calendar.set(Calendar.SECOND, 00);
			calendar.set(Calendar.MILLISECOND, 00);
			from = calendar.getTime();
		}
		if (to != null) {
			calendar.setTime(to);
			calendar.set(Calendar.HOUR, 00);
			calendar.set(Calendar.MINUTE, 00);
			calendar.set(Calendar.SECOND, 00);
			calendar.set(Calendar.MILLISECOND, 00);
			calendar.add(Calendar.DAY_OF_MONTH, 1);
			to = calendar.getTime();
		}

		List<ExpiryBalanceUnits> list = integralManagementService
				.getAccountBlanceUnits(from, to, paginationDetail);

		long countAccounts = integralManagementService.countAccounts(from, to);
		Double amountPoints = integralManagementService.amountPoints(from, to);

		model.addAttribute("countAccount", countAccounts);
		model.addAttribute("amountPoints", amountPoints);

		model.addAttribute("total", paginationDetail.getTotalRows());
		model.addAttribute("page", page);
		model.addAttribute("rows", list);

		return "integralManagement/list";
	}

	/**
	 * 失效积分操作
	 * 
	 * @return
	 */
	@RequestMapping("/expiry")
	public void expiryBalanceUnits(HttpServletResponse response, Date from,
			Date to, Model model) {

		logger.debug("Entry expiryBalanceUnits IntegralManagementControl controller!");

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out;
		try {
			out = response.getWriter();

			Calendar calendar = Calendar.getInstance();
			if (from != null) {
				calendar.setTime(from);
				calendar.set(Calendar.HOUR, 00);
				calendar.set(Calendar.MINUTE, 00);
				calendar.set(Calendar.SECOND, 00);
				calendar.set(Calendar.MILLISECOND, 00);
				from = calendar.getTime();
			} else {
				out.println(CommonUtil.toJson(new AjaxResponseCommonVo(
						"开始时间不能为空!")));
			}
			if (to != null) {
				calendar.setTime(to);
				calendar.set(Calendar.HOUR, 00);
				calendar.set(Calendar.MINUTE, 00);
				calendar.set(Calendar.SECOND, 00);
				calendar.set(Calendar.MILLISECOND, 00);
				calendar.add(Calendar.DAY_OF_MONTH, 1);
				to = calendar.getTime();
			} else {
				out.println(CommonUtil.toJson(new AjaxResponseCommonVo(
						"截止时间不能为空!")));
			}
			if (null != from && to != null) {
				Transaction tx = transactionService.expiryMemberPoints(
						String.valueOf(UserContext.getUserId()), from, to);

				if (tx != null) {
					out.println(CommonUtil.toJson(new AjaxResponseCommonVo(
							"操作成功,交易号为：" + tx.getTxId()))); // tx.getTxId()
				} else {
					out.println(CommonUtil.toJson(new AjaxResponseCommonVo(
							"指定条件内没有积分可以失效")));
				}
			}
			out.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 统计失效积分交易
	 * 
	 * @return
	 */
	@RequestMapping("/expired_list")
	public String listGroupBalanceUnits(String opt, Date from, Date to,
			Integer page, Integer rows, Model model) {
		try {
			logger.debug(
					"Entry listGroupBalanceUnits IntegralManagementControl controller,That page is:{} rows is: {}",
					new Object[] { page, rows });

			rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
			page = page == null ? 1 : page;

			Page paginationDetail = new Page();
			paginationDetail.setPage(page);
			paginationDetail.setRows(rows);

			Calendar calendar = Calendar.getInstance();
			if (from != null) {
				calendar.setTime(from);
				calendar.set(Calendar.HOUR, 00);
				calendar.set(Calendar.MINUTE, 00);
				calendar.set(Calendar.SECOND, 00);
				calendar.set(Calendar.MILLISECOND, 00);
				from = calendar.getTime();
			}
			if (to != null) {
				calendar.setTime(to);
				calendar.set(Calendar.HOUR, 00);
				calendar.set(Calendar.MINUTE, 00);
				calendar.set(Calendar.SECOND, 00);
				calendar.set(Calendar.MILLISECOND, 00);
				calendar.add(Calendar.DAY_OF_MONTH, 1);
				to = calendar.getTime();
			}

			List<GroupExpiryBalanceUnits> list = integralManagementService
					.getExpiryHistory(opt, from, to, paginationDetail);

			model.addAttribute("total", paginationDetail.getTotalRows());
			model.addAttribute("page", page);
			model.addAttribute("rows", list);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "integralManagement/expiredList";
	}

	/**
	 * 统计失效积分交易
	 * 
	 * @return
	 */
	@RequestMapping(value = "/expired_details", method = RequestMethod.POST)
	public String doSearchExpiryDetail(String transactionNo, Integer page,
			Integer rows, Model model) {
		try {
			logger.debug(
					"Entry expiryDetail IntegralManagementControl controller,That page is:{} rows is: {}",
					new Object[] { page, rows });
			rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
			page = page == null ? 1 : page;

			Page paginationDetail = new Page();
			paginationDetail.setPage(page);
			paginationDetail.setRows(rows);

			List<ExpiryBalanceUnits> list = integralManagementService
					.getExpiedDetailHistory(transactionNo, paginationDetail);

			model.addAttribute("total", paginationDetail.getTotalRows());
			model.addAttribute("page", page);
			model.addAttribute("rows", list);
			return "integralManagement/expiredDetails";
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 统计失效积分交易
	 * 
	 * @return
	 */
	@RequestMapping(value = "/expired_detail", method = RequestMethod.GET)
	public String expiryDetail(String transactionNo, Integer page,
			Integer rows, Model model) {
		model.addAttribute("transactionNo", transactionNo);
		return "integralManagement/expiredDetails";
	}
}
