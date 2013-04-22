//package com.chinarewards.metro;
//
//
//import static org.junit.Assert.assertNotNull;
//
//import java.io.BufferedOutputStream;
//import java.io.File;
//import java.io.FileNotFoundException;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.io.UnsupportedEncodingException;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Calendar;
//import java.util.Collections;
//import java.util.Date;
//import java.util.HashMap;
//import java.util.List;
//import java.util.UUID;
//
//import org.apache.http.NameValuePair;
//import org.apache.http.client.ClientProtocolException;
//import org.apache.http.client.HttpClient;
//import org.apache.http.client.ResponseHandler;
//import org.apache.http.client.entity.UrlEncodedFormEntity;
//import org.apache.http.client.methods.HttpGet;
//import org.apache.http.client.methods.HttpPost;
//import org.apache.http.impl.client.BasicResponseHandler;
//import org.apache.http.impl.client.DefaultHttpClient;
//import org.apache.http.message.BasicNameValuePair;
//import org.apache.poi.ss.SpreadsheetVersion;
//import org.apache.poi.ss.usermodel.Cell;
//import org.apache.poi.ss.usermodel.CellStyle;
//import org.apache.poi.ss.usermodel.Font;
//import org.apache.poi.ss.usermodel.Row;
//import org.apache.poi.ss.usermodel.Sheet;
//import org.apache.poi.xssf.streaming.SXSSFWorkbook;
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.jdbc.core.RowMapper;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//import org.springframework.test.context.transaction.TransactionConfiguration;
//
//import com.chinarewards.metro.core.common.Constants;
//import com.chinarewards.metro.core.common.DateTools;
//import com.chinarewards.metro.core.common.Dictionary;
//import com.chinarewards.metro.core.common.FileUtil;
//import com.chinarewards.metro.core.common.HBDaoSupport;
//import com.chinarewards.metro.core.common.JDBCDaoSupport;
//import com.chinarewards.metro.core.common.Page;
//import com.chinarewards.metro.core.common.SystemTimeProvider;
//import com.chinarewards.metro.core.common.UUIDUtil;
//import com.chinarewards.metro.domain.brand.Brand;
//import com.chinarewards.metro.domain.brand.BrandUnionMember;
//import com.chinarewards.metro.domain.member.Member;
//import com.chinarewards.metro.domain.member.MemberCard;
//import com.chinarewards.metro.model.brand.BrandUnionMemberCriteria;
//import com.chinarewards.metro.model.brand.UnionMemberVo;
//
///**
// * 为联合会员导出准备测试数据：500W个会员，500W张会员卡，5个品牌，每个品牌100W个联合会员
// * 
// * @author weishengshui
// * 
// */
//@RunWith(SpringJUnit4ClassRunner.class)
//@TransactionConfiguration(defaultRollback = false)
//@ContextConfiguration(locations = { "classpath:member_test.xml" })
//public class BrandUnionMemberTest {
//
//	@Autowired
//	private HBDaoSupport hbDaoSupport;
////	@Autowired
////	private IBrandService brandService;
//	@Autowired
//	private JDBCDaoSupport jdbcDaoSupport;
//
//	@Test
//	public void test() {
//		assertNotNull(hbDaoSupport);
//		addMember();
//		addBrand();
//		addBrandUnionMember();
//	}
//
//	@Test
//	public void init() {
//
//	}
//
//	@Test
//	public void addMember() {
//		String[] name = new String[3501];
//		String[] surname = new String[1346];
//		// 创建默认的httpClient实例
//		HttpClient httpclient = new DefaultHttpClient();
//
//		String url = "http://www.98bk.com/cycx/bjx/";
//		// String url = "http://www.98bk.com/cycx/bjx/search.asp";
//		HttpPost post = new HttpPost(url);
//		try {
//			System.out.println("--------------------------------------");
//			System.out.println("Executing request url:" + post.getURI());
//
//			int count = 0;
//			for (int i = 0; i < 4; i++) {
//				List<NameValuePair> params = new ArrayList<NameValuePair>();
//				params.add(new BasicNameValuePair("page", i + 1 + ""));
//				UrlEncodedFormEntity uefEntity = new UrlEncodedFormEntity(
//						params, "UTF-8");
//				post.setEntity(uefEntity);
//				ResponseHandler<String> responseHandler = new BasicResponseHandler();
//				String responseBody = httpclient.execute(post, responseHandler);
//				String responseContent = new String(
//						responseBody.getBytes("ISO-8859-1"), "GBK");
//				int startIndex = 0;
//				int endIndex = 0;
//				if (null != responseContent) {
//					while (startIndex != -1) {
//						startIndex = responseContent.indexOf("href=cyshow.asp",
//								startIndex + 1);
//						if (startIndex != -1) {
//							endIndex = responseContent.indexOf("</a>",
//									startIndex + 1);
//							surname[count] = responseContent
//									.substring(responseContent.indexOf(">",
//											startIndex) + 1, endIndex);
//							System.out
//									.println(responseContent.substring(
//											responseContent.indexOf(">",
//													startIndex) + 1, endIndex));
//							// System.out.println("count ====>" + count);
//							count++;
//						}
//					}
//				}
//			}
//			url = "http://hanyu.iciba.com/zt/3500.html";
//			HttpGet httpGet = new HttpGet(url);
//			ResponseHandler<String> responseHandler = new BasicResponseHandler();
//			String responseBody = httpclient.execute(post, responseHandler);
//			responseBody = httpclient.execute(httpGet, responseHandler);
//			String responseContent = new String(
//					responseBody.getBytes("ISO-8859-1"), "UTF-8");
//			int startIndex = 0;
//			String indexStr = "target='_blank'>";
//			count = 0;
//			while (startIndex != -1) {
//				startIndex = responseContent.indexOf(indexStr, startIndex + 1);
//				if (startIndex != -1) {
//					startIndex += indexStr.length();
//					name[count] = responseContent.substring(startIndex,
//							startIndex + 1);
//				}
//				count++;
//			}
//			System.out.println("count ====>" + (count - 1));
//		} catch (ClientProtocolException e) {
//			e.printStackTrace();
//		} catch (UnsupportedEncodingException e1) {
//			e1.printStackTrace();
//		} catch (IOException e) {
//			e.printStackTrace();
//		} finally {
//			// 关闭连接,释放资源
//			httpclient.getConnectionManager().shutdown();
//		}
//
//		// prepare member and memberCard
//		int cardNumber = 100000000;
//		int nameLength = name.length;
//		int surnameLength = surname.length;
//		Calendar calendar = Calendar.getInstance();
//		calendar.set(2013, Calendar.JANUARY, 1, 0, 0, 0);
//		for (int i = 0; i < 50000; i++) {
//			MemberCard card = new MemberCard();
//			card.setCardNumber(UUIDUtil.generate());
//
//			Member member = new Member();
//			member.setName(name[((int) (Math.random() * nameLength) % nameLength)]
//					+ name[((int) (Math.random() * nameLength) % nameLength)]);
//			member.setSurname(surname[(int) (Math.random() * surnameLength % surnameLength)]);
//			member.setCard(card);
//			member.setIndustry(0);
//			member.setProfession(0);
//			member.setPosition(0);
//			member.setSalary(0);
//			member.setEducation(0);
//			member.setStatus(Dictionary.MEMBER_STATE_ACTIVATE);
//			
////			calendar.add(Calendar.DAY_OF_YEAR,
////					(int) (Math.random() * 100));
////			calendar.add(Calendar.SECOND,
////					(int) (Math.random() * 84000));
//			
//			member.setCreateDate(SystemTimeProvider.getCurrentTime());
//			member.setUpdateDate(SystemTimeProvider.getCurrentTime());
//			member.setCreateUser("admin");
//			member.setUpdateUser("admin");
//			
////			calendar.set(2013, Calendar.JANUARY, 1, 0, 0, 0);
//			hbDaoSupport.save(member);
//			System.out.println("add member " + (i + 1));
//		}
//
//	}
//
//	@Test
//	public void testUUID() {
//		UUID uuid = UUID.randomUUID();
//		System.out.println(uuid.toString());
//	}
//
//	@Test
//	public void addBrand() {
//		String[] brandName = { "adidas", "361度", "yizhichun", "xxxxxxxxx",
//				"yyyyyyyyyyyyy" };
//		String[] brandCompanyName = { "adidas", "361度", "yizhichun",
//				"xxxxxxxxx", "yyyyyyyyyyyyy" };
//		String[] brandWebsite = { "http://www.adidas.com",
//				"http://www.361度.com", "http://www.yizhichun.com",
//				"http://www.xxxxxxxxx.com", "http://www.yyyyyyyyyyyyy.com" };
//		for (int i = 0; i < 5; i++) {
//
//			Brand brand = new Brand();
//			brand.setCompanyName(brandCompanyName[i]);
//			brand.setCompanyWebSite(brandWebsite[i]);
//			brand.setCreatedAt(new Date());
//			brand.setCreatedBy(0);
//			brand.setLastModifiedAt(new Date());
//			brand.setLastModifiedBy(0);
//			brand.setName(brandName[i]);
//			brand.setUnionInvited(true);
//
//			hbDaoSupport.save(brand);
//
//			System.out.println("add brand " + (i + 1));
//		}
//	}
//
//	@Test
//	public void addBrandUnionMember() {
//		Calendar calendar = Calendar.getInstance();
//		calendar.set(2013, Calendar.JANUARY, 1, 0, 0, 0);
//		List<Brand> brands = hbDaoSupport.findAll(Brand.class);
//		if (null != brands && brands.size() > 0) {
//			for (int i = 0, length = brands.size(); i < length; i++) {
//				Brand brand = brands.get(i);
//				int j = 1;
//				for (int index = i; index < i + 1; index++) {
//					Page page = new Page();
//					page.setPage(index + 1);
//					page.setRows(10000);
//					List<Member> members = hbDaoSupport.findTsByHQLPage(
//							"FROM Member m ORDER BY m.createDate DESC ",
//							new HashMap<String, Object>(), page);
//					if (null != members && members.size() > 0) {
//						for (Member member : members) {
//							BrandUnionMember brandUnionMember = new BrandUnionMember();
//							brandUnionMember.setBrand(brand);
//							brandUnionMember.setCreatedAt(new Date());
//							brandUnionMember.setCreatedBy("weishengshui");
//							calendar.add(Calendar.DAY_OF_YEAR,
//									(int) (Math.random() * 100));
//							calendar.add(Calendar.SECOND,
//									(int) (Math.random() * 84000));
//							brandUnionMember.setJoinedDate(calendar.getTime());
//
//							brandUnionMember.setMember(member);
//							hbDaoSupport.save(brandUnionMember);
//
//							System.out.println("add brandUnionMember: brand("
//									+ (i + 1) + ") member(" + j + ")");
//							j++;
//							calendar.set(2013, Calendar.JANUARY, 1, 0, 0, 0);
//						}
//					}
//				}
//			}
//		}
//	}
//
//	@Test
//	public void testQueryListUnionMemberTime_jdbcDaoSupport() {
//		long begin = System.currentTimeMillis();
//		BrandUnionMemberCriteria brandUnionMemberCriteria = new BrandUnionMemberCriteria();
//		Page paginationDetail = new Page();
//
//		paginationDetail.setPage(2000);
//		paginationDetail.setRows(10);
//		brandUnionMemberCriteria.setBrandId(1);
//		brandUnionMemberCriteria.setPaginationDetail(paginationDetail);
//
//		List<UnionMemberVo> list = listBrandUnionMember(brandUnionMemberCriteria);
//		// listBrandUnionMember took 7 seconds
//		// listBrandUnionMember took 7 seconds
//
//		System.out.println("listBrandUnionMember took "
//				+ ((System.currentTimeMillis() - begin) / 1000) + " seconds");
//	}
//
//	public List<UnionMemberVo> listBrandUnionMember(
//			BrandUnionMemberCriteria brandUnionMemberCriteria) {
//
//		StringBuffer strBuffer = new StringBuffer();
//		List<Object> params = new ArrayList<Object>();
//
//		strBuffer
//				.append("SELECT m.surname as surname, m.name as name, mc.cardNumber as cardNumber, bm.joinedDate as joinedDate ");
//
//		strBuffer
//				.append("FROM BrandUnionMember as bm, Brand as b, Member as m, MemberCard as mc WHERE bm.brand_id=b.id AND bm.member_id=m.id AND m.card_id=mc.id "); // 很奇妙
//
//		if (brandUnionMemberCriteria != null) {
//			Integer id = brandUnionMemberCriteria.getBrandId();
//			String memberName = brandUnionMemberCriteria.getMemberName();
//			String cardNumber = brandUnionMemberCriteria.getCardNumber();
//			Date joinedStart = brandUnionMemberCriteria.getJoinedStart();
//			Date joinedEnd = brandUnionMemberCriteria.getJoinedEnd();
//
//			if (null != id) { // 进入修改页面时，id为空
//				strBuffer.append(" AND b.id=?");
//				params.add(id);
//			} else {
//				strBuffer.append(" AND 1=0");
//			}
//			if (null != memberName && !memberName.isEmpty()) {
//				strBuffer.append(" AND m.name like ?");
//				params.add("%" + memberName + "%");
//			}
//			if (null != cardNumber && !cardNumber.isEmpty()) {
//				strBuffer.append(" AND mc.cardNumber like ?");
//				params.add("%" + cardNumber + "%");
//			}
//			if (null != joinedStart) {
//				strBuffer.append(" AND bm.joinedDate >= ?");
//				params.add(joinedStart);
//			}
//			if (null != joinedEnd) {
//				joinedEnd = DateTools.getDateLastSecond(joinedEnd);
//				strBuffer.append(" AND bm.joinedDate <= ?");
//				params.add(joinedEnd);
//			}
//			strBuffer.append(" ORDER BY bm.joinedDate DESC");
//			// TODO
//		}
//		System.out.println("listBrandUnionMember sql ====>"
//				+ strBuffer.toString());
//		List<UnionMemberVo> list = jdbcDaoSupport.findTsPageBySQL(
//				new RowMapper<UnionMemberVo>() {
//
//					@Override
//					public UnionMemberVo mapRow(ResultSet rs, int rowNum)
//							throws SQLException {
//						return new UnionMemberVo(rs.getString("surname"), rs
//								.getString("name"), rs.getString("cardNumber"),
//								rs.getDate("joinedDate"));
//					}
//				}, brandUnionMemberCriteria.getPaginationDetail(), "",
//				strBuffer.toString(), params.toArray());
//
//		return list;
//	}
//	
//	
//	@Test
//	public void listBrandUnionMember_oneTable_Test(){
//		
//		BrandUnionMemberCriteria criteria = new BrandUnionMemberCriteria();
//		SXSSFWorkbook workbook = new SXSSFWorkbook(1);  // excel 2007, HSSFWorkbook 在数据量大时会发生内存溢出
//		CellStyle cellStyle = workbook.createCellStyle();
//		Font font = workbook.createFont();
//
//		font.setFontName("宋体");
//		font.setFontHeightInPoints((short) 12);
//		cellStyle.setFont(font);
////		int maxSheetRows = 10000;
//		int maxSheetRows = SpreadsheetVersion.EXCEL97.getLastRowIndex();
//		Page paginationDetail = new Page();
//		// 一次从数据库读取 65535 条数据
//		paginationDetail.setRows(maxSheetRows);
//		paginationDetail.setPage(1);
//		
//		criteria.setPaginationDetail(paginationDetail);
//		criteria.setBrandId(1);
//		
//		int rowsCount = countBrandUnionMembers(criteria);
//		int mod = rowsCount % maxSheetRows;
//		int index = (mod==0?(rowsCount/maxSheetRows):(rowsCount/maxSheetRows + 1));
//		
//		
//		long begin = System.currentTimeMillis();
//		int middlePage = ((index%2==0)?(index>>1):((index >> 1) + 1));
//		System.out.println("middlePage ====>"+middlePage);
//		if(index > 0){
//			for(int i = 1; i <= middlePage; i++){
//				long onceTime = System.currentTimeMillis();
//				paginationDetail.setPage(i);
//				List<UnionMemberVo> list = listBrandUnionMember_oneTable(criteria, true);
//				
//				Sheet sheet = workbook.createSheet("第" + i + "页");
//				fillNewSheet(sheet, list, cellStyle);
//				System.out.println("listUnionMember "+i+" ====> "
//						+ ((System.currentTimeMillis() - onceTime) / 1000) + " seconds");
//				
//			}
//			for(int i = index; i > middlePage; i--){
//				long onceTime = System.currentTimeMillis();
//				if(i == index){
//					paginationDetail.setRows((mod==0)?maxSheetRows:mod);
//				}else{
//					paginationDetail.setRows(maxSheetRows);
//				}
//				paginationDetail.setPage((index-i)+1);
//				List<UnionMemberVo> list = listBrandUnionMember_oneTable(criteria, false);
//				Collections.reverse(list);
//				
//				Sheet sheet = workbook.createSheet("第" + i + "页");
//				fillNewSheet(sheet, list, cellStyle);
//				System.out.println("listUnionMember "+i+" ====> "
//						+ ((System.currentTimeMillis() - onceTime) / 1000) + " seconds");
//			}
//			// set order
//			for(int i = index; i > middlePage; i--){
//				workbook.setSheetOrder("第"+i+"页", (i-1));
//			}
//		}else{
//			Sheet sheet = workbook.createSheet("第" + 1 + "页");
//			fillNewSheet(sheet, null, cellStyle);
//		}
//		System.out.println("listUnionMember all time ====> "
//				+ ((System.currentTimeMillis() - begin) / 1000)
//				+ " seconds");
//		try {
//			FileUtil.pathExist(Constants.EXPORT_UNIONMEMBER_DIR);
//			workbook.write(new BufferedOutputStream(new FileOutputStream(new File(Constants.EXPORT_UNIONMEMBER_DIR)+"/xxxx.xlsx"), 1048576));
//		} catch (FileNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		workbook.dispose(); // dispose of temporary files backing this workbook on disk
//	}
//	
//	public List<UnionMemberVo> listBrandUnionMember_oneTable(
//			BrandUnionMemberCriteria brandUnionMemberCriteria, boolean isDESC) {
//
//		StringBuffer strBuffer = new StringBuffer();
//		List<Object> params = new ArrayList<Object>();
//
//		strBuffer
//				.append("SELECT bumr.name as name, bumr.cardNumber as cardNumber, bumr.joinedDate as joinedDate FROM brandunionmember_report bumr ");
//
//		strBuffer
//				.append("WHERE 1=1"); // 很奇妙
//
//		if (brandUnionMemberCriteria != null) {
//			Integer id = brandUnionMemberCriteria.getBrandId();
//			String memberName = brandUnionMemberCriteria.getMemberName();
//			String cardNumber = brandUnionMemberCriteria.getCardNumber();
//			Date joinedStart = brandUnionMemberCriteria.getJoinedStart();
//			Date joinedEnd = brandUnionMemberCriteria.getJoinedEnd();
//
//			if (null != id) { // 进入修改页面时，id为空
//				strBuffer.append(" AND bumr.brandId=?");
//				params.add(id);
//				if (null != memberName && !memberName.isEmpty()) {
//					strBuffer.append(" AND bumr.name like ?");
//					params.add(memberName + "%");
//				}
//				if (null != cardNumber && !cardNumber.isEmpty()) {
//					strBuffer.append(" AND bumr.cardNumber like ?");
//					params.add(cardNumber+"%");
//				}
//				if (null != joinedStart) {
//					strBuffer.append(" AND bumr.joinedDate >= ?");
//					params.add(joinedStart);
//				}
//				if (null != joinedEnd) {
//					joinedEnd = DateTools.getDateLastSecond(joinedEnd);
//					strBuffer.append(" AND bumr.joinedDate <= ?");
//					params.add(joinedEnd);
//				}else {
//					strBuffer.append(" AND bumr.joinedDate <= NOW()");
//				}
//			} else {
//				strBuffer.append(" AND 1=0");
//			}
//			if (isDESC) {
//				strBuffer.append(" ORDER BY bumr.joinedDate DESC");
//			} else {
//				strBuffer.append(" ORDER BY bumr.joinedDate ASC");
//			}
//			// TODO
//		}
////		System.out.println("listBrandUnionMember sql ====>"
////				+ strBuffer.toString());
//		List<UnionMemberVo> list = jdbcDaoSupport.findTsPageBySQL_NotTotalCount(
//				new RowMapper<UnionMemberVo>() {
//
//					@Override
//					public UnionMemberVo mapRow(ResultSet rs, int rowNum)
//							throws SQLException {
//						return new UnionMemberVo(rs
//								.getString("name"), rs.getString("cardNumber"),
//								new Date(rs.getTimestamp("joinedDate").getTime()));
//					}
//				}, brandUnionMemberCriteria.getPaginationDetail(), strBuffer.toString(), params.toArray());
//
//		return list;
//	}
//	
//	private void fillNewSheet(Sheet sheet, List<UnionMemberVo> list,
//			CellStyle cellStyle) {
//
//		sheet.setColumnWidth(0, 7000);
//		sheet.setColumnWidth(1, 7000);
//		sheet.setColumnWidth(2, 7000);
//		String[] title = new String[] { "会员名称", "会员卡号", "加入时间" };
//		Row row = sheet.createRow(0);
//		Cell cell;
//		// set title
//		for (int i = 0, length = title.length; i < length; i++) {
//
//			cell = row.createCell(i);
//			cell.setCellValue(title[i]);
//			cell.setCellStyle(cellStyle);
//		}
//
//		// just for test
//		/*SimpleDateFormat dateFormat = new SimpleDateFormat(
//				"yyyy-MM-dd HH:mm:ss");
//		for(int i = 1; i <= 65535; i++){
//			row = sheet.createRow(i);
//
//			cell = row.createCell(0);
//			cell.setCellValue("中文姓名");
//			cell.setCellStyle(cellStyle);
//
//			cell = row.createCell(1);
//			cell.setCellValue("1235562254411111");
//			cell.setCellStyle(cellStyle);
//
//			cell = row.createCell(2);
//			cell.setCellValue(dateFormat.format(new Date()));
//			cell.setCellStyle(cellStyle);
//
//		}*/
//		if (null != list && list.size() > 0) {
//			int j = 1;
//			SimpleDateFormat dateFormat = new SimpleDateFormat(
//					"yyyy-MM-dd HH:mm:ss");
//			for (UnionMemberVo unionMemberVo : list) {
//				row = sheet.createRow(j);
//
//				cell = row.createCell(0);
//				cell.setCellValue(unionMemberVo.getMemberName());
//				cell.setCellStyle(cellStyle);
//
//				cell = row.createCell(1);
//				cell.setCellValue(unionMemberVo.getCardNumber());
//				cell.setCellStyle(cellStyle);
//
//				cell = row.createCell(2);
//				cell.setCellValue(dateFormat.format(unionMemberVo.getJoinDate()));
//				cell.setCellStyle(cellStyle);
//
//				j++;
//			}
//		}
//	}
//	
//	public int countBrandUnionMembers(
//			BrandUnionMemberCriteria brandUnionMemberCriteria) {
//
//		StringBuffer strBuffer = new StringBuffer();
//		List<Object> params = new ArrayList<Object>();
//
//		strBuffer
//				.append("SELECT COUNT(*) FROM brandunionmember_report bumr ");
//
//		strBuffer
//				.append("WHERE 1=1"); // 很奇妙
//
//		if (brandUnionMemberCriteria != null) {
//			Integer id = brandUnionMemberCriteria.getBrandId();
//			String memberName = brandUnionMemberCriteria.getMemberName();
//			String cardNumber = brandUnionMemberCriteria.getCardNumber();
//			Date joinedStart = brandUnionMemberCriteria.getJoinedStart();
//			Date joinedEnd = brandUnionMemberCriteria.getJoinedEnd();
//
//			if (null != id) { // 进入修改页面时，id为空
//				strBuffer.append(" AND bumr.brandId=?");
//				params.add(id);
//				if (null != memberName && !memberName.isEmpty()) {
//					strBuffer.append(" AND bumr.name like ?");
//					params.add(memberName + "%");
//				}
//				if (null != cardNumber && !cardNumber.isEmpty()) {
//					strBuffer.append(" AND bumr.cardNumber like ?");
//					params.add(cardNumber+"%");
//				}
//				if (null != joinedStart) {
//					strBuffer.append(" AND bumr.joinedDate >= ?");
//					params.add(joinedStart);
//				}
//				if (null != joinedEnd) {
//					joinedEnd = DateTools.getDateLastSecond(joinedEnd);
//					strBuffer.append(" AND bumr.joinedDate <= ?");
//					params.add(joinedEnd);
//				}else {
//					strBuffer.append(" AND bumr.joinedDate <= NOW()");
//				}
//			} else {
//				strBuffer.append(" AND 1=0");
//			}
//			// TODO
//		}
//		System.out.println("listBrandUnionMember sql ====>"
//				+ strBuffer.toString());
//		
//		return jdbcDaoSupport.findCount(strBuffer.toString(), params.toArray());
//	}
//
//}
