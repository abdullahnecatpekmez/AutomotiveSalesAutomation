USE [AUTOMATION 1]
ALTER TABLE OPTIONS DROP CONSTRAINT AddOptionForUnSoldCar
IF OBJECT_ID('AddOptionUnSoldCar') IS NOT NULL
    DROP FUNCTION dbo.AddOptionUnSoldCar
	DROP TRIGGER SetSalesOpt�onsPrice 
	DROP TRIGGER SetSalesOpt�onsPrice2
    DROP TRIGGER  SetSalesCarPrice

	GO

CREATE TRIGGER  SetSalesCarPrice ON SALES FOR  INSERT
	AS BEGIN
		DECLARE @CARPR�CE FLOAT
		DECLARE @NO VARCHAR(9)
		SELECT @NO= SSerialNO FROM INSERTED
		SELECT @CARPR�CE=C.CPrice FROM CAR C,INSERTED i WHERE C.CSER�ALNO=i.SSerialNO
		UPDATE SALES SET SPrice =@CARPR�CE WHERE @NO=SSerialNO
	END;

GO 
CREATE TRIGGER SetSalesOpt�onsPrice ON OPTIONS FOR  INSERT
	AS BEGIN
		DECLARE @OPR�CE FLOAT
		DECLARE @NO VARCHAR(9)
		SELECT @NO= OserialNO FROM INSERTED
		SELECT @OPR�CE=i.OptPrice FROM OPTIONS O,INSERTED i WHERE O.OSerialNo=i.Oserialno
		UPDATE SALES SET SPrice+=@OPR�CE WHERE @NO=Sserialno
	END;

GO 
CREATE TRIGGER SetSalesOpt�onsPrice2 ON OPTIONS FOR  DELETE
	AS BEGIN
		DECLARE @OPR�CE FLOAT
		DECLARE @NO VARCHAR(9)
		SELECT @NO= OserialNO FROM DELETED
		SELECT @OPR�CE=i.OptPrice FROM DELETED i
		UPDATE SALES SET SPrice-=@OPR�CE WHERE @NO=Sserialno
	END;

GO
CREATE FUNCTION dbo.AddOptionUnSoldCar()
RETURNS INT 
	AS BEGIN RETURN 
	(
		SELECT COUNT(*)
		FROM OPTIONS O
		LEFT JOIN SALES S
		ON S.SSerialNO=O.OSerialNO
		WHERE S.SSerialNO IS NULL
	)
	END;
GO
ALTER TABLE OPTIONS ADD CONSTRAINT AddOptionForUnSoldCar CHECK (dbo.AddOptionUnSoldCar()=0);


