
-- 60个积分兑换1张5元现金抵用券 
INSERT INTO unit VALUES(2, '积点', 12);
-- 在http://xxxxx:8080/alading 上传图片，得到一个id为 1 的fileitem
INSERT INTO card(id, cardName, picUrl, unit_id) VALUES(1, 'IRewards积点卡', 1, 2);

-- 将所有企业 初始化为默认的卡， 即“IRewards积点卡”
INSERT INTO companyCard(card_Id, company_Id) SELECT 1, nid FROM tbl_qy;