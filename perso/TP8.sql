-- TP 8 : DVD

-- Création des tables
-- CREATE DATABASE location_dvd
USE location_dvd
GO

CREATE TABLE clients(
	code_client char(6) NOT NULL CONSTRAINT pk_clients PRIMARY KEY,
	titre varchar(5) NOT NULL,
	prenom varchar(30),
	nom varchar(30) NOT NULL,
	adresse_rue varchar(50),
	cpo char(5) CONSTRAINT ck_clients_cpo CHECK(cpo BETWEEN 01000 AND 95999) DEFAULT '44000',
	ville varchar(30),
	num_tel varchar(10),
	date_n datetime,
	enfants bit NOT NULL DEFAULT 0
);

CREATE TABLE factures(
	num_facture int IDENTITY(1,1) CONSTRAINT pk_factures PRIMARY KEY,
	code_client char(6) NOT NULL REFERENCES clients(code_client) ON DELETE CASCADE,
	date_facture date NOT NULL
);

CREATE TABLE types_location(
	code_type char(2) NOT NULL CONSTRAINT pk_types_location PRIMARY KEY,
	libelle varchar(40) NOT NULL,
	coefficient decimal(3,2) NOT NULL,
	nb_jours decimal(2) NOT NULL
);

CREATE TABLE genres_film(
	code_genre char(2) NOT NULL CONSTRAINT pk_genres_film PRIMARY KEY,
	signification varchar(40) NOT NULL
);

DELETE FROM realisateurs;
CREATE TABLE realisateurs(
	code_realisateur char(6) NOT NULL CONSTRAINT pk_realisateurs PRIMARY KEY,
	prenom varchar(30),
	nom varchar(30) NOT NULL,
	annee_naissance decimal(4) NOT NULL DEFAULT 1900,
	pays varchar(20)
);

DELETE FROM dvd;

CREATE TABLE dvd(
	num_dvd int IDENTITY(1,1) CONSTRAINT pk_dvd PRIMARY KEY,
	titre varchar(70) NOT NULL,
	prix_base decimal(4,2) NOT NULL DEFAULT 0,
	code_realisateur char(6) NOT NULL
					CONSTRAINT fk_dvd_realisateurs_code_realisateur
					REFERENCES realisateurs(code_realisateur),
	code_genre char(2) NOT NULL
					CONSTRAINT fk_dvd_genres_film_code_genre
					REFERENCES genres_film(code_genre),
	annee decimal(4) NOT NULL,
	descriptif text,
	duree decimal(3)
);

DELETE FROM locations;
DROP TABLE locations;
CREATE TABLE locations(
	num_facture int NOT NULL
			CONSTRAINT fk_locations_factures_num_facture
			REFERENCES factures(num_facture),
	num_dvd int NOT NULL
			CONSTRAINT fk_locations_dvd_num_dvd
			REFERENCES dvd(num_dvd),
	code_type char(2) NOT NULL
			CONSTRAINT fk_locations_type_location_code_type
			REFERENCES types_location(code_type),
	date_retour datetime,
	CONSTRAINT pk_locations PRIMARY KEY(num_facture, num_dvd)
);


-- Requêtes Sélection
-- 1.
SELECT nom, prenom, ville FROM clients;

-- 2.
SELECT * FROM clients
ORDER BY ville ASC,
		nom DESC;

-- 3.
SELECT titre, annee FROM dvd
ORDER BY titre;

-- 4.
SELECT * FROM realisateurs
ORDER BY annee_naissance ASC;

-- 5.
SELECT * FROM clients
WHERE cpo LIKE '44%';

-- 6.
SELECT * FROM clients
WHERE UPPER(prenom) LIKE 'A%' AND titre <> 'M.';

-- 7.
SELECT * FROM clients
WHERE date_n BETWEEN '01/01/1970' AND '31/12/1979';

SELECT * FROM clients
WHERE DATEPART(yy,date_n) BETWEEN 1970 AND 1979;

-- 8.
SELECT * FROM realisateurs
WHERE pays='USA' OR pays='ANGLETERRE';

SELECT * FROM realisateurs
WHERE pays IN('USA', 'ANGLETERRE');

-- 9.
SELECT * FROM realisateurs
WHERE pays='USA' AND nom LIKE '%a%' AND (annee_naissance LIKE '18%' OR annee_naissance=1900) AND annee_naissance <> 1800;

SELECT * FROM realisateurs
WHERE pays='USA'
	AND annee_naissance < 1900
	AND nom LIKE '%a%';

-- 10.
SELECT * FROM dvd
WHERE duree < 120;

-- Requête avec calculs statistiques
-- 1.
SELECT COUNT(*) AS nb,titre FROM clients
GROUP BY titre;

-- 2.
SELECT COUNT(*) AS nb, code_genre FROM dvd
GROUP BY code_genre;

-- 3.
SELECT COUNT(*) AS nb, pays FROM realisateurs
GROUP BY pays
ORDER BY nb DESC;

-- 4.
SELECT COUNT(*) AS nb, code_genre FROM dvd
WHERE annee LIKE '197%'
GROUP BY code_genre;

-- 5.
SELECT AVG(duree) AS 'durée moy', code_genre FROM dvd
GROUP BY code_genre;

-- 6.
SELECT MAX(duree) AS 'durée max', code_genre FROM dvd
WHERE annee LIKE '198%'
GROUP BY code_genre;

-- 7.
SELECT COUNT(*) AS nb, MONTH(date_n) AS 'mois naissance' FROM clients
GROUP BY 'mois naissance';