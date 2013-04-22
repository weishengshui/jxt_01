package com.chinarewards.metro.resources;

import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.DiscountNumber;
import com.chinarewards.metro.domain.shop.DiscountNumberHistory;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.model.discount.DiscountMode;
import com.chinarewards.metro.models.CheckCodeResp;
import com.chinarewards.metro.models.DiscountUseCodeResp;
import com.chinarewards.metro.models.VerifyDiscountResp;
import com.chinarewards.metro.models.request.CheckCodeReq;
import com.chinarewards.metro.models.request.DiscountReq;
import com.chinarewards.metro.models.request.DiscountUseCodeReq;
import com.chinarewards.metro.models.request.VerifyDiscountReq;
import com.chinarewards.metro.models.response.DiscountResp;
import com.chinarewards.metro.repository.shop.ShopRepository;
import com.chinarewards.metro.sequence.BusinessNumGenerator;
import com.chinarewards.metro.service.activity.IActivityService;
import com.chinarewards.metro.service.discount.IDiscountService;
import com.chinarewards.metro.service.line.ILineService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.utils.StringUtil;

@Component
@Path("/discount")
public class DiscountCodeResource {

	@Autowired
	IDiscountService discountService;
	@Autowired
	IMemberService memberService;
	@Autowired
	ILineService lineService;
	@Autowired
	IActivityService activityService;
	@Autowired
	ShopRepository shopRepository;
	@Autowired
	BusinessNumGenerator businessNumGenerator;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@POST
	@Path("/code")
	@Produces({ "application/xml", "application/json" })
	public DiscountResp getDiscountCode(DiscountReq discountReq) {

		try {
			// check sign
			String checkStr = discountReq.getCheckStr();
			JAXBContext c = JAXBContext.newInstance(DiscountReq.class);
			discountReq.setCheckStr(SHA1Util.SHA1Encode(discountReq
					.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(discountReq, r);
			String s = r.toString();
			if (!MD5.MD5Encoder(s).equals(checkStr)) {
				throw new IllegalArgumentException("Request Sign failed!");
			}
		} catch (Exception e) {
			throw new IllegalStateException(
					"Processing request sign error happended!", e);
		}

		Member member = null;
		Shop shop = null;
		ActivityInfo activityInfo = null;

		if (StringUtils.isNotEmpty(String.valueOf(discountReq.getMid()))) {
			member = memberService.findMemberById(discountReq.getMid());
		}

		if (discountReq.getType() == 0) {
			if (StringUtils
					.isNotEmpty(String.valueOf(discountReq.getCouponId()))) {
				shop = lineService.findShopById(discountReq.getCouponId());
			}
		} else if (discountReq.getType() == 1) {
			if (StringUtils
					.isNotEmpty(String.valueOf(discountReq.getCouponId()))) {
				activityInfo = activityService.findActivityById(String
						.valueOf(discountReq.getCouponId()));
			}
		}

		DiscountMode code = discountService.getDiscountCode(member,
				member == null ? null : member.getCard(), shop, activityInfo,
				discountReq.getType());

		DiscountResp resp = new DiscountResp();

		try {
			PropertyUtils.copyProperties(resp, code);
			// sign
			String ckvalue = resp.getSignValue();
			resp.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

			JAXBContext ctx = JAXBContext.newInstance(DiscountResp.class);
			StringWriter writer = new StringWriter();
			ctx.createMarshaller().marshal(resp, writer);
			String custString = writer.toString();
			resp.setCheckStr(MD5.MD5Encoder(custString));

			return resp;
		} catch (Exception e) {
			throw new IllegalStateException(
					"Signing response error happended!", e);
		}
	}

	@POST
	@Path("/useCode")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public VerifyDiscountResp useDiscountCode(
			VerifyDiscountReq verifyDiscountReq) {
		// result(0:成功 1: 优惠码不存在,2,暂无优惠活动,3：无效的终端编号,4:优惠码已使用,5:优惠码已过期,6:
		// 该活动已结束！，7:该活动已取消 ;8:该活动未开始; other:非业务类错误)
		long d0=System.currentTimeMillis();
		VerifyDiscountResp vrp = new VerifyDiscountResp();

		
		PosBind pb =null;
		// 门店信息（mark:0-活动；1-门店）
		Shop shop = null;
		ActivityInfo activity = null;
		String posid=verifyDiscountReq.getPosId();
		if (!StringUtil.isEmptyString(posid)) {
			pb=shopRepository.findBindPos(verifyDiscountReq.getPosId());
			shop = shopRepository.findShopById(pb.getfId().toString());
			// 活动信息（mark:0-活动；1-门店）
			activity = activityService.findActivityById(pb.getfId().toString());
		}

		int id = 0;
		Integer couponType=0;
		if (shop != null && pb!=null&&pb.getMark() == 1) {
			id = shop.getId();
			vrp.setTitle(shop.getName() + "%权益验证");
			vrp.setTip(shop.getPosout());
			couponType=1;
		}else if (activity != null && pb!=null&& pb.getMark() == 0) {
			id = activity.getId();
			vrp.setTitle(activity.getActivityName() + "%权益验证");
			vrp.setTip(activity.getPosDescr());
			couponType=0;
			if (DateTools.compareDay(activity.getStartDate(),
					activity.getEndDate()) == false) {
				vrp.setResult("6");
				vrp.setTip("该活动已结束！");
				return vrp;
			}
			if (activity.getTag() == 0) {
				vrp.setResult("7");
				vrp.setTip("该活动已取消！");
				return vrp;
			}

			if (DateTools.compareDay(new Date(), activity.getStartDate())) {
				vrp.setResult("8");
				vrp.setTip("该活动未开始！");
				return vrp;
			}
		}
		if (shop == null && activity == null) {
			vrp.setResult("3");
			vrp.setTip("无效的终端编号!");
			return vrp;
		} 
		if(id!=0){
				discountService.removeExpiredCodeToHistroy();
				Map map = new HashMap();
				try {
					map = discountService.selDiscountByCode(
							verifyDiscountReq.getDiscountCode(), id,couponType,shop);
				} catch (Exception e) {
					vrp.setResult("other");
					vrp.setTip("非业务类错误!");
					return vrp;
				}
				// 历史优惠信息
				DiscountNumberHistory dnh = (DiscountNumberHistory) map
						.get("discounthistory");
				// 现有优惠信息
				DiscountNumber dn = null;
				List<DiscountNumber> dnlist = (List<DiscountNumber>) map.get("discount");
				if(pb.getMark() == 1){
					for(DiscountNumber dis:dnlist){
						if(dis!=null&&shop.getDiscountModel()!=null){
							if(dis.getCodeType()==Integer.valueOf(shop.getDiscountModel())){
								dn=dis;
								break;
							}else{
								vrp.setTip("该门店优惠码无效！");
								vrp.setResult("16");
							}
						}
					}
					if(dn!=null||(dn==null&&dnh!=null)){
						vrp.setResult("");
					}
				}else if(pb.getMark() == 0&&dnlist.size()!=0){
						dn=dnlist.get(0);
				}
				if((StringUtil.isEmptyString(vrp.getResult())&&pb.getMark() == 1)||pb.getMark() == 0){
							vrp.setXactTime(DateTools.dateToHour24());
							int resend = verifyDiscountReq.getResend();
							if (resend == 0) {// 不重发，直接使用
								if (dn == null && dnh == null) {	
									vrp.setResult("1");
									vrp.setTip("优惠码不存在!");
									return vrp;
								} else if (dn != null && dn.getExpiredDate() != null) {
									if (DateTools.compareDay(new Date(), dn.getExpiredDate()) == false) {
										vrp.setResult("5");
										vrp.setTip("优惠码已过期!");
										return vrp;
									} else if (dn.getState() == 0) {
										// 流水号在第一次时需要插入到数据库，修改状态
										// 生成交易号
										verifyDiscountReq.setTransactionNO(businessNumGenerator
												.getTransactionNO());
										discountService.checkDiscountCode(verifyDiscountReq, pb,id,shop);
										vrp.setResult("0");
										vrp.setTransactionNo(verifyDiscountReq.getTransactionNO());
									}
								} else if ((dnh != null && dnh.getStatus() == 1)
										|| (dn != null && dn.getState() == 1)) {
									vrp.setResult("4");
									vrp.setTip("优惠码已使用!");
									return vrp;
								} else if ((dnh != null && dnh.getStatus() == 0)) {
									vrp.setResult("5");
									vrp.setTip("优惠码已过期!");
									return vrp;
								} else {
									vrp.setResult("other");
									vrp.setTip("非业务类错误!");
									return vrp;
								}
					
							} else {// 重发，先找流水号
									// 到历史记录表里查找24小时之内的信息
								DiscountNumberHistory dhistory = discountService
										.getDiscountBySerialId(verifyDiscountReq.getSerialId());
								if (dhistory != null) {
									vrp.setResult("0");
								} else {
									// 说明这条记录还在原表中
									if (shop == null && activity == null) {
										vrp.setResult("3");
										vrp.setTip("无效的终端编号!");
										return vrp;
									} else if (dn == null && dnh == null) {
										vrp.setResult("1");
										vrp.setTip("优惠码不存在!");
										return vrp;
									} else if (dn != null && dn.getExpiredDate() != null) {
										if (DateTools.compareDay(new Date(), dn.getExpiredDate()) == false) {
											vrp.setResult("5");
											vrp.setTip("优惠码已过期!");
											return vrp;
										} else if (dn.getState() == 0) {
											// 流水号在第一次时需要插入到数据库，修改状态
											verifyDiscountReq.setTransactionNO(businessNumGenerator
													.getTransactionNO());
											discountService.checkDiscountCode(verifyDiscountReq, pb,id,shop);
											vrp.setResult("0");
											vrp.setTransactionNo(verifyDiscountReq
													.getTransactionNO());
										}
									} else if ((dnh != null && dnh.getStatus() == 1)
											|| (dn != null && dn.getState() == 1)) {
										// 4:优惠码已使用
										vrp.setResult("0");
										vrp.setTransactionNo(dnh.getTransactionNO());
									} else if ((dnh != null && dnh.getStatus() == 0)) {
										vrp.setResult("5");
										vrp.setTip("优惠码已过期!");
										return vrp;
									} else {
										vrp.setResult("other");
										vrp.setTip("非业务类错误!");
										return vrp;
									}
								}
							}
				  }
				
		}
		if (vrp.getResult()==null||vrp.getResult().isEmpty()) {
			vrp.setResult("other");
			vrp.setTip("非业务类错误!");
		}
		long d1=System.currentTimeMillis();
		logger.trace("time:========================================="+(d1-d0));
		return vrp;
	}

	@POST
	@Path("/useDiscountCode")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public DiscountUseCodeResp useDiscountCodeByClient(DiscountUseCodeReq req) {
		// result( 0: 优惠码不存在,1:成功  , 2,暂无优惠活动,3：门店或活动不存在,4:优惠码已使用,5:优惠码已过期,6:
		// 该活动已结束！，7:该活动已取消 ;8:该活动未开始;9：用户不存在；10：会员id不能为空；11：该会员未激活； 12:请输入门店id或活动id;13:优惠码不能为空；14.优惠码类型输入错误；15.该会员已删除;16.该活动优惠码无效！；other:非业务类错误)
		DiscountUseCodeResp vrp = new DiscountUseCodeResp();
		vrp.setCouponCode(req.getCouponCode());

		try {
			// check sign
			String checkStr = req.getCheckStr();
			JAXBContext c = JAXBContext.newInstance(DiscountUseCodeReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req
					.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			if (!MD5.MD5Encoder(s).equals(checkStr)) {
				throw new IllegalArgumentException("Request Sign failed!");
			}
		} catch (Exception e) {
			throw new IllegalStateException(
					"Processing request sign error happended!", e);
		}
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
			    	discountService.removeExpiredCodeToHistroy();
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
					if (shop == null && activity == null) {
						vrp.setUsedState("3");
						vrp.setUsedDescription("不存在该门店或活动!");
					} 
					if(vrp.getUsedState()==null||"".equals(vrp.getUsedState())){
							Map map = new HashMap();
							try {
								map = discountService.selDiscountByCode(req.getCouponCode(), id,req.getCouponType(),shop);
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
											vrp.setUsedDescription("该门店优惠码无效！");
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
								if(dnlist.size()!=0){
									dn=dnlist.get(0);
								}
							}
							if(((vrp.getUsedState()==null||"".equals(vrp.getUsedState()))&&req.getCouponType()==1)||req.getCouponType()==0){
									
									// 使用后，调用方法，批量把过期的移入到历史记录表
									// 3：无效的终端编号
									 if ((dn == null && dnh == null)||
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
											discountService.useDiscountNumber(req,shop);
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
		try {
			// sign
			String ckvalue = vrp.getSignValue();
			vrp.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

			JAXBContext ctx = JAXBContext.newInstance(DiscountUseCodeResp.class);
			StringWriter writer = new StringWriter();
			ctx.createMarshaller().marshal(vrp, writer);
			String custString = writer.toString();
			vrp.setCheckStr(MD5.MD5Encoder(custString));
			return vrp;
		} catch (Exception e) {
			throw new IllegalStateException(
					"Signing response error happended!", e);
		}
	}


	
	@POST
	@Path("/checkCode")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public CheckCodeResp checkCode(CheckCodeReq checkCodeReq) throws JAXBException {
		CheckCodeResp cp = new CheckCodeResp();
		Map map = new HashMap();
		try {

			// check sign
			String checkStr = checkCodeReq.getCheckStr();
			JAXBContext c = JAXBContext.newInstance(CheckCodeReq.class);
			checkCodeReq.setCheckStr(SHA1Util.SHA1Encode(checkCodeReq
					.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(checkCodeReq, r);
			String s = r.toString();
			if (!MD5.MD5Encoder(s).equals(checkStr)) {
				throw new IllegalArgumentException("Request Sign failed!");
			}
			cp.setCouponCode(checkCodeReq.getCouponCode());
			cp.setCouponInfo("");
			cp.setIsRepeat(0);
			cp.setUseTime(null);
			logger.trace("ddddddddddddddddddd"+checkCodeReq.getCouponId());
			if(StringUtil.isEmptyString(checkCodeReq.getCouponCode())){
				cp.setErrorReason("优惠码不能为空！");
			}else if(checkCodeReq.getCouponId()==null||(checkCodeReq.getCouponId()!=0&&checkCodeReq.getCouponId()!=1)){
				cp.setErrorReason("优惠码类型填写错误！");
			}else if(StringUtil.isEmptyString(checkCodeReq.getShopOrActivityId())&&checkCodeReq.getCouponId()==1){
				cp.setErrorReason(" 门店id不能为空！");
			}else if(StringUtil.isEmptyString(checkCodeReq.getShopOrActivityId())&&checkCodeReq.getCouponId()==0){
				cp.setErrorReason(" 活动id不能为空！");
			}else{
				discountService.removeExpiredCodeToHistroy();
				Shop shop = lineService.findShopById(Integer.valueOf(checkCodeReq
						.getShopOrActivityId()));
				
				ActivityInfo activity = activityService.findActivityById(checkCodeReq
						.getShopOrActivityId());
					
					
				//类型（ 0--活动；1--门店）
				if(checkCodeReq.getCouponId()==1&&shop==null){
					cp.setErrorReason("该门店不存在");
				}else if(checkCodeReq.getCouponId()==0&&activity==null){
					cp.setErrorReason("该活动不存在");
				}else if (activity != null&&checkCodeReq.getCouponId()==0) {
					if (DateTools.compareDay(new Date(),
							activity.getEndDate()) == false) {
						cp.setErrorReason("该活动已结束！");
					}
					if (activity.getTag() == 0) {
						cp.setErrorReason("该活动已取消！");
					}
					if (DateTools.compareDay(new Date(), activity.getStartDate())) {
						cp.setErrorReason("该活动未开始！");
					}
				}
				
				if(StringUtil.isEmptyString(cp.getErrorReason())){
					map = discountService.selDiscountByCode(
							checkCodeReq.getCouponCode(), checkCodeReq.getCouponId(),checkCodeReq.getShopOrActivityId(),shop);
					
					
					DiscountNumber dn=null;
					boolean success=true;
					// 历史优惠信息
					DiscountNumberHistory dnh = (DiscountNumberHistory) map
							.get("discounthistory");
					// 现有优惠信息
					if(checkCodeReq.getCouponId()==1){
						List<DiscountNumber> dnlist = (List<DiscountNumber>) map.get("discount");
						for(DiscountNumber dis:dnlist){
							if(dis!=null&&shop.getDiscountModel()!=null){
								if(dis.getCodeType()==Integer.valueOf(shop.getDiscountModel())){
									dn=dis;
									break;
								}else{
									cp.setErrorReason("该门店优惠码无效！");
									success=false;
								}
							}
						}
						if(dn!=null||(dn==null&&dnh!=null)){
							cp.setErrorReason(null);
							success=true;
						}
					}else if(checkCodeReq.getCouponId()==0){
						List<DiscountNumber> dnlist = (List<DiscountNumber>) map.get("discount");
						if(dnlist.size()!=0){
							dn=dnlist.get(0);
						}
					}
					
					if((success&&checkCodeReq.getCouponId()==1)||checkCodeReq.getCouponId()==0){
							
							
							if(checkCodeReq.getCouponId()!=0&&checkCodeReq.getCouponId()!=1){
								cp.setErrorReason("请输入正确的优惠码类型！");
							}else  if(dn==null&&dnh==null&&checkCodeReq.getCouponId()==0){
								cp.setErrorReason("该活动优惠码不存在！");
							}else if(dn==null&&dnh==null&&checkCodeReq.getCouponId()==1){
								cp.setErrorReason("该门店优惠码不存在！");
							}else {
									if (dn != null && dn.getState() != null && dn.getState() == 0
											&& DateTools.compareDay(new Date(), dn.getExpiredDate())) {// 未使用
										cp.setIsAvailable(1);
										cp.setErrorReason("优惠码可用！");
									} else {
										cp.setIsAvailable(0);
										cp.setErrorReason("优惠码不可使用！");
									}
									if ((dn!=null&&DateTools.compareDay(new Date(), dn.getExpiredDate()) == false)) {
										cp.setErrorReason("优惠码已过期！");
									}else if(dn==null&&dnh!=null&&DateTools.compareDay(new Date(), dnh.getExpiredDate()) == false){
										cp.setErrorReason("优惠码已过期！");
									}
									if (dn != null) {
										cp.setCouponInfo(dn.getDescr());
									}else if(dnh!=null){
										cp.setCouponInfo(dnh.getDescription());
									}
									if (dn==null&&dnh != null && dnh.getStatus() == 1) {
										SimpleDateFormat df = new SimpleDateFormat(
												"yyyy-MM-dd HH:mm:ss");
										cp.setUseTime(dnh.getUsedDate() == null ? null : df.parse(df
												.format(dnh.getUsedDate())));
										cp.setErrorReason("优惠码已使用！");
									}
							}
							
						}
					}
				
		 }
			

		} catch (Exception e) {
			cp.setErrorReason("优惠码出错！");
		}

		// sign
		String ckvalue = cp.getSignValue();
		cp.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext.newInstance(CheckCodeResp.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(cp, writer);
		String custString = writer.toString();
		cp.setCheckStr(MD5.MD5Encoder(custString));
		return cp;

	}

	public IDiscountService getDiscountService() {
		return discountService;
	}

	public void setDiscountService(IDiscountService discountService) {
		this.discountService = discountService;
	}

	public IMemberService getMemberService() {
		return memberService;
	}

	public void setMemberService(IMemberService memberService) {
		this.memberService = memberService;
	}

	public ILineService getLineService() {
		return lineService;
	}

	public void setLineService(ILineService lineService) {
		this.lineService = lineService;
	}

	public IActivityService getActivityService() {
		return activityService;
	}

	public void setActivityService(IActivityService activityService) {
		this.activityService = activityService;
	}

}
