CREATE DATABASE location;
USE location;
GO

-- création des tables
CREATE TABLE client(
	noCli numeric(6) NOT NULL PRIMARY KEY,
	nom varchar(30) NOT NULL,
	prenom varchar(30),
	adresse varchar(120),
	cpo char(5) NOT NULL CHECK(cpo BETWEEN 1000 AND 95999), -- Utiliser BETWEEN pour comparer des char
	ville varchar(80) NOT NULL DEFAULT 'Nantes'
);

CREATE TABLE fiches(
	noFic numeric(6) PRIMARY KEY,
	noCli numeric(6)
		REFERENCES client(noCli) ON DELETE CASCADE,
	dateCrea datetime NOT NULL DEFAULT GETDATE(),
	datePaye datetime,
	etat char(2) NOT NULL CONSTRAINT ck_constraint_name CHECK(etat IN('EC', 'RE','SO')) DEFAULT 'EC',
	-- A décomposer
	CHECK((datePaye is NOT NULL AND datePaye > dateCrea AND etat = 'SO') OR (datePaye is NULL AND etat <> 'SO')),
);

CREATE TABLE tarifs(
	codeTarif char(5) NOT NULL PRIMARY KEY,
	libelle varchar(30) NOT NULL CONSTRAINT idx_tarifs_libelle UNIQUE,
	prixJour numeric(5,2) NOT NULL CHECK(0 < prixJour)
); 

CREATE TABLE gammes(
	codeGam char(5) NOT NULL PRIMARY KEY,
	libelle varchar(30) NOT NULL CONSTRAINT idx_gammes_libelle UNIQUE
);

CREATE TABLE categories(
	codeCate char(5) NOT NULL PRIMARY KEY,
	libelle varchar(30) NOT NULL CONSTRAINT idx_categories_libelle UNIQUE
);


CREATE TABLE grilleTarifs(
	codeGam char(5) NOT NULL REFERENCES gammes(codeGam),
	codeCate char(5) NOT NULL REFERENCES categories(codeCate),
	codeTarif char(5) NOT NULL REFERENCES tarifs(codeTarif),
	CONSTRAINT pk_grilletarifs PRIMARY KEY(codeGam, codeCate)
);

CREATE TABLE articles(
	refart char(8) NOT NULL PRIMARY KEY,
	designation varchar(80) NOT NULL,
	codeGam char(5) NOT NULL,
	codeCate char(5) NOT NULL,
	CONSTRAINT fk_articles_grilletarifs FOREIGN KEY(codeGam,codeCate)
	REFERENCES grilleTarifs(codeGam, codeCate)
);

CREATE TABLE lignesFic(
	noFic numeric(6) REFERENCES fiches(noFic) ON DELETE CASCADE,
	noLig numeric(3),
	refart char(8) REFERENCES articles(refart),
	depart datetime NOT NULL DEFAULT GETDATE(),
	retour datetime,
	CHECK(retour > depart),
	CONSTRAINT pk_lignesFic PRIMARY KEY(noFic, noLig)
);


-- quelques insertions
INSERT INTO client(noCli, nom, prenom, adresse, cpo,ville)
				VALUES
				(1,'Albert','Anatole','Rue des accacias','61000','Amiens'),
				(2,'Bernard','Barnabé','Rue du bar','01000','Bourg en Bresse'),
				(3,'Dupond','Camille','Rue Crébillon','44000','Nantes'),
				(4,'Desmoulin','Daniel','Rue descendante','21000','Dijon'),
				(5,'Ernest','Etienne','Rue de l''échaffaud','42000','Saint Etienne'),
				(6,'Ferdinand','François','Rue de la conventin','44100','Nantes'),
				(9,'Dupond','Jean','Rue des mimosas','75018','Paris'),
				(14,'Boutaud','Sabine','Rue des platanes','75002','Paris');

INSERT INTO fiches(noFic,noCli,dateCrea,datePaye,etat)
				VALUES
				(1001,14,GETDATE()-15,GETDATE()-13,'SO'),
				(1002,4,GETDATE()-13,NULL,'EC'),
				(1003,1,GETDATE()-12,GETDATE()-10,'SO'),
				(1004,6,GETDATE()-11,NULL,'EC'),
				(1005,3,GETDATE()-10,NULL,'EC'),
				(1006,9,GETDATE()-10,NULL,'RE'),
				(1007,1,GETDATE()-3,NULL,'EC'),
				(1008,2,GETDATE(),NULL,'EC');

INSERT INTO tarifs(codeTarif, libelle,prixJour)
				VALUES
				('T1','Base',10),
				('T2','Chocolat',15),
				('T3','Bronze',20),
				('T4','Argent',30),
				('T5','Or',50),
				('T6','Platine',90);

INSERT INTO gammes(codeGam, libelle)
			VALUES
			('PR','Matériel Professionnel'),
			('HG','Haut de gamme'),
			('MG','Moyenne gamme'),
			('EG','Entrée de gamme');

INSERT INTO categories(codeCate,libelle)
			VALUES
			('MONO','Monoski'),
			('SURF','Surf'),
			('PA','Patinette'),
			('FOA','Ski de fond alternatif'),
			('FOP','Ski de fond patineur'),
			('SA','Ski alpin');

INSERT INTO grilleTarifs(codeGam,codeCate,codeTarif)
			VALUES
			('EG','MONO','T1'),
			('MG','MONO','T2'),
			('EG','SURF','T1'),
			('MG','SURF','T2'),
			('HG','SURF','T3'),
			('PR','SURF','T5'),
			('EG','PA','T1'),
			('MG','PA','T2'),
			('EG','FOA','T1'),
			('HG','FOP','T4'),
			('PR','FOP','T6'),
			('EG','SA','T1');

INSERT INTO articles(refart,designation,codeGam,codeCate)
			VALUES
			('F05','Fischer Cruiser','EG','FOA'),
			('F50','Fischer SOSSkating VASA','HG','FOP'),
			('F60','Fischer CS CARBOITE Skating','PR','FOP'),
			('A03','Salomon 24x+Z12','EG','SA'),
			('A04','Salomon 24x+Z12','EG','SA'),
			('S03','Décathlon Apparition','EG','SURF');

INSERT INTO lignesFic(noFic, noLig, refart, depart, retour)
				VALUES
				(1001,1,'F05',GETDATE()-15,GETDATE()-13),
				(1001,2,'F50',GETDATE()-15,GETDATE()-14),
				(1001,3,'F60',GETDATE()-13,DATEADD(hh,6,GETDATE()-13)),
				(1002,1,'A03',GETDATE()-13,GETDATE()-9),
				(1002,2,'A04',GETDATE()-12,GETDATE()-7),
				(1003,3,'S03',GETDATE()-8,NULL);


-- test utilisation DATEADD
-- SELECT DATEADD(hh,6,GETDATE()-13);



--DROP TABLE tarifs

--DROP TABLE lignesFic

--DROP TABLE grilleTarifs

--DROP TABLE categories

--DROP TABLE gammes

--DROP TABLE fiches

--DROP TABLE client

--DROP DATABASE location

-- Exos :
-- 1)
UPDATE articles SET designation='Ecran Samsung' WHERE refart='A01';

SELECT * FROM articles;
-- 2)
UPDATE articles SET designation= codeGam+ '-' +designation  WHERE codeGam='EG';

-- 3)
-- impossible
UPDATE gammes SET codeGam='ER' WHERE codeGam='EG';

-- 1)
DELETE FROM clients WHERE nom='Boutaud' and prenom='Sabine';
-- 2e solution
SELECT * FROM clients WHERE nom='Boutaud' and prenom='Sabine';
DELETE FROM clients WHERE noCli=14;

-- 2)
DELETE FROM fiches WHERE datePaye IS NULL;

-- 3)
-- impossible
DELETE FROM articles WHERE codeGam='EG';

-- 4)
DELETE FROM clients;

-- 5)
SELECT * FROM fiches;
-- toutes les fiches clients ont disparues car les client n'existent plus liés par le DELETE ON CASCADE


SELECT cl.nom + ' '+ cl.prenom AS np, cl.adresse, cl.cpo,
	f.dateCrea, f.datePaye, f.etat
FROM clients AS cl, fiches AS f
WHERE cl.noCli = f.noCli;