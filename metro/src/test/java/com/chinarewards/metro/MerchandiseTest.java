//package com.chinarewards.metro;
//
//import static org.junit.Assert.assertNotNull;
//
//import java.io.IOException;
//import java.io.UnsupportedEncodingException;
//import java.util.ArrayList;
//import java.util.List;
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
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//import org.springframework.test.context.transaction.TransactionConfiguration;
//
//import com.chinarewards.metro.core.common.HBDaoSupport;
//import com.chinarewards.metro.core.common.JDBCDaoSupport;
//import com.chinarewards.metro.core.common.SystemTimeProvider;
//import com.chinarewards.metro.domain.brand.Brand;
//import com.chinarewards.metro.domain.category.Category;
//import com.chinarewards.metro.domain.merchandise.Merchandise;
//import com.chinarewards.metro.domain.merchandise.MerchandiseCatalog;
//import com.chinarewards.metro.domain.merchandise.MerchandiseSaleform;
//import com.chinarewards.metro.domain.merchandise.MerchandiseStatus;
//
///**
// * 为联合会员导出准备测试数据：500W个会员，500W张会员卡，5个品牌，每个品牌100W个联合会员
// * 
// * @author weishengshui
// * 
// */
//@RunWith(SpringJUnit4ClassRunner.class)
//@TransactionConfiguration(defaultRollback = false)
//@ContextConfiguration(locations = { "classpath:merchandise_test.xml" })
//public class MerchandiseTest {
//
//	@Autowired
//	private HBDaoSupport hbDaoSupport;
//	@Autowired
//	private JDBCDaoSupport jdbcDaoSupport;
//
//	@Test
//	public void test() {
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
//		// add 10 categories
//		String[] categoryNames = { "类别1", "类别2", "类别3", "类别4", "类别5", "类别6",
//				"类别7", "类别8", "类别9", "类别10", };
//		int[] sort = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 };
//		Category parent = hbDaoSupport.findTById(Category.class, "0");
//		List<Category> categories = new ArrayList<Category>();
//		for (int i = 0; i < 10; i++) {
//			Category category = new Category();
//			category.setCreatedAt(SystemTimeProvider.getCurrentTime());
//			category.setCreatedBy(0);
//			category.setDisplaySort((long) sort[i]);
//			category.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
//			category.setLastModifiedBy(0);
//			category.setName(categoryNames[i]);
//			category.setParent(parent);
//			hbDaoSupport.save(category);
//			categories.add(category);
//		}
//
//		// add 5000 brands
//		int nameLength = name.length;
//		int surnameLength = surname.length;
//		List<Brand> brands = new ArrayList<Brand>();
//		long phoneNumber = 15189755312l;
//		for (int i = 0; i < 5000; i++) {
//			Brand brand = new Brand();
//			String companyName = name[((int) (Math.random() * nameLength) % nameLength)]
//					+ name[((int) (Math.random() * nameLength) % nameLength)];
//			brand.setCompanyName(companyName);
//			brand.setCompanyWebSite("http://www." + companyName + ".com");
//			brand.setContact(surname[((int) (Math.random() * surname.length) % surnameLength)]
//					+ name[((int) (Math.random() * nameLength) % nameLength)]
//					+ name[((int) (Math.random() * nameLength) % nameLength)]);
//			brand.setCreatedAt(SystemTimeProvider.getCurrentTime());
//			brand.setCreatedBy(0);
//			brand.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
//			brand.setLastModifiedBy(0);
//			brand.setName(companyName);
//			brand.setPhoneNumber((phoneNumber++) + "");
//			brand.setUnionInvited(true);
//			hbDaoSupport.save(brand);
//			brands.add(brand);
//		}
//
//		// add 5000 merchandises
//		int merchandiseCode = 9000;
//		int merchandiseModel = 8254;
//		long displaySort = 63561;
//		Category category = categories.get(0);
//		for (int i = 0; i < 5000; i++) {
//			Merchandise merchandise = new Merchandise();
//			String merchandiseName = name[((int) (Math.random() * nameLength) % nameLength)]
//					+ name[((int) (Math.random() * nameLength) % nameLength)];
//
//			double binkePrice = 1000.25 + (int) (Math.random() * 10000);
//			double binkePrivilegePrice = binkePrice - 200;
//			double rmbPrice = 8000.52 + (int) (Math.random() * 1000);
//			double rmbPrivilegePrice = 7000.65 + (int) (Math.random() * 1000);
//			double purchasePrice = 6000.85 + (int) (Math.random() * 1000);
//			double freight = 10 + (int) (Math.random() * 10);
//
//			merchandise.setBinkePrcie(binkePrice);
//			merchandise.setBinkePreferentialPrcie(binkePrivilegePrice);
//			merchandise.setBrand(brands.get(i));
//			merchandise.setCode(getAbcs() + merchandiseCode++);
//			merchandise.setCreatedAt(SystemTimeProvider.getCurrentTime());
//			merchandise.setCreatedBy(0);
//			merchandise.setFreight(freight);
//			merchandise.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
//			merchandise.setLastModifiedBy(0);
//			merchandise.setModel(getAbcs() + merchandiseModel++);
//			merchandise.setName(merchandiseName);
//			merchandise.setPurchasePrice(purchasePrice);
//			merchandise.setRmbPrcie(rmbPrice);
//			merchandise.setRmbPreferentialPrcie(rmbPrivilegePrice);
//			merchandise.setShowInSite(true);
//			hbDaoSupport.save(merchandise);
//
//			// rmb saleform
//			MerchandiseSaleform saleform1 = new MerchandiseSaleform();
//			saleform1.setCreatedAt(SystemTimeProvider.getCurrentTime());
//			saleform1.setCreatedBy(0);
//			saleform1.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
//			saleform1.setLastModifiedBy(0);
//			saleform1.setMerchandise(merchandise);
//			saleform1.setPreferentialPrice(rmbPrivilegePrice);
//			saleform1.setPrice(rmbPrice);
//			saleform1.setUnitId("0");
//			hbDaoSupport.save(saleform1);
//			// binke saleform
//			MerchandiseSaleform saleform2 = new MerchandiseSaleform();
//			saleform2.setCreatedAt(SystemTimeProvider.getCurrentTime());
//			saleform2.setCreatedBy(0);
//			saleform2.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
//			saleform2.setLastModifiedBy(0);
//			saleform2.setMerchandise(merchandise);
//			saleform2.setPreferentialPrice(binkePrivilegePrice);
//			saleform2.setPrice(binkePrice);
//			saleform2.setUnitId("1");
//			hbDaoSupport.save(saleform2);
//
//			if (i % 500 == 0) {
//				category = categories.get(i / 500);
//			}
//			MerchandiseCatalog catalog = new MerchandiseCatalog();
//
//			// catalog
//			catalog.setCategory(category);
//			catalog.setCreatedAt(SystemTimeProvider.getCurrentTime());
//			catalog.setCreatedBy(0);
//			catalog.setDisplaySort(displaySort++);
//			catalog.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
//			catalog.setLastModifiedBy(0);
//			catalog.setMerchandise(merchandise);
//			catalog.setOn_offTIme(SystemTimeProvider.getCurrentTime());
//			catalog.setStatus(MerchandiseStatus.ON);
//			hbDaoSupport.save(catalog);
//		}
//	}
//
//	private String getAbcs() {
//		String[] abc = { "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a",
//				"s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v",
//				"b", "n", "m" };
//		int abcLength = abc.length;
//		return abc[((int) (Math.random() * abcLength) % abcLength)]
//				+ abc[((int) (Math.random() * abcLength) % abcLength)]
//				+ abc[((int) (Math.random() * abcLength) % abcLength)]
//				+ abc[((int) (Math.random() * abcLength) % abcLength)];
//	}
//
//	@Test
//	public void init() {
//
//	}
//
//}
