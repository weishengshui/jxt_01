
DROP TABLE IF EXISTS companyCard;
DROP TABLE IF EXISTS card;
DROP TABLE IF EXISTS unit;
DROP TABLE IF EXISTS `fileitem`;

CREATE TABLE IF NOT EXISTS `fileitem` (
  `id` int NOT NULL auto_increment,
  `description` longtext,
  `filesize` bigint(20) DEFAULT NULL,  
  `mimeType` varchar(255) DEFAULT NULL,
  `originalFilename` varchar(255) DEFAULT NULL,    
  `content` blob(10485760),
  PRIMARY KEY (`id`)
);

-- 积分单位表
CREATE TABLE IF NOT EXISTS unit
(
pointId INT NOT NULL ,
pointName VARCHAR(255),
pointRate INT,
PRIMARY KEY(pointId)
);

-- 会员卡表
CREATE TABLE IF NOT EXISTS card
(
id INT NOT NULL auto_increment,
cardName VARCHAR(255),
picUrl INT ,
unit_id INT,
PRIMARY KEY(id),
CONSTRAINT fk_cardUnit FOREIGN KEY (unit_id) REFERENCES unit(pointId),
CONSTRAINT fk_picUrl FOREIGN KEY (picUrl) REFERENCES fileitem(id)
);

-- 企业会员卡关系表
CREATE TABLE IF NOT EXISTS companyCard
(
id INT NOT NULL auto_increment,
card_Id INT,
company_Id INT,
PRIMARY KEY(id),
CONSTRAINT fk_card FOREIGN KEY (card_id) REFERENCES card(id),
CONSTRAINT fk_company FOREIGN KEY (company_Id) REFERENCES tbl_qy(nid)
);

-- 60个积分兑换1张5元现金抵用券 
INSERT INTO unit VALUES(2, '积点', 12);
INSERT INTO card(cardName, picUrl, unit_id) VALUES('缤分联盟卡', NULL, 2);

