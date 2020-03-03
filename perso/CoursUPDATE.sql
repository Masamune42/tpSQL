-- sélection
SELECT * FROM une_entreprise.facturation.facture;

-- insertion
INSERT INTO une_entreprise.facturation.facture VALUES('F500',14,140,20)

-- maj
UPDATE une_entreprise.facturation.facture SET qte=30 -- /!\ va modifier toutes les qte à 30
UPDATE une_entreprise.facturation.facture SET qte=30 WHERE numero='F400';
UPDATE une_entreprise.facturation.facture SET montant_ht=1000, qte=100 WHERE qte=40 AND tva=20;
UPDATE une_entreprise.facturation.facture SET montant_ht=1000, qte=100 WHERE tva IS NULL;

--suppression
DELETE FROM une_entreprise.facturation.facture; -- /!\ va supprimer toutes les lignes
DELETE FROM une_entreprise.facturation.facture WHERE 1=1; -- sur MySQL
DELETE FROM une_entreprise.facturation.facture WHERE id=7; -- A faire avec des clés primaires de préférence

-- sous-requête : recherche ce qu'on veut supprimer, puis on le supprime
DELETE FROM une_entreprise.facturation.facture WHERE id=(SELECT id FROM une_entreprise.facturation.facture WHERE tva > 10);