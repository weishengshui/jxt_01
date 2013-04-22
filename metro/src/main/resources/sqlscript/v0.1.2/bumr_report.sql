


-----------------------------------------------------------
-- DROP TABLE IF EXISTS brandunionmember_report;
-- 联合会员报表
CREATE TABLE IF NOT EXISTS `brandunionmember_report` (
  `id` int(11) NOT NULL PRIMARY KEY auto_increment,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cardNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `brandId` int(11) DEFAULT NULL,
  `joinedDate` datetime DEFAULT NULL,
  `memberId` int(11) DEFAULT NULL
  -- `cardId` int(11) DEFAULT NULL,
  
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

CREATE TABLE IF NOT EXISTS `ReportTask` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `descrition` longtext DEFAULT NULL,
  `endTime` datetime NOT NULL,
  `startTime` datetime NOT NULL,
  `taskName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

-- CREATE INDEX
CREATE INDEX brandunionmember_report_index1 ON brandunionmember_report( brandId, joinedDate);
CREATE INDEX brandunionmember_report_index2 ON brandunionmember_report(cardNumber(30), `name`(40), brandId, joinedDate);
CREATE INDEX brandunionmember_report_index3 ON brandunionmember_report(`name`(40), brandId, joinedDate);
CREATE INDEX brandunionmember_report_index4 ON brandunionmember_report(memberId, brandId);

CREATE INDEX member_index1 ON Member(card_id, updateDate);
CREATE INDEX brandunionmember_index1 ON BrandUnionMember(joinedDate, member_id, brand_id);

-- 积分分析报表

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `IntegralReport` 2013-04-12
-- ----------------------------
DROP TABLE IF EXISTS `IntegralReport`;
CREATE TABLE `IntegralReport` (
  `txid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `integralType` int(11) NOT NULL,
  `integralCount` decimal(19,2) DEFAULT NULL,
  `comsumePoint` decimal(19,2) DEFAULT NULL,
  `memName` varchar(510) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `memberCard` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `orderSource` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `origin` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `exchangeHour` date,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of IntegralReport
-- ----------------------------
CREATE INDEX m_account_index ON Member(account);
CREATE INDEX m_cardId_index ON Member(card_id);
CREATE INDEX o_txId_index ON OrderInfo(tx_txId);
CREATE INDEX t_busines_index ON Transaction(busines);
