package jxt.elt.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ExcelWriter
{
  Workbook wb = null;
  String workspacePath = null;

  public ExcelWriter(String path) {
    try { InputStream inp = new FileInputStream(path + File.separator + "template.xls");
      this.workspacePath = path;
      this.wb = WorkbookFactory.create(inp);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (InvalidFormatException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public ExcelWriter(String path, String templeate) {
    try {
      InputStream inp = new FileInputStream(path + File.separator + templeate);
      this.workspacePath = path;
      this.wb = WorkbookFactory.create(inp);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (InvalidFormatException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public String exportData(ArrayList<String[]> data)
  {
    String fileName = "";
    Sheet sheet = this.wb.getSheetAt(0);
    int rowCounter = 1;

    if (data.size() < 2)
    {
      sheet.removeRow(sheet.getRow(1));
      sheet.removeRow(sheet.getRow(2));
    }

    for (String[] row : data)
    {
      Row row1 = sheet.createRow(rowCounter);

      createCell(row1, 0, row[0]);
      createCell(row1, 1, row[1]);
      createCell(row1, 2, row[2]);
      createCell(row1, 3, row[3]);
      createCell(row1, 4, row[4]);
      createCell(row1, 5, row[5]);
      createCell(row1, 6, row[6]);
      createCell(row1, 7, row[7]);
      rowCounter++;
    }

    try
    {
      File exportBuffPath = new File(this.workspacePath + File.separator + "exportbuffer");
      if (!exportBuffPath.exists()) {
        exportBuffPath.mkdirs();
      }

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmsss");
      Date curDate = new Date(System.currentTimeMillis());

      fileName = "员工信息列表_" + formatter.format(curDate) + ".xls";
      FileOutputStream fileOut = new FileOutputStream(this.workspacePath + File.separator + "exportbuffer" + File.separator + fileName);
      this.wb.write(fileOut);
      fileOut.close();
    }
    catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return fileName;
  }

  public String exportData(ArrayList<String[]> data, String type)
  {
    String fileName = "";
    Sheet sheet = this.wb.getSheetAt(0);
    int rowCounter = 1;

    for (String[] row : data)
    {
      Row row1 = sheet.createRow(rowCounter);
      int rowSize = row.length;
      for (int i = 0; i < rowSize; i++) {
        createCell(row1, i, row[i]);
      }
      rowCounter++;
    }

    try
    {
      File exportBuffPath = new File(this.workspacePath + File.separator + "exportbuffer");
      if (!exportBuffPath.exists()) {
        exportBuffPath.mkdirs();
      }

      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmsss");
      Date curDate = new Date(System.currentTimeMillis());

      if ((null != type) && (type.startsWith("flq")))
        fileName = "发放福利券模板_" + formatter.format(curDate) + ".xls";
      else {
        fileName = "发放积分模板_" + formatter.format(curDate) + ".xls";
      }
      FileOutputStream fileOut = new FileOutputStream(this.workspacePath + File.separator + "exportbuffer" + File.separator + fileName);
      this.wb.write(fileOut);
      fileOut.close();
    }
    catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return fileName;
  }

  public void createCell(Row row, int column, String value)
  {

		Cell cell = row.createCell(column);
		cell.setCellValue(value);
		CellStyle cellStyle = wb.createCellStyle();
		cellStyle.setBorderTop((short)1);
		cellStyle.setBorderLeft((short)1);
		cellStyle.setBorderRight((short)1);
		cellStyle.setBorderBottom((short)1);
		cellStyle.setAlignment((short)2);
		cell.setCellStyle(cellStyle);
  }
}