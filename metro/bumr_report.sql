##########################################################
#联合会员报表
CREATE TABLE IF NOT EXISTS `brandunionmember_report` (
  `id` int(11) NOT NULL PRIMARY KEY auto_increment,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cardNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `brandId` int(11) DEFAULT NULL,
  `joinedDate` datetime DEFAULT NULL,
  `memberId` int(11) DEFAULT NULL
  #`cardId` int(11) DEFAULT NULL,
  
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

#CREATE INDEX
CREATE INDEX brandunionmember_report_index1 ON brandunionmember_report( brandId, joinedDate);
CREATE INDEX brandunionmember_report_index2 ON brandunionmember_report(cardNumber(30), `name`(40), brandId, joinedDate);
CREATE INDEX brandunionmember_report_index3 ON brandunionmember_report(`name`(40), brandId, joinedDate);
CREATE INDEX brandunionmember_report_index4 ON brandunionmember_report(memberId, brandId);

CREATE INDEX member_index1 ON Member(card_id, updateDate);
CREATE INDEX brandunionmember_index1 ON BrandUnionMember(joinedDate, member_id, brand_id);


#remove invalid record
DELETE FROM brandunionmember_report WHERE brandunionmember_report.id NOT IN (SELECT id FROM brandunionmember);

#update old record

update brandunionmember_report bumr 
inner join (
SELECT CONCAT(m.surname,m.name) as name, mc.cardNumber AS cardNumber, b.id AS brandId, m.id AS memberId
FROM brandunionmember bum, brand b, member m, membercard mc 
WHERE mc.id = m.card_id AND bum.brand_id=b.id AND bum.member_id=m.id 
AND m.updateDate >='2012-04-01 00:00:00' AND m.updateDate <= '2012-04-02 00:00:00'
) bum
on bumr.brandId=bum.brandId AND bumr.memberId=bum.memberId  
set bumr.`name` = bum.`name`, bumr.cardNumber = bum.cardNumber;

#add new record
INSERT INTO brandunionmember_report(id, `name`, `cardNumber`, `brandId`, `joinedDate`, `memberId`) 
SELECT bum.id AS id, CONCAT(m.surname,m.name) as name, mc.cardNumber AS cardNumber, b.id AS brandId, bum.joinedDate AS joinedDate, m.id AS memberId
#, mc.id AS cardId
FROM brandunionmember bum, brand b, member m, membercard mc 
WHERE mc.id = m.card_id AND bum.brand_id=b.id AND bum.member_id=m.id 
AND bum.joinedDate >='2012-04-01 00:00:00' AND bum.joinedDate <= '2012-04-02 00:00:00'
AND NOT EXISTS ( SELECT * FROM brandunionmember_report bumr WHERE bumr.brandId=b.id AND bumr.memberId=m.id )

