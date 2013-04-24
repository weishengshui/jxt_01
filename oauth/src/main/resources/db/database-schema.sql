--drop table if exists registration;
DROP TABLE registration IF EXISTS; 
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

DROP TABLE users IF EXISTS;
create table IF NOT EXISTS users (
    id varchar(255) not null,
    name varchar(255),
    constraint pk_users primary key (id)
);