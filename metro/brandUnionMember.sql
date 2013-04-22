

SELECT COUNT(*) FROM brandunionmember;




select bum.brand_id as brandId, bum.joinedDate as joinedDate
, bum.member_id as memberId 
from BrandUnionMember bum inner join Brand b
 on bum.brand_id=b.id inner join Member m on bum.member_id=m.id 
where b.id=1 order by bum.joinedDate DESC limit 0,65535

#查询1
select bum.id as id14_, bum.brand_id as brand5_14_, bum.createdAt as createdAt14_
, bum.createdBy as createdBy14_, bum.joinedDate as joinedDate14_, bum.member_id as member6_14_ 
from BrandUnionMember bum inner join Brand b on bum.brand_id=b.id inner join Member m on bum.member_id=m.id 
where 1=1 and b.id=1 order by bum.joinedDate DESC limit 2300, 10
时间: 23.437s
时间: 21.062s
时间: 20.890s
时间: 21.156s
#AFTER CREATE INDEX brandunionmember_memberId_brandId_index ON brandunionmember(brand_id, member_id);
时间: 21.375s

#ALTER TABLE brandunionmember DROP INDEX brandunionmember_joinedDate_index;
时间: 245.000s

#查询2
select  bum.brand_id as brand5_14_
, bum.joinedDate as joinedDate14_, bum.member_id as member6_14_ 
from BrandUnionMember bum inner join Brand b on bum.brand_id=b.id inner join Member m on bum.member_id=m.id 
where 1=1 and b.id=1 order by bum.joinedDate DESC limit 1600, 10
时间: 23.281s
时间: 13.937s

#查询3
select  bum.brand_id as brand5_14_
, bum.joinedDate as joinedDate14_, bum.member_id as member6_14_ 
from BrandUnionMember bum, Brand b, Member m 
where 1=1 and b.id=1 AND bum.brand_id=b.id AND bum.member_id=m.id   order by bum.joinedDate DESC limit 2600, 10
时间: 23.391s
时间: 20.859s
时间: 20.875s
时间: 8.844s
时间: 8.265s(删除在joinedDate上的index，效率有明显提升)
时间: 20.828s
时间: 20.750s
#结论：查询3 比 查询1 优。且 删除在joinedDate上的index，效率有明显提升， 但在joinedDate上的index对查询1有帮助
时间: 12.500s
时间: 8.000s
时间: 13.921s


CREATE INDEX brandunionmember_memberId_brandId_index ON brandunionmember(brand_id, member_id);
#AFTER CREATE INDEX brandunionmember_memberId_brandId_index ON brandunionmember(brand_id, member_id);


DESC brandunionmember;

SHOW INDEX FROM brandunionmember;



CREATE INDEX brandunionmember_joinedDate_index ON brandunionmember(joinedDate);
ALTER TABLE brandunionmember DROP INDEX brandunionmember_joinedDate_index;







##################################################################################################################################################
#BEFORE CREATE INDEX brandunionmember_joinedDate_index ON brandunionmember(joinedDate);
时间: 17.235s
时间: 7.329s

时间: 7.718s
时间: 7.719s
select bum.brand_id as brandId, bum.joinedDate as joinedDate
, bum.member_id as memberId 
from BrandUnionMember bum inner join Brand b
 on bum.brand_id=b.id 
where b.id=1 
order by bum.joinedDate DESC 
limit 1,65535;

select bum.brand_id as brandId, bum.joinedDate as joinedDate
, bum.member_id as memberId 
from BrandUnionMember bum inner join Brand b
 on bum.brand_id=b.id 
where b.id=1 
order by bum.joinedDate DESC
 limit 131710,65535

##################################################################################################################################################
CREATE INDEX brandunionmember_joinedDate_index ON brandunionmember(joinedDate);
#AFTER CREATE INDEX brandunionmember_joinedDate_index ON brandunionmember(joinedDate);
时间: 6.891s
时间: 7.610s

时间: 6.891s
时间: 7.703s

时间: 7.703s
时间: 7.250s
select bum.brand_id as brandId, bum.joinedDate as joinedDate
, bum.member_id as memberId 
from BrandUnionMember bum inner join Brand b
 on bum.brand_id=b.id 
where b.id=1 
order by bum.joinedDate DESC 
limit 1,65535;

select bum.brand_id as brandId, bum.joinedDate as joinedDate
, bum.member_id as memberId 
from BrandUnionMember bum inner join Brand b
 on bum.brand_id=b.id 
where b.id=1 
order by bum.joinedDate DESC
 limit 131710,65535

结论：CREATE INDEX brandunionmember_joinedDate_index ON brandunionmember(joinedDate);没有效果

删除在joinedDate上的index
ALTER TABLE brandunionmember DROP INDEX brandunionmember_joinedDate_index;



