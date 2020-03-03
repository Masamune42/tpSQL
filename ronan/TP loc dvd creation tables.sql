CREATE DATABASE loc_dvd;
GO

USE loc_dvd;


CREATE TABLE clients(
	code_client char(6) CONSTRAINT pk_clients PRIMARY KEY,
	titre varchar(4),
	prenom varchar(30),
	nom varchar(30),
	adresse_rue varchar(60),
	code_postal char(5),
	ville varchar(40),
	num_telephone char(10),
	date_naissance DATETIME,
	enfants bit
);

CREATE TABLE factures(
	num_facture int IDENTITY(1,1) CONSTRAINT pk_factures PRIMARY KEY,
	code_client char(6) CONSTRAINT fk_factures_clients REFERENCES clients(code_client),
	date_facture DATE
);

CREATE TABLE realisateurs(
	code_realisateur char(6) CONSTRAINT pk_realisateurs PRIMARY KEY,
	prenom varchar(30),
	nom varchar(30),
	annee_naissance int,
	pays varchar(30)
);

CREATE TABLE genres_film(
	code_genre char(6) CONSTRAINT pk_genresfilm PRIMARY KEY,
	signification varchar(30)
);


CREATE TABLE dvd(
	num_dvd int IDENTITY(1,1) CONSTRAINT pk_dvd PRIMARY KEY,
	titre varchar(50),
	prix_base decimal(4,2),
	code_realisateur char(6) CONSTRAINT fk_dvd_realisateurs REFERENCES realisateurs(code_realisateur),
	code_genre char(6) CONSTRAINT fk_dvd_genre REFERENCES genres_film(code_genre),
	annee int,
	descriptif text,
	duree int
);

CREATE TABLE types_location(
	code_type char(2) CONSTRAINT pk_typeslocation PRIMARY KEY,
	libelle varchar(30),
	coefficient decimal(4,2),
	nb_jours int
);

CREATE TABLE locations(
	num_facture int CONSTRAINT fk_locations_factures REFERENCES factures(num_facture),
	num_dvd int CONSTRAINT fk_locations_dvd REFERENCES dvd(num_dvd),
	CONSTRAINT pk_locations PRIMARY KEY(num_facture, num_dvd),
	code_type char(2) CONSTRAINT fk_locations_typesloc REFERENCES types_location(code_type),
	date_retour DATETIME
);

