INSERT INTO location.hiver.client(no_cli, nom, prenom, adresse, cpo, ville) VALUES
    (1, 'Albert', 'Anatole', 'Rue des accacias', '61000', 'Amiens'), 
    (2, 'Bernard', 'Barnabé', 'Rue du bar', '01000', 'Bourg en Bresse'), 
    (3, 'Dupond', 'Camille', 'Rue crébillon', '44000', 'Nantes'), 
    (4, 'Desmoulin', 'Daniel', 'Rue descendante', '21000', 'Dijon'), 
    (5, 'Ernest', 'Etienne', 'Rue de l échaffaud', '42000', 'Saint Etienne'), 
    (6, 'Ferdinand', 'Francois', 'Rue de la convention', '44100', 'Nantes'),
    (9, 'Dupond', 'Jean', 'Rue des mimosas', '75018', 'Paris'),
    (14, 'Boutaud', 'Sabine', 'Rue des platanes', '75002', 'Paris');

DECLARE  @DDJ datetime;
SET @DDJ = GETDATE();


INSERT INTO location.hiver.gammes (code_game, libelle) VALUES
	('PR', 'Matériel Professionnel'),
	('HG', 'Haut de gamme'),
	('MG', 'Moyenne gamme'),
	('EG', 'Entrée de gamme');

INSERT INTO location.hiver.categories(code_cate, libelle) VALUES
	('MONO', 'Monoski'),
	('SURF', 'Surf'),
	('PA', 'Patinette'),
	('FOA', 'Ski de fond alternatif'),
	('FOP', 'Ski de fond patineur'),
	('SA', 'Ski alpin');

INSERT INTO location.hiver.tarifs(code_tarif, libelle, prix_jour) VALUES
	('T1', 'Base', 10),
	('T2', 'Chocolat', 15),
	('T3', 'Bronze', 20),
	('T4', 'Argent', 30),
	('T5', 'Or', 50),
	('T6', 'Platine', 90);

INSERT INTO location.hiver.grille_tarifs (code_game, code_cate, code_tarif) VALUES
	('EG', 'MONO', 'T1'),
	('MG', 'MONO', 'T2'),
	('EG', 'SURF', 'T1'),
	('MG', 'SURF', 'T2'),
	('HG', 'SURF', 'T3'),
	('PR', 'SURF', 'T5'),
	('EG', 'PA', 'T1'),
	('MG', 'PA', 'T2'),
	('EG', 'FOA', 'T1'),
	('MG', 'FOA', 'T2'),
	('HG', 'FOA', 'T4'),
	('PR', 'FOA', 'T6'),
	('EG', 'FOP', 'T2'),
	('MG', 'FOP', 'T3'),
	('HG', 'FOP', 'T4'),
	('PR', 'FOP', 'T6'),
	('EG', 'SA', 'T1'),
	('MG', 'SA', 'T2'),
	('HG', 'SA', 'T4'),
	('PR', 'SA', 'T6');
	




INSERT INTO location.hiver.articles(refart, designation, code_game, code_cate) VALUES
	('F01', 'Fischer Cruiser', 'EG', 'FOA'),
	('F02', 'Fischer Cruiser', 'EG', 'FOA'),
	('F03', 'Fischer Cruiser', 'EG', 'FOA'),
	('F04', 'Fischer Cruiser', 'EG', 'FOA'),
	('F05', 'Fischer Cruiser', 'EG', 'FOA'),
	('F10', 'Fischer Sporty Crown', 'MG', 'FOA'),
	('F20', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
	('F21', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
	('F22', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
	('F23', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
	('F50', 'Fischer SOSSkating VASA', 'HG', 'FOP'),
	('F60', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
	('F61', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
	('F62', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
	('F63', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
	('F64', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
	('P01', 'Décathlon Allegre junior 150', 'EG', 'PA'),
	('P10', 'Fischer mini ski patinette', 'MG', 'PA'),
	('P11', 'Fischer mini ski patinette', 'MG', 'PA'),
	('S01', 'Décathlon Apparition', 'EG', 'SURF'),
	('S02', 'Décathlon Apparition', 'EG', 'SURF'),
	('S03', 'Décathlon Apparition', 'EG', 'SURF'),
	('A01', 'Salomon 24X+Z12', 'EG', 'SA'),
	('A02', 'Salomon 24X+712', 'EG', 'SA'),
	('A03', 'Salomon 24X+712', 'EG', 'SA'),
	('A04', 'Salomon 24X+Z12', 'EG', 'SA'),
	('A05', 'Salomon 24X+Z12', 'EG', 'SA'),
	('A10', 'Salomon Pro Link Equipe 4S', 'PR', 'SA'),
	('A11', 'Salomon Pro Link Equipe 45', 'PR', 'SA'),
	('A21', 'Salomon 3V RACE JR+L10', 'PR', 'SA');


INSERT INTO location.hiver.fiches(no_fic, no_cli, date_crea, date_paye, etat) VALUES
	(1001, 14, @DDJ-15, @DDJ-13,'SO'),
	(1002, 4, @DDJ-13, null,'EC'),
	(1003, 1, @DDJ-12, @DDJ-10,'SO'),
	(1004, 6, @DDJ-11, null,'EC'),
	(1005, 3, @DDJ-10, null,'EC'),
	(1006, 9, @DDJ-10, null,'RE'),
	(1007, 1, @DDJ-3, null,'EC'),
	(1008, 2, @DDJ, null,'EC');

INSERT INTO location.hiver.lignes_fic(no_fic, no_lig, refart, depart, retour) VALUES
	(1001, 1, 'F05', @DDJ-15, @DDJ-13),
	(1001, 2, 'F50', @DDJ-15, @DDJ-14),
	(1001, 3, 'F60', @DDJ-13, DATEADD(hour, 6,@DDJ-13)),
	(1002, 1, 'A03', @DDJ-13, @DDJ-9),
	(1002, 2, 'A04', @DDJ-12, @DDJ-7),
	(1002, 3, 'S03', @DDJ-8, NULL),
	(1003, 1, 'F50', @DDJ-12, @DDJ-10),
	(1003, 2, 'F05', @DDJ-12, @DDJ-10),
	(1004, 1, 'P01', @DDJ-6, NULL),
	(1005, 1, 'F05', @DDJ-9, @DDJ-5),
	(1005, 2, 'F10', @DDJ-4, NULL),
	(1006, 1, 'S01', @DDJ-10, @DDJ-9),
	(1006, 2, 'S02', @DDJ-10, @DDJ-9),
	(1006, 3, 'S03', @DDJ-10, @DDJ-9),
	(1007, 1, 'F50', @DDJ-3, @DDJ-2),
	(1007, 3, 'F60', @DDJ-1, NULL),
	(1007, 2, 'F05', @DDJ-3, NULL),
	(1007, 4, 'S02', @DDJ, NULL),
	(1008, 1, 'S01', @DDJ, NULL);