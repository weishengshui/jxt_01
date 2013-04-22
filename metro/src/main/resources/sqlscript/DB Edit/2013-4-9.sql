

DROP TABLE IF EXISTS `DiscountNumberReport`;

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
          commit;    

END;//
delimiter ;

create Index  NK_SOURCE_NUM   on  Source(num);
