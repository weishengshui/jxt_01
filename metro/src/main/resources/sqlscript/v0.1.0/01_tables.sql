-- phpMyAdmin SQL Dump
-- version 3.3.10deb1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2013 年 01 月 14 日 17:04
-- 服务器版本: 5.1.63
-- PHP 版本: 5.3.5-1ubuntu7.11

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `metro`
--

-- --------------------------------------------------------

--
-- 表的结构 `Account`
--

CREATE TABLE IF NOT EXISTS `Account` (
  `accountId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `accountType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `AccountBalance`
--

CREATE TABLE IF NOT EXISTS `AccountBalance` (
  `id` int(11) NOT NULL,
  `account` tinyblob,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unitCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `units` double NOT NULL,
  `version` bigint(20) NOT NULL,
  `expDate` date DEFAULT NULL,
  `unitPrice` double NOT NULL,
  `account_accountId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDAD9EC0FFBA13741` (`account_accountId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `AccountBalanceUnits`
--

CREATE TABLE IF NOT EXISTS `AccountBalanceUnits` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `accountBalance` tinyblob,
  `availableDay` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expDate` date DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unit` tinyblob,
  `unitPrice` double NOT NULL,
  `units` double NOT NULL,
  `version` bigint(20) NOT NULL,
  `expired` bit(1) NOT NULL,
  `lastUpadtedAt` datetime DEFAULT NULL,
  `lastUpdatedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accountBalance_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tx_txId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unit_unitId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDAF3ACA030F77F6` (`tx_txId`),
  KEY `FKDAF3ACA07D78E60` (`unit_unitId`),
  KEY `FKDAF3ACA0AB990DC` (`accountBalance_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `AccountSequence`
--

CREATE TABLE IF NOT EXISTS `AccountSequence` (
  `sequenceId` bigint(20) NOT NULL,
  PRIMARY KEY (`sequenceId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ActivityInfo`
--

CREATE TABLE IF NOT EXISTS `ActivityInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activityName` varchar(255) NOT NULL,
  `activityNet` varchar(255) DEFAULT NULL,
  `conTel` varchar(255) DEFAULT NULL,
  `contacts` varchar(255) DEFAULT NULL,
  `description` text,
  `endDate` datetime NOT NULL,
  `hoster` varchar(255) DEFAULT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `tag` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=34 ;

-- --------------------------------------------------------

--
-- 表的结构 `BirthRule`
--

CREATE TABLE IF NOT EXISTS `BirthRule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `times` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

--
-- 表的结构 `Brand`
--

CREATE TABLE IF NOT EXISTS `Brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(255) DEFAULT NULL,
  `companyWebSite` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `description` text,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `unionInvited` bit(1) NOT NULL,
  `logo_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3D75B67FEE5766F` (`logo_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- 表的结构 `BrandActivity`
--

CREATE TABLE IF NOT EXISTS `BrandActivity` (
  `gid` int(11) NOT NULL AUTO_INCREMENT,
  `joinTime` datetime DEFAULT NULL,
  `activityInfo_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`gid`),
  KEY `FKD8FB5B96B8789612` (`brand_id`),
  KEY `FKD8FB5B967C26C998` (`activityInfo_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=36 ;

-- --------------------------------------------------------

--
-- 表的结构 `BrandUnionMember`
--

CREATE TABLE IF NOT EXISTS `BrandUnionMember` (
  `id` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `joinedDate` datetime NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC4522C62A8D494AD` (`member_id`),
  KEY `FKC4522C62B8789612` (`brand_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Category`
--

CREATE TABLE IF NOT EXISTS `Category` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lft` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rgt` bigint(20) NOT NULL,
  `parent_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `displaySort` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6DD211EE91BA89D` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `City`
--

CREATE TABLE IF NOT EXISTS `City` (
  `id` int(11) NOT NULL,
  `codeName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `province_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK200D8B2FDB56B8` (`province_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ConsumptionType`
--

CREATE TABLE IF NOT EXISTS `ConsumptionType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `num` int(11) DEFAULT NULL,
  `shopId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `DiscountCodeImport`
--

CREATE TABLE IF NOT EXISTS `DiscountCodeImport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discountNum` varchar(255) DEFAULT NULL,
  `importDate` datetime DEFAULT NULL,
  `isRecived` int(11) DEFAULT NULL,
  `shopId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=191 ;

-- --------------------------------------------------------

--
-- 表的结构 `DiscountNumber`
--

CREATE TABLE IF NOT EXISTS `DiscountNumber` (
  `id` int(11) NOT NULL,
  `discountNum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expiredDate` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `generatedDate` datetime DEFAULT NULL,
  `member` tinyblob,
  `privilege` tinyblob,
  `shop_id` int(11) DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descr` longtext COLLATE utf8_unicode_ci,
  `activityInfo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB1D6540A3F8F54D1` (`shop_id`),
  KEY `FKB1D6540A7C26C998` (`activityInfo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `DiscountNumberHistory`
--

CREATE TABLE IF NOT EXISTS `DiscountNumberHistory` (
  `id` int(11) NOT NULL,
  `discountNum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expiredDate` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `generatedDate` datetime DEFAULT NULL,
  `member` tinyblob,
  `privilege` tinyblob,
  `usedDate` datetime DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `status` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3D67692A3F8F54D1` (`shop_id`),
  KEY `FK3D67692AA8D494AD` (`member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `FileItem`
--

CREATE TABLE IF NOT EXISTS `FileItem` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `filesize` bigint(20) NOT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimeType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `originalFilename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `IntegralRule`
--

CREATE TABLE IF NOT EXISTS `IntegralRule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AmountConsumedFrom` double DEFAULT NULL,
  `AmountConsumedTo` double DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rangeAgeFrom` int(11) DEFAULT NULL,
  `rangeAgeTo` int(11) DEFAULT NULL,
  `rangeFrom` datetime DEFAULT NULL,
  `rangeTo` datetime DEFAULT NULL,
  `ruleName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `times` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=16 ;

-- --------------------------------------------------------

--
-- 表的结构 `Ledger`
--

CREATE TABLE IF NOT EXISTS `Ledger` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `expDate` date DEFAULT NULL,
  `txDate` datetime DEFAULT NULL,
  `unitCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unitPrice` double NOT NULL,
  `units` double NOT NULL,
  `account_accountId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `transaction_txId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `unit_unitId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK876E998956DD5BDC` (`transaction_txId`),
  KEY `FK876E9989FBA13741` (`account_accountId`),
  KEY `FK876E99897D78E60` (`unit_unitId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Member`
--

CREATE TABLE IF NOT EXISTS `Member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthDay` datetime DEFAULT NULL,
  `cashAccount` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createDate` datetime DEFAULT NULL,
  `createUser` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `education` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `identityCard` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `industry` int(11) DEFAULT NULL,
  `integralAccount` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `postcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profession` int(11) DEFAULT NULL,
  `province` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `updateDate` datetime DEFAULT NULL,
  `updateUser` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `valiCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `surname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- 表的结构 `MemberCard`
--

CREATE TABLE IF NOT EXISTS `MemberCard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cardNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=37 ;

-- --------------------------------------------------------

--
-- 表的结构 `MemberIntegralAccountHistory`
--

CREATE TABLE IF NOT EXISTS `MemberIntegralAccountHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business` varchar(255) DEFAULT NULL,
  `businiessNo` varchar(255) DEFAULT NULL,
  `giftCount` int(11) DEFAULT NULL,
  `giftName` varchar(255) DEFAULT NULL,
  `integral` double NOT NULL,
  `preTxIntegral` double NOT NULL,
  `ruleName` varchar(255) DEFAULT NULL,
  `shopName` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `transactionDate` datetime DEFAULT NULL,
  `txAmount` double NOT NULL,
  `txSource` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4F7BD5CDA8D494AD` (`member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `MemberSavingsAccountHistory`
--

CREATE TABLE IF NOT EXISTS `MemberSavingsAccountHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `balance` double NOT NULL,
  `businiessNo` varchar(255) DEFAULT NULL,
  `giftCount` int(11) DEFAULT NULL,
  `giftName` varchar(255) DEFAULT NULL,
  `preTxBalance` double NOT NULL,
  `status` int(11) DEFAULT NULL,
  `transactionDate` datetime DEFAULT NULL,
  `txSource` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1B404826A8D494AD` (`member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `merchandise`
--

CREATE TABLE IF NOT EXISTS `merchandise` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) NOT NULL,
  `model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `purchasePrice` double DEFAULT NULL,
  `supplierName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `model` (`model`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Merchandise`
--

CREATE TABLE IF NOT EXISTS `Merchandise` (
  `id` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) NOT NULL,
  `model` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `purchasePrice` varchar(255) DEFAULT NULL,
  `supplierName` varchar(255) DEFAULT NULL,
  `category_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `model` (`model`),
  KEY `FK859C7BA3C95DA3C9` (`category_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `MerchandiseCatalog`
--

CREATE TABLE IF NOT EXISTS `MerchandiseCatalog` (
  `id` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `displaySort` bigint(20) DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) NOT NULL,
  `price` double DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `unitName` varchar(255) DEFAULT NULL,
  `merchandise_id` varchar(255) DEFAULT NULL,
  `unitId` varchar(255) DEFAULT NULL,
  `category_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC2AAEF69063B58E` (`merchandise_id`),
  KEY `FKC2AAEF6C95DA3C9` (`category_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `merchandisecatalog`
--

CREATE TABLE IF NOT EXISTS `merchandisecatalog` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `displaySort` bigint(20) DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) NOT NULL,
  `price` double DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unitId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `merchandise_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC2AAEF6C95DA3C9` (`category_id`),
  KEY `FKC2AAEF69063B58E` (`merchandise_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `merchandisefile`
--

CREATE TABLE IF NOT EXISTS `merchandisefile` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `filesize` bigint(20) NOT NULL,
  `imageType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) DEFAULT NULL,
  `mimeType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `originalFilename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `merchandise_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK26015BBF9063B58E` (`merchandise_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `MerchandiseFile`
--

CREATE TABLE IF NOT EXISTS `MerchandiseFile` (
  `id` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `features` varchar(255) DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` int(11) DEFAULT NULL,
  `fileItem_id` varchar(255) DEFAULT NULL,
  `merchandise_id` varchar(255) DEFAULT NULL,
  `description` longtext,
  `filesize` bigint(20) NOT NULL,
  `imageType` varchar(255) DEFAULT NULL,
  `mimeType` varchar(255) DEFAULT NULL,
  `originalFilename` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK26015BBF76920F0B` (`fileItem_id`),
  KEY `FK26015BBF9063B58E` (`merchandise_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `MessageTask`
--

CREATE TABLE IF NOT EXISTS `MessageTask` (
  `taskId` varchar(255) NOT NULL,
  `actualSendTime` datetime DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `notSentAmount` int(11) NOT NULL,
  `planSendTime` datetime DEFAULT NULL,
  `taskName` varchar(255) DEFAULT NULL,
  `taskStates` int(11) DEFAULT NULL,
  `telephoneFile` tinyblob,
  PRIMARY KEY (`taskId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `MessageTelephone`
--

CREATE TABLE IF NOT EXISTS `MessageTelephone` (
  `telephoneId` int(11) NOT NULL AUTO_INCREMENT,
  `states` int(11) NOT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `messageTask_taskId` varchar(255) DEFAULT NULL,
  `sendTime` datetime DEFAULT NULL,
  PRIMARY KEY (`telephoneId`),
  KEY `FKC15C2FDD5D4DBD97` (`messageTask_taskId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=202 ;

-- --------------------------------------------------------

--
-- 表的结构 `MetroLine`
--

CREATE TABLE IF NOT EXISTS `MetroLine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numno` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lbx` double DEFAULT '0',
  `lby` double DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=140 ;

-- --------------------------------------------------------

--
-- 表的结构 `MetroLineSite`
--

CREATE TABLE IF NOT EXISTS `MetroLineSite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderNo` int(11) DEFAULT NULL,
  `lineId` int(11) DEFAULT NULL,
  `siteId` int(11) DEFAULT NULL,
  `line_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `lindId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK9B340174F4024986` (`lineId`),
  KEY `FK9B340174FFFA1F6C` (`siteId`),
  KEY `FK9B340174404706BD` (`line_id`),
  KEY `FK9B340174B2EA61DD` (`site_id`),
  KEY `FK9B340174F40245C5` (`lindId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1102 ;

-- --------------------------------------------------------

--
-- 表的结构 `MetroSite`
--

CREATE TABLE IF NOT EXISTS `MetroSite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rx` double DEFAULT '0',
  `ry` double DEFAULT '0',
  `x` double DEFAULT '0',
  `y` double DEFAULT '0',
  `descs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=994 ;

-- --------------------------------------------------------

--
-- 表的结构 `OrderInfo`
--

CREATE TABLE IF NOT EXISTS `OrderInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bankPay` decimal(19,2) DEFAULT NULL,
  `beforeCash` decimal(19,2) DEFAULT NULL,
  `beforeUnits` decimal(19,2) DEFAULT NULL,
  `cash` decimal(19,2) DEFAULT NULL,
  `clerkId` varchar(255) DEFAULT NULL,
  `couponCode` varchar(255) DEFAULT NULL,
  `deliverTime` datetime DEFAULT NULL,
  `integration` decimal(19,2) DEFAULT NULL,
  `matchedRules` varchar(255) DEFAULT NULL,
  `memberCard` decimal(19,2) DEFAULT NULL,
  `orderNo` varchar(255) DEFAULT NULL,
  `orderPrice` decimal(19,2) DEFAULT NULL,
  `orderSource` varchar(255) DEFAULT NULL,
  `orderTime` datetime DEFAULT NULL,
  `redemptionQuantity` int(11) NOT NULL,
  `serialId` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `usingCode` decimal(19,2) DEFAULT NULL,
  `account_accountId` varchar(255) DEFAULT NULL,
  `merchandise_id` varchar(255) DEFAULT NULL,
  `posBind_id` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  `tx_txId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK601628FCFBA13741` (`account_accountId`),
  KEY `FK601628FC30F77F6` (`tx_txId`),
  KEY `FK601628FC9332757F` (`posBind_id`),
  KEY `FK601628FC3F8F54D1` (`shop_id`),
  KEY `FK601628FC9063B58E` (`merchandise_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `PointExpiredQueue`
--

CREATE TABLE IF NOT EXISTS `PointExpiredQueue` (
  `id` varchar(255) NOT NULL,
  `CompletedAt` datetime DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `accBalanceUnits_id` varchar(255) DEFAULT NULL,
  `tx_txId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5DB3427C30F77F6` (`tx_txId`),
  KEY `FK5DB3427C965ABC84` (`accBalanceUnits_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `Pos`
--

CREATE TABLE IF NOT EXISTS `Pos` (
  `id` int(11) NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK13A343F8F54D1` (`shop_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `PosBind`
--

CREATE TABLE IF NOT EXISTS `PosBind` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bindDate` datetime DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `fId` int(11) DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) DEFAULT NULL,
  `mark` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

--
-- 表的结构 `POSSalesDetail`
--

CREATE TABLE IF NOT EXISTS `POSSalesDetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consumeType` varchar(255) DEFAULT NULL,
  `quantity` decimal(19,2) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4A419DA992A2201B` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `PriorityPeriodLimit`
--

CREATE TABLE IF NOT EXISTS `PriorityPeriodLimit` (
  `priority` int(11) NOT NULL,
  `lastMod` datetime DEFAULT NULL,
  `timeRange` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`priority`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `Privilege`
--

CREATE TABLE IF NOT EXISTS `Privilege` (
  `id` int(11) NOT NULL,
  `activeDate` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `expireDate` datetime DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Province`
--

CREATE TABLE IF NOT EXISTS `Province` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Region`
--

CREATE TABLE IF NOT EXISTS `Region` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK91AD1314513497D8` (`city_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ResourceOperation`
--

CREATE TABLE IF NOT EXISTS `ResourceOperation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `limitValue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK60A620D96ED6732F` (`resource_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- 表的结构 `Resources`
--

CREATE TABLE IF NOT EXISTS `Resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `button_rights` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(255) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=48 ;

-- --------------------------------------------------------

--
-- 表的结构 `Role`
--

CREATE TABLE IF NOT EXISTS `Role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- 表的结构 `RoleResources`
--

CREATE TABLE IF NOT EXISTS `RoleResources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resources_id` int(255) DEFAULT NULL,
  `rights` int(11) DEFAULT NULL,
  `role_id` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=239 ;

-- --------------------------------------------------------

--
-- 表的结构 `Shop`
--

CREATE TABLE IF NOT EXISTS `Shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `businessHours` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `discountModel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expresion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `features` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `province` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `workPhone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `siteId` int(11) DEFAULT NULL,
  `shopChain_id` int(11) DEFAULT NULL,
  `num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `site` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metroLineSite_id` int(11) DEFAULT NULL,
  `activeDate` datetime DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expireDate` datetime DEFAULT NULL,
  `linkman` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `privilegeDesc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `privilegeTile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `orderNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK274F164CE5F143` (`shopChain_id`),
  KEY `FK274F16AA7B8144` (`siteId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=98 ;

-- --------------------------------------------------------

--
-- 表的结构 `ShopBrand`
--

CREATE TABLE IF NOT EXISTS `ShopBrand` (
  `id` int(11) NOT NULL,
  `joinDate` datetime DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKF8740A113F8F54D1` (`shop_id`),
  KEY `FKF8740A11B8789612` (`brand_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ShopChain`
--

CREATE TABLE IF NOT EXISTS `ShopChain` (
  `id` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hotline` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ShopFile`
--

CREATE TABLE IF NOT EXISTS `ShopFile` (
  `id` int(11) NOT NULL,
  `fileItem_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKEF3F3DB276920F0B` (`fileItem_id`),
  KEY `FKEF3F3DB23F8F54D1` (`shop_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ShopPrivilege`
--

CREATE TABLE IF NOT EXISTS `ShopPrivilege` (
  `id` int(11) NOT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `privilege_id` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKFD5E603B499C98FC` (`privilege_id`),
  KEY `FKFD5E603B3F8F54D1` (`shop_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `SMSInbox`
--

CREATE TABLE IF NOT EXISTS `SMSInbox` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `optlock` bigint(20) NOT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `providerMessageId` varchar(255) DEFAULT NULL,
  `receivedDate` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `SMSOutbox`
--

CREATE TABLE IF NOT EXISTS `SMSOutbox` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `destId` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `expectSendDate` datetime DEFAULT NULL,
  `failCount` int(11) DEFAULT NULL,
  `lastFail` datetime DEFAULT NULL,
  `optlock` bigint(20) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `providerTaskId` varchar(255) DEFAULT NULL,
  `providerUsed` varchar(255) DEFAULT NULL,
  `sentDate` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `submitDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=134 ;

-- --------------------------------------------------------

--
-- 表的结构 `SMSOutboxHistory`
--

CREATE TABLE IF NOT EXISTS `SMSOutboxHistory` (
  `id` bigint(20) NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `destId` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `expectSendDate` datetime DEFAULT NULL,
  `failCount` int(11) DEFAULT NULL,
  `lastFail` datetime DEFAULT NULL,
  `optlock` bigint(20) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `providerTaskId` varchar(255) DEFAULT NULL,
  `providerUsed` varchar(255) DEFAULT NULL,
  `sentDate` datetime DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `submitDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `Transaction`
--

CREATE TABLE IF NOT EXISTS `Transaction` (
  `txId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `businiessNo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdAt` date NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` date NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` bigint(20) DEFAULT NULL,
  `transactionDate` date NOT NULL,
  `busines` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`txId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `TransactionQueue`
--

CREATE TABLE IF NOT EXISTS `TransactionQueue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `unitCode` varchar(255) DEFAULT NULL,
  `units` decimal(19,2) DEFAULT NULL,
  `account_accountId` varchar(255) DEFAULT NULL,
  `tx_txId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKEB56B4F3FBA13741` (`account_accountId`),
  KEY `FKEB56B4F330F77F6` (`tx_txId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `TransactionSequence`
--

CREATE TABLE IF NOT EXISTS `TransactionSequence` (
  `sequenceId` bigint(20) NOT NULL,
  PRIMARY KEY (`sequenceId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Unit`
--

CREATE TABLE IF NOT EXISTS `Unit` (
  `unitId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `availableDay` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` datetime NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` double NOT NULL,
  `unitCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numberOfDecimals` int(11) NOT NULL,
  `available` int(11) DEFAULT NULL,
  `availableUnit` int(11) DEFAULT NULL,
  `displayName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`unitId`),
  UNIQUE KEY `unitCode` (`unitCode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `unit`
--

CREATE TABLE IF NOT EXISTS `unit` (
  `unitId` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `available` int(11) DEFAULT NULL,
  `availableUnit` int(11) DEFAULT NULL,
  `createdAt` date DEFAULT NULL,
  `createdBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastModifiedAt` date NOT NULL,
  `lastModifiedBy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numberOfDecimals` int(11) NOT NULL,
  `price` double NOT NULL,
  `unitCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`unitId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `UnitLedger`
--

CREATE TABLE IF NOT EXISTS `UnitLedger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `available` int(11) DEFAULT NULL,
  `availableUnit` int(11) DEFAULT NULL,
  `numberOfDecimals` int(11) NOT NULL,
  `operationPeople` varchar(255) DEFAULT NULL,
  `operationTime` datetime NOT NULL,
  `price` double NOT NULL,
  `unitCode` varchar(255) DEFAULT NULL,
  `unitId` varchar(255) DEFAULT NULL,
  `displayName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- 表的结构 `unitledger`
--

CREATE TABLE IF NOT EXISTS `unitledger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `available` int(11) DEFAULT NULL,
  `availableUnit` int(11) DEFAULT NULL,
  `numberOfDecimals` int(11) NOT NULL,
  `operationPeople` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operationTime` datetime NOT NULL,
  `price` double NOT NULL,
  `unitCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unitId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `UserInfo`
--

CREATE TABLE IF NOT EXISTS `UserInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disable` int(11) DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=19 ;

-- --------------------------------------------------------

--
-- 表的结构 `UserRole`
--

CREATE TABLE IF NOT EXISTS `UserRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(255) DEFAULT NULL,
  `user_id` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=26 ;

--
-- 限制导出的表
--

--
-- 限制表 `Category`
--
ALTER TABLE `Category`
  ADD CONSTRAINT `FK6DD211EE91BA89D` FOREIGN KEY (`parent_id`) REFERENCES `Category` (`id`);
