CREATE TABLE IF NOT EXISTS `tbl_orderform` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `couponNo` varchar(50) NOT NULL,
  `merchandiseName` varchar(255) DEFAULT NULL,
  `sellPrice` double(16,0) DEFAULT NULL COMMENT '抵用券的售卖价格',
  `quantity` int(11) DEFAULT NULL COMMENT '抵用券数量',
  `status` int(2) DEFAULT NULL COMMENT '0订单可用,1过期，2，已使用，3已取消',
  `merchandiseId` int(50) DEFAULT NULL,
  `orderTime` datetime DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL COMMENT '员工Id',
  `mobilePhone` varchar(30) DEFAULT NULL COMMENT '下订单的手机号码',
  `unitCode` varchar(10) DEFAULT NULL,
  `unitPrice` double(16,0) DEFAULT NULL,
  `units` double(16,0) DEFAULT NULL COMMENT '使用积分数量',
  `enterpriseId` int(11) DEFAULT NULL COMMENT '企业id',
  `lastUpdatedAt` datetime DEFAULT NULL,
  `expiredTime` datetime DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--DROP TABLE IF EXISTS `tbl_exchangelog`;
CREATE TABLE IF NOT EXISTS `tbl_exchangelog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `terminalId` varchar(50) DEFAULT NULL,
  `merchantName` varchar(255) DEFAULT NULL,
  `merchantAddress` varchar(50) DEFAULT NULL,
  `couponNo` varchar(50) DEFAULT NULL COMMENT '终端请求日志表',
  `operation` varchar(255) DEFAULT NULL,
  `returnCode` varchar(10) DEFAULT NULL,
  `errMessage` longtext,
  `createdAt` datetime NOT NULL,
  `transactionDate` datetime DEFAULT NULL,
  `mobilePhone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;