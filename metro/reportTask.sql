

SHOW INDEX FROM brandunionmember;
SHOW INDEX FROM member;

CREATE INDEX member_index1 ON member(card_id, updateDate);
CREATE INDEX brandunionmember_index1 ON brandunionmember(member_id, brand_id);

DESC member;
DESC brandunionmember;
DESC brandunionmember_report;

#add new record
INSERT INTO brandunionmember_report(`name`, `cardNumber`, `brandId`, `joinedDate`, `memberId`) 
(
SELECT CONCAT(m.surname,m.name) as name, mc.cardNumber AS cardNumber, b.id AS brandId, bum.joinedDate AS joinedDate, m.id AS memberId
#, mc.id AS cardId
FROM brandunionmember bum, brand b, member m, membercard mc 
WHERE mc.id = m.card_id AND bum.brand_id=b.id AND bum.member_id=m.id 
AND m.updateDate >='2012-04-01 00:00:00' AND m.updateDate <= '2012-04-02 00:00:00'
AND NOT EXISTS ( SELECT * FROM brandunionmember_report bumr WHERE bumr.brandId=b.id AND bumr.memberId=m.id )
)


#update old record




#remove invalid record