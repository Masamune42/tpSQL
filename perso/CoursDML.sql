-- INSERTION D'UNE DONNEE
INSERT INTO gestion_employe.dbo.service(code_service, libelle)
							VALUES('HOP22', 'hopla2');

-- DECLARER UNE VARIABLE
DECLARE @myid int
SET @myid = 11

-- INSERT INTO
INSERT INTO gestion_employe.dbo.employe(
									code_emp,
									nom,
									prenom,
									date_embauche,
									salaire,
									code_service,
									code_chef
									)
								VALUES(
									@myid,
									'un nom',
									null,
									GETDATE(),
									2500,
									'HOP22',
									1
									);

-- VERIFIER LA DATA PAR SELECTION
SELECT * FROM gestion_employe.dbo.service;

SELECT * FROM gestion_employe.dbo.employe;