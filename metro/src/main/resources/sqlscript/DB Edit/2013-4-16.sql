DROP PROCEDURE  `discountNumberReport_add`;
commit;
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

          insert into `DiscountNumberReport`(id,discountNum,`expiredDate`,`generatedDate`,`member`,`privilege`,`usedDate`,`shop_id`,`description`,
                       `title`,`status`,`member_id`,`posDescr`,`activityInfo_id`,`serialId`,`money`,`transactionNO`,`orderId`,`codeType` )
                 select id,discountNum,`expiredDate`,`generatedDate`,`member`,`privilege`,`usedDate`,`shop_id`,`description`,
                       `title`,`status`,`member_id`,`posDescr`,`activityInfo_id`,`serialId`,`money`,`transactionNO`,`orderId`,`codeType`  from `DiscountNumberHistory` h ;
           insert into `DiscountNumberReport` (id,activityInfo_id,codeType,discountNum,expiredDate,generatedDate,member_id,
            shop_id,status,description)  
            select dn.id,dn.`activityInfo_id`,dn.`codeType`,dn.`discountNum`,dn.`expiredDate`,
              dn.`generatedDate`,dn.`member_id`,dn.`shop_id`,dn.`state`,dn.`descr` 
            from `DiscountNumber` dn  ;  
            
       else
            --  过期(数据不变化)、使用（状态发生改变）       
         delete  from `DiscountNumberReport`   where  `id`
            IN(select  id  from `DiscountNumberHistory`    where `usedDate`>_taskTimeEnd_past and `usedDate`<NOW() );
          insert into `DiscountNumberReport`(id,discountNum,`expiredDate`,`generatedDate`,`member`,`privilege`,`usedDate`,`shop_id`,`description`,
                       `title`,`status`,`member_id`,`posDescr`,`activityInfo_id`,`serialId`,`money`,`transactionNO`,`orderId`,`codeType` )
                 select id,discountNum,`expiredDate`,`generatedDate`,`member`,`privilege`,`usedDate`,`shop_id`,`description`,
                       `title`,`status`,`member_id`,`posDescr`,`activityInfo_id`,`serialId`,`money`,`transactionNO`,`orderId`,`codeType`  from `DiscountNumberHistory` h 
                 where h.`usedDate` > _taskTimeEnd_past  and    h.`usedDate`< NOW();    
          insert into `DiscountNumberReport` (id,activityInfo_id,codeType,discountNum,expiredDate,generatedDate,member_id,
            shop_id,status,description)  
            select dn.id,dn.`activityInfo_id`,dn.`codeType`,dn.`discountNum`,dn.`expiredDate`,
              dn.`generatedDate`,dn.`member_id`,dn.`shop_id`,dn.`state`,dn.`descr` 
            from `DiscountNumber` dn   where     dn.`generatedDate` > _taskTimeEnd_past  and    dn.`generatedDate`< NOW();
       
       end if;
     insert into `TaskToDiscountReport`(taskTimeStart, taskTimeEnd) values(_taskTimeStart_now,now());   
       COMMIT;  
END;//
delimiter ;
