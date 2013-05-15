
-- DROP TABLE IF EXISTS companyCard;
-- DROP TABLE IF EXISTS card;
-- DROP TABLE IF EXISTS unit;
-- DROP TABLE IF EXISTS `fileitem`;

CREATE TABLE IF NOT EXISTS `fileitem` (
  `id` int(11) NOT NULL auto_increment,
  `description` longtext,
  `filesize` bigint(20) DEFAULT NULL,  
  `mimeType` varchar(255) DEFAULT NULL,
  `originalFilename` varchar(255) DEFAULT NULL,    
  `content` blob(10485760),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- 积分单位表
CREATE TABLE IF NOT EXISTS unit
(
pointId INT(11) NOT NULL,
pointName VARCHAR(255),
pointRate INT,
PRIMARY KEY(pointId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- 会员卡表
CREATE TABLE IF NOT EXISTS card
(
id INT(11) NOT NULL auto_increment,
cardName VARCHAR(255) not null,
picUrl INT ,
unit_id INT,
PRIMARY KEY(id),
CONSTRAINT fk_cardUnit FOREIGN KEY (unit_id) REFERENCES unit(pointId),
CONSTRAINT fk_picUrl FOREIGN KEY (picUrl) REFERENCES fileitem(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- 企业会员卡关系表
CREATE TABLE IF NOT EXISTS companyCard
(
id INT(11) NOT NULL auto_increment,
card_Id INT,
company_Id INT,
PRIMARY KEY(id),
CONSTRAINT fk_card FOREIGN KEY (card_id) REFERENCES card(id),
CONSTRAINT fk_company FOREIGN KEY (company_Id) REFERENCES tbl_qy(nid)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;


-- DROP TABLE IF EXISTS `tbl_orderform`;
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
  `transactionNo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- DROP TABLE IF EXISTS `tbl_exchangelog`;
CREATE TABLE IF NOT EXISTS `tbl_exchangelog` (
  `id` int(11) NOT NULL,
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
  `transactionNo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- 1 表示默认卡，只有一张默认卡
alter table card add column defaultCard bit default 0;

alter table unit modify pointId int not null auto_increment;
