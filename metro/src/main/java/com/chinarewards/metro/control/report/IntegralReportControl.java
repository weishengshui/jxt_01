package com.chinarewards.metro.control.report;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.SpreadsheetVersion;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.common.ProgressBarMap;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.integral.IntegralQueryConditionVo;
import com.chinarewards.metro.model.integral.IntegralReport;
import com.chinarewards.metro.service.integral.IRuleService;
import com.chinarewards.metro.service.system.ISysLogService;

@Controller
public class IntegralReportControl {

	@Autowired
	private IRuleService ruleService;

	@Autowired
	private ISysLogService sysLogService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping("/integralReport/integralList")
	public String integralIndex(Model model) {
		return "report/integralList";
	}
	
	/**
	 * 分页查询积分信息
	 */
	@RequestMapping(value = "/integralReport/queryIntegralList")
	public String queryIntegralList(Integer page, Integer rows,
			IntegralQueryConditionVo condition, Model model, String type,
			String status, String startDate, String endDate, String origin,
			String memName, String memberCard) {
		
		condition = new IntegralQueryConditionVo();
		if(!StringUtils.isEmpty(endDate)){
			condition.setEndDate(endDate);
		}
		
		if(!StringUtils.isEmpty(type)){
			condition.setIntegralType(Integer.valueOf(type));
		}
		
		if(!StringUtils.isEmpty(status)){
			condition.setStatus(status);
		}
		
		if(!StringUtils.isEmpty(startDate)){
			condition.setStartDate(startDate);
		}
		
		if(!StringUtils.isEmpty(origin)){
			condition.setOrigin(origin);
		}
		
		if(!StringUtils.isEmpty(memName)){
			condition.setMemName(memName);
		}
		
		if(!StringUtils.isEmpty(memberCard)){
			condition.setMemberCard(memberCard);
		}

		try {
			Page paginationDetail = new Page();
			rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
			page = page == null ? 1 : page;
			logger.trace("page : " + page + "   rows : " + rows);
			paginationDetail.setPage(page);
			paginationDetail.setRows(rows);
			long onceTime = System.currentTimeMillis();
			List<IntegralReport> list = ruleService.getIntegralReport(
					condition, paginationDetail);

			model.addAttribute("rows", list);
			model.addAttribute("total",
					ruleService.countIntegralReport(condition));
			model.addAttribute("page", page);

			Map<String, Object> totalIntegralMap = ruleService
					.sumIntegralPoint(condition);
			long obtain = (totalIntegralMap.get("obtain") != null) ? ((BigDecimal) totalIntegralMap
					.get("obtain")).longValue() : 0l;
			model.addAttribute("getTotalIntegral", obtain);
			long consume = (totalIntegralMap.get("consume") != null) ? ((BigDecimal) totalIntegralMap
					.get("consume")).longValue() : 0l;
			model.addAttribute("useTotalIntegral", consume);
			logger.trace(" ********************************====> "
					+ ((System.currentTimeMillis() - onceTime) / 1000)
					+ " seconds");
			return "report/integralList";
		} catch (Exception e) {
			e.printStackTrace();
			return "report/integralList";
		}
	}

	@RequestMapping(value = "/integralReport/exportIntegralData")
	public void exportIntegralData(HttpServletResponse response,
			HttpServletRequest request,String uuid) {

		IntegralQueryConditionVo condition = new IntegralQueryConditionVo();
		condition.setType(request.getParameter("type"));
		condition.setStatus(request.getParameter("status"));
		condition.setStartDate(request.getParameter("startDate"));
		condition.setEndDate(request.getParameter("endDate"));
		condition.setOrigin(request.getParameter("origin"));
		condition.setMemName(request.getParameter("memName"));
		condition.setMemberCard(request.getParameter("memberCard"));
		ProgressBar progressBar = new ProgressBar(uuid,0);
		ProgressBarMap.put(uuid, progressBar);
		try {
			long onceTime = System.currentTimeMillis();
			writeExcel(response, condition,progressBar);
			logger.trace("====> "
					+ ((System.currentTimeMillis() - onceTime) / 1000)
					+ " seconds");
			sysLogService.addSysLog("积分分析报表", "",
					OperationEvent.EVENT_EXPORT.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("积分分析报表", "",
					OperationEvent.EVENT_EXPORT.getName(), "失败");
			e.printStackTrace();
		}
	}

	/**
	 * 把数据写入Excel中
	 * 
	 * @param response
	 * @param dataList
	 */
	public void writeExcel(HttpServletResponse response,
			IntegralQueryConditionVo condition,ProgressBar progressBar) {
		int count = 1;
		OutputStream out = null;
		FileOutputStream fileOut = null;
		SXSSFWorkbook workbook = new SXSSFWorkbook(1);
		File file = new File("积分分析报表.xls");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		try {
			out = response.getOutputStream();
			fileOut = new FileOutputStream(file);
			CellStyle cellStyle = workbook.createCellStyle();
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			Font font = workbook.createFont();
			font.setFontName("宋体");
			font.setFontHeightInPoints((short) 12);
			cellStyle.setFont(font);

			// List<IntegralReport> list_ =
			// ruleService.getIntegralReportData(condition);
			// List<IntegralReport> list_ =
			// ruleService.getIntegralReport(condition, null);
			long time = System.currentTimeMillis();
			int num = Integer.valueOf(ruleService
					.countIntegralReport(condition).toString());
			logger.trace("查询总记录数耗时    ====> "
							+ ((System.currentTimeMillis() - time) / 1000)
							+ " seconds");
			// int num = list_ != null ? list_.size() : 0 ;
			int maxSheetRows = SpreadsheetVersion.EXCEL97.getLastRowIndex();
			int mod = num % maxSheetRows;
			int index = (mod == 0) ? (num / maxSheetRows)
					: (num / maxSheetRows + 1);

			Page paginationDetail = new Page();
			// 一次从数据库读取 65535 条数据
			paginationDetail.setRows(maxSheetRows);
			long oTime = System.currentTimeMillis();
			if (index > 0) {
				for (int i = 0; i < index; i++) {
					paginationDetail.setPage(i + 1);
					// List<IntegralReport> list =
					// ruleService.queryIntegralReportData(condition,
					// paginationDetail);
					List<IntegralReport> list = ruleService.getIntegralReport(
							condition, paginationDetail);
					Sheet sheet = workbook.createSheet("第" + (i + 1) + "页");
					createNewSheet(count, dateFormat, cellStyle, sheet, list);
					progressBar.setValue( (int) (((double) (i+1))
							/ ((double) index) * 100));// 准备数据进度
				}
			} else {
				Sheet sheet = workbook.createSheet("第" + 1 + "页");
				createNewSheet(count, dateFormat, cellStyle, sheet, null);
				progressBar.setValue(100);
			}
			logger.trace("查询数据和写入excel耗时    ====> "
					+ ((System.currentTimeMillis() - oTime) / 1000)
					+ " seconds");

			if (workbook != null) {
				int c = 1;
				String uuid = progressBar.getUuid();
				do {
					if (null == ProgressBarMap.get(uuid)) {
						break;
					} else {
						try {
							Thread.sleep(500);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				} while (c < 6);
				response.reset();
				response.setContentType("application/octet-stream; charset=UTF-8");
				response.setHeader(
						"Content-Disposition",
						"attachment; filename="
								+ new String("积分分析报表.xls".getBytes("gb2312"),
										"ISO8859-1"));
				long onceTime = System.currentTimeMillis();
				workbook.write(new BufferedOutputStream(out, 1048576));// 加缓冲，提高IO效率
				logger.trace("IO 输出耗时    ====> "
						+ ((System.currentTimeMillis() - onceTime) / 1000)
						+ " seconds");
				out.flush();
			}

		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (fileOut != null) {
					fileOut.flush();
					fileOut.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	private void createNewSheet(int count, SimpleDateFormat dateFormat,
			CellStyle cellStyle, Sheet sheet, List<IntegralReport> list) {
		Cell cell;
		String[] title = new String[] { "会员名称", "会员标识", "类型", " 获取积分数",
				"使用积分数", "来源 ", "积分状态", "交易时间" };
		Row row = sheet.createRow(0);
		for (int j = 0; j < title.length; j++) {
			sheet.setColumnWidth(j, 7000);
			cell = row.createCell(j); // 行创建一个单元格
			cell.setCellValue(title[j]); // 设定单元格的值
			cell.setCellStyle(cellStyle);
		}

		if (list != null && list.size() > 0) {
			for (IntegralReport data : list) {
				row = sheet.createRow(count); // sheet 创建一行
				cell = row.createCell(0);
				cell.setCellValue(data.getMemName());
				cell.setCellStyle(cellStyle);

				cell = row.createCell(1);
				cell.setCellValue(data.getMemberCard());
				cell.setCellStyle(cellStyle);

				String type = data.getType();
				String reType = reverserString(type);
				cell = row.createCell(2);
				cell.setCellValue(reType);
				cell.setCellStyle(cellStyle);

				cell = row.createCell(3);
				cell.setCellValue(data.getIntegralCount());
				cell.setCellStyle(cellStyle);

				cell = row.createCell(4);
				cell.setCellValue(data.getUsedIntegral());
				cell.setCellStyle(cellStyle);

				String origin = data.getOrderSource();
				cell = row.createCell(5);
				cell.setCellValue(origin);
				cell.setCellStyle(cellStyle);

				String status = data.getStatus();
				String reStatus = reverserString(status);
				cell = row.createCell(6);
				cell.setCellValue(reStatus);
				cell.setCellStyle(cellStyle);

				cell = row.createCell(7);
				cell.setCellValue(data.getExchangeHour() != null ? dateFormat
						.format(data.getExchangeHour()) : "");
				cell.setCellStyle(cellStyle);
				++count;
			}
		}
	}

	private String reverserString(String value) {
		if (value == null) {
			return value;
		}
		if (value.equals("POS_SALES")) {
			return "POS机端获取积分";
		} else if (value.equals("EXT_ORDER")) {
			return "外部订单";
		} else if (value.equals("POS_REDEMPTION")) {
			return "POS机端消费积分";
		} else if (value.equals("EXPIRY_POINT")) {
			return "过期积分";
		} else if (value.equals("HAND_POINT")) {
			return "手动添加积分";
		} else if (value.equals("HAND_MONEY")) {
			return "手动处理卡充值";
		} else if (value.equals("EXTERNAL_POINT")) {
			return "外部接口注册时送的积分";
		} else if (value.equals("SAVING_ACCOUNT_CONSUMPTION")) {
			return "储值卡消费接口扣除金额";
		} else if (value.equals("EXT_REDEMPTION")) {
			return "外部兑换订单";
		} else if (value.equals("FROZEN")) {
			return "冻结";
		} else if (value.equals("COMPLETED")) {
			return "到账";
		} else{
			return value;
		}
	}
}
