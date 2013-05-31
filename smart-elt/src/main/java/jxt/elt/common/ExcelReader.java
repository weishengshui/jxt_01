package jxt.elt.common;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ExcelReader {
	Workbook wb = null;
	List<String[]> dataList = new ArrayList<String[]>(100);

	public ExcelReader(String path) {
		try {
			InputStream inp = new FileInputStream(path);
			wb = WorkbookFactory.create(inp);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	/**
	 * 取Excel所有数据，包含header
	 * 
	 * @return List<String[]>
	 */
	public List<String[]> getAllData(int sheetIndex) {
		int columnNum = 0;
		Sheet sheet = this.wb.getSheetAt(sheetIndex);
		if (sheet.getRow(0) != null) {
			columnNum = sheet.getRow(0).getLastCellNum()
					- sheet.getRow(0).getFirstCellNum();
		}

		if (columnNum > 0) {
			for (Row row : sheet) {
				String[] singleRow = new String[columnNum];
				int n = 0;
				for (int i = 0; i < columnNum; i++) {
					Cell cell = row.getCell(i, Row.CREATE_NULL_AS_BLANK);
					switch (cell.getCellType()) {
					case 3:
						singleRow[n] = "";
						break;
					case 4:
						singleRow[n] = Boolean.toString(cell
								.getBooleanCellValue());

						break;
					case 0:
						if (DateUtil.isCellDateFormatted(cell)) {
							singleRow[n] = String.valueOf(cell
									.getDateCellValue());
						} else {
							cell.setCellType(1);
							String temp = cell.getStringCellValue();

							if (temp.indexOf(".") > -1) {
								singleRow[n] = String.valueOf(new Double(temp))
										.trim();
							} else {
								singleRow[n] = temp.trim();
							}
						}
						break;
					case 1:
						singleRow[n] = cell.getStringCellValue().trim();
						break;
					case 5:
						singleRow[n] = "";
						break;
					case 2:
						cell.setCellType(1);
						singleRow[n] = cell.getStringCellValue();
						if (singleRow[n] == null)
							break;
						singleRow[n] = singleRow[n].replaceAll("#N/A", "")
								.trim();
						break;
					default:
						singleRow[n] = "";
					}

					n++;
				}

				if (("".equals(singleRow[1])) && ("".equals(singleRow[2]))
						&& ("".equals(singleRow[5]))) {
					continue;
				}
				this.dataList.add(singleRow);
			}
		}
		return this.dataList;
	}

	public List<String[]> getAllDataFromfftemplate(int sheetIndex) {
		List dataList = new ArrayList();
		int columnNum = 0;
		Sheet sheet = this.wb.getSheetAt(sheetIndex);
		if (sheet.getRow(0) != null) {
			columnNum = sheet.getRow(0).getLastCellNum()
					- sheet.getRow(0).getFirstCellNum();
		}

		if (columnNum > 0) {
			for (Row row : sheet) {
				String[] singleRow = new String[columnNum];
				int n = 0;
				for (int i = 0; i < columnNum; i++) {
					Cell cell = row.getCell(i, Row.CREATE_NULL_AS_BLANK);
					switch (cell.getCellType()) {
					case 3:
						singleRow[n] = "";
						break;
					case 4:
						singleRow[n] = Boolean.toString(cell
								.getBooleanCellValue());

						break;
					case 0:
						if (DateUtil.isCellDateFormatted(cell)) {
							singleRow[n] = String.valueOf(cell
									.getDateCellValue());
						} else {
							cell.setCellType(1);
							String temp = cell.getStringCellValue();

							if (temp.indexOf(".") > -1) {
								singleRow[n] = String.valueOf(new Double(temp))
										.trim();
							} else {
								singleRow[n] = temp.trim();
							}
						}
						break;
					case 1:
						singleRow[n] = cell.getStringCellValue().trim();
						break;
					case 5:
						singleRow[n] = "";
						break;
					case 2:
						cell.setCellType(1);
						singleRow[n] = cell.getStringCellValue();
						if (singleRow[n] == null)
							break;
						singleRow[n] = singleRow[n].replaceAll("#N/A", "")
								.trim();
						break;
					default:
						singleRow[n] = "";
					}

					n++;
				}

				if (columnNum == 5) {
					if ("".equals(singleRow[4])) {
						continue;
					}
					dataList.add(singleRow);
				}

				if (columnNum == 6) {
					if ("".equals(singleRow[4])) {
						continue;
					}
					dataList.add(singleRow);
				}
			}
		}
		return dataList;
	}

	public int getRowNum(int sheetIndex) {
		Sheet sheet = this.wb.getSheetAt(sheetIndex);
		return sheet.getLastRowNum();
	}

	public int getColumnNum(int sheetIndex) {
		Sheet sheet = this.wb.getSheetAt(sheetIndex);
		Row row = sheet.getRow(0);
		if ((row != null) && (row.getLastCellNum() > 0)) {
			return row.getLastCellNum();
		}
		return 0;
	}

	public String[] getRowData(int sheetIndex, int rowIndex) {
		String[] dataArray = null;
		if (rowIndex > getColumnNum(sheetIndex)) {
			return dataArray;
		}
		dataArray = new String[getColumnNum(sheetIndex)];
		return (String[]) this.dataList.get(rowIndex);
	}

	public String[] getColumnData(int sheetIndex, int colIndex) {
		String[] dataArray = null;
		if (colIndex > getColumnNum(sheetIndex))
			return dataArray;
		int index;
		if ((this.dataList != null) && (this.dataList.size() > 0)) {
			dataArray = new String[getRowNum(sheetIndex) + 1];
			index = 0;
			for (String[] rowData : this.dataList) {
				if (rowData != null) {
					dataArray[index] = rowData[colIndex];
					index++;
				}
			}
		}

		return dataArray;
	}
}