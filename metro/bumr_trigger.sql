#品牌联合会员报表

##########################################################
DROP TABLE IF EXISTS brandunionmember_report;
#联合会员报表
CREATE TABLE `brandunionmember_report` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cardNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `brandId` int(11) DEFAULT NULL,
  `joinedDate` datetime DEFAULT NULL,
  `memberId` int(11) DEFAULT NULL,
  `cardId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

#CREATE INDEX
CREATE INDEX XXX2 ON brandunionmember_report(cardNumber(30), `name`(40), brandId, joinedDate);
CREATE INDEX XXX1 ON brandunionmember_report( brandId, joinedDate);
CREATE INDEX XXX3 ON brandunionmember_report(`name`(40), brandId, joinedDate);

##########################################################
DROP TRIGGER IF EXISTS bum_insert_trigger;
DELIMITER |
CREATE TRIGGER bum_insert_trigger #添加联合会员时，往联合会员报表中插入记录
AFTER INSERT
ON 
BrandUnionMember
FOR EACH ROW
BEGIN
		DECLARE memberId INT;
		DECLARE cardId INT;
		DECLARE bumId INT;
		DECLARE brandId INT;
		DECLARE m_status INT;		
		DECLARE memberName VARCHAR(255);
		DECLARE cardNumber VARCHAR(255);
		DECLARE joinedDate datetime;
		
		SET memberId = NEW.member_id, brandId = NEW.brand_id, joinedDate = NEW.joinedDate, bumId=NEW.id;
		IF memberId IS NOT NULL THEN
			SELECT m.`status`, m.card_id, CONCAT(m.surname,m.`name`) INTO m_status, cardId, memberName FROM Member m WHERE m.id = memberId;
			IF cardId IS NOT NULL THEN
					SELECT mc.cardNumber INTO cardNumber FROM MemberCard mc WHERE mc.id = cardId;
					INSERT INTO brandunionmember_report(id, `name`, cardNumber, brandId, joinedDate, memberId, cardId) VALUES(bumId, memberName, cardNumber, brandId, joinedDate, memberId, cardId);
			END IF;
		END IF;		
END |

DELIMITER ;

##########################################################
DROP TRIGGER IF EXISTS bum_del_trigger;
DELIMITER |
CREATE TRIGGER bum_del_trigger #会员退出某一品牌的联合会员
AFTER DELETE
ON 
BrandUnionMember
FOR EACH ROW
BEGIN
		DELETE FROM brandunionmember_report WHERE id=OLD.id;	
END |

DELIMITER ;

##########################################################
DROP TRIGGER IF EXISTS m_update_trigger;
DELIMITER |
CREATE TRIGGER m_update_trigger #修改会员记录时，删除联合会员报表中的记录或修改联合会员的姓名
AFTER UPDATE
ON 
Member
FOR EACH ROW
BEGIN		
		DECLARE memberName VARCHAR(255);
		IF NEW.status = 3 THEN #会员注销，将从品牌的联合会员中移除，会员的状态是不可逆的
			DELETE FROM brandunionmember_report WHERE memberId=OLD.id;
			#DELETE FROM brandunionmember WHERE member_id=OLD.id; #在注销会员时，在应用中做
		ELSEIF NEW.surname != OLD.surname OR NEW.`name` != OLD.`name` THEN #如果会员的姓名有更改，将更改报表中的会员姓名			
			SET memberName=CONCAT(NEW.surname,NEW.`name`); #将“名”与“姓”连接起来
			UPDATE brandunionmember_report SET `name`=memberName WHERE memberId=OLD.id;
		END IF;		
END |
DELIMITER ;

##########################################################
DROP TRIGGER IF EXISTS mc_update_trigger;
DELIMITER |
CREATE TRIGGER mc_update_trigger #修改会员卡号，更新报表中的卡号
AFTER UPDATE
ON 
MemberCard
FOR EACH ROW
BEGIN
		IF NEW.cardNumber != OLD.cardNumber THEN
			UPDATE brandunionmember_report SET cardNumber=NEW.cardNumber WHERE cardId=OLD.id;		
		END IF;
END |
DELIMITER ;
