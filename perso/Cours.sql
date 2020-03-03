-- R�cup. des bases de donn�s dans le moteur SQL
-- SELECT collation_name, name FROM sys.databases;

-- Supprimer une base de donn�es
-- DROP DATABASE une_entreprise;

-- Cr�er une nouvelle base de donn�es
-- CREATE DATABASE une_entreprise COLLATE French_CI_AS;

-- Modifier une base de donn�es
-- ALTER DATABASE une_entreprise SET COMPATIBILITY_LEVEL = 120;

-- Pointer sur une base de donn�es
-- USE une_entreprise;
-- GO -- spec SQL SERVER = Commit

-- Cr�er un schema
-- CREATE SCHEMA facturation;

-- Cr�er une table
/* CREATE TABLE une_entreprise.facturation.facture(
	id int,
	nom varchar(20)
); */

-- Afficher les tables de la bdd (spec. SQL SERVER)
-- SELECT * FROM une_entreprise.INFORMATION_SCHEMA.TABLES;

-- Modifier une table
-- ALTER TABLE une_entreprise.facturation.facture
--	ADD prenom varchar(50), montantHT decimal(18,2);

-- V�rifier les attribus de la table FACTURE
--SELECT * FROM une_entreprise.facturation.facture;

-- Modifier un attribut d'une table
-- ALTER TABLE une_entreprise.facturation.facture
--	ALTER COLUMN montantHT decimal(10,2);

-- Cr�er une table avec des contraintes
--CREATE TABLE une_entreprise.facturation.client(
	-- cr�er une cl� primaire ID
--	id int IDENTITY(1,1) CONSTRAINT pk_client_id PRIMARY KEY, -- IDENTITY(num de d�part, valeur incr�mentation)
	-- constraint :  NOT NULL
--	nom varchar(50) NOT NULL,
	-- constraint : DEFAULT VALUE
--	codepostal varchar(7) NOT NULL DEFAULT '44000',
	-- constraint : UNIQUE
--	siret varchar(18) NOT NULL CONSTRAINT idx_client_siret UNIQUE,
	-- constraint : CALCULATE
--	age int CONSTRAINT ck_client_age CHECK(age BETWEEN 20 AND 50)
--);

-- TP
-- 1/ SUPPRIMER LA TABLE FACTURE
-- 2/ CREER LA TABLE FACTURE (l'identifiant sera incr�ment� par 2) :
--	- Num�ro de facture : pas null/unique
--	- qte : pas null/ sup�rieur � 0
--	- montantHt : pas null 
--	- tva : pas null / plus grand que 0 et < 50%



-- Suppression TABLE FACTURE
-- DROP TABLE une_entreprise.facturation.facture;



-- Cr�ation table facture
--CREATE TABLE une_entreprise.facturation.facture(
	
--	id int IDENTITY(1,2) CONSTRAINT pk_facture_id PRIMARY KEY,
	
--	numero varchar(10) NOT NULL CONSTRAINT idx_facture_numero UNIQUE,
	
--	qte int NOT NULL CONSTRAINT ck_facture_qte CHECK(0 < qte),
	
--	montant_ht decimal(10,2) NOT NULL,
	
--	tva decimal(10,2) NOT NULL CONSTRAINT ck_facture_tva CHECK(0 < tva AND 50 > tva)
--);


-- TD Cr�er une FK dans la table facture --> client
-- ALTER TABLE une_entreprise.facturation.facture
--	ADD client_id int CONSTRAINT fk_facture_client_id
--	REFERENCES une_entreprise.facturation.client(id);

-- user
--CREATE LOGIN my_user WITH PASSWORD='my_pass', DEFAULT_DATABASE=une_entreprise;
--DROP LOGIN my_user
-- etc...

-- Cr�er une table r�cursive
--CREATE TABLE personne(
--	id int IDENTITY(1,1) CONSTRAINT pk_personne_id PRIMARY KEY,
--	nom varchar(20),
--	prenom varchar(20),
--	-- FOREIGN KEY = RECURSIVE personne --> personne --> personne +00
--	papa_personne_id int CONSTRAINT fk_personne_papa_id REFERENCES personne(id),
--	mama_personne_id int CONSTRAINT fk_personne_mama_id REFERENCES personne(id)
--);

-- Exemple de cl� compos�
--CREATE TABLE hopla(
--	id_1 int NOT NULL,
--	id_2 int NOT NULL,
--	nom varchar(20),
--	-- Il faudra que id_1 et id_2 n'est pas � eux 2, 2 fois la m�me ligne
--	CONSTRAINT hopla_id PRIMARY KEY(id_1, id_2)
--);

-- CREATE DATABASE gestionemployes;

USE gestionemployes;
GO

-- CREATE SCHEMA entreprise;


CREATE TABLE gestionemployes.entreprise.servicess(
	code_service char(5)
		CONSTRAINT pk_services PRIMARY KEY,
	libelle varchar(50)
);


CREATE TABLE gestionemployes.entreprise.employes(
	code_emp int IDENTITY(1,1) CONSTRAINT pk_employes_code_emp PRIMARY KEY,
	nom varchar(20),
	prenom varchar(20),
	date_embauche date NOT NULL,
	date_modif datetime,
	salaire decimal(18,2) NOT NULL,
	photo varchar(50),
	code_service char(5)
		CONSTRAINT fk_employes_service_code_service
		REFERENCES gestionemployes.entreprise.servicess(code_service),
	code_chef int
		CONSTRAINT fk_employes_employe_code_emp
		REFERENCES gestionemployes.entreprise.employes(code_emp)
);

CREATE TABLE gestionemployes.entreprise.conges(
	code_emp int NOT NULL REFERENCES gestionemployes.entreprise.employes(code_emp),
	annee numeric(4) NOT NULL,
	nb_jours_acquis numeric(2),
	-- PRIMARY KEY COMPOSE
	CONSTRAINT pk_conges PRIMARY KEY(code_emp, annee)
);

CREATE TABLE gestionemployes.entreprise.conges_mens(
	code_emp int NOT NULL,
	mois numeric(2) NOT NULL,
	annee numeric(4) NOT NULL,
	nb_jours_pris numeric(2),
	-- PRIMARY KEY COMPOSE (x3)
	CONSTRAINT pk_conges_mens PRIMARY KEY(code_emp, annee, mois),
	-- FK COMPOSE (x2) --> table conge
	CONSTRAINT fk_congesmens_conges FOREIGN KEY(code_emp, annee)
	REFERENCES gestionemployes.entreprise.conges(code_emp, annee) ON DELETE CASCADE
	
);





DROP TABLE gestionemployes.entreprise.conges_mens

DROP TABLE gestionemployes.entreprise.conges

DROP TABLE gestionemployes.entreprise.employes

DROP TABLE gestionemployes.entreprise.servicess