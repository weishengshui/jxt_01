package com.chinarewards.alading.service;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.CardDetail;
import com.chinarewards.alading.domain.CardList;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.domain.Member;
import com.chinarewards.alading.domain.MemberInfo;
import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.CompanyCardMapper;
import com.chinarewards.alading.reg.mapper.MemberMapper;
import com.google.inject.Inject;

public class MemberService implements IMemberService {

	@InjectLogger
	private Logger logger;

	@Inject
	private MemberMapper memberMapper;
	@Inject
	private CompanyCardMapper companyCardMapper;

	@Override
	public MemberInfo findMemberInfoByPhone(String phoneNumber) {
		MemberInfo memberInfo = memberMapper
				.selectMemberInfoByPhone(phoneNumber);
		if (null != memberInfo) {
			CardList cardList = memberInfo.getCardList();
			CardDetail cardDetail = cardList.getCardDetail().get(0);

			if (null == cardDetail.getCardName()
					
					|| "".equals(cardDetail.getCardName())) {
				Card card = companyCardMapper.selectDefaultCard();
				if (null != card) {
					String cardName = card.getCardName();
					FileItem fileItem = card.getPicUrl();
					Unit unit = card.getUnit();
					String picUrl = null;
					if (null != fileItem) {
						picUrl = String.valueOf(fileItem.getId());
					}
					String pointId = null;
					String pointName = null;
					String pointRate = null;
					if (null != unit) {
						pointId = String.valueOf(unit.getPointId());
						pointName = unit.getPointName();
						pointRate = String.valueOf(unit.getPointRate());
					}

					cardDetail.setCardName(cardName);
					cardDetail.setPicUrl(picUrl);
					cardDetail.setPointId(pointId);
					cardDetail.setPointName(pointName);
					cardDetail.setPointRate(pointRate);
				}
			}
		}
		return memberInfo;
	}

	@Override
	public MemberInfo findMemberInfoById(Integer id) {
		return memberMapper.select(id);
	}

	@Override
	public Member findMemberById(Integer id) {
		return memberMapper.selectMemberById(id);
	}

}
