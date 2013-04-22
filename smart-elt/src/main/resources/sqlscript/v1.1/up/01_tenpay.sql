-- ----------------------------
-- Records of tbl_config
-- ----------------------------
INSERT INTO `tbl_config` VALUES ('rootPath', 'http://192.168.4.243:8080', '');
INSERT INTO `tbl_config` VALUES ('tenpay.key', 'f082e3874be9cdde54523662a2eefeef', '');
INSERT INTO `tbl_config` VALUES ('tenpay.partner', '1214946201', '');
INSERT INTO `tbl_config` VALUES ('tenpay.spname', 'IRewards', '');

CREATE TABLE IF NOT EXISTS `tbl_paylog` (
	 `nid` int(11) NOT NULL AUTO_INCREMENT,
	 `action` varchar(255) DEFAULT NULL,
	 `content` text,
	 `param1` varchar(255),
	 `param2` varchar(255),
	 `param3` varchar(255),
	 `otsParams` text,
	 `logDate` datetime DEFAULT NULL,
	 PRIMARY KEY (`nid`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;