package com.chinarewards.metro.support.account;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.service.account.NumberHelper;

@Repository
public class RuleMatcher {

	protected Integer calcAge(Date birthDay) {
		if (null == birthDay) {
			return null;
		}

		Calendar calendar = Calendar.getInstance();
		int curYear = calendar.get(Calendar.YEAR);

		calendar.setTime(birthDay);
		int bornYear = calendar.get(Calendar.YEAR);

		return curYear - bornYear;
	}

	public double amount(Map<Long, Double> consumeDetail) {
		double value = 0d;
		for (Double d : consumeDetail.values()) {
			value = NumberHelper.add(value, d);
		}
		return value;
	}

	/**
	 * 检查消费区间， 如果定义一种的一个区间值为Null ,说明没有设限返回true
	 * 
	 * @param amount
	 * @param from
	 * @param to
	 * @return
	 */
	protected boolean amountRange(double amount, Double from, Double to) {
		if ((null == from || null == to) || (amount >= from && amount <= to)) {
			return true;
		}
		return false;
	}

	/**
	 * 检查时间区间， 如果定义一种的一个区间值为Null ,说明没有设限返回true
	 * 
	 * @param amount
	 * @param from
	 * @param to
	 * @return
	 */
	protected boolean dateRange(Date from, Date to, Date TransactionDate) {

		if (to != null) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(to);
			calendar.set(Calendar.HOUR, 00);
			calendar.set(Calendar.MINUTE, 00);
			calendar.set(Calendar.SECOND, 00);
			calendar.set(Calendar.MILLISECOND, 00);

			calendar.add(Calendar.DAY_OF_MONTH, 1);
			to = calendar.getTime();
		}

		if (from != null) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(from);
			calendar.set(Calendar.HOUR, 00);
			calendar.set(Calendar.MINUTE, 00);
			calendar.set(Calendar.SECOND, 00);
			calendar.set(Calendar.MILLISECOND, 00);

			from = calendar.getTime();
		}

		if ((null == from || null == to)
				|| (TransactionDate.getTime() >= from.getTime() && TransactionDate
						.getTime() < to.getTime())) {
			return true;
		}
		return false;
	}

	/**
	 * 检查年龄区间， 如果定义一种的一个区间值为Null ,说明没有设限返回true
	 * 
	 * @param amount
	 * @param from
	 * @param to
	 * @return
	 */
	protected boolean ageRange(Integer from, Integer to, Integer age) {
		if ((null != from && null != to) && age == null) {
			return false;
		}

		if ((null == from || null == to) || (age >= from && age <= to)) {
			return true;
		}
		return false;
	}

	public boolean genderMatch(String ruleGender, String gender) {

		if (StringUtils.isEmpty(ruleGender)
				|| ruleGender.equals(String
						.valueOf(Dictionary.MEMBER_SEX_NOLIMIT))
				|| (!StringUtils.isEmpty(gender) && ruleGender.equals(gender))) {
			return true;
		}
		return false;
	}

	public Map<IntegralRule/* 匹配到的规则 */, Double/* 规则额外累积积分数量 */> match(
			Member member, Map<Long, Double> consumeDetails,
			List<IntegralRule> rules, Date transactionDate) {

		Map<IntegralRule, Double> map = new HashMap<IntegralRule, Double>();
		double amount = amount(consumeDetails);
		for (IntegralRule rule : rules) {

			// 匹配消费金额
			if (amountRange(amount, rule.getAmountConsumedFrom(),
					rule.getAmountConsumedTo())) {

				Integer age = calcAge(member.getBirthDay());
				// 匹配年龄
				if (ageRange(rule.getRangeAgeFrom(), rule.getRangeAgeTo(), age)) {

					// 匹配消费时间
					if (dateRange(rule.getRangeFrom(), rule.getRangeTo(),
							transactionDate)) {

						// 匹配性别
						if (genderMatch(
								(rule.getGender() == null) ? null
										: String.valueOf(rule.getGender()),
								member.getSex() == null ? null : String
										.valueOf(member.getSex()))) {

							double vl = NumberHelper.multiply(amount,
									rule.getTimes());
							map.put(rule, vl);
						}
					}
				}
			}
		}
		return map;
	}

	public double matchBirthday(Member member,
			Map<Long, Double> consumeDetails, Double times/* 倍数，如果为空不处理 */,
			Date transactionDate) {
		double amount = amount(consumeDetails);
		SimpleDateFormat fmt = new SimpleDateFormat("MMdd");
		if (null != times
				&& member.getBirthDay() != null
				&& fmt.format(transactionDate).equals(
						fmt.format(member.getBirthDay()))) {
			return NumberHelper.multiply(times, amount);

		}
		return 0d;
	}
}
