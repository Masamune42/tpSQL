
CREATE DATABASE location;
GO

USE location;
GO

CREATE SCHEMA hiver;
GO


CREATE TABLE location.hiver.gammes(
	code_game char(5) NOT NULL CONSTRAINT pk_gammes PRIMARY KEY,
	libelle varchar(30) NOT NULL CONSTRAINT uk_gammes_libelle UNIQUE
);



CREATE TABLE location.hiver.categories(
	code_cate char(5) NOT NULL CONSTRAINT pk_categories PRIMARY KEY,
	libelle varchar(30) NOT NULL CONSTRAINT uk_categories_libelle UNIQUE
);


CREATE TABLE location.hiver.tarifs(
	code_tarif char(5) NOT NULL CONSTRAINT pk_tarifs PRIMARY KEY,
	libelle varchar(30) NOT NULL CONSTRAINT uk_tarifs_libelle UNIQUE,
	prix_jour numeric(5,2) NOT NULL CONSTRAINT ck_tarifs_prixjour CHECK(prix_jour > 0)
);


CREATE TABLE location.hiver.grille_tarifs(
	code_game char(5) NOT NULL CONSTRAINT fk_grilletarifs_gammes REFERENCES location.hiver.gammes(code_game),
	code_cate char(5) NOT NULL CONSTRAINT fk_grilletarifs_categories REFERENCES location.hiver.categories(code_cate),
	CONSTRAINT pk_grille_tarifs PRIMARY KEY(code_game, code_cate),
	code_tarif char(5) CONSTRAINT fk_grilletarifs_tarifs REFERENCES location.hiver.tarifs(code_tarif)
);

CREATE TABLE location.hiver.articles(
	refart char(8) NOT NULL CONSTRAINT pk_articles PRIMARY KEY,
	designation varchar(80),
	code_game char(5),
	code_cate char(5),
	CONSTRAINT fk_articles_grilletarifs FOREIGN KEY(code_game, code_cate) REFERENCES location.hiver.grille_tarifs(code_game, code_cate)
);

CREATE TABLE location.hiver.client(
	no_cli numeric(6) NOT NULL CONSTRAINT pk_client PRIMARY KEY,
	nom varchar(30) NOT NULL,
	prenom varchar(30),
	adresse varchar(120),
	cpo char(5) NOT NULL CONSTRAINT ck_client_cpo CHECK(cpo BETWEEN '01000' AND '95999'),
	ville varchar(80) NOT NULL DEFAULT 'Nantes'
);



CREATE TABLE location.hiver.fiches(
	no_fic numeric(6) CONSTRAINT pk_fiches PRIMARY KEY,
	no_cli numeric(6) CONSTRAINT fk_fiches_client REFERENCES location.hiver.client(no_cli) ON DELETE CASCADE,
	date_crea datetime NOT NULL DEFAULT GETDATE(),
	date_paye datetime,
	CONSTRAINT ck_fiches_datepaye CHECK(date_paye > date_crea),
	etat char(2) NOT NULL CONSTRAINT ck_fiches_etat CHECK(etat IN ('EC', 'RE', 'SO')) DEFAULT 'EC',
	CONSTRAINT ck_fiches_dpaye_etat CHECK(((date_paye IS NOT NULL) AND (etat='SO')) OR ((date_paye IS NULL) AND (etat <> 'SO')))
);


CREATE TABLE location.hiver.lignes_fic(
	no_fic numeric(6) NOT  NULL CONSTRAINT fk_lignesfic_fiches REFERENCES location.hiver.fiches(no_fic) ON DELETE CASCADE,
	no_lig numeric(3) NOT NULL,
	CONSTRAINT pk_lignes_fic PRIMARY KEY(no_fic, no_lig),
	refart char(8) CONSTRAINT fk_lignesfic_articles REFERENCES location.hiver.articles(refart),
	depart datetime NOT NULL DEFAULT GETDATE(),
	retour datetime,
	CONSTRAINT ck_lignesfic_retour CHECK(retour > depart)
);





		
-------------------------------




		
