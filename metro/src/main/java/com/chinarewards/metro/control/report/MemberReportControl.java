package com.chinarewards.metro.control.report;

import java.io.BufferedOutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.common.ProgressBarMap;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.member.Source;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.member.MemberReport;
import com.chinarewards.metro.service.account.IAccountService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.utils.StringUtil;

@Controller
@RequestMapping("/memberReport")
public class MemberReportControl {

	@Autowired
	private IMemberService memberService;
	@Autowired
	private IAccountService accountService;
	@Autowired
	private ISysLogService sysLogService;
	private Integer getMemberExportSchedule;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping("/member")
	public String memberIndex(Model model) throws Exception {
		model.addAttribute("status", Dictionary.findMemberStatus());
		model.addAttribute("statusJson",
				CommonUtil.toJson(Dictionary.findMemberStatus()));
		model.addAttribute("source",memberService.findSources());
		return "report/memberReport";
	}
	@RequestMapping("/findMembersToReport")
	public Map<String, Object> findMemebers(Member member, Page page,Model model)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rows", memberService.findMembersToReport(member, page));
		map.put("total", page.getTotalRows());
		model.addAttribute("getTotalMemeber",memberService.getCountMembers(member));
		return map;
	}
	
	
	
	/**
	 * 查看页面
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/viewMemberPage")
	public String viewMemberPage(Model model, Integer id) {
		Member m=memberService.findMemberById(id);
		Source source=memberService.findByNum(m.getSource());
		if(source!=null)
		    m.setSource(source.getName());
		BigDecimal orderPriceSum =memberService.getOrderPriceSum( m.getAccount());
		
	
		m.setOrderPriceSum(orderPriceSum);
		model.addAttribute("member", m);
		model.addAttribute("male", Dictionary.MEMBER_SEX_MALE);
		model.addAttribute("female", Dictionary.MEMBER_SEX_FEMALE);
		model.addAttribute("member_state_logout",
				Dictionary.MEMBER_STATE_LOGOUT);
		model.addAttribute("member_state_noactive",
				Dictionary.MEMBER_STATE_NOACTIVATE);
		model.addAttribute("member_state_active",
				Dictionary.MEMBER_STATE_ACTIVATE);
		
		return "report/memberView";
	}
	
	

	@RequestMapping(value = "/exportMemberData")
	public void exportMemberData(HttpServletResponse response,HttpServletRequest request ,@ModelAttribute Member member,String uuid) {
		try {
			int count = memberService.getCountMembers(member);
			ProgressBar progressBar = new  ProgressBar(uuid, 0);
			ProgressBarMap.put(uuid, progressBar);
			SXSSFWorkbook workbook = new SXSSFWorkbook(1); // excel 2007,
			// HSSFWorkbook
			// 在数据量大时会发生内存溢出
			CellStyle cellStyle = workbook.createCellStyle();
			Font font = workbook.createFont();

			font.setFontName("宋体");
			font.setFontHeightInPoints((short) 12);
			cellStyle.setFont(font);
			int maxSheetRows = SpreadsheetVersion.EXCEL97.getLastRowIndex();
			int mod = count % maxSheetRows;
			int index = (mod == 0) ? (count / maxSheetRows)
					: (count / maxSheetRows + 1);

			Page paginationDetail = new Page();
			// 一次从数据库读取 65535 条数据
			paginationDetail.setRows(maxSheetRows - 1);
			member.setPaginationDetail(paginationDetail);
			long d0=System.currentTimeMillis();
			if (index > 0) {
				for (int i = 0; i < index; i++) {
					long d00=System.currentTimeMillis();
					paginationDetail.setPage(i + 1);
					List<MemberReport> list = memberService.getTotleMembers(member);

					Sheet sheet = workbook.createSheet("第" + (i + 1) + "页");
					long d11=System.currentTimeMillis();
					writeExcel(sheet, list, cellStyle);
					long d1111=System.currentTimeMillis();
					logger.trace("第"+i+"次写入==="+(d1111-d11)/1000);
					progressBar.setValue((int)(((double)(i+1))/((double)index)*100));
					long d1=System.currentTimeMillis();
					logger.trace("第"+i+"次===="+(d1-d00)/1000);
				}
			} else {
				Sheet sheet = workbook.createSheet("第" + 1 + "页");
				writeExcel(sheet, null, cellStyle);
				progressBar.setValue(100);
			}
			long d2=System.currentTimeMillis();
			logger.trace("总读取时间==="+(d2-d0)/1000);
			/**
			 * write to response.getOutputStream()
			 * 
			 */
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			String fileName = "会员分析报表"
					+ dateFormat.format(SystemTimeProvider.getCurrentTime())
					+ ".xls";
			/**
			 * write to response.getOutputStream()
			 * 
			 */
			try {
				int count1 = 1;
				String uuid1 = progressBar.getUuid();
				do {
					if (null == ProgressBarMap.get(uuid1)) {
						break;
					} else {
						Thread.sleep(500);
					}
				} while (count1 < 6);
				response.reset();
				response.setHeader("Content-Disposition", "attachment; filename="
						+ new String(fileName.getBytes("gb2312"), "ISO8859-1"));
				response.setContentType("application/octet-stream; charset=UTF-8");
				workbook.write(new BufferedOutputStream(response.getOutputStream(),
						1048576));// 加缓冲，提高IO效率
				response.getOutputStream().flush();
				sysLogService.addSysLog("会员分析报表导出","", OperationEvent.EVENT_EXPORT.getName(), "成功");
			} catch (Exception e) {
			
			} finally {
				workbook.dispose(); 
			}
		} catch (Exception e) {
			sysLogService.addSysLog("会员分析报表导出","", OperationEvent.EVENT_EXPORT.getName(), "失败");
			e.printStackTrace();
		}
	}

	/**
	 * 把数据写入Excel中
	 * 
	 * @param response
	 * @param dataList
	 */
	public void writeExcel(Sheet sheet,List<MemberReport> dataList,
			CellStyle cellStyle) {
		sheet.setColumnWidth(0, 7000);
		sheet.setColumnWidth(1, 7000);
		sheet.setColumnWidth(2, 7000);
		String[] title = new String[] { "会员姓名","手机","E-mail","会员卡号", "详细地址","注册时间", "性别", "出生日期","消费金额","状态","注册渠道" };
		Row row = sheet.createRow(0);
		Cell cell;
		for (int i = 0, length = title.length; i < length; i++) {

			cell = row.createCell(i);
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
		}
     	int count = 1;

			if (dataList != null && dataList.size() > 0) {
				for (MemberReport data : dataList) {
					
					row = sheet.createRow(count); // sheet 创建一行
					
					
					cell = row.createCell(0);
					cell.setCellValue((StringUtil.isEmptyString(data.getSurname())?"":data.getSurname())+(StringUtil.isEmptyString(data.getName())?"":data.getName()));
					cell.setCellStyle(cellStyle);
					
					cell = row.createCell(1);
					cell.setCellValue(data.getPhone());
					cell.setCellStyle(cellStyle);
					
					cell = row.createCell(2);
					cell.setCellValue(data.getEmail());
					cell.setCellStyle(cellStyle);
					
					
					cell = row.createCell(3);
					cell.setCellValue(data.getCardNumber());
					cell.setCellStyle(cellStyle);

					cell = row.createCell(4);
					cell.setCellValue((StringUtil.isEmptyString(data.getProvince())?"":data.getProvince())+(StringUtil.isEmptyString(data.getCity())?"":data.getCity())+(StringUtil.isEmptyString(data.getArea())?"":data.getArea())+(StringUtil.isEmptyString(data.getAddress())?"":data.getAddress()));
					cell.setCellStyle(cellStyle);
					
					cell = row.createCell(5);
					cell.setCellValue(data.getCreateDate()==null?"":DateTools.dateToString(data.getCreateDate()));
					cell.setCellStyle(cellStyle);
					

					cell = row.createCell(6);
					if(data.getSex()==null){
						cell.setCellValue("");
					}else if(data.getSex().equals(1)){
						cell.setCellValue("男");
					}else if(data.getSex().equals(2)){
						cell.setCellValue("女");
					}
					cell.setCellStyle(cellStyle);

					cell = row.createCell(7);
					cell.setCellValue(data.getBirthDay()==null ? "":DateTools.dateToString(data.getBirthDay()));
					cell.setCellStyle(cellStyle);


					cell = row.createCell(8);
					cell.setCellValue(data.getOrderPriceSum()!=null?data.getOrderPriceSum().toString():"");
					cell.setCellStyle(cellStyle);
					
					cell = row.createCell(9);
					if(data.getStatus()==1){
						cell.setCellValue("已激活");
					}else if(data.getStatus()==2){
						cell.setCellValue("未激活");
					}
					cell.setCellStyle(cellStyle);
					
					
					cell = row.createCell(10);
					cell.setCellValue(data.getSource());
					cell.setCellStyle(cellStyle);
					
					++count;
				}
			}

	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
