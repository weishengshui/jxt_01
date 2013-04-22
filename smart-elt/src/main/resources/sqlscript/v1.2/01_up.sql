-- ----------------------------
-- Records of tbl_config
-- ----------------------------
CREATE TABLE IF NOT EXISTS `tbl_expirynotify` (
  `nid` int(11) NOT NULL AUTO_INCREMENT,
  `refid` int(11) DEFAULT NULL,
  `jfq` int(11) DEFAULT NULL,
  `firstnotify` CHAR,
  `firstnotifydate` datetime DEFAULT NULL,
  `secondnotify` CHAR(4),
  `secondnotifydate` datetime DEFAULT NULL,
  `content1` VARCHAR(3000) DEFAULT '0',
  `content2` VARCHAR(3000) DEFAULT '0',
  PRIMARY KEY (`nid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

ALTER TABLE tbl_jfffmc ADD bz varchar(255);

ALTER TABLE tbl_jfffmc ADD ffyy varchar(255);

ALTER TABLE tbl_jfffmc ADD ref varchar(255);
