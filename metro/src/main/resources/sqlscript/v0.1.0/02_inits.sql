-- liuan 2013-04-10
create Index  NK_CREATEDATE   on  Member(createDate);

alter table `Member` add orderPriceSum DECIMAL(19,2) DEFAULT NULL ;
create Index  NK_MESSAGETASK_CREATEDAT  on  MessageTask(createdAt);

CREATE TABLE `DiscountNumberReport` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `discountNum` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expiredDate` DATETIME DEFAULT NULL,
  `generatedDate` DATETIME DEFAULT NULL,
  `member` TINYBLOB,
  `privilege` TINYBLOB,
  `usedDate` DATETIME DEFAULT NULL,
  `shop_id` INTEGER(11) DEFAULT NULL,
  `description` LONGTEXT,
  `title` VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` INTEGER(11) NOT NULL,
  `member_id` INTEGER(11) DEFAULT NULL,
  `posDescr` LONGTEXT,
  `activityInfo_id` INTEGER(11) DEFAULT NULL,
  `serialId` BIGINT(20) DEFAULT NULL,
  `money` DOUBLE(15,3) DEFAULT NULL,
  `transactionNO` VARCHAR(225) COLLATE utf8_unicode_ci DEFAULT NULL,
  `orderId` VARCHAR(225) COLLATE utf8_unicode_ci DEFAULT NULL,
  `codeType` INTEGER(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3D67692A3F8F54D1` (`shop_id`),
  KEY `FK3D67692AA8D494AD` (`member_id`),
  KEY `FK3D67692A7C26C998` (`activityInfo_id`),
  KEY `usedDate` (`usedDate`, `id`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';



CREATE TABLE `TaskToDiscountReport` (
  `taskId` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `taskTimeStart` DATETIME DEFAULT NULL,
  `taskTimeEnd` DATETIME DEFAULT NULL,
  PRIMARY KEY (`taskId`),
  UNIQUE KEY `taskId` (`taskId`)
)ENGINE=InnoDB
AUTO_INCREMENT=4 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';


CREATE TABLE `TaskToMemberOrderPrice` (
  `taskId` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `taskTimeStart` DATETIME DEFAULT NULL,
  `taskTimeEnd` DATETIME DEFAULT NULL,
  PRIMARY KEY (`taskId`),
  UNIQUE KEY `taskId` (`taskId`)
)ENGINE=InnoDB
AUTO_INCREMENT=2 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

delimiter //
CREATE DEFINER = 'metro'@'%' PROCEDURE `discountNumberReport_add`()
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
DECLARE   _taskTimeEnd_past DATETIME;
declare   _taskTimeStart_now DATETIME default NOW(); 

         set  _taskTimeStart_now =NOW();
    select `taskTimeEnd` into _taskTimeEnd_past  from `TaskToDiscountReport`   order by `taskTimeEnd` desc limit 1;  
      if  _taskTimeEnd_past is null    then

         insert into   `DiscountNumberReport` select * from  `DiscountNumberHistory` h ;
           insert into `DiscountNumberReport` (id,activityInfo_id,codeType,discountNum,expiredDate,generatedDate,member_id,
            shop_id,status,description)  
            select dn.id,dn.`activityInfo_id`,dn.`codeType`,dn.`discountNum`,dn.`expiredDate`,
              dn.`generatedDate`,dn.`member_id`,dn.`shop_id`,dn.`state`,dn.`descr` 
            from `DiscountNumber` dn  ;  
            
       else
            insert into `DiscountNumberReport` select * from `DiscountNumberHistory` h where h.`generatedDate` > _taskTimeEnd_past  and    h.`generatedDate`< NOW();
         insert into `DiscountNumberReport` (id,activityInfo_id,codeType,discountNum,expiredDate,generatedDate,member_id,
            shop_id,status,description)  
            select dn.id,dn.`activityInfo_id`,dn.`codeType`,dn.`discountNum`,dn.`expiredDate`,
              dn.`generatedDate`,dn.`member_id`,dn.`shop_id`,dn.`state`,dn.`descr` 
            from `DiscountNumber` dn   where     dn.`generatedDate` > _taskTimeEnd_past  and    dn.`generatedDate`< NOW();
       
       end if;
     insert into `TaskToDiscountReport`(taskTimeStart, taskTimeEnd) values(_taskTimeStart_now,now());   
END;



CREATE DEFINER = 'metro'@'%' PROCEDURE `memberOrderPrice_update`()
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN 
DECLARE   _taskTimeEnd_past DATETIME;
declare   _taskTimeStart_now DATETIME default NOW();    
set   _taskTimeStart_now=NOW();   
  select `taskTimeEnd` into _taskTimeEnd_past  from `TaskToMemberOrderPrice`  order by `taskTimeEnd` desc limit 1; 
  
  if _taskTimeEnd_past is null    then
         update `Member` m 
             inner join  
             (  select  account_accountId ,tx_txId,sum(orderPrice) as orderPriceSum
                 from `OrderInfo`
                 where type in(0,3,4) 
         		 group by  account_accountId    
                  having sum(orderPrice)>0  ) o  
              inner join
               `Transaction` t
				 set m.`orderPriceSum`= o.orderPriceSum
				 where o.account_accountId =m.account  and  t.txId=o.tx_txId;

  else
    
   update Member m 
             inner join  
             (  select  account_accountId ,tx_txId,sum(orderPrice) as orderPriceSum
                 from `OrderInfo`
                 where type in(0,3,4) 
         		 group by  account_accountId   
                  having sum(orderPrice)>0  ) o  
              inner join
             `Transaction` t
				 set m.`orderPriceSum`= o.orderPriceSum
				 where o.account_accountId =m.account  and  t.txId=o.tx_txId   and   t.transactionDate  >  _taskTimeEnd_past    and  t.transactionDate < NOW();
   
   
   
    end if;
    insert into `TaskToMemberOrderPrice`(taskTimeStart, taskTimeEnd) values(_taskTimeStart_now,now());   
       

END;//
delimiter ;

create Index  NK_SOURCE_NUM   on  Source(num);

-- weishengsui
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

CREATE INDEX m_account_index ON Member(account);
CREATE INDEX m_cardId_index ON Member(card_id);
CREATE INDEX o_txId_index ON OrderInfo(tx_txId);
CREATE INDEX t_busines_index ON Transaction(busines);

INSERT INTO `Resources` VALUES ('59', '系统参数', null, '45', 'sysparams/show', '0', null, null, '4');

CREATE TABLE `Source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/** 注册来源 start */
INSERT INTO `Source` VALUES ('1', '网站', '1000');
INSERT INTO `Source` VALUES ('2', '手机(IOS)', '100101');
INSERT INTO `Source` VALUES ('3', '微信', '1002');
INSERT INTO `Source` VALUES ('4', '触摸屏', '1003');
INSERT INTO `Source` VALUES ('5', 'POS', '1004');
INSERT INTO `Source` VALUES ('6', 'CRM', '1005');
INSERT INTO `Source` VALUES ('7', '手机(Android)', '100102');
/**  send */

-- 2013-04-12


