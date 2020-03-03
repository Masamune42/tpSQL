CREATE DATABASE gestion_employes COLLATE French_CI_AS;
GO

USE gestion_employes;
GO

CREATE SCHEMA res_hum;
GO


CREATE TABLE gestion_employes.res_hum.serv(
	code_service int IDENTITY(1,1) CONSTRAINT pk_serv_id PRIMARY KEY,
	libelle varchar(20)
);

CREATE TABLE gestion_employes.res_hum.employe(
	code_emp int IDENTITY(1,1) CONSTRAINT pk_employ_id PRIMARY KEY,
	nom varchar(20) NOT NULL,
	prenom varchar(20) NOT NULL,
	date_embauche datetime,
	date_modif datetime,
	salaire decimal(12,2),
	photo_path varchar(20),
	code_service int CONSTRAINT fk_employe_serv_codeservice REFERENCES gestion_employes.res_hum.serv(code_service),
	code_chef int CONSTRAINT fk_employe_chef REFERENCES gestion_employes.res_hum.employe(code_emp)
);


CREATE TABLE gestion_employes.res_hum.conges(
	code_emp int CONSTRAINT fk_conges_employe_id REFERENCES gestion_employes.res_hum.employe(code_emp),
	annee int NOT NULL,
	CONSTRAINT pk_conges PRIMARY KEY(code_emp, annee),
	nb_jours_aquis decimal(4,1)
);

CREATE TABLE gestion_employes.res_hum.conges_mens(
	code_emp int NOT NULL,
	annee int NOT NULL,
	CONSTRAINT fk_conges_mens_conge FOREIGN KEY (code_emp, annee)  REFERENCES gestion_employes.res_hum.conges(code_emp, annee),
	mois int NOT NULL,
	CONSTRAINT pk_conges_mens PRIMARY KEY(code_emp, annee, mois),
	nbr_jours_pris decimal(4,1)
);


