--drop table if exists registration;
create table IF NOT EXISTS registration (
    id varchar(80) not null,
    appId varchar(80) not null,
    appName varchar(80),
    regCode varchar(80) not null,
    macAddress varchar(80),
    generatedAt datetime ,
    registedAt datetime ,
    constraint pk_registration primary key (id)
);