
delimiter //
-- proc_apply_coupon
CREATE PROCEDURE `proc_apply_coupon`(IN `_couponNo` varchar(50),IN `_terminalId` varchar(100),IN `_merchantName` varchar(255),IN `_merchantAddress` varchar(255),IN `_transactionDate` varchar(50),IN `_transactionNo` varchar(50),OUT `returnCode` varchar(10))
BEGIN
   DECLARE c_order_status INT;
       
   DECLARE c_order_id INT ;
   
   DECLARE c_employee_id INT;

   DECLARE c_count INT;

   DECLARE c_err_message LONGTEXT;
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
       SET returnCode="113";
       SET c_err_message = "Unknow error happended!";
       INSERT INTO tbl_exchangelog(terminalId, merchantName, merchantAddress, couponNo, operation, returnCode, errMessage, createdAt, transactionDate, mobilePhone,transactionNo)
       VALUES(_terminalId,_merchantName,_merchantAddress,_couponNo,'apply',returnCode,c_err_message,NOW(),_transactionDate,NULL,_transactionNo);
   END;
   
   SELECT count(1) INTO c_count FROM tbl_orderform od WHERE od.couponNo=_couponNo;
   IF c_count <1 THEN
           SET returnCode = "101";
   END IF;

   SELECT o.`status`,o.id,o.employeeId INTO c_order_status,c_order_id,c_employee_id FROM tbl_orderform o WHERE o.couponNo=_couponNo;

   IF returnCode IS NULL THEN
           SELECT count(1) INTO c_count FROM tbl_qyyg WHERE nid = c_employee_id and zt=1;
           IF c_count <> 1 THEN
                   SET returnCode = "121";
           END IF;
   END IF;

   
   IF returnCode IS NULL THEN
           IF c_order_status = 0 THEN
               UPDATE tbl_orderform o SET o.`status` = 2,o.transactionNo=_transactionNo,o.lastUpdatedAt =NOW() WHERE o.id= c_order_id;
									
							 UPDATE tbl_ygddzb dd SET dd.state = 5 WHERE dd.ddh = _couponNo;
							 UPDATE tbl_ygddmx mx SET mx.state= 5 WHERE mx.ddh = _couponNo;		

               SET returnCode = "100";
           ELSEIF c_order_status = 1 THEN
               -- expired
               SET returnCode = "102";
           ELSE
               SET returnCode = "103";
           END IF;
   END IF;
   
   INSERT INTO tbl_exchangelog(terminalId, merchantName, merchantAddress, couponNo, operation, returnCode, errMessage, createdAt, transactionDate, mobilePhone,transactionNo)
   VALUES(_terminalId,_merchantName,_merchantAddress,_couponNo,'apply',returnCode,_couponNo,NOW(),_transactionDate,NULL,_transactionNo);

END //



-- drop PROCEDURE proc_exchange_coupon
-- proc_exchange_coupon
CREATE PROCEDURE `proc_exchange_coupon`(IN _couponNo VARCHAR(50),IN _accountId INT,IN _quantity INT,IN _terminalId VARCHAR(50),IN _terminalAddress VARCHAR(255),IN _transactionDate VARCHAR(50),OUT returnCode VARCHAR(10))
BEGIN
   
   DECLARE c_counts INT ;

   DECLARE c_employee_balance DECIMAL(16,2);

   DECLARE c_employeeId INT ;

   DECLARE c_marketprice DECIMAL(16,2);

   DECLARE c_unitprice DECIMAL(16,2);

   DECLARE c_merchandise_id INT ;

   DECLARE c_enterprise_id INT ;
   
   DECLARE c_group_merchandise_id INT ;

   DECLARE c_amount_pay DECIMAL(16,2);

   DECLARE c_employeeMobile VARCHAR(20);

   DECLARE c_err_message LONGTEXT;
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
       set returnCode="113";
       set c_err_message = "Unknow error happended!";
       INSERT INTO `tbl_exchangelog` (`terminalId`, `merchantName`, `merchantAddress`, `couponNo`, `operation`, `returnCode`, `errMessage`, `createdAt`, `transactionDate`, `mobilePhone`) VALUES
       (_terminalId,'ishelf', _terminalAddress, _couponNo, 'exchange', returnCode,c_err_message, NOW(),_transactionDate, c_employeeMobile);
   END;

		-- validate couponNO 
		IF (_couponNo IS NULL OR _couponNo = '') THEN	
			set returnCode = "113";
			set c_err_message = "CouponNo could not allow empty!";
		END IF;

   -- check coupon whether exists
   SELECT count(1) INTO c_counts  FROM tbl_orderform o WHERE o.couponNo = _couponNo ;
   IF (returnCode IS NULL AND c_counts >= 1) THEN    
       set returnCode = "101";
	 END IF;
   
   -- find employee
   SELECT count(1) INTO c_counts FROM tbl_qyyg yg WHERE yg.nid = _accountId;
   IF (returnCode IS NULL AND c_counts <> 1) THEN
       set returnCode = "113";
       set c_err_message = "No or mutilpart employee is found";
   END IF;

   -- obtain employee nid and balance
   IF returnCode IS NULL THEN
       SELECT yg.nid,yg.jf,yg.qy,yg.lxdh INTO c_employeeId,c_employee_balance,c_enterprise_id,c_employeeMobile FROM tbl_qyyg yg WHERE yg.nid = _accountId;
   END IF;
   -- find merchandise
   SELECT sp.nid,sp.qbjf,sp.scj,sp.spl into c_merchandise_id,c_unitprice,c_marketprice,c_group_merchandise_id FROM tbl_sp sp WHERE sp.spbh = 'CP_001';
   
   set c_amount_pay = c_unitprice * _quantity ;
   -- check employee balance whether enough to pay
   IF returnCode IS NULL AND c_amount_pay > c_employee_balance THEN
       set returnCode = "102";
   END IF ;
   
   -- check employee balance is null
   IF returnCode IS NULL AND c_employee_balance IS NULL THEN
			 set c_err_message = "Employee jf is NULL";	
       set returnCode = "113";
   END IF ;

	IF returnCode IS NULL AND c_amount_pay IS NULL THEN
			 set c_err_message = "Payment not allow null";	
       set returnCode = "113";
   END IF ;

	IF returnCode IS NULL AND c_amount_pay < 0 THEN
			 set c_err_message = "Payment could not less zero!";	
       set returnCode = "113";
  END IF ;
	


   IF returnCode IS NULL THEN
       -- ELT ORDER MODEL
       INSERT INTO `tbl_ygddzb` (`ddh`, `state`, `cjrq`, `jsrq`, `ydh`, `shrq`, `fhrq`, `zjf`, `zje`, `jfqsl`, `fhr`, `fhrdh`, `yg`, `ddbz`, `shdz`, `shdzxx`, `qsrq`, `gys`) VALUES
       (_couponNo, 1, now(), NOW(), NULL, NULL, NULL, c_amount_pay, 0.00, 0, NULL, NULL, c_employeeId, '实时兑换', NULL, NULL, NULL,NULL);

       -- 3 waiting comment , 9,cancelled
       INSERT INTO `tbl_ygddmx` (`dd`, `sp`, `dhfs`, `sl`, `jf`, `je`, `jfq`, `yg`, `spl`, `jssj`, `ddh`, `state`) VALUES
       (last_insert_id(), c_merchandise_id, NULL, _quantity, c_amount_pay, NULL, NULL, c_employeeId, c_group_merchandise_id, now(), _couponNo, 1);

       UPDATE tbl_qyyg yg SET yg.jf = (c_employee_balance - c_amount_pay) WHERE yg.nid = c_employeeId;

       INSERT INTO `tbl_orderform` (`couponNo`, `merchandiseName`, `sellPrice`, `quantity`, `status`, `merchandiseId`, `orderTime`, `createdAt`, `employeeId`, `mobilePhone`, `unitCode`, `unitPrice`, `units`, `enterpriseId`, `lastUpdatedAt`, `expiredTime`) VALUES
       (_couponNO, 'ishelf', c_marketprice, _quantity, 0, c_merchandise_id,_transactionDate, NOW(), c_employeeId, c_employeeMobile, '积点', 0.8, c_amount_pay, c_enterprise_id, NOW(), NULL);
           
       set returnCode = "100";
   END IF;
   
   INSERT INTO `tbl_exchangelog` (`terminalId`, `merchantName`, `merchantAddress`, `couponNo`, `operation`, `returnCode`, `errMessage`, `createdAt`, `transactionDate`, `mobilePhone`) VALUES
       (_terminalId,'ishelf', _terminalAddress, _couponNo, 'exchange', returnCode,c_err_message, NOW(),_transactionDate, c_employeeMobile);

END //



-- proc_expire_coupon
CREATE PROCEDURE `proc_expire_coupon`(IN `_couponNo` varchar(50),OUT `returnCode` varchar(50))
BEGIN
   DECLARE c_order_status INT;
       
   DECLARE c_order_id INT ;

   DECLARE c_count INT;
   
   DECLARE c_employee_id INT;

   DECLARE c_employee_balance DECIMAL(16,2);
   
   DECLARE c_pay_amounts DECIMAL(16,2);

   DECLARE c_err_message LONGTEXT;
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
       SET returnCode="113";
       SET c_err_message = "Unknow error happended!";
       INSERT INTO tbl_exchangelog(couponNo, operation, returnCode, errMessage, createdAt)
       VALUES(_couponNo,'expire',returnCode,c_err_message,NOW());
   END;

	 -- validate couponNO 
		IF (_couponNo IS NULL OR _couponNo = '') THEN	
			set returnCode = "113";
			set c_err_message = "CouponNo could not allow empty!";
		END IF;
	
		IF returnCode IS NULL THEN 
			SELECT o.`status`,o.id,o.employeeId,o.units INTO c_order_status,c_order_id,c_employee_id,c_pay_amounts FROM tbl_orderform o WHERE o.couponNo=_couponNo;
			SELECT yg.jf INTO c_employee_balance FROM tbl_qyyg yg WHERE yg.nid = c_employee_id;
		END IF;

   IF returnCode IS NULL AND c_order_id IS NULL THEN
           SET returnCode = "101";
   END IF;
   
   IF returnCode IS NULL AND c_pay_amounts IS NOT NULL THEN
           IF c_order_status = 0 THEN
               UPDATE tbl_orderform o SET o.`status` = 3,o.lastUpdatedAt =NOW() WHERE o.id= c_order_id;
               UPDATE tbl_qyyg qy SET qy.jf = (qy.jf + c_pay_amounts) WHERE qy.nid = c_employee_id;

               UPDATE tbl_ygddzb dd SET dd.state = 9 WHERE dd.ddh = _couponNo;
               UPDATE tbl_ygddmx mx SET mx.state= 9 WHERE mx.ddh = _couponNo;
               SET returnCode = "100";
           ELSEIF c_order_status = 1 THEN
               -- expired
               SET returnCode = "102";
           ELSEIF c_order_status = 3 THEN
               -- cancelled
               SET returnCode = "103";
           ELSE
           	   -- used or other error couponNo 	
               SET returnCode = "104";
           END IF;
   END IF;
   
   INSERT INTO tbl_exchangelog(couponNo, operation, returnCode, errMessage, createdAt)
   VALUES(_couponNo,'expire',returnCode,c_err_message,NOW());
END //
 
delimiter ;

grant execute on procedure jxtelt.proc_exchange_coupon to 'jxtelt'@'%';
grant execute on procedure jxtelt.proc_apply_coupon to 'jxtelt'@'%';
grant execute on procedure jxtelt.proc_expire_coupon to 'jxtelt'@'%';
