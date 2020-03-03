USE gestion_employe
GO

-- DQL
SELECT TOP(2) * FROM employe;

-- ORDER BY
SELECT nom AS 'Nom' , prenom AS 'Prénom', date_embauche FROM employe
ORDER BY date_embauche DESC;

SELECT * FROM employe
			WHERE nom='Regis'
			ORDER BY nom DESC;

-- LIKE
SELECT * FROM employe
			WHERE nom LIKE 'R%g%s' OR nom LIKE 'M%'
			ORDER BY nom DESC;

SELECT * FROM employe
			WHERE nom LIKE 'R%' OR nom NOT LIKE 'M%'
			ORDER BY nom DESC;

-- DISTINCT
SELECT DISTINCT code_service FROM employe;

-- Calcule dans une colonne
SELECT nom, (salaire*10) AS 'Salairex10' FROM employe;

-- AVG()
SELECT nom, AVG(salaire) FROM employe
	GROUP BY nom;

-- COUNT() : calcule le nombre de fois que la valeur de la colonne est présente
SELECT COUNT(nom),nom, AVG(salaire) FROM employe
GROUP BY nom;

-- SUM()
SELECT SUM(salaire) FROM employe WHERE code_service = 'INFOR';

-- /!\
-- SELECT nom, MAX(salaire) FROM employe WHERE code_service = 'INFOR';

-- Dans doc : {} <- obligatoire, [] <- , v1|v2 <- v1 ou v2
SELECT DATEPART(dw, GETDATE());

SELECT CONVERT(varchar,GETDATE(),103);