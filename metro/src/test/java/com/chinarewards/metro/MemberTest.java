//package com.chinarewards.metro;
//
//
//import static org.junit.Assert.assertNotNull;
//
//import java.io.IOException;
//import java.io.UnsupportedEncodingException;
//import java.math.BigDecimal;
//import java.util.ArrayList;
//import java.util.Date;
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
//import org.springframework.transaction.annotation.Transactional;
//
//import com.chinarewards.metro.core.common.Dictionary;
//import com.chinarewards.metro.core.common.HBDaoSupport;
//import com.chinarewards.metro.core.common.JDBCDaoSupport;
//import com.chinarewards.metro.core.common.MD5;
//import com.chinarewards.metro.core.common.SystemTimeProvider;
//import com.chinarewards.metro.core.common.UUIDUtil;
//import com.chinarewards.metro.domain.account.Account;
//import com.chinarewards.metro.domain.account.Business;
//import com.chinarewards.metro.domain.account.Transaction;
//import com.chinarewards.metro.domain.account.Unit;
//import com.chinarewards.metro.domain.business.OrderInfo;
//import com.chinarewards.metro.domain.member.AccountrPay;
//import com.chinarewards.metro.domain.member.Member;
//import com.chinarewards.metro.domain.member.MemberCard;
//import com.chinarewards.metro.service.account.IAccountService;
//import com.chinarewards.metro.service.system.ISysLogService;
//
///**
// * 为联合会员导出准备测试数据：500W个会员，500W张会员卡，5个品牌，每个品牌100W个联合会员
// * 
// * @author weishengshui
// * 
// */
//@RunWith(SpringJUnit4ClassRunner.class)
//@TransactionConfiguration(defaultRollback = true)
//@ContextConfiguration(locations = { "classpath:member_test.xml" })
//public class MemberTest {
//
//	@Autowired
//	private HBDaoSupport hbDaoSupport;
//	@Autowired
//	private JDBCDaoSupport jdbcDaoSupport;
//	@Autowired
//	private IAccountService accountService;
//	@Autowired
//	private ISysLogService sysLogService;
//
//	@Test
////	@Transactional
//	public void prepareData() {
//		
//		assertNotNull(accountService);
//		assertNotNull(hbDaoSupport);
//		assertNotNull(jdbcDaoSupport);
//		assertNotNull(sysLogService);
//		
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
//		//int cardNumber = (int)(Math.random()*100000000);
//		long phoneNumber = 13495632021l;
//		List<Member> list = new ArrayList<Member>();
//		for(int i = 0; i < 1000; i++){
//			MemberCard card = new MemberCard();
//			card.setCardNumber(UUIDUtil.generate());
//
//			Member member = new Member();
//			member.setName(name[((int) (Math.random() * name.length) % name.length)]
//					+ name[((int) (Math.random() * name.length) % name.length)]);
//			member.setSurname(surname[(int) (Math.random() * surname.length % surname.length)]);
//			Date date = new Date();
//			member.setCreateDate(date);
//			member.setCreateUser("admin");
//			member.setUpdateDate(date);
//			member.setCard(card);
//			member.setIndustry(0);
//			member.setProfession(0);
//			member.setPosition(0);
//			member.setSalary(0);
//			member.setEducation(0);
//			member.setPassword(MD5.MD5Encoder("123456"));
//			member.setStatus(Dictionary.MEMBER_STATE_NOACTIVATE);
//			member.setPhone((phoneNumber++)+"");
//			
//			
//			Account account = new Account();
//			account.setAccountId(UUIDUtil.generate());
//			account.setCreatedAt(new Date());
//			account.setCreatedBy(member.getName());
//			account.setStatus("activated");
//			
//			hbDaoSupport.save(account);
//			
//			member.setAccount(account != null ? account.getAccountId() : "");
//			member.setSource(Dictionary.MEMBER_SOURCE_CRM);
//			hbDaoSupport.save(member);
//			list.add(member);
//		}
//		
//		for(int i = 0; i < 1000; i++){
//			AccountrPay accountPay = new AccountrPay();
//			Date d = SystemTimeProvider.getCurrentTime();
//			
//			Transaction tx = accountService.createTransaction(accountPay.getMemberName(), Business.HAND_POINT, d);
//			Member member = list.get(i);
//			
//			accountPay.setMemberId(member.getId());
//			accountPay.setMemberName(member.getName());
//			accountPay.setMoney(10000.00f);
//			accountPay.setSource("");
//			accountPay.setNote("");
//			accountPay.setTransaction(d);
//			accountPay.setPayType(Dictionary.SUFFICIENT_TYPE_STORED);
//			accountPay.setCreateUser(0);
//			
//			Account account = accountService.findAccountById(member.getAccount());
//			String strUnit = Dictionary.UNIT_CODE_RMB;
//
//			Unit unit = hbDaoSupport.findTByHQL("FROM Unit where unitCode = ?",strUnit);
//			
//			OrderInfo orderInfo = new OrderInfo();
//			if (Dictionary.SUFFICIENT_TYPE_STORED == accountPay.getPayType()) { //交易类型
//				double a = accountService.getAccountBalance(account, Dictionary.UNIT_CODE_RMB);
//				orderInfo.setType(2);
//				orderInfo.setBeforeCash(BigDecimal.valueOf(a));
//				tx.setBusines(Business.HAND_MONEY);
//			}else{
//				double a = accountService.getAccountBalance(account, Dictionary.UNIT_CODE_BINKE);
//				orderInfo.setType(0);
//				orderInfo.setBeforeUnits(BigDecimal.valueOf(a));
//				tx.setBusines(Business.HAND_POINT);
//			}
//			orderInfo.setAccount(account);
//			orderInfo.setClerkId("");
//			orderInfo.setTx(tx);
//			orderInfo.setOrderSource("会员账户充值");
//			orderInfo.setOrderNo(tx.getTxId());
//			orderInfo.setIntegration(BigDecimal.valueOf(accountPay.getMoney()));
//			orderInfo.setOrderTime(d);
//			orderInfo.setChargeDesc(accountPay.getNote());
//			hbDaoSupport.save(accountPay);
//			accountService.deposit(accountPay.getMemberName(), account, unit,accountPay.getMoney(), tx);
//			hbDaoSupport.save(orderInfo);
////			String type = accountPay.getSource().equals(Dictionary.SUFFICIENT_TYPE_INTEGRAL) ? "积分" : "金额";
////			sysLogService.addSysLog("会员账户充值", accountPay.getMemberName(), OperationEvent.EVENT_SAVE.getName(), type+"充值: "+accountPay.getMemberName());
//		}
//		for(Member m : list){
//			System.out.println("member id ====>"+m.getId());
//		}
//	}
//
//}
