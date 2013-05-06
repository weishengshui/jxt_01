--    Copyright 2010-2012 The MyBatis Team

--    Licensed under the Apache License, Version 2.0 (the "License");
--    you may not use this file except in compliance with the License.
--    You may obtain a copy of the License at

--       http://www.apache.org/licenses/LICENSE-2.0

--    Unless required by applicable law or agreed to in writing, software
--    distributed under the License is distributed on an "AS IS" BASIS,
--    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--    See the License for the specific language governing permissions and
--    limitations under the License.

--    version: $Id$

insert into users(id, name) VALUES (1, 'Pocoyo'),(2, 'Pato'),(3, 'Eli'),(4, 'Valentina');

insert into tbl_orderform values( 1, '001',  NULL, 60, 5, 0, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25', 1, '',  NULL, 12, 60, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25') -- 抵用券可用
,( 2, '002',  NULL, 60, 5, 1, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25', 2, '',  NULL, 12, 60, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25') -- 已过期
,( 3, '003',  NULL, 60, 5, 2, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25', 2, '',  NULL, 12, 60, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25') -- 已使用
,( 4, '004',  NULL, 60, 5, 3, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25', 2, '',  NULL, 12, 60, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25') -- 已取消
,( 5, '005',  NULL, 60, 5, 4, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25', 2, '',  NULL, 12, 60, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25') -- 错误的状态
,( 6, '006',  NULL, 60, 5, 0, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25', 3, '',  NULL, 12, 60, 1, '2012-01-01 12:23:25', '2012-01-01 12:23:25') -- 已锁定(非正常状态)
;

INSERT INTO tbl_qyyg VALUES ('1', '1', '', '梁桢-2', '1', NULL, '', NULL, '', 'zhen.liang@china-rewards.com', NULL, '1', '1', NULL, 'e5515a7de40d2b3266e8a4929ed1642b', NULL, '5400', '0', '', NULL, NULL, NULL);
INSERT INTO tbl_qyyg VALUES ('2', '1', '', '倪云华', '1', NULL, '', NULL, '', 'yunhua.ni@china-rewards.com', '2012-11-01 00:00:00', '1', '1', NULL, '788d06895bb6740f9ee00ac2bb9157b4', NULL, '3100', '1', ',1,2,3,4,5,6,7,10,11,12,13,', NULL, NULL, 'yunhua');
INSERT INTO tbl_qyyg VALUES ('3', '1', '', '梁桢', '1', NULL, '', NULL, '', '405825526$qq.com', NULL, '0', '1', NULL, '40923b3cd82f1c35fbcf55d42ce9d774', NULL, '0', '0', NULL, NULL, NULL, NULL);

