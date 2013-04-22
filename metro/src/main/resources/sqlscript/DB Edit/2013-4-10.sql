create Index  createDate   on  Member(createDate);

alter table `Member` add orderPriceSum DECIMAL(19,2) DEFAULT NULL ;

create Index  createdAt   on  MessageTask(createdAt);