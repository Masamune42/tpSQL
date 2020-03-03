--POC

CREATE DATABASE poc;
GO

USE poc;
GO

CREATE SCHEMA sch;
GO

CREATE TABLE essais (
	id int IDENTITY(1,1) CONSTRAINT pk_essais PRIMARY KEY,
	col1 varchar(10),
	col2 text,
	col3 bit);

INSERT INTO essais VALUES
		('qsdf','sdfqd qsdf', 0),
		('gsdfgb','qsd vcv qsdv', 1);

SELECT * FROM essais;