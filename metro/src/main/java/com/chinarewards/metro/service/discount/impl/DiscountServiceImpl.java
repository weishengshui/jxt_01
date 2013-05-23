package com.chinarewards.metro.service.discount.impl;

import java.io.File;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.OperatePropertiesFile;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.SystemParamsConfig;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.member.MemberCard;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.DiscountCodeImport;
import com.chinarewards.metro.domain.shop.DiscountNumber;
import com.chinarewards.metro.domain.shop.DiscountNumberHistory;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.model.discount.DiscountMode;
import com.chinarewards.metro.model.discount.DiscountNumberReport;
import com.chinarewards.metro.model.integral.IntegralReport;
import com.chinarewards.metro.models.DiscountUseCodeResp;
import com.chinarewards.metro.models.request.DiscountUseCodeReq;
import com.chinarewards.metro.models.request.VerifyDiscountReq;
import com.chinarewards.metro.repository.global.SysDefinesRepository;
import com.chinarewards.metro.sequence.IBusinessNumGenerator;
import com.chinarewards.metro.service.activity.IActivityService;
import com.chinarewards.metro.service.discount.IDiscountService;
import com.chinarewards.metro.service.line.ILineService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.utils.StringUtil;

@Service
public class DiscountServiceImpl implements IDiscountService {
	Logger log = Logger.getLogger(this.getClass());
	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private SysDefinesRepository repository;
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;

	@Autowired
	IBusinessNumGenerator businessNumGenerator;
	@Autowired
	ILineService lineService;
	@Autowired
	IActivityService activityService;
	
	@Autowired
	IMemberService memberService;

	public final static String CONFIG_FILE = "discountRecord.properties";


	// 记录回收后的记录数据
	private static volatile Map<String, LinkedList<Integer>> gcRecord = new HashMap<String, LinkedList<Integer>>();

	public DiscountMode getCompRandCode(Member member, MemberCard card,
			Shop shop) {
		DiscountNumber number = null;
		DiscountMode discountMode = new DiscountMode();
		Map<String, String> codeData = new HashMap<String, String>();
		log.info("shop ======>>> : "+ shop);
		if (shop != null) {
			String expre = shop.getExpresion();
			String[] expresion = null;
			if (expre != null) {
				expresion = expre.split("~");
			} else {
				expresion = repository.getVariable("expresion").split("~");
			}
			String compRandCode = "0";
			log.info("expresion ======>>> : "+ expresion);
			if (expresion != null) {
				String subscript = expresion[1];
				String shopKey = "shop_rand_" + shop.getId();
				String ruleKey_1 = "shop_1_" + shop.getId() ;
				String ruleKey_2 = "shop_2_" + shop.getId() ;
				creatNewFile();
				String v = OperatePropertiesFile.getValueByPropertyName(CONFIG_FILE, shopKey);
				String ruleSubValue_1 = OperatePropertiesFile.getValueByPropertyName(CONFIG_FILE, ruleKey_1);  //得到变更前的下标
				String ruleSubValue_2 = OperatePropertiesFile.getValueByPropertyName(CONFIG_FILE, ruleKey_2);
				log.info("v ======>>> : "+ v + "   ruleSubValue_1 =====>>>> : "+ruleSubValue_1+"     ruleSubValue_2 =======>>>>> : "+ruleSubValue_2);
				if((ruleSubValue_1 != null && !ruleSubValue_1.equals(expresion[0])) || (ruleSubValue_2 != null && !ruleSubValue_2.equals(expresion[1]))){
					v = null ;
					OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_1, expresion[0]);
					OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_2, expresion[1]);
					String filePath = OperateTxtData.getFilePath(shop, null, 0);
					File file = new File(filePath);
					boolean delFlag = file.delete();
					
					log.info("delFlag ======>>> : "+ delFlag);
					
				}
				Integer len = 0;
				if (v == null) {
					log.info("v **********: "+ v);
					len = Integer.valueOf(expresion[0]) + Integer.valueOf(99);
					Integer num = (len > Integer.valueOf(expresion[1])) ? Integer
							.valueOf(expresion[1]) : len;
					OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_1, expresion[0]);
					OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_2, expresion[1]);
					OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, shopKey, String.valueOf(num));
					for (int i = Integer.valueOf(expresion[0]); i <= num; i++) {
						codeData.put(shopKey + "_" + i, String.valueOf(i));
					}
					compRandCode = getDiscountCode(shop, null,
							0, codeData);
				} else {
					String filePath = OperateTxtData.getFilePath(shop, null, 0);
					Map<String, String> shopCodeData = OperateTxtData
							.getDiscountData(filePath);
					if (shopCodeData.size() <= 10) {
						if (Integer.valueOf(v) < Integer.valueOf(subscript)) {// 当池中还剩10条记录时再生成
							for (int i = Integer.valueOf(v)+1; i < Integer.valueOf(v) + Integer.valueOf(90) + 1
									&& i < Integer.valueOf(subscript) + 1; i++) {
								codeData.put(shopKey + "_" + i,
										String.valueOf(i));
							}
							int num = Integer.valueOf(expresion[1]) - Integer.valueOf(expresion[0]) + 1 ;
							OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, shopKey, String.valueOf((Integer.valueOf(v) + Integer.valueOf(90)) > num ? num : Integer.valueOf(v) + Integer.valueOf(90)));
						}

						OperateTxtData.recoverDidcountCodeData(codeData,
								filePath);

						compRandCode = getDiscountCode(shop,
								null, 0, codeData);
					} else {
						compRandCode = getDiscountCode(shop,
								null, 0, codeData);
					}
					if (shopCodeData.size() == 0) {// 区间内没有数据可以生成，那么就对已过期的优惠码进行回收
						LinkedList<Integer> codeList = new LinkedList<Integer>(); // 存储回收的优惠码数据
						Date now_date = new Date();
						String hql = "select * from DiscountNumber d where d.expiredDate <= ? and d.shop_id = ? and d.codeType = 0 or d.state = 1  and d.shop_id = ? and d.expiredDate >= now() and d.codeType = 0";
						String his_hql = "select * from DiscountNumberHistory d where d.expiredDate between DATE_SUB(now(), INTERVAL '3' DAY_HOUR) and now() and d.shop_id = ? and d.codeType = 0  or d.status = 1 and d.shop_id = ? and d.expiredDate >= now() and d.codeType = 0";
						RowMapper rowMapper = getRowMapper_discount();
						RowMapper rowMapper_his = getRowMapper_discountHistroy();

						List<DiscountNumber> list = jdbcDaoSupport.findTsBySQL(
								rowMapper, hql, now_date, shop.getId(),shop.getId());
						List<DiscountNumberHistory> his_list = jdbcDaoSupport
								.findTsBySQL(rowMapper_his, his_hql, shop.getId(),shop.getId());

						if (list != null && list.size() > 0) {
							for (DiscountNumber dn : list) {
								boolean flag = gcCodeCheck(dn.getDiscountNum(), shop.getId(), 0);
								if(!flag){
									if (dn.getDiscountNum() != null) {
										codeList.add(Integer.valueOf(dn
												.getDiscountNum() != null ? dn
												.getDiscountNum() : "0"));
									}
								}
							}
							gcRecord.put(shopKey, codeList);
						}
						if (his_list != null && his_list.size() > 0) {
							for (DiscountNumberHistory dn : his_list) {
								boolean flag = gcCodeCheck(dn.getDiscountNum(), shop.getId(), 0);
								if(!flag){
									if (dn.getDiscountNum() != null) {
										codeList.add(Integer.valueOf(dn
												.getDiscountNum() != null ? dn
												.getDiscountNum() : "0"));
									}
								}
							}
							gcRecord.put(shopKey, codeList);
						}
						LinkedList<Integer> linkedList = gcRecord.get(shopKey) ;
						if (linkedList != null && linkedList.size() > 0) {
							Set<Integer> set = new HashSet<Integer>(linkedList);
							linkedList.clear();
							linkedList.addAll(set);
							for (int i = 0; i < 100; i++) {
								if (i < linkedList.size()) {
									for(int j = Integer.valueOf(expresion[0]) ;j <= Integer.valueOf(expresion[1]);j++){
										if(linkedList.get(i) == j){//对在修改后规则的优惠码回收
											codeData.put(shopKey + "_rand_" + i, String
													.valueOf(linkedList.get(i)));
											break ;
										}
									}
								}
							}
							OperateTxtData.recoverDidcountCodeData(codeData,
									filePath);
							compRandCode = getDiscountCode(shop,
									null, 0, codeData);
							linkedList.remove(compRandCode);
						} else {
							String sql = "select * from DiscountNumber where shop_id = ? and codeType = 0" ;
							List<DiscountNumber> list_1 = jdbcDaoSupport
							.findTsBySQL(rowMapper, sql, shop.getId());
							if(list_1.size() == 0){
								len = Integer.valueOf(expresion[0])
								+ Integer.valueOf(99);
								Integer num = len > Integer.valueOf(expresion[1]) ? Integer
										.valueOf(expresion[1]) : len;
								OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, shopKey, String.valueOf(num));
								for (int i = Integer.valueOf(expresion[0]); i <= num; i++) {
										codeData.put(shopKey + "_" + i,
												String.valueOf(i));
								}
								OperateTxtData.recoverDidcountCodeData(codeData,
										filePath);
								compRandCode = getDiscountCode(shop,
										null, 0, codeData);
							}else{
								compRandCode = Dictionary.DISCOUNT_CODE_STUTA;
								discountMode.setErrCode(compRandCode);
								return discountMode;
							}
						}
					}
				}
				number = saveDiscountNumber(member, card, shop, compRandCode,
						null,0);
				return new DiscountMode(number.getDiscountNum(), member.getId(), shop.getId(), shop.getName(), 0,
						shop.getPosout(), number.getDiscountNum() != null ? "200" : Dictionary.DISCOUNT_CODE_STUTA);
			}
		}

		return discountMode;
	}

	private void creatNewFile() {
		File file = new File(CONFIG_FILE);
		log.info("****************** enter creatNewFile method ******************") ;	
		if(!file.exists()){
			log.info("****************** file is not exists ******************") ;	
			try {
				file.createNewFile();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else{
			log.info("****************** file is exists ******************") ;	
		}
	}

	public DiscountMode getImpRandCode(Member member, MemberCard card, Shop shop) {
		DiscountNumber number = null;
		Random random = new Random();
		String compRandCode = null ;
		DiscountMode discountMode = new DiscountMode();
		List<DiscountCodeImport> codes = getImpCode(shop);
		if (codes != null && codes.size() > 0) {
			while(true){
				if(codes.size() == 0){
					compRandCode = Dictionary.DISCOUNT_CODE_STUTA;
					discountMode.setErrCode(compRandCode);
					return discountMode;
				}
				int num = random.nextInt(codes.size());
				DiscountCodeImport codeImport = codes.get(num);
				boolean flag = false ;
				RowMapper rowMapper = getRowMapper_discount();
				String sql = "select * from DiscountNumber where expiredDate >= ? and discountNum = ? and shop_id = ? and codeType = 1";
				List<DiscountNumber> list = jdbcDaoSupport.findTsBySQL(rowMapper, sql,new Date(),
						codeImport.getDiscountNum(), shop.getId());
				int count = (( list != null ) ? list.size() : 0 ) ;
				flag = ( count > 0 ) ? true : false ;
				if(!flag){
					String hql = "update DiscountCodeImport set isRecived = ? where id = ? and shopid = ? and discountNum = ? and del = 0";
					hbDaoSupport.executeHQL(hql, 1, codeImport.getId(),shop.getId(),codeImport.getDiscountNum());
					number = saveDiscountNumber(member, card, shop, codeImport.getDiscountNum(), null,1);
					return new DiscountMode(number.getDiscountNum(), member.getId(),
							shop.getId(), shop.getName(), 0, shop.getPosout(), "200");
				}else{
					codes.remove(num);
				}
			}
		}else{
			compRandCode = Dictionary.DISCOUNT_CODE_STUTA;
			discountMode.setErrCode(compRandCode);
			return discountMode;
		} 
	}

	
	@Override
	public DiscountMode getDiscountCode(Member member, MemberCard card,
			Shop shop, ActivityInfo activityInfo, int type) {
		Member mem = null;
		String code = "200";
		DiscountNumber number = null;
		DiscountMode discountMode = new DiscountMode();
		this.removeExpiredCodeToHistroy();
		if (member != null) {
			if (member.getStatus() == Dictionary.MEMBER_STATE_NOACTIVATE) {
				code = Dictionary.MEMBER_STUTA_NOACTIVATE;
				discountMode.setErrCode(code);
				return discountMode;
			} else if (member.getStatus() == Dictionary.MEMBER_STATE_LOGOUT) {
				code = Dictionary.MEMBER_STUTA_LOGOUT;
				discountMode.setErrCode(code);
				return discountMode;
			}
			String hql = "from Member where status = ? and id = ?";
			mem = hbDaoSupport.findTByHQL(hql,
					Dictionary.MEMBER_STATE_ACTIVATE, member.getId());
		} else {
			code = Dictionary.MEMBER_NO_EXISTS;
			discountMode.setErrCode(code);
			return discountMode;
		}

		if (mem != null) {
			if (type == 0) {
				if (shop != null) {
					String tag = shop.getDiscountModel();
					if (tag.equals(String.valueOf(Dictionary.PROME_Code_AUTO))) {
						discountMode = getCompRandCode(member, card, shop);
					} else {
						discountMode = getImpRandCode(member, card, shop);
					}
				} else {
					code = Dictionary.SHOP_NO_EXISTS;
					discountMode.setErrCode(code);
					return discountMode;
				}
				return discountMode;
			} else if (type == 1) {
				Map<String, String> codeData = new HashMap<String, String>();
				String compRandCode = "0";
				if (activityInfo != null) {
					if (activityInfo.getStartDate().after(new Date())) {
						compRandCode = Dictionary.ACTIVITY_NO_START;
						discountMode.setErrCode(compRandCode);
						return discountMode;
					}
					if (activityInfo.getEndDate().before(new Date())) {
						compRandCode = Dictionary.ACTIVITY_END;
						discountMode.setErrCode(compRandCode);
						return discountMode;
					}
					if (activityInfo.getTag() == 0) {
						compRandCode = Dictionary.ACTIVITY_CANCLE;
						discountMode.setErrCode(compRandCode);
						return discountMode;
					}

					String[] expresion = repository.getVariable("expresion")
							.split("~");

					if (expresion != null) {
						String superscript = expresion[0];
						String subscript = expresion[1];
						String activityKey = "rand_act_" + activityInfo.getId();
						String ruleKey_1 = "activity_1_" + activityInfo.getId();
						String ruleKey_2 = "activity_2_" + activityInfo.getId();
						creatNewFile();
						
						String v = OperatePropertiesFile.getValueByPropertyName(CONFIG_FILE, activityKey);
						String ruleSubValue_1 = OperatePropertiesFile.getValueByPropertyName(CONFIG_FILE, ruleKey_1);
						String ruleSubValue_2 = OperatePropertiesFile.getValueByPropertyName(CONFIG_FILE, ruleKey_2);
						if((ruleSubValue_1 != null && !ruleSubValue_1.equals(expresion[0]))  ||  (ruleSubValue_2 != null && !ruleSubValue_2.equals(expresion[1])) ){
							v = null ;
							OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_1, superscript);
							OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_2, superscript);
							String filePath = OperateTxtData.getFilePath(null, activityInfo, 1);
							File file = new File(filePath);
							file.delete();
						}
						Integer len = 0;
						if (v == null) {
							len = Integer.valueOf(expresion[0])
									+ Integer.valueOf(99);
							Integer num = len > Integer.valueOf(expresion[1]) ? Integer
									.valueOf(expresion[1]) : len;
							OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_1, superscript);
							OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, ruleKey_2, subscript);
							OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, activityKey, String.valueOf(num));
							for (int i = Integer.valueOf(expresion[0]); i <= num; i++) {
								codeData.put(activityKey + "_" + i,
										String.valueOf(i));
							}
							compRandCode = getDiscountCode(shop,
									activityInfo, type, codeData);
						} else {
							String filePath = OperateTxtData.getFilePath(null,
									activityInfo, 1);
							Map<String, String> activityCodeData = OperateTxtData
									.getDiscountData(filePath);
							if (activityCodeData.size() <= 10) {

								if (Integer.valueOf(v) < Integer.valueOf(subscript)) {// 当池中还剩10条记录时再生成
									for (int i = Integer.valueOf(v)+1; i < Integer.valueOf(v) + Integer.valueOf(90)
											+ 1
											&& i < Integer.valueOf(subscript) + 1; i++) {
										codeData.put(activityKey + "_" + i,
												String.valueOf(i));
									}
									int num = Integer.valueOf(expresion[1]) - Integer.valueOf(expresion[0]) + 1 ;
									OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, activityKey, String.valueOf((Integer.valueOf(v) + Integer.valueOf(90)) > num ? num : Integer.valueOf(v) + Integer.valueOf(90)));

								}

								OperateTxtData.recoverDidcountCodeData(
										codeData, filePath);

								compRandCode = getDiscountCode(
										shop, activityInfo, type, codeData);
							} else {
								compRandCode = getDiscountCode(
										shop, activityInfo, type, codeData);
							}
							if (activityCodeData.size() == 0) {// 区间内没有数据可以生成，那么就对已过期的优惠码进行回收

								Date now_date = new Date();
								RowMapper rowMapper = getRowMapper_discount();
								RowMapper rowMapper_his = getRowMapper_discountHistroy();

								String hql = "select * from DiscountNumber d where d.expiredDate <= ? and d.activityInfo_id = ? and d.codeType = 0  or d.state = 1 and d.activityInfo_id = ? and d.expiredDate >= now()";
								String his_hql = "select * from DiscountNumberHistory d where d.expiredDate between DATE_SUB(now(), INTERVAL '3' DAY_HOUR) and now() and d.activityInfo_id = ? and d.codeType = 0  or d.status = 1 and d.activityInfo_id = ? and d.expiredDate >= now()";
								
								LinkedList<Integer> codeList = new LinkedList<Integer>(); // 存储回收的优惠码数据

								List<DiscountNumber> list = jdbcDaoSupport
										.findTsBySQL(rowMapper, hql, now_date,
												activityInfo.getId(),activityInfo.getId());
								List<DiscountNumberHistory> his_list = jdbcDaoSupport
										.findTsBySQL(rowMapper_his, his_hql,
												activityInfo.getId(),activityInfo.getId());
								if (list != null && list.size() > 0) {
									for (DiscountNumber dn : list) {
										boolean flag = gcCodeCheck(dn.getDiscountNum(), activityInfo.getId(), 1);
										if(!flag){
											codeList.add(Integer.valueOf(dn
													.getDiscountNum()));
										}
									}
									gcRecord.put(activityKey, codeList);
								}

								if (his_list != null && his_list.size() > 0) {
									for (DiscountNumberHistory dn : his_list) {
										boolean flag = gcCodeCheck(dn.getDiscountNum(), activityInfo.getId(), 1);
										if(!flag){
											codeList.add(Integer.valueOf(dn
													.getDiscountNum()));
										}
									}
									gcRecord.put(activityKey, codeList);
								}
								LinkedList<Integer> linkedList = gcRecord.get(activityKey) ;
								if (linkedList != null && linkedList.size() > 0) {
									Set<Integer> set = new HashSet<Integer>(linkedList);
									linkedList.clear();
									linkedList.addAll(set);
									for (int i = 0; i < 100; i++) {
										if(i < linkedList.size()){
											for(int j = Integer.valueOf(expresion[0]) ;j <= Integer.valueOf(expresion[1]);j++){
												if(linkedList.get(i) == j){//对在修改后规则的优惠码回收
													codeData.put(
															activityKey + "_" + i,
															String.valueOf(linkedList.get(i)));
													break ;
												}
											}
											
										}
									}
									compRandCode = getDiscountCode(shop,
													activityInfo, type,
													codeData);
									linkedList.remove(compRandCode);
								} else {
									String sql = "select * from DiscountNumber where activityInfo_id = ?" ;
									List<DiscountNumber> list_1 = jdbcDaoSupport
									.findTsBySQL(rowMapper, sql, activityInfo.getId());
									if(list_1.size() == 0){
										len = Integer.valueOf(expresion[0])
										+ Integer.valueOf(99);
										Integer num = len > Integer.valueOf(expresion[1]) ? Integer
												.valueOf(expresion[1]) : len;
										OperatePropertiesFile.changeValueByPropertyName(CONFIG_FILE, activityKey, String.valueOf(num));
										for (int i = Integer.valueOf(expresion[0]); i <= num; i++) {
											codeData.put(activityKey + "_" + i,
													String.valueOf(i));
										}
										OperateTxtData.recoverDidcountCodeData(codeData,
												filePath);
										compRandCode = getDiscountCode(shop,
												activityInfo, type, codeData);
									}else{
										compRandCode = Dictionary.DISCOUNT_CODE_STUTA;
										discountMode.setErrCode(compRandCode);
										return discountMode;
									}
									
								}
							}
						}
					}

					number = saveDiscountNumber(member, card, shop,
							compRandCode, activityInfo,0);
				} else {
					compRandCode = Dictionary.ACTIVITY_NO_EXISTS;
					discountMode.setErrCode(compRandCode);
					return discountMode;
				}
				return new DiscountMode(number.getDiscountNum(),member.getId(), activityInfo.getId(),
						activityInfo.getActivityName(), 0,
						activityInfo.getDescr(), number.getDiscountNum() != null ? "200" : Dictionary.DISCOUNT_CODE_STUTA);
			}
		}

		return new DiscountMode();
	}

	/**
	 * 随机生成优惠码
	 */
	public String getDiscountCode(Shop shop, ActivityInfo activityInfo,
			int type, Map<String, String> initdata) {
		OperateTxtData.insert(initdata, shop, activityInfo, type);
		Random random = new Random();
		List<String> list = new ArrayList<String>();
		String filePath = null;
		filePath = OperateTxtData.getFilePath(shop, activityInfo, type);
		try {
			Map<String, String> data = OperateTxtData.getDiscountData(filePath);
			if(data.size() == 0){
				data = initdata ;
			}
			Set<Map.Entry<String, String>> set = data.entrySet();
			for (Iterator<Map.Entry<String, String>> it = set.iterator(); it
					.hasNext();) {
				Map.Entry<String, String> entry = (Map.Entry<String, String>) it
						.next();
				list.add(entry.getKey());
			}
			if (list != null && list.size() > 0) {
				
				List<DiscountNumber> numbers = null ;
				while(true){
					if(list.size() == 0){
						break ;
					}
					String value = null;
					int num = random.nextInt(list.size());
					String randomKey = list.get(num);
					value = data.get(randomKey);
					if(type == 0){
						numbers = jdbcDaoSupport.findTsBySQL(DiscountNumber.class, "select * from DiscountNumber where shop_id = ? and discountNum = ? and expiredDate >= ? and codeType = 0 ", shop.getId(),value,new Date());
						if(numbers != null && numbers.size() > 0){
							OperateTxtData.delete(randomKey, filePath, shop, activityInfo,
									type);
							list.remove(num);
							continue ;
						}else{
							OperateTxtData.delete(randomKey, filePath, shop, activityInfo,
									type);
							list.remove(num);
							return value;
						}
					}else{
						numbers = jdbcDaoSupport.findTsBySQL(DiscountNumber.class, "select * from DiscountNumber where activityInfo_id = ? and discountNum = ? and expiredDate >= ?", activityInfo.getId(),value,new Date());
						if(numbers != null && numbers.size() > 0){
							OperateTxtData.delete(randomKey, filePath, shop, activityInfo,
									type);
							list.remove(num);
							continue ;
						}else{
							list.remove(num);
							OperateTxtData.delete(randomKey, filePath, shop, activityInfo,
									type);
							return value;
						}
					}
				}
			} 
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 把生成的优惠码插到数据库中
	 */
	public DiscountNumber saveDiscountNumber(Member member, MemberCard card,
			Shop shop, String code, ActivityInfo activityInfo,int codeType) {
		DiscountNumber number = new DiscountNumber();
		Date now_time = new Date();
		if (code != null
				&& !code.equals(String.valueOf(Dictionary.DISCOUNT_CODE_STUTA))
				&& !code.equals(String
						.valueOf(Dictionary.MEMBER_STUTA_NOACTIVATE))) {
			if (shop != null) {
				number.setDiscountNum(code);
				number.setGeneratedDate(now_time);
				Calendar cal = Calendar.getInstance();
				cal.setTime(now_time);
				cal.add(Calendar.HOUR_OF_DAY, Integer.valueOf(SystemParamsConfig.getSysVariableValue("expirTime")));
				number.setExpiredDate(cal.getTime());// 默认3小时后过期
				number.setMember(member);
				number.setDescr(shop.getPrivilegeDesc());
				number.setShop(shop);
				number.setTitle(shop.getPrivilegeTile());
				number.setPosDescr(shop.getPosout());
				number.setState(0);
				number.setCodeType(codeType);
				hbDaoSupport.save(number);
			}

			if (activityInfo != null) {
				number.setDiscountNum(code);
				number.setGeneratedDate(now_time);
				Calendar cal = Calendar.getInstance();
				cal.setTime(now_time);
				cal.add(Calendar.HOUR_OF_DAY, 3);
				number.setExpiredDate(cal.getTime());// 默认3小时后过期
				number.setMember(member);
				number.setActivityInfo(activityInfo);
				number.setTitle(activityInfo.getTitle());
				number.setDescr(activityInfo.getDescr());
				number.setPosDescr(activityInfo.getPosDescr());
				number.setState(0);
				number.setCodeType(codeType);
				hbDaoSupport.save(number);
			}
		}
		// startThread(number);
		return number;
	}

	/**
	 * 启动一条线程，每隔5秒定时检查一遍数据 用于处理失效后优惠码
	 */
	public void startThread(DiscountNumber number) {
		ScheduledThreadPoolExecutor scheduledThreadPool = new ScheduledThreadPoolExecutor(
				30);
		scheduledThreadPool.scheduleAtFixedRate(new ThreadPoolTask(number,
				hbDaoSupport), 1000, 5000, TimeUnit.MILLISECONDS);
	}

	/**
	 * 根据门店ID查找所有的导入优惠码信息
	 * 
	 * @param shop
	 *            门店对象
	 */
	public List<DiscountCodeImport> getImpCode(Shop shop) {

		String hql = "select * from DiscountCodeImport where shopId = ? and del = 0 and isRecived = 0";
		RowMapper rowMapper = getRowMapper();
		List<DiscountCodeImport> codes = jdbcDaoSupport.findTsBySQL(rowMapper,
				hql, shop.getId());
		return codes;
	}

	private RowMapper getRowMapper() {
		RowMapper rowMapper = new RowMapper<DiscountCodeImport>() {

			@Override
			public DiscountCodeImport mapRow(ResultSet rs, int arg1)
					throws SQLException {
				DiscountCodeImport discountCodeImport = new DiscountCodeImport();
				try {
					SimpleDateFormat sdf = new SimpleDateFormat(
							"yyyy-MM-dd HH:mm:ss");

					discountCodeImport.setId(rs.getInt("id"));
					discountCodeImport.setDel(rs.getInt("del"));
					discountCodeImport.setDiscountNum(rs
							.getString("discountNum"));
					discountCodeImport.setImportDate(sdf.parse(rs
							.getString("importDate")));
					discountCodeImport.setIsRecived(rs.getInt("isRecived"));
					discountCodeImport.setNote(rs.getString("note"));
					discountCodeImport.setShopId(rs.getInt("shopId"));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return discountCodeImport;
			}
		};
		return rowMapper;
	}

	private RowMapper getRowMapper_discount() {
		RowMapper rowMapper = new RowMapper<DiscountNumber>() {

			@Override
			public DiscountNumber mapRow(ResultSet rs, int arg1)
					throws SQLException {
				DiscountNumber discountNumber = new DiscountNumber();
				try {
					SimpleDateFormat sdf = new SimpleDateFormat(
							"yyyy-MM-dd HH:mm:ss");
					discountNumber.setId(rs.getInt("id"));
					discountNumber.setDescr(rs.getString("descr"));
					discountNumber.setDiscountNum(rs.getString("discountNum"));
//					 discountNumber.setActivityInfo((ActivityInfo)rs.getObject("activityInfo"));
					discountNumber.setExpiredDate(sdf.parse(rs
							.getString("expiredDate")));
					discountNumber.setGeneratedDate(sdf.parse(rs
							.getString("generatedDate")));
//					 discountNumber.setMember((Member)rs.getObject("member"));
					discountNumber.setPosDescr(rs.getString("posDescr"));
//					 discountNumber.setSerialId(rs.getLong("serialId"));
//					 discountNumber.setShop((Shop)rs.getObject("shop"));
					discountNumber.setState(rs.getInt("state"));
					discountNumber.setTitle(rs.getString("title"));

				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return discountNumber;
			}
		};
		return rowMapper;
	}

	private RowMapper getRowMapper_discountHistroy() {
		RowMapper rowMapper = new RowMapper<DiscountNumberHistory>() {

			@Override
			public DiscountNumberHistory mapRow(ResultSet rs, int arg1)
					throws SQLException {
				DiscountNumberHistory history = new DiscountNumberHistory();
				try {
					SimpleDateFormat sdf = new SimpleDateFormat(
							"yyyy-MM-dd HH:mm:ss");

					history.setId(rs.getInt("id"));
					history.setDescription(rs.getString("description"));
					history.setDiscountNum(rs.getString("discountNum"));
//					 history.setActivityInfo((ActivityInfo)rs.getObject("activityInfo"));
					history.setExpiredDate(sdf.parse(rs
							.getString("expiredDate")));
					history.setGeneratedDate(sdf.parse(rs
							.getString("generatedDate")));
//					 history.setMember((Member)rs.getObject("member"));
					history.setPosDescr(rs.getString("posDescr"));
					// history.setSerialId(rs.getLong("serialId"));
//					 history.setShop((Shop)rs.getObject("shop"));
					history.setOrderId(rs.getString("orderId"));
//					history.setSource(rs.getInt("source"));
					history.setStatus(rs.getInt("status"));
					history.setTitle(rs.getString("title"));
					history.setMoney(rs.getDouble("money"));
					history.setTransactionNO(rs.getString("transactionNO"));
					if(rs.getString("usedDate") != null){
						history.setUsedDate(sdf.parse(rs.getString("usedDate")));
					}
					
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return history;
			}
		};
		return rowMapper;
	}

	/**
	 * 对优惠码的使用状态进行校验
	 * 
	 * @param code
	 *            优惠码
	 * @return flag true:表示此优惠码已经被使用;false:没被使用
	 */
	public boolean isUseCode(String code) {
		removeExpiredCodeToHistroy();
		Date now_time = new Date();
		boolean flag = false;
		String hql = "from DiscountNumber where discountNum = ? ";
		DiscountNumber number = hbDaoSupport.findTByHQL(hql, code);
		if (number != null) {
			Date expiredTime = number.getExpiredDate();
			flag = now_time.before(expiredTime);
		}
		return flag;
	}

	private int isNoImpCode(Shop shop) {
		String hql = "from DiscountCodeImport where shopId = ? and del = 0";
		List<DiscountCodeImport> codes = hbDaoSupport.findTsByHQL(hql,
				shop.getId());
		return codes.size();
	}

	@Override
	public boolean checkDiscountCode(VerifyDiscountReq verifyDiscountReq, PosBind pb,int id,Shop shop) {
		this.removeExpiredCodeToHistroy();

		boolean checkResult = true;
		String hql1 = "";
		
		DiscountNumber number=null;
		
		 if(pb.getMark()==0){
	    	    hql1 = "from DiscountNumber where discountNum = ? and activityInfo_id = ? ";
	    	     number = hbDaoSupport.findTByHQL(hql1,
	    	    		 verifyDiscountReq.getDiscountCode(),id);
	       }else if(pb.getMark()==1){
	    	   hql1 = "from DiscountNumber where discountNum = ? and shop_id =? and codeType=?";
	    	   number = hbDaoSupport.findTByHQL(hql1,
	    			   verifyDiscountReq.getDiscountCode(),id,Integer.valueOf(shop.getDiscountModel()));
	       }
		
	
		
		
		if (number == null) {
			checkResult = false;
		} else {
			if (number.getExpiredDate() != null) {
				if (DateTools.compareDay(new Date(), number.getExpiredDate())) {
					// 修改状态
					StringBuffer hql2 = new StringBuffer();
					
					hql2.append("update DiscountNumber set state=:state where discountNum=:discountNum  ");
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("discountNum", verifyDiscountReq.getDiscountCode());
					map.put("state", 1);
				
					  if(pb.getMark()==0){
				    	    hql2.append(" and activityInfo_id=:activityInfo_id  ") ;
				    	    map.put("activityInfo_id", id);
				       }else if(pb.getMark()==1){
				    	   hql2.append(" and shop_id=:shop_id  ") ;
				    	   map.put("shop_id", id);
				    	   hql2.append(" and codeType=:codeType  ") ;
				    	   map.put("codeType", Integer.valueOf(shop.getDiscountModel()));
				       }
					map.put("discountNum",verifyDiscountReq.getDiscountCode());
					map.put("state", 1);
					hbDaoSupport.executeHQL(hql2.toString(), map);
					

					// 移到历史表
					DiscountNumberHistory history = new DiscountNumberHistory();
					history.setId(number.getId());
					history.setDescription(number.getDescr());
					history.setDiscountNum(number.getDiscountNum());
					history.setExpiredDate(number.getExpiredDate());
					history.setGeneratedDate(number.getGeneratedDate());
					history.setMember(number.getMember());
					history.setShop(number.getShop());
					history.setStatus(1);
					history.setTitle(number.getTitle());
					history.setUsedDate(new Date());
					history.setSerialId(verifyDiscountReq.getSerialId());
					history.setMoney(verifyDiscountReq.getMoney());
					history.setTransactionNO(verifyDiscountReq
							.getTransactionNO());
					history.setPosDescr(number.getPosDescr());
					history.setActivityInfo(number.getActivityInfo());
					history.setCodeType(number.getCodeType());
					hbDaoSupport.save(history);

					// 删除
					String delHql = "delete from DiscountNumber where id = ?";
					hbDaoSupport.executeHQL(delHql, number.getId());

				} else {
					checkResult = false;
				}
			}
		}
		return checkResult;
	}

	@Override
	public Map selDiscountByCode(String code, int id,Integer couponType,Shop shop) {
		Map map = new HashMap();
		if(couponType==1){//优惠码类型( 0--活动；1--门店）
			String hql1 = "from DiscountNumber where discountNum = ? and shop.id=?";
			List<DiscountNumber> discountshop = hbDaoSupport.findTsByHQL(hql1, code, id);
			map.put("discount", discountshop);
			
			String hql11 = "from DiscountNumberHistory where discountNum = ? and shop.id=? and codeType=?  order by generatedDate desc limit 1";
			DiscountNumberHistory hdiscountshop = hbDaoSupport.findTByHQL(hql11,
					code, id,Integer.valueOf(shop.getDiscountModel()));
			map.put("discounthistory", hdiscountshop);
			
		}else if(couponType==0){
			String hql2 = "from DiscountNumber where discountNum = ? and activityInfo.id=?";
			List<DiscountNumber> discountact = hbDaoSupport.findTsByHQL(hql2, code, id);
			map.put("discount", discountact);

			String hql12 = "from DiscountNumberHistory where discountNum = ? and activityInfo.id=?  order by generatedDate desc limit 1";
			DiscountNumberHistory hdiscountact = hbDaoSupport.findTByHQL(hql12,		code, id);
			map.put("discounthistory", hdiscountact);
		}
		return map;
	}

	@Override
	public void removeExpiredCodeToHistroy() {
		Date now_date = new Date();
		String hql = "from DiscountNumber where expiredDate <= ? or state=1";
		List<DiscountNumber> list = hbDaoSupport.findTsByHQL(hql, now_date);
		if (list != null && list.size() > 0) {
			for (DiscountNumber number : list) {
				DiscountNumberHistory history = new DiscountNumberHistory();
				history.setId(number.getId());
				history.setDescription(number.getDescr());
				history.setDiscountNum(number.getDiscountNum());
				history.setExpiredDate(number.getExpiredDate());
				history.setGeneratedDate(number.getGeneratedDate());
				history.setMember(number.getMember());
				history.setShop(number.getShop());
				history.setStatus((number.getState() == null ? 0 : number
						.getState()));
				history.setTitle(number.getTitle());
				history.setSerialId(number.getSerialId());
				history.setPosDescr(number.getPosDescr());
				history.setActivityInfo(number.getActivityInfo());
				history.setCodeType(number.getCodeType());
				try {
					hbDaoSupport.save(history);
					String delHql = "delete from DiscountNumber where id = ?";
					hbDaoSupport.executeHQL(delHql, number.getId());   
//					if(number.getCodeType() == 1){
//						String updatehql = "update DiscountCodeImport set isRecived = ? where shopid = ? and discountNum = ? ";
//						hbDaoSupport.executeHQL(updatehql, 0,number.getShop().getId(),number.getDiscountNum());
//					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	@Override
	public DiscountNumberHistory getDiscountBySerialId(long serialId) {
		String hql = "from DiscountNumberHistory where serialId = ? and  NOW()-usedDate <=1 order by generatedDate desc limit 1";
		DiscountNumberHistory number = hbDaoSupport.findTByHQL(hql, serialId);
		return number;
	}

	@Override
	public Map selDiscountByCode(String code, Integer codetype,String shopOrActivityId,Shop shop ) {
		Map map = new HashMap();
		if (codetype == 1) {
			
			String hql1 = "from DiscountNumber where discountNum = ? and shop.id = ? ";
			List<DiscountNumber> discountshop = hbDaoSupport.findTsByHQL(hql1, code,Integer.valueOf(shopOrActivityId));
			map.put("discount", discountshop);

			String hql11 = "from DiscountNumberHistory where discountNum = ? and shop.id = ?  and codeType=?  order by generatedDate desc limit 1";
			DiscountNumberHistory hdiscountshop = hbDaoSupport.findTByHQL(
					hql11, code,Integer.valueOf(shopOrActivityId),Integer.valueOf(shop.getDiscountModel()));
			map.put("discounthistory", hdiscountshop);
		} else {
			String hql2 = "from DiscountNumber where discountNum = ? and activityInfo.id =?";
			List<DiscountNumber>  discountact= hbDaoSupport.findTsByHQL(hql2, code,Integer.valueOf(shopOrActivityId));
			map.put("discount", discountact);

			String hql12 = "from DiscountNumberHistory where discountNum = ? and activityInfo.id =? order by generatedDate desc limit 1";
			DiscountNumberHistory hdiscountact = hbDaoSupport.findTByHQL(hql12,
					code,Integer.valueOf(shopOrActivityId));
			map.put("discounthistory", hdiscountact);
		}

		return map;
	}

	
	@Override
	public List<DiscountNumberReport> findDiscountToReport(
			DiscountNumberHistory discount, Page page) {
		List<DiscountNumberReport> mlist=new ArrayList<DiscountNumberReport>();
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		StringBuffer sqlCount = new StringBuffer();
		StringBuffer sql = new StringBuffer();
//		sql.append("select discount.id,discount.`discountNum`,discount.`expiredDate`,discount.`status`,discount.shop_id,discount.activityInfo_id,concat_ws('',s.`name`,ai.`activityName`) as shopActivityName,s.`name` as shopName,ai.`activityName` ,discount.member_id,"+
//                     "discount.description,date_format(discount.`usedDate`,'%Y-%m-%d %H:%i:%s') as usedDate,discount.`transactionNO`,CONCAT(m.`surname`,m.`name`) as memberName,mc.cardNumber as memberCard "+
//					"FROM( "+
//					 "   select dnh.`id`,dnh.shop_id,dnh.activityInfo_id,dnh.`expiredDate`,dnh.`member_id`,dnh.`discountNum`,dnh.`status` ,dnh.`description`,dnh.usedDate,dnh.transactionNO "+
//					  "  from DiscountNumberHistory    dnh "+
//					   " UNION all "+
//					    "select     dn.`id`,dn.shop_id,dn.activityInfo_id,dn.`expiredDate`,dn.`member_id`,dn.`discountNum`,dn.state as status ,dn.descr as description ,null,null "+
//					    "from   DiscountNumber        dn "+
//					  ")  discount "+
//					" left join  "+ 
//					"    `Member`  m "+ 
//					" on  "+ 
//					"   m.id=discount.member_id       "+        
//					" left join  "+ 
//					"   `MemberCard` mc "+ 
//					" on  "+ 
//					"    m.`card_id` =mc.`id` "+ 
//					" left join  "+ 
//					"   `Shop`  s "+ 
//					" on  "+ 
//					"    s.`id`=discount.shop_id "+ 
//					" left join  "+ 
//					"   `ActivityInfo`  ai "+ 
//					" on  "+ 
//					"   ai.`id`=discount.activityInfo_id where 1=1 "
//		);
	
//		sqlCount.append("SELECT count(discount.id) "+
//				"FROM( "+
//				 "   select dnh.`id`,dnh.shop_id,dnh.activityInfo_id ,dnh.expiredDate,dnh.`member_id`,dnh.`discountNum`,dnh.`status`,dnh.`description` "+
//				  "  from DiscountNumberHistory    dnh "+
//				   " UNION all "+
//				    "select     dn.`id`,dn.`shop_id`,dn.`activityInfo_id` ,dn.expiredDate,dn.`member_id`,dn.`discountNum`,dn.state as status,dn.descr as description "+
//				    "from   DiscountNumber        dn "+
//				  ")  discount "+
//				  " left join  "+ 
//					"   `Shop`  s "+ 
//					" on  "+ 
//					"    s.`id`=discount.shop_id "+ 
//					" left join  "+ 
//					"   `ActivityInfo`  ai "+ 
//					" on  "+ 
//					"   ai.`id`=discount.activityInfo_id where 1=1 ");
		sql.append("select discount.id,discount.`discountNum`,discount.`expiredDate`,discount.`status`,discount.shop_id,discount.activityInfo_id,concat_ws('',s.`name`,ai.`activityName`) as shopActivityName,s.`name` as shopName,ai.`activityName` ,discount.member_id,"+
                "discount.description,date_format(discount.`usedDate`,'%Y-%m-%d %H:%i:%s') as usedDate,discount.`transactionNO`,CONCAT(m.`surname`,m.`name`) as memberName,mc.cardNumber as memberCard "+
				"FROM "+
				  
				  " DiscountNumberReport discount "+
				" left join  "+ 
				"    `Member`  m "+ 
				" on  "+ 
				"   m.id=discount.member_id       "+        
				" left join  "+ 
				"   `MemberCard` mc "+ 
				" on  "+ 
				"    m.`card_id`=mc.`id` "+ 
				" left join  "+ 
				"   `Shop`  s "+ 
				" on  "+ 
				"    s.`id`=discount.shop_id "+ 
				" left join  "+ 
				"   `ActivityInfo`  ai "+ 
				" on  "+ 
				"   ai.`id`=discount.activityInfo_id where 1=1 "
	);
		sqlCount.append("SELECT count(discount.id) "+
				"FROM "+
				 "   DiscountNumberReport  discount "+
				  " left join  "+ 
					"   `Shop`  s "+ 
					" on  "+ 
					"    s.`id`=discount.shop_id "+ 
					" left join  "+ 
					"   `ActivityInfo`  ai "+ 
					" on  "+ 
					"   ai.`id`=discount.activityInfo_id where 1=1 ");
			
		
		if (discount.getStatus()!=null&&discount.getStatus()!=3) {
			if(discount.getStatus()==0){
				sql.append(" and  discount.status=0 and  discount.`expiredDate` > NOW() ");
				sqlCount.append(" and  discount.status=0 and  discount.`expiredDate` > NOW() ");
			}else if(discount.getStatus()==1){
				sql.append(" and  discount.status=1 ");
				sqlCount.append(" and  discount.status=1 ");
			}else if(discount.getStatus()==2){
				sql.append(" and  discount.`expiredDate` < NOW() and discount.`status`!=1 ");
				sqlCount.append(" and  discount.`expiredDate` < NOW() and discount.`status`!=1 ");
			}
		}
		if(discount.getSource()!=null&&discount.getSource()!=0){
			if(discount.getSource()==1){//门店
				sql.append(" and    discount.shop_id!=0");
				sqlCount.append(" and   discount.shop_id!=0");
			}
            if(discount.getSource()==2){//活动
            	sql.append(" and  discount.activityInfo_id!=0");
    			sqlCount.append(" and discount.activityInfo_id!= 0");
			}
		}
		if(!"".equals(discount.getShopActivityName())&&discount.getShopActivityName()!=null){
			sql.append(" and   s.`name` like ? or  ai.`activityName`   like ?");
			sqlCount.append(" and   s.`name` like ? or  ai.`activityName`   like ?");
			args.add("%" + discount.getShopActivityName()+"%" );
			args.add("%" + discount.getShopActivityName()+"%" );
			argsCount.add("%" + discount.getShopActivityName()+"%" );
			argsCount.add("%" + discount.getShopActivityName()+"%" );
		}
		//sql.append(" order by  discount.usedDate  desc  ,discount.member_id  asc  ");
		sql.append(" order by  discount.usedDate  desc    ");
		sql.append(" LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		if(argsCount.size()>0){
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
		}else{
			page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
		}
		mlist = jdbcDaoSupport.findTsBySQL(DiscountNumberReport.class, sql.toString(),args.toArray());
		List<DiscountNumberReport> list=new ArrayList<DiscountNumberReport>();
		for(DiscountNumberReport d:mlist){
			if(d.getStatus()==0){
				if(d.getExpiredDate()!=null){
					if(DateTools.compareDay(new Date(), d.getExpiredDate())==false){
						d.setStatus(2);
				   }	
				}
			}
			list.add(d);
		}
		
	////////	
//		for(int i=200000;i<260000;i++){
//			Member member=new Member();
//			member.setId(100171);//
//			MemberCard card=new MemberCard();
//			card.setCardNumber("111111");//
//			Shop shop=new Shop();
//			shop.setId(10);//
//			String code=Integer.valueOf(i).toString();
//			ActivityInfo activityInfo=null;
//		//	activityInfo.setId(id);//
//			int codeType=0;
//			 saveDiscountNumber( member,  card,
//					  shop,  code,  activityInfo, codeType);
//		}
       return list;
	}

	@Override
	public void useDiscountNumber(DiscountUseCodeReq req,Shop shop) {
		this.removeExpiredCodeToHistroy();
		String hql1="";
		DiscountNumber number=null;
       if(req.getCouponType()==0){
    	    hql1 = "from DiscountNumber where discountNum = ? and member_id=? and activityInfo_id = ? ";
    	     number = hbDaoSupport.findTByHQL(hql1,
    				req.getCouponCode(), req.getUserId(),req.getShopOrActivityId());
       }else if(req.getCouponType()==1){
    	   hql1 = "from DiscountNumber where discountNum = ? and member_id=? and shop_id =? and codeType=?";
    	   number = hbDaoSupport.findTByHQL(hql1,
   				req.getCouponCode(), req.getUserId(),req.getShopOrActivityId(),Integer.valueOf(shop.getDiscountModel()));
       }
		
		if (number != null) {
			if (number.getExpiredDate() != null) {
				if (DateTools.compareDay(new Date(), number.getExpiredDate())) {
					// 修改状态
					StringBuffer hql2 = new StringBuffer();
					 hql2.append("update DiscountNumber set state=:state where discountNum=:discountNum and member_id=:member_id");
					Map<String, Object> map = new HashMap<String, Object>();
					
					  if(req.getCouponType()==0){
				    	    hql2.append(" and activityInfo_id=:activityInfo_id  ") ;
				    	    map.put("activityInfo_id", req.getShopOrActivityId());
				       }else if(req.getCouponType()==1){
				    	   hql2.append(" and shop_id=:shop_id  ") ;
				    	   map.put("shop_id", req.getShopOrActivityId());
				    	   hql2.append(" and codeType=:codeType  ") ;
				    	   map.put("codeType", Integer.valueOf(shop.getDiscountModel()));
				       }
					map.put("discountNum", req.getCouponCode());
					map.put("state", 1);
					map.put("member_id", req.getUserId());
					hbDaoSupport.executeHQL(hql2.toString(), map);
					// 移到历史表
					DiscountNumberHistory history = new DiscountNumberHistory();
					history.setId(number.getId());
					history.setDescription(number.getDescr());
					history.setDiscountNum(number.getDiscountNum());
					history.setExpiredDate(number.getExpiredDate());
					history.setGeneratedDate(number.getGeneratedDate());
					history.setMember(number.getMember());
					history.setShop(number.getShop());
					history.setStatus(1);
					history.setTitle(number.getTitle());
					history.setUsedDate(new Date());
					// history.setSerialId(verifyDiscountReq.getSerialId());
					// history.setMoney(verifyDiscountReq.getMoney());
					history.setTransactionNO(req.getTransactionNO());
					history.setPosDescr(number.getPosDescr());
					history.setActivityInfo(number.getActivityInfo());
					history.setOrderId(req.getOrderId());
					history.setCodeType(number.getCodeType());
					hbDaoSupport.save(history);
					// 删除
					String delHql = "delete from DiscountNumber where id = ?";
					hbDaoSupport.executeHQL(delHql, number.getId());
				}
			}
		}
	}

	@Override
	public boolean gcCodeCheck(String code, Integer id, Integer type) {
		String sql = null;
		boolean flag = false ;
		Date now_date = new Date();
		RowMapper rowMapper = getRowMapper_discount();
		if (type == 0) {
			sql = "select * from DiscountNumber where expiredDate >= ? and discountNum = ? and shop_id = ? and codeType = 0";
		} else {
			sql = "select * from DiscountNumber where expiredDate >= ? and  discountNum = ? and activityInfo_id = ?";
		}

		List<DiscountNumber> list = jdbcDaoSupport.findTsBySQL(rowMapper, sql,now_date,
				code, id);
		if(list != null && list.size() > 0){
			flag = true ;
		}
		return flag;
	}


	@Override
	public List<DiscountNumberReport> getDiscountReport(
			DiscountNumberHistory discount) {
	    List<DiscountNumberReport> mlist=new ArrayList<DiscountNumberReport>();
	
		List<Object> args = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		sql.append("select discount.`discountNum`,discount.`expiredDate`,discount.`status`,concat_ws('',s.`name`,ai.`activityName`) as shopActivityName,s.`name` as shopName,ai.`activityName` ,"+
                     "discount.description,discount.`usedDate`,discount.`transactionNO`,CONCAT(m.`surname`,m.`name`) as memberName,mc.cardNumber as memberCard "+
					"FROM "+
					  " DiscountNumberReport  discount "+
					" left join  "+ 
					"   `Shop`  s "+ 
					" on  "+ 
					"    s.`id`=discount.shop_id "+ 
					" left join  "+ 
					"   `ActivityInfo`  ai "+ 
					" on  "+ 
					"   ai.`id`=discount.activityInfo_id  "+
					" left join  "+ 
					"    `Member`  m "+ 
					" on  "+ 
					"   m.id=discount.member_id   "+   
					" left join  "+ 
					"   `MemberCard` mc "+ 
					" on  "+ 
					"    m.`card_id`=mc.`id` "+ 
					" where 1=1 "
		);
		
		
		if (discount.getStatus()!=null&&discount.getStatus()!=3) {
			// 优惠码状态: 0未使用、1已使用
			if(discount.getStatus()==0){
				sql.append(" and  discount.status=0 and  discount.`expiredDate` > NOW() ");
			}else if(discount.getStatus()==1){
				sql.append(" and  discount.status=1 ");
			}else if(discount.getStatus()==2){
				sql.append(" and  discount.`expiredDate` < NOW() and discount.`status`!=1 ");
			}
		}
		if(discount.getSource()!=null&&discount.getSource()!=0){
			if(discount.getSource()==1){//门店
				sql.append(" and    discount.shop_id!=0");
			}
            if(discount.getSource()==2){//活动
            	sql.append(" and  discount.activityInfo_id!=0");
			}
		}
		if(!"".equals(discount.getShopActivityName())&&discount.getShopActivityName()!=null){
			sql.append(" and   s.`name` like ? or  ai.`activityName`   like ?");
			args.add("%" + discount.getShopActivityName()+"%" );
			args.add("%" + discount.getShopActivityName()+"%" );
		}
	//	sql.append(" order by  discount.usedDate  desc  ");
		sql.append("   LIMIT ?,?");
		args.add(discount.getPaginationDetail().getStart());
		args.add(discount.getPaginationDetail().getRows());
		long d1=System.currentTimeMillis();
		RowMapper rowMapper = getRowDiscountMapper();
		mlist = jdbcDaoSupport.findTsBySQL(DiscountNumberReport.class, sql.toString(),args.toArray());
		long d2=System.currentTimeMillis();
	
		List<DiscountNumberReport> list=new ArrayList<DiscountNumberReport>();
				for(DiscountNumberReport d:mlist){
					if(d.getStatus()==0){
						if(d.getExpiredDate()!=null){
							if(DateTools.compareDay(new Date(), d.getExpiredDate())==false){
								d.setStatus(2);
						   }	
						}
					}
					list.add(d);
				}
		return list;
	}
	
	private RowMapper getRowDiscountMapper() {
		RowMapper rowMapper = new RowMapper<DiscountNumberReport>() {
			@Override
			public DiscountNumberReport mapRow(ResultSet rs, int arg1)
					throws SQLException {
				DiscountNumberReport report = new DiscountNumberReport();
				 report.setStatus(rs.getInt("status"));
				 report.setShopActivityName(rs.getString("shopActivityName"));
				 report.setMemberName(rs.getString("memberName"));
				 report.setMemberCard(rs.getString("memberCard"));
				 report.setTransactionNO(rs.getString("transactionNO"));
				 report.setUsedDate(rs.getDate("usedDate"));
				 report.setDiscountNum(rs.getString("discountNum"));
				 report.setDescription(rs.getString("description"));
				 report.setExpiredDate(rs.getDate("expiredDate"));
				return report;
			}
		};
		return rowMapper;
	}

	@Override
	public DiscountUseCodeResp useDiscountNumber2(DiscountUseCodeReq req) {
		// result( 0: 优惠码不存在,1:成功  , 2,暂无优惠活动,3：门店或活动不存在,4:优惠码已使用,5:优惠码已过期,6:
		// 该活动已结束！，7:该活动已取消 ;8:该活动未开始;9：用户不存在；10：会员id不能为空；11：该会员未激活； 12:请输入门店id或活动id;13:优惠码不能为空；14.优惠码类型输入错误；15.该会员已删除;other:非业务类错误)
		DiscountUseCodeResp vrp = new DiscountUseCodeResp();
		vrp.setCouponCode(req.getCouponCode());
		vrp.setIsRepeat(0);
		//Verifying Interface Parameters
		if(StringUtil.isEmptyString(req.getUserId())){
			vrp.setUsedState("10");
			vrp.setUsedDescription("会员id不能为空！");
		}else if(StringUtil.isEmptyString(req.getShopOrActivityId())){
			vrp.setUsedState("12");
			vrp.setUsedDescription("请输入门店id或活动id");
		}else if(StringUtil.isEmptyString(req.getCouponCode())){
			vrp.setUsedState("13");
			vrp.setUsedDescription("优惠码不能为空");
		}else if(req.getCouponType()==null||(req.getCouponType()!=0&&req.getCouponType()!=1)){
			vrp.setUsedState("14");
			vrp.setUsedDescription("优惠码类型输入错误！");
		}else{
			if(!"".equals(req.getUserId())){
				Member m=memberService.findMemberById(Integer.valueOf(req.getUserId()));
				if(m==null){
					vrp.setUsedState("9");
					vrp.setUsedDescription("该会员不存在！");
				}else if(m.getStatus()==2){
						vrp.setUsedState("11");
						vrp.setUsedDescription("该会员未激活！");
				}else if(m.getStatus()==3){
					vrp.setUsedState("15");
					vrp.setUsedDescription("该会员已删除！");
			    }else{
					// 门店信息（mark:0-活动；1-门店）
			    	this.removeExpiredCodeToHistroy();
					Shop shop = null;
					ActivityInfo activity = null;
					if (!"".equals(req.getShopOrActivityId())) {
						shop = lineService.findShopById(Integer.valueOf(req
								.getShopOrActivityId()));
						// 活动信息（mark:0-活动；1-门店）
						activity = activityService.findActivityById(req
								.getShopOrActivityId());
					}
					int id = 0;
					if (shop != null&&req.getCouponType()==1) {
						id = shop.getId();
						vrp.setCouponDescription(shop.getPrivilegeDesc());
					}
					if (activity != null&&req.getCouponType()==0) {
						id = activity.getId();
						vrp.setCouponDescription(activity.getDescr());
			
						if (DateTools.compareDay(new Date(),
								activity.getEndDate()) == false) {
							vrp.setUsedState("6");
							vrp.setUsedDescription("该活动已结束！");
					
						}
						if (activity.getTag() == 0) {
							vrp.setUsedState("7");
							vrp.setUsedDescription("该活动已取消！");
						}
						if (DateTools.compareDay(new Date(), activity.getStartDate())) {
							vrp.setUsedState("8");
							vrp.setUsedDescription("该活动未开始！");
						}
					}
					if(vrp.getUsedState()==null||"".equals(vrp.getUsedState())){
							Map map = new HashMap();
							try {
								map = this.selDiscountByCode(req.getCouponCode(), id,req.getCouponType(),shop);
							} catch (Exception e) {
								vrp.setUsedState("other");
								vrp.setUsedDescription("非业务类错误!");
							}
							
							// 历史优惠信息
							DiscountNumberHistory dnh = (DiscountNumberHistory) map
									.get("discounthistory");
							// 现有优惠信息
							DiscountNumber dn = null;
						
							if(req.getCouponType()==1){
								List<DiscountNumber> dnlist = (List<DiscountNumber>) map.get("discount");
								for(DiscountNumber dis:dnlist){
									if(dis!=null&&shop.getDiscountModel()!=null){
										if(dis.getCodeType()==Integer.valueOf(shop.getDiscountModel())){
											dn=dis;
											break;
										}else{
											vrp.setUsedDescription("该活动优惠码无效！");
											vrp.setUsedState("16");
										}
									}
								}
								if(dn!=null||(dn==null&&dnh!=null)){
									vrp.setUsedDescription(null);
									vrp.setUsedState("");
								}
							}else if(req.getCouponType()==0){
								List<DiscountNumber> dnlist = (List<DiscountNumber>) map.get("discount");
								dn=dnlist.get(0);
							}
							if(((vrp.getUsedState()==null||"".equals(vrp.getUsedState()))&&req.getCouponType()==1)||req.getCouponType()==0){
									
									// 使用后，调用方法，批量把过期的移入到历史记录表
									// 3：无效的终端编号
									if (shop == null && activity == null) {
										vrp.setUsedState("3");
										vrp.setUsedDescription("不存在该门店或活动!");
									} else if ((dn == null && dnh == null)||
											(dn!=null&&!req.getUserId().equals(dn.getMember().getId().toString()))||
											(dnh!=null&&!req.getUserId().equals(dnh.getMember().getId().toString()))) {
										// 1: 优惠码不存在
										vrp.setUsedState("0");
										vrp.setUsedDescription("优惠码不存在!");
									}else if ( (dn != null && dn.getState() == 1)||(dn==null&&(dnh != null && dnh.getStatus() == 1))) {
										// 4:优惠码已使用
										vrp.setUsedState("4");
										vrp.setUsedDescription("优惠码已使用!");
									} else if (dn != null && dn.getExpiredDate() != null) {
										// 5:优惠码已过期
										if (DateTools.compareDay(new Date(), dn.getExpiredDate()) == false) {
											vrp.setUsedState("5");
											vrp.setUsedDescription("优惠码已过期!");
										} else if (dn.getState() == 0) {
											vrp.setUserId(dn.getMember().getId().toString());
											vrp.setCouponId(String.valueOf(dn.getId()));
							
											req.setTransactionNO(businessNumGenerator.getTransactionNO());
											this.useDiscountNumber(req,shop);
											vrp.setUsedState("1");
											vrp.setUsedDescription("已成功使用！");
										}
									} else if (dn==null&&dnh != null && dnh.getStatus() == 0) {
										vrp.setUsedState("5");
										vrp.setUsedDescription("优惠码已过期!");
									} else {
										vrp.setUsedState("other");
										vrp.setUsedDescription("非业务类错误!");
									}
							
									if (vrp.getUsedState()==null) {
										vrp.setUsedState("other");
										vrp.setUsedDescription("非业务类错误!");
									}
				          	}
					   }
					
					
				}
				
			}
			vrp.setUserId(req.getUserId());
			
		}
		return vrp;
	}

	@Override
	public int getCountDiscount(DiscountNumberHistory discount) {
        List<DiscountNumberReport> mlist=new ArrayList<DiscountNumberReport>();
		
		List<Object> args = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		sql.append("select count(p.id) from ( select discount.id"+
					" FROM "+
					
					  " DiscountNumberReport  discount "+
					" left join  "+ 
					"   `Shop`  s "+ 
					" on  "+ 
					"    s.`id`=discount.shop_id "+ 
					" left join  "+ 
					"   `ActivityInfo`  ai "+ 
					" on  "+ 
					"   ai.`id`=discount.activityInfo_id where 1=1 "
		);
		
//		sql.append("select count(p.id) from ( select discount.id,discount.`discountNum`,discount.`expiredDate`,discount.`status`,discount.shop_id,discount.activityInfo_id,concat_ws('',s.`name`,ai.`activityName`) as shopActivityName,s.`name` as shopName,ai.`activityName` ,discount.member_id,"+
//                "discount.description,h.`usedDate`,h.`transactionNO`,CONCAT(m.`surname`,m.`name`) as memberName,mc.cardNumber as memberCard "+
//				"FROM( "+
//				 "   select dnh.`id`,dnh.shop_id,dnh.activityInfo_id,dnh.`expiredDate`,dnh.`member_id`,dnh.`discountNum`,dnh.`status` ,dnh.`description` "+
//				  "  from DiscountNumberHistory    dnh "+
//				   " UNION "+
//				    "select     dn.`id`,dn.shop_id,dn.activityInfo_id,dn.`expiredDate`,dn.`member_id`,dn.`discountNum`,dn.state as status ,dn.descr as description "+
//				    "from   DiscountNumber        dn "+
//				  ")  discount "+
//				"left JOIN "+
//				" DiscountNumberHistory h "+ 
//				"on "+
//				" discount.id=h.id "+
//				" left join  "+ 
//				"    `Member`  m "+ 
//				" on  "+ 
//				"   m.id=discount.member_id       "+        
//				" left join  "+ 
//				"   `MemberCard` mc "+ 
//				" on  "+ 
//				"    mc.`id`=m.`card_id` "+ 
//				" left join  "+ 
//				"   `Shop`  s "+ 
//				" on  "+ 
//				"    s.`id`=discount.shop_id "+ 
//				" left join  "+ 
//				"   `ActivityInfo`  ai "+ 
//				" on  "+ 
//				"   ai.`id`=discount.activityInfo_id where 1=1 "
//	);
//	
		
		
		if (discount.getStatus()!=null&&discount.getStatus()!=3) {
			
			// 优惠码状态: 0未使用、1已使用
			if(discount.getStatus()==0){
				sql.append(" and  discount.status=0 and  discount.`expiredDate` > NOW() ");
			}else if(discount.getStatus()==1){
				sql.append(" and  discount.status=1 ");
			}else if(discount.getStatus()==2){
				sql.append(" and  discount.`expiredDate` < NOW() and discount.`status`!=1 ");
			}
		}
		if(discount.getSource()!=null&&discount.getSource()!=0){
			if(discount.getSource()==1){//门店
				sql.append(" and    discount.shop_id!=0");
			}
            if(discount.getSource()==2){//活动
            	sql.append(" and  discount.activityInfo_id!=0");
			}
		}
		if(!"".equals(discount.getShopActivityName())&&discount.getShopActivityName()!=null){
			sql.append(" and   s.`name` like ? or  ai.`activityName`   like ?");
			args.add("%" + discount.getShopActivityName()+"%" );
			args.add("%" + discount.getShopActivityName()+"%" );
		}
		sql.append(" ) p");
		
		log.trace("count sql="+sql);
		  if(args.size()>0){
			 return	jdbcDaoSupport.findCount(sql.toString(),args.toArray());
			}else{
				return	jdbcDaoSupport.findCount(sql.toString());
			}
	
	}
}
