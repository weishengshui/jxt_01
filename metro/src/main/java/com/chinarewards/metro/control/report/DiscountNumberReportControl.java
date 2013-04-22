package com.chinarewards.metro.control.report;

import java.io.BufferedOutputStream;
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
import com.chinarewards.metro.domain.shop.DiscountNumberHistory;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.discount.DiscountNumberReport;
import com.chinarewards.metro.service.discount.IDiscountService;
import com.chinarewards.metro.service.system.ISysLogService;

@Controller
@RequestMapping("/discountNumberReport")
public class DiscountNumberReportControl {

	@Autowired
	private IDiscountService discountService;
	@Autowired
	private ISysLogService sysLogService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping("/discountNumber")
	public String memberIndex(Model model) throws Exception {
		model.addAttribute("status", Dictionary.findMemberDiscountNumberSatuses());
		model.addAttribute("statusJson",
				CommonUtil.toJson(Dictionary.findMemberDiscountNumberSatuses()));
		return "report/discountNumberReport";
	}
	@RequestMapping("/findDiscountNumberToReport")
	public Map<String, Object> findDiscountNumberToReport(DiscountNumberHistory ds, Page page,Model model)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rows", discountService.findDiscountToReport(ds, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	

	@RequestMapping(value = "/exportDiscountData")
	public void exportDiscountData(HttpServletResponse response,HttpServletRequest request ,@ModelAttribute DiscountNumberHistory discount,String uuid) {
		try {
			ProgressBar progressBar = new  ProgressBar(uuid, 0);
			ProgressBarMap.put(uuid, progressBar);
			int count = discountService.getCountDiscount(discount);
				
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
			discount.setPaginationDetail(paginationDetail);
			long d0=System.currentTimeMillis();
			if (index > 0) {
			
				for (int i = 0; i < index; i++) {
					paginationDetail.setPage(i + 1);
					
					long d1=System.currentTimeMillis();
					List<DiscountNumberReport> list = discountService.getDiscountReport(discount);
					long d2=System.currentTimeMillis();
					logger.trace("第"+i+"次读用时间======"+(d2-d1)/1000);
					Sheet sheet = workbook.createSheet("第" + (i + 1) + "页");
					
					writeExcel(sheet, list, cellStyle);
			
					list=null;
					progressBar.setValue( (int)(((double)(i+1))/((double)index)*100));
				}
			} else {
				Sheet sheet = workbook.createSheet("第" + 1 + "页");
				writeExcel(sheet, null, cellStyle);
				progressBar.setValue(  100);
			}
			long d00=System.currentTimeMillis();
			logger.trace("读总共时间====="+(d00-d0)/1000);
			/**
			 * write to response.getOutputStream()
			 * 
			 */
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			String fileName = "优惠码报表"
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
				sysLogService.addSysLog("优惠码报表导出","", OperationEvent.EVENT_EXPORT.getName(), "成功");
			} catch (Exception e) {
			
			} finally {
				workbook.dispose(); 
			}
		} catch (Exception e) {
			sysLogService.addSysLog("优惠码报表导出","", OperationEvent.EVENT_EXPORT.getName(), "失败");
		}
			
		
	}

	/**
	 * 把数据写入Excel中
	 * 
	 * @param response
	 * @param dataList
	 */
	public void writeExcel(Sheet sheet,List<DiscountNumberReport> dataList,
			CellStyle cellStyle)  {
		int count = 1;
		sheet.setColumnWidth(0, 7000);
		sheet.setColumnWidth(1, 7000);
		sheet.setColumnWidth(2, 7000);
		String[] title = new String[] { "姓名","会员卡号",  "交易编号", "交易时间","优惠码","优惠内容","名称","状态" };
		Row row = sheet.createRow(0);
		Cell cell;
		for (int i = 0, length = title.length; i < length; i++) {

			cell = row.createCell(i);
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
		}
			if (dataList != null && dataList.size() > 0) {
				for (DiscountNumberReport data : dataList) {
					row = sheet.createRow(count); // sheet 创建一行
					cell = row.createCell(0);
					cell.setCellValue(data.getMemberName()!=null?data.getMemberName():"");
					cell.setCellStyle(cellStyle);

					cell = row.createCell(1);
					cell.setCellValue(data.getMemberCard()!=null?data.getMemberCard():"");
					cell.setCellStyle(cellStyle);

					cell = row.createCell(2);
					cell.setCellValue(data.getTransactionNO()!=null?data.getTransactionNO():"");
					cell.setCellStyle(cellStyle);

					cell = row.createCell(3);
					cell.setCellValue(data.getUsedDate()==null?"":DateTools.dateToStringDm(data.getUsedDate()));
					cell.setCellStyle(cellStyle);

					cell = row.createCell(4);
					cell.setCellValue(data.getDiscountNum()!=null?data.getDiscountNum():"");
					cell.setCellStyle(cellStyle);

					cell = row.createCell(5);
					cell.setCellValue(data.getDescription()!=null?data.getDescription():"");
					cell.setCellStyle(cellStyle);

					cell = row.createCell(6);
					cell.setCellValue(data.getShopActivityName()!=null?data.getShopActivityName():"");
					cell.setCellStyle(cellStyle);
					
					cell = row.createCell(7);
					if(data.getStatus()==0){
					    cell.setCellValue("未使用");
					}else if(data.getStatus()==1){
						cell.setCellValue("已使用");
					}else if(data.getStatus()==2){
						cell.setCellValue("已过期");
					}
					cell.setCellStyle(cellStyle);
					++count;
				}
			}

	}
}
