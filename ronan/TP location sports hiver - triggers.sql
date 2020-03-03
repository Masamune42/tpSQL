/*
CREATE TRIGGER tr_retourarticle ON location.hiver.lignes_fic 
	AFTER INSERT, UPDATE AS
	IF UPDATE(retour) BEGIN
		UPDATE location.hiver.lignes_fic SET retour =GETDATE();
	END;
*/

------------

CREATE TRIGGER tr_retourarticle2 ON location.hiver.lignes_fic 
	AFTER INSERT, UPDATE AS
	BEGIN
		DECLARE @flag bit;
		SET @flag = 1;
		DECLARE @retourtmp DATETIME;
		DECLARE @nofictmp numeric(6);
		DECLARE @noficmodiftmp numeric(6);
		DECLARE ligne CURSOR FOR SELECT no_fic, retour FROM location.hiver.lignes_fic;
		DECLARE ligne_modife CURSOR FOR SELECT no_fic FROM inserted; ----modifiée plutot que inserée ?
		FETCH no_fic INTO @noficmodiftmp;
		OPEN ligne;
		FETCH ligne INTO @nofictmp, @retourtmp;
		WHILE (@@FETCH_STATUS=0) BEGIN
			IF ((@nofictmp=@noficmodiftmp) AND (@retourtmp IS NULL)) BEGIN
				SET @flag = 0;
			END;
			FETCH ligne INTO @nofictmp, @retourtmp;
		END;
		CLOSE ligne;
		DEALLOCATE ligne;
		CLOSE ligne_modifie;
		DEALLOCATE ligne_modifie;
		IF (@flag=1) BEGIN
			???????????????????????????????????????????????????????????????
		END;
	END;


