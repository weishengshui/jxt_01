package com.chinarewards.metro.service.brand;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Transient;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.ProgressBar;
import com.chinarewards.metro.core.common.ProgressBarMap;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.brand.Brand;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.brand.BrandCriteria;
import com.chinarewards.metro.model.brand.BrandUnionMemberCriteria;
import com.chinarewards.metro.model.brand.UnionMemberVo;
import com.chinarewards.metro.service.system.ISysLogService;

/**
 * 
 * @author weishengshui
 * 
 */

@Service
public class BrandService implements IBrandService, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7608804600487371649L;

	@Autowired
	private HBDaoSupport hbDaoSupport;
	
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	
	@Autowired
	private ISysLogService sysLogService;

	Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public Brand createBrand(Brand brand) {

		brand.setCreatedAt(SystemTimeProvider.getCurrentTime());
		brand.setCreatedBy(UserContext.getUserId());
		brand.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		brand.setLastModifiedBy(UserContext.getUserId());

		hbDaoSupport.save(brand);
		return brand;
	}

	@Override
	public Brand updateBrand(Brand brand) {

		Brand brandFromDb = hbDaoSupport.findTById(Brand.class, brand.getId());
		if(null != brandFromDb){
			brandFromDb.setCompanyName(brand.getCompanyName());
			brandFromDb.setCompanyWebSite(brand.getCompanyWebSite());
			brandFromDb.setContact(brand.getContact());
			brandFromDb.setDescription(brand.getDescription());
			brandFromDb.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
			brandFromDb.setLastModifiedBy(UserContext.getUserId());
			brandFromDb.setName(brand.getName());
			brandFromDb.setPhoneNumber(brand.getPhoneNumber());
			brandFromDb.setUnionInvited(brand.getUnionInvited());
			hbDaoSupport.update(brandFromDb);
		}

		return brandFromDb;
	}

	@Override
	public List<Brand> searchBrands(BrandCriteria brandCriteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchBrandsHQL(brandCriteria, params, false);
		List<Brand> list = hbDaoSupport.executeQuery(hql, params,
				brandCriteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countBrands(BrandCriteria brandCriteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchBrandsHQL(brandCriteria, params, true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchBrandsHQL(BrandCriteria brandCriteria,
			Map<String, Object> params, boolean isCount) {

		StringBuffer strBuffer = new StringBuffer();
		if (isCount) {
			strBuffer.append("SELECT COUNT(b) ");
		} else {
			strBuffer.append("SELECT b ");
		}

		strBuffer.append("FROM Brand b WHERE 1=1 "); // 很奇妙

		if (brandCriteria != null) {
			String name = brandCriteria.getName();
			String companyName = brandCriteria.getCompanyName();
			Date start = brandCriteria.getCreateStart();
			Date end = brandCriteria.getCreateEnd();
			if (null != end) {
				SimpleDateFormat dateFormat = new SimpleDateFormat(
						"yyyy-MM-dd HH:mm:ss");
				String str = dateFormat.format(end);
				str = str.substring(0, 10) + " 23:59:59";
				try {
					end = dateFormat.parse(str);
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			String unionInvited = brandCriteria.getUnionInvited();

			if (null != name && !name.isEmpty()) {
				strBuffer.append(" AND b.name like :name");
				params.put("name", "%" + name + "%");
			}
			if (null != companyName && !companyName.isEmpty()) {
				strBuffer.append(" AND b.companyName like :companyName");
				params.put("companyName", "%" + companyName + "%");
			}
			if (null != start) {
				strBuffer.append(" AND b.createdAt >= :start");
				params.put("start", start);
			}
			if (null != end) {
				strBuffer.append(" AND b.createdAt <= :end");
				params.put("end", end);
			}
			if (null != unionInvited && !unionInvited.isEmpty()) {
				if (unionInvited.equals("ON")) {
					strBuffer.append(" AND b.unionInvited = :unionInvited");
					params.put("unionInvited", true);
				} else if (unionInvited.equals("OFF")) {
					strBuffer.append(" AND b.unionInvited = :unionInvited");
					params.put("unionInvited", false);
				}
			}
			strBuffer.append(" ORDER BY b.createdAt DESC");
			// TODO
		}
		return strBuffer.toString();
	}

	@Override
	public Brand findBrandById(Integer id) {

		return hbDaoSupport.findTById(Brand.class, id);
	}

	@Override
	public Brand checkValidDelete(Integer id) {

		Brand brand = hbDaoSupport.findTById(Brand.class, id);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("brand", brand);
		List<Long> list = hbDaoSupport
				.executeQuery(
						"SELECT COUNT(bum) FROM BrandUnionMember bum WHERE bum.brand=:brand",
						params, null);
		if (null != list && list.size() > 0) {
			if (list.get(0) == 0) {
				return null;
			} else {
				return brand;
			}
		}
		return null;
	}

	@Override
	public Integer batchDeleteBrands(Integer[] ids) {

		Integer count = 0;
		if (null != ids && ids.length > 0) {
			for (Integer id : ids) {
				Brand brand = hbDaoSupport.findTById(Brand.class, id);
				try {
					hbDaoSupport.delete(brand);
					sysLogService.addSysLog("品牌维护", brand.getName(), OperationEvent.EVENT_DELETE.getName(), "成功");
				} catch (Exception e) {
				}
				count++;
			}
		}
		return count;
	}

	protected String buildSearchBrandUnionMembersSQL(
			BrandUnionMemberCriteria brandUnionMemberCriteria,
			List<Object> params, boolean isCount, boolean isDESC) {

		StringBuffer strBuffer = new StringBuffer();
		if (isCount) {
			strBuffer
					.append("SELECT COUNT(*) FROM brandunionmember_report bumr ");
		} else {
			//DATE_FORMAT(bumr.joinedDate, '%Y-%m-%d %T') as joinedDate
			strBuffer 
			.append("SELECT bumr.name as name, bumr.cardNumber as cardNumber, bumr.joinedDate as joinedDate FROM brandunionmember_report bumr ");
		}

		strBuffer
				.append(" WHERE 1=1"); // 很奇妙

		if (brandUnionMemberCriteria != null) {
			Integer id = brandUnionMemberCriteria.getBrandId();
			String memberName = brandUnionMemberCriteria.getMemberName();
			String cardNumber = brandUnionMemberCriteria.getCardNumber();
			Date joinedStart = brandUnionMemberCriteria.getJoinedStart();
			Date joinedEnd = brandUnionMemberCriteria.getJoinedEnd();

			if (null != id) { // 进入修改页面时，id为空
				strBuffer.append(" AND bumr.brandId=?");
				params.add(id);
				if (null != memberName && !memberName.isEmpty()) {
					strBuffer.append(" AND bumr.name like ?");
					params.add(memberName + "%");
				}
				if (null != cardNumber && !cardNumber.isEmpty()) {
					strBuffer.append(" AND bumr.cardNumber like ?");
					params.add(cardNumber+"%");
				}
				if (null != joinedStart) {
					strBuffer.append(" AND bumr.joinedDate >= ?");
					params.add(joinedStart);
				}
				if (null != joinedEnd) {
					joinedEnd = DateTools.getDateLastSecond(joinedEnd);
					strBuffer.append(" AND bumr.joinedDate <= ?");
					params.add(joinedEnd);
				}else {
					strBuffer.append(" AND bumr.joinedDate <= NOW()");
				}
			} else {
				strBuffer.append(" AND 1=0");
			}
			if(!isCount){
				if(isDESC){
					strBuffer.append(" ORDER BY bumr.joinedDate DESC");
				} else{
					strBuffer.append(" ORDER BY bumr.joinedDate ASC");
				}
			}
			// TODO
		}
		logger.trace("listBrandUnionMember sql ====>"
				+ strBuffer.toString());
		
		return strBuffer.toString();
	}

	@Override
	public List<UnionMemberVo> searchBrandUnionMembers(
			BrandUnionMemberCriteria brandUnionMemberCriteria, boolean isDESC) {

		List<Object> params = new ArrayList<Object>();
		String sql = buildSearchBrandUnionMembersSQL(brandUnionMemberCriteria, params, false, isDESC);

		List<UnionMemberVo> list = jdbcDaoSupport.findTsPageBySQL_NotTotalCount(
				new RowMapper<UnionMemberVo>() {

					@Override
					public UnionMemberVo mapRow(ResultSet rs, int rowNum)
							throws SQLException {
						return new UnionMemberVo(rs
								.getString("name"), rs.getString("cardNumber"),
								new Date(rs.getTimestamp("joinedDate").getTime()));
					}
				}, brandUnionMemberCriteria.getPaginationDetail(), sql, params.toArray());

		return list;
	}

	@Override
	public int countBrandUnionMembers(
			BrandUnionMemberCriteria brandUnionMemberCriteria) {

		List<Object> params = new ArrayList<Object>();
		String sql = buildSearchBrandUnionMembersSQL(brandUnionMemberCriteria, params, true, true);

		return jdbcDaoSupport.findCount(sql, params.toArray());
	}

	@Override
	public void exportUnionMember(HttpServletResponse response,
			HttpServletRequest request, BrandUnionMemberCriteria criteria, ProgressBar progressBar) {

		SXSSFWorkbook workbook = new SXSSFWorkbook(1); // excel 2007,
														// HSSFWorkbook
														// 在数据量大时会发生内存溢出
		CellStyle cellStyle = workbook.createCellStyle();
		Font font = workbook.createFont();

		font.setFontName("宋体");
		font.setFontHeightInPoints((short) 12);
		cellStyle.setFont(font);
		int maxSheetRows = SpreadsheetVersion.EXCEL97.getLastRowIndex();
		int rowsCount = countBrandUnionMembers(criteria);
		int mod = rowsCount % maxSheetRows;
		int index = (mod == 0 ? (rowsCount / maxSheetRows) : (rowsCount
				/ maxSheetRows + 1));

		Page paginationDetail = new Page();
		// 一次从数据库读取 65535 条数据
		paginationDetail.setRows(maxSheetRows);
		paginationDetail.setPage(1);

		criteria.setPaginationDetail(paginationDetail);
		criteria.setBrandId(1);

		long begin = System.currentTimeMillis();
		int middlePage = ((index % 2 == 0) ? (index >> 1) : ((index >> 1) + 1));
		if (index > 0) {
			for (int i = 1; i <= middlePage; i++) {
				long onceTime = System.currentTimeMillis();
				paginationDetail.setPage(i);
				List<UnionMemberVo> list = searchBrandUnionMembers(criteria,
						true);

				Sheet sheet = workbook.createSheet("第" + i + "页");
				fillNewSheet(sheet, list, cellStyle);
				logger.trace("listUnionMember " + i + " ====> "
						+ ((System.currentTimeMillis() - onceTime) / 1000)
						+ " seconds");
				progressBar.setValue( (int) (((double) i)
						/ ((double) index) * 100));// 准备数据进度
				list = null;
			}
			for (int i = index; i > middlePage; i--) {
				long onceTime = System.currentTimeMillis();
				if (i == index) {
					paginationDetail.setRows((mod == 0) ? maxSheetRows : mod);
				} else {
					paginationDetail.setRows(maxSheetRows);
				}
				paginationDetail.setPage((index - i) + 1);
				List<UnionMemberVo> list = searchBrandUnionMembers(criteria,
						false);
				Collections.reverse(list);

				Sheet sheet = workbook.createSheet("第" + i + "页");
				fillNewSheet(sheet, list, cellStyle);
				logger.trace("listUnionMember " + i + " ====> "
						+ ((System.currentTimeMillis() - onceTime) / 1000)
						+ " seconds");
				progressBar.setValue((int) (((double) (middlePage + (index
						- i + 1)) / (double) index) * 100));// 准备数据进度
				list = null;
			}
			// set sheet order
			for (int i = index; i > middlePage; i--) {
				workbook.setSheetOrder("第" + i + "页", (i - 1));
			}
		} else {
			Sheet sheet = workbook.createSheet("第" + 1 + "页");
			fillNewSheet(sheet, null, cellStyle);
			progressBar.setValue(100);
		}
		logger.trace("listUnionMember all time ====> "
				+ ((System.currentTimeMillis() - begin) / 1000) + " seconds");

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String fileName = "联合会员"
				+ dateFormat.format(SystemTimeProvider.getCurrentTime())
				+ ".xlsx";

		/**
		 * write to response.getOutputStream()
		 * 
		 */
		try {
			int count = 1;
			String uuid = progressBar.getUuid();
			do {
				if (null == ProgressBarMap.get(uuid)) {
					break;
				} else {
					Thread.sleep(500);
				}
			} while (count < 6);
			response.reset();
			response.setHeader("Content-Disposition", "attachment; filename="
					+ new String(fileName.getBytes("gb2312"), "ISO8859-1"));
			response.setContentType("application/octet-stream; charset=UTF-8");
			workbook.write(new BufferedOutputStream(response.getOutputStream(),
					1048576));// 加缓冲，提高IO效率
			response.getOutputStream().flush();
			logger.trace("listUnionMember all write time ====> "
					+ ((System.currentTimeMillis() - begin) / 1000)
					+ " seconds");
		} catch (Exception e) {
			// ignore: io exception
		} finally {
			workbook.dispose(); // dispose of temporary files backing this
								// workbook on disk
		}
	}

	private void fillNewSheet(Sheet sheet, List<UnionMemberVo> list,
			CellStyle cellStyle) {

		sheet.setColumnWidth(0, 7000);
		sheet.setColumnWidth(1, 7000);
		sheet.setColumnWidth(2, 7000);
		String[] title = new String[] { "会员名称", "会员卡号", "加入时间" };
		Row row = sheet.createRow(0);
		Cell cell;
		// set title
		for (int i = 0, length = title.length; i < length; i++) {

			cell = row.createCell(i);
			cell.setCellValue(title[i]);
			cell.setCellStyle(cellStyle);
		}

		if (null != list && list.size() > 0) {
			int j = 1;
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			for (UnionMemberVo unionMemberVo : list) {
				row = sheet.createRow(j);

				cell = row.createCell(0);
				cell.setCellValue(unionMemberVo.getMemberName());
				cell.setCellStyle(cellStyle);

				cell = row.createCell(1);
				cell.setCellValue(unionMemberVo.getCardNumber());
				cell.setCellStyle(cellStyle);

				cell = row.createCell(2);
				cell.setCellValue(dateFormat.format(unionMemberVo.getJoinDate()));
				cell.setCellStyle(cellStyle);

				j++;
			}
		}
	}

	@Override
	public boolean checkNameExists(Brand brand) {

		Brand brand2 = hbDaoSupport.findTByHQL(" FROM Brand WHERE name=?",
				brand.getName());
		if (null == brand2) {
			return false;
		}
		if (brand2.getId().equals(brand.getId())) {
			return false;
		}
		return true;
	}

	@Override
	public boolean checkCompanyNameExists(Brand brand) {
		Brand brand2 = hbDaoSupport.findTByHQL(
				" FROM Brand WHERE companyName=?", brand.getCompanyName());
		if (null == brand2) {
			return false;
		}
		if (brand2.getId().equals(brand.getId())) {
			return false;
		}
		return true;
	}

	@Override
	public boolean checkCompanyWebSiteExists(Brand brand) {

		Brand brand2 = hbDaoSupport
				.findTByHQL(" FROM Brand WHERE companyWebSite=?",
						brand.getCompanyWebSite());
		if (null == brand2) {
			return false;
		}
		if (brand2.getId().equals(brand.getId())) {
			return false;
		}
		return true;
	}

	@Override
	public boolean checkPhoneNumberExists(Brand brand) {

		Brand brand2 = hbDaoSupport.findTByHQL(
				" FROM Brand WHERE phoneNumber=?", brand.getPhoneNumber());
		if (null == brand2) {
			return false;
		}
		if (brand2.getId().equals(brand.getId())) {
			return false;
		}
		return true;
	}

	@Override
	public Brand checkBrandHasMerchandise(Integer id) {
		Brand brand = hbDaoSupport.findTById(Brand.class, id);
		Merchandise merchandise = hbDaoSupport.findTByHQL("FROM Merchandise WHERE brand=?", brand);
		if(null != merchandise){
			return brand;
		}else{
			return null;
		}
	}

	@Override
	public void saveImages(Integer id, Map<String, FileItem> images) throws IOException{
		Brand brand = hbDaoSupport.findTById(Brand.class, id);
		if(null != brand){
			FileItem logoFromDB = brand.getLogo();
			if(null != images && images.size() > 0){
				FileItem logo = null;
				for(Map.Entry<String, FileItem> entry: images.entrySet()){
					logo = entry.getValue();
					break;
				}
				if(logo != null && null != logoFromDB ){
					if(!logoFromDB.getId().equals(logo.getId())){
						brand.setLogo(null);
						hbDaoSupport.update(brand);
						new File(Constants.BRAND_IMAGE_DIR, logoFromDB.getUrl());
						hbDaoSupport.delete(logoFromDB);
						
						if(logo.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)){
							logo.setUrl(FileUtil.moveFile(Constants.BRAND_IMAGE_BUFFER, logo.getUrl(), Constants.BRAND_IMAGE_DIR));
							brand.setLogo(logo);
							hbDaoSupport.save(logo);
							hbDaoSupport.update(brand);
						}
					}
				}else if(logo != null && null == logoFromDB ){
					if(logo.getUrl().startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)){
						logo.setUrl(FileUtil.moveFile(Constants.BRAND_IMAGE_BUFFER, logo.getUrl(), Constants.BRAND_IMAGE_DIR));
						brand.setLogo(logo);
						hbDaoSupport.save(logo);
						hbDaoSupport.update(brand);
					}
				}
			}else{
				if(null != logoFromDB){
					brand.setLogo(null);
					hbDaoSupport.update(brand);
					new File(Constants.BRAND_IMAGE_DIR, logoFromDB.getUrl());
					hbDaoSupport.delete(logoFromDB);
				}
			}
		}
	}

}
