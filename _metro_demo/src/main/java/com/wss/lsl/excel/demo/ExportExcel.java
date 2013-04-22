package com.wss.lsl.excel.demo;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.SpreadsheetVersion;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

public class ExportExcel {

	public static void createWorkBook(int rowNumbers, SXSSFWorkbook workbook) {

		/**
		 * write to response.getOutputStream()
		 * 
		 */
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String fileName = "联合会员" + dateFormat.format(new Date());

		int maxRowNumber = SpreadsheetVersion.EXCEL97.getLastRowIndex();
		fileName += ".xlsx";

		CellStyle cellStyle = workbook.createCellStyle();
		Font font = workbook.createFont();

		font.setFontName("宋体");
		font.setFontHeightInPoints((short) 12);
		cellStyle.setFont(font);
		int mod = rowNumbers % maxRowNumber;
		int index = rowNumbers / maxRowNumber;
		index = (mod == 0) ? (index)
				: (index + 1);
		long start = System.currentTimeMillis();
		if (index > 0) {
			for (int i = 0; i < index; i++) {
				Sheet sheet = workbook.createSheet("第" + (i + 1) + "页");
				int sheetRows = 0;
				if (i == (index - 1) && mod != 0) {
					sheetRows = mod;
				} else {
					sheetRows = maxRowNumber;
				}
				fillNewSheet(sheet, null, cellStyle, sheetRows);
				System.out.println("i =============> " + i);
			}
		} else {
			Sheet sheet = workbook.createSheet("第" + 1 + "页");
			fillNewSheet(sheet, null, cellStyle, 0);
		}
		// System.out.println("export 131070 recordes took "
		// + ((System.currentTimeMillis() - start) / 1000) + " seconds");

		File dir = new File(System.getProperty("user.dir") + "/export/excel/");
		if (!dir.exists()) {
			dir.mkdirs();
		}
		File file = new File(dir, fileName);
		BufferedOutputStream fos;
		try {
			fos = new BufferedOutputStream(new FileOutputStream(file)
			,1024 * 1024 * 10
					);
			// start = System.currentTimeMillis();
			workbook.write(fos);
			fos.close();
			// System.out.println("write excel times is "
			// + ((System.currentTimeMillis() - start) / 1000)
			// + " seconds");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		long end = System.currentTimeMillis();
		System.out.println("export "+ rowNumbers +" recordes took "
				+ ((end - start) / 1000) + " seconds");
		workbook.dispose();

	}

	private static void fillNewSheet(Sheet sheet, List<Object> list,
			CellStyle cellStyle, int sheetRows) {

		sheet.setColumnWidth(0, 7000);
		sheet.setColumnWidth(1, 7000);
		sheet.setColumnWidth(2, 7000);
		String[] title = new String[] { "会员名称", "会员卡号", "加入时间" };
		Row row = sheet.createRow(0);
		Cell cell;
		for (int i = 0, length = title.length; i < length; i++) {

			cell = row.createCell(i);
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
		}

		// just for test
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		for (int i = 1; i <= sheetRows; i++) {
			row = sheet.createRow(i);

			cell = row.createCell(0);
			cell.setCellValue("中文姓名4434");
			cell.setCellStyle(cellStyle);

			cell = row.createCell(1);
			cell.setCellValue("1235562434341");
			cell.setCellStyle(cellStyle);

			cell = row.createCell(2);
			cell.setCellValue(dateFormat.format(new Date()));
			cell.setCellStyle(cellStyle);

		}
	}

	public static void main(String[] args) {
//		createWorkBook(10000000, new HSSFWorkbook());
		createWorkBook(100000, new SXSSFWorkbook());

	}
}
