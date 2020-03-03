USE loc_dvd;
GO

--REQUETES SELECTION
--1)
SELECT nom, prenom, ville FROM clients;

--2)
SELECT * FROM clients
	ORDER BY ville ASC, nom DESC;

--3)
SELECT titre, annee FROM dvd
	ORDER BY titre ASC;

--4)
SELECT * FROM realisateurs
	ORDER BY annee_naissance ASC;

--5)
SELECT * FROM clients WHERE code_postal LIKE '44%';

--6)
SELECT * FROM clients WHERE UPPER(prenom) LIKE 'A%' AND titre <>'M.'; --UPPER pour le passer en majuscule (bien que le LIKE % ne soit pas sensible à la casse)

--7)
SELECT * FROM clients WHERE (DATEPART(year, date_naissance) BETWEEN 1970 AND 1979); --/!\attention aux formats des dates (américaines notemment...)

--8)
SELECT * FROM realisateurs WHERE pays IN('USA', 'ANGLETERRE');

--9) (plutôt 19ème siècle...)
SELECT * FROM realisateurs WHERE pays = 'USA' AND (annee_naissance BETWEEN 1801 AND 1900) AND nom LIKE '%a%';

--10)
SELECT * FROM dvd WHERE duree <= 120;



--REQUETES AVEC CALCUL STATISTIQUE
--1)
SELECT titre, count(*) AS 'nb clients' FROM clients GROUP BY titre;

--2)
SELECT code_genre, count(*) AS 'nb genre' FROM dvd GROUP BY code_genre;

--3)
SELECT pays, count(*) AS 'nb par pays' FROM realisateurs 
		GROUP BY pays
		ORDER BY 'nb par pays' DESC;

--4)
SELECT code_genre, count(*) AS 'nb genre 70' FROM dvd 
		WHERE annee LIKE '197%'
		GROUP BY code_genre;

--5)
SELECT code_genre, AVG(duree) AS 'durée moyenne' FROM dvd GROUP BY code_genre;

--6)
SELECT code_genre, MAX(duree) AS 'durée max 80' FROM dvd 
		WHERE annee LIKE '198%'
		GROUP BY code_genre;

--7)
SELECT DATEPART(mm, date_naissance) AS 'mois', Count(*) AS 'nb' FROM clients
		GROUP BY DATEPART(mm, date_naissance);



--REQUETES MULTITABLES
--1)
SELECT dvd.titre, dvd.code_genre, genres_film.signification FROM dvd, genres_film	
		WHERE dvd.code_genre = genres_film.code_genre;
--1 bis) (version avec INNER JOIN, plus propre)
SELECT dvd.titre, dvd.code_genre, genres_film.signification 
		FROM dvd INNER JOIN genres_film	
		ON dvd.code_genre = genres_film.code_genre;


--2)
SELECT dvd.titre, realisateurs.nom, realisateurs.prenom, realisateurs.pays, genres_film.signification
		FROM dvd, realisateurs, genres_film
		WHERE dvd.code_genre = genres_film.code_genre AND dvd.code_realisateur = realisateurs.code_realisateur;
--2 bis) (version avec INNER JOIN, plus propre)
SELECT dvd.titre, realisateurs.nom, realisateurs.prenom, realisateurs.pays, genres_film.signification
		FROM dvd INNER JOIN realisateurs ON dvd.code_realisateur = realisateurs.code_realisateur
				INNER JOIN genres_film ON dvd.code_genre = genres_film.code_genre;


--3)
SELECT DISTINCT clients.nom, clients.prenom FROM clients, factures
		WHERE clients.code_client = factures.code_client 
			AND (DATEPART(year,factures.date_facture) = 2006)
			AND (DATEPART(month,factures.date_facture) = 6);
--3 bis) (version avec INNER JOIN, plus propre)
SELECT DISTINCT clients.nom, clients.prenom	
	FROM clients INNER JOIN factures ON clients.code_client = factures.code_client
	WHERE (DATEPART(year,factures.date_facture) = 2006)
		AND (DATEPART(month,factures.date_facture) = 6);

--4)
SELECT dvd.titre, dvd.duree, 
		clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité client',
		realisateurs.nom+' '+realisateurs.prenom AS 'réalisateur'
	FROM dvd, clients, realisateurs, factures, locations
	WHERE locations.num_facture= factures.num_facture 
		AND factures.code_client=clients.code_client 
		AND locations.num_dvd=dvd.num_dvd
		AND dvd.code_realisateur=realisateurs.code_realisateur;
--4 bis) (version avec INNER JOIN, plus propre)
SELECT dvd.titre, dvd.duree, 
		clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité client',
		realisateurs.nom+' '+realisateurs.prenom AS 'réalisateur'
	FROM locations INNER JOIN factures ON locations.num_facture= factures.num_facture
				INNER JOIN clients ON factures.code_client=clients.code_client
				INNER JOIN dvd ON locations.num_dvd=dvd.num_dvd
				INNER JOIN realisateurs ON dvd.code_realisateur=realisateurs.code_realisateur;

--5)
SELECT clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité client'
	FROM clients, dvd, factures, locations, realisateurs
	WHERE locations.num_dvd=dvd.num_dvd
		AND dvd.code_realisateur=realisateurs.code_realisateur
		AND realisateurs.pays = 'ALLEMAGNE'
		AND (DATEPART(year,factures.date_facture) = 2006)
		AND (DATEPART(month,factures.date_facture) = 6) 
		AND locations.num_facture=factures.num_facture
		AND factures.code_client=clients.code_client;
--5 bis) (version avec INNER JOIN, plus propre)
SELECT clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité client'
	FROM locations INNER JOIN dvd ON locations.num_dvd=dvd.num_dvd
				INNER JOIN realisateurs ON dvd.code_realisateur=realisateurs.code_realisateur
				INNER JOIN factures ON locations.num_facture=factures.num_facture
				INNER JOIN clients ON factures.code_client=clients.code_client
	WHERE realisateurs.pays = 'ALLEMAGNE'
		AND (DATEPART(year,factures.date_facture) = 2006)
		AND (DATEPART(month,factures.date_facture) = 6);

--6)
SELECT DISTINCT dvd.titre
	FROM dvd, locations, factures, clients
	WHERE dvd.code_genre='AV'
		AND locations.num_dvd=dvd.num_dvd
		AND locations.num_facture=factures.num_facture
		AND factures.code_client=clients.code_client
		AND DATEPART(year,clients.date_naissance) LIKE '196%'
		AND clients.titre='M.';
--6 bis) (version avec INNER JOIN, plus propre)
SELECT DISTINCT dvd.titre
	FROM locations INNER JOIN dvd ON locations.num_dvd=dvd.num_dvd
				INNER JOIN factures ON locations.num_facture=factures.num_facture
				INNER JOIN clients ON factures.code_client=clients.code_client
	WHERE dvd.code_genre='AV'
		AND DATEPART(year,clients.date_naissance) LIKE '196%'
		AND clients.titre='M.';


--7)
SELECT TOP(1) clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité', COUNT(*) AS 'nb'
	FROM clients, factures, locations
	WHERE locations.num_facture=factures.num_facture
		AND factures.code_client=clients.code_client
	GROUP BY clients.titre+' '+clients.nom+' '+clients.prenom
	ORDER BY 'nb' DESC;
--7) (version avec INNER JOIN, plus propre)
SELECT TOP(1) clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité', COUNT(*) AS 'nb'
	FROM locations INNER JOIN factures ON locations.num_facture=factures.num_facture
				INNER JOIN clients ON factures.code_client=clients.code_client
	GROUP BY clients.titre+' '+clients.nom+' '+clients.prenom
	ORDER BY 'nb' DESC;
--variante si on compte les dvd loués
SELECT dvd.titre, count(*) AS 'nb'
	FROM locations INNER JOIN dvd ON locations.num_dvd=dvd.num_dvd
	GROUP BY dvd.titre
	ORDER BY 'nb' DESC;

--8)
INSERT INTO clients VALUES('ZZZ999','M.','Ron','T','mon adresse','44000','NANTES','0203040506','juil  7 1985 12:00AM',0 );

SELECT clients.titre+' '+clients.nom+' '+clients.prenom AS 'identité'
	FROM clients LEFT JOIN factures
	ON clients.code_client=factures.code_client
	WHERE factures.code_client IS NULL;

--autre solution
SELECT * FROM clients WHERE code_client NOT IN (SELECT code_client FROM factures);

--REQUETES ANALYSE CROISEE
--1)
SELECT realisateurs.pays, genres_film.signification, COUNT(*) AS 'nb'
	FROM dvd INNER JOIN realisateurs ON dvd.code_realisateur=realisateurs.code_realisateur
			INNER JOIN genres_film ON dvd.code_genre=genres_film.code_genre
	GROUP BY realisateurs.pays, genres_film.signification --WITH ROLLUP si on veut en plus avoir les sommes pour chaque pays et la somme totale et WITH CUBE pour avoir en plus les sommes pour chaque genre
	ORDER BY realisateurs.pays, genres_film.signification;

--2)
SELECT LEFT(clients.code_postal,2) AS 'Département', clients.titre,  COUNT(*) AS 'nb'
	FROM clients
	GROUP BY LEFT(clients.code_postal,2), clients.titre
	ORDER BY LEFT(clients.code_postal,2), clients.titre;

--3)
SELECT realisateurs.pays, genres_film.signification, AVG(dvd.duree) AS 'durée moyenne'
	FROM dvd INNER JOIN realisateurs ON dvd.code_realisateur=realisateurs.code_realisateur
			INNER JOIN genres_film ON dvd.code_genre=genres_film.code_genre
	GROUP BY realisateurs.pays, genres_film.signification
	ORDER BY realisateurs.pays, genres_film.signification;


--REQUETES ACTION
--1)
DROP TABLE clients44;
GO
SELECT titre, nom, prenom, DATEDIFF(year, date_naissance, GETDATE()) AS 'age'
	INTO clients44 
	FROM clients
	WHERE code_postal LIKE '44%';
SELECT * FROM clients44;

--2)
DELETE FROM clients44 WHERE age >= 50;
SELECT * FROM clients44;

