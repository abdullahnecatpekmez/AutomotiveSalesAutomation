USE [AUTOMATION 2]
DROP TRIGGER SalePriceUpdatePackage --arabaya paket ekledi�imde sat�� fiyat�n� g�nceller
DROP TRIGGER SalePriceUpdateOption --arabaya option ekledi�imde sat�� fiyat�n�  g�nceller
DROP TRIGGER SalePriceUpdateOption2 --arabadan opsiyon sildi�imde sat�� fiyat�n� g�nceller
DROP TRIGGER Fiyat�evir --sat�� fiyat�n� model tablosundan al�r
DROP TRIGGER SalePriceUpdatePackage2 --arabadan paket sildi�imde sat�� fiyat�n� g�nceller
DROP TRIGGER SetPackagePrice --pakete opsiyon ekledi�imde paketin fiyat�n� g�nceller
DROP TRIGGER SetPackagePrice2 --paketten opsiyon sildi�imde paketin fiyat�n� g�nceller
DROP TRIGGER DefaultPackagePrice --paket olu�turuldu�unda fiyat� 0 yapar
DROP TRIGGER PaketEklemeKontrol --sat�n al�nacak paketin i�indeki option daha �nce araca eklenmi� mi
DROP TRIGGER OptionEklemeKontrol --sat�n al�nacak option daha �nce araca eklenmi� mi

GO
CREATE TRIGGER SalePriceUpdatePackage on CAR_PACKAGE FOR INSERT
	AS BEGIN
		DECLARE @price FLOAT
		DECLARE @Sno VARCHAR(9)
		SELECT @Sno=SerialNO from inserted
		SELECT @price=M.PackagePrice from MODEL_PACKAGE M,inserted i WHERE M.PackageNO=i.PackageNO
		UPDATE SALE SET Sprice+=@price WHERE SerialNO=@Sno 
	END;

GO
CREATE TRIGGER SalePriceUpdateOption on CAR_OPTION FOR INSERT
	AS BEGIN
		DECLARE @Price FLOAT
		DECLARE @Sno VARCHAR(9)
		SELECT @Sno=SerialNO from inserted
		SELECT @Price=O.OptionPrice from OPTIONS O,inserted i WHERE O.OptionNO=i.OptNO
		UPDATE SALE SET Sprice+=@price WHERE SerialNO=@Sno
	END;

GO
CREATE TRIGGER SalePriceUpdateOption2 on CAR_OPTION FOR DELETE
	AS BEGIN
		DECLARE @Price FLOAT
		DECLARE @Sno VARCHAR(9)
		SELECT @Sno=SerialNO from deleted
		SELECT @Price=O.OptionPrice from OPTIONS O,deleted i WHERE O.OptionNO=i.OptNO
		UPDATE SALE SET Sprice-=@price WHERE SerialNO=@Sno
	END;

GO
CREATE TRIGGER Fiyat�evir on SALE FOR INSERT
	AS BEGIN
		DECLARE @Price FLOAT
		DECLARE @ModelNO INT
		DECLARE @Sno VARCHAR(9) 
		SELECT @Sno=SerialNO from inserted
		SELECT @ModelNO=C.ModelNO FROM CAR C,inserted i WHERE C.SerialNO=i.SerialNO
		SELECT @Price=M.Price FROM MODEL M WHERE M.ModelNO=@ModelNO
		UPDATE SALE SET SPrice=@Price WHERE SerialNO=@Sno
	END;

GO
CREATE TRIGGER SalePriceUpdatePackage2 on CAR_PACKAGE FOR DELETE
	AS BEGIN
		DECLARE @price FLOAT
		DECLARE @Sno VARCHAR(9)
		SELECT @Sno=SerialNO from deleted
		select @price=M.PackagePrice from MODEL_PACKAGE M,deleted i WHERE M.PackageNO=i.PackageNO
		UPDATE SALE SET Sprice-=@price WHERE SerialNO=@Sno 
	END;

GO
CREATE TRIGGER SetPackagePrice on P_OPTION FOR INSERT
	AS BEGIN
		DECLARE @Price FLOAT
		DECLARE @OPrice FLOAT
		DECLARE @NO INT
		SELECT @NO=PackageNO FROM inserted
		SELECT @Price=M.PackagePrice*5/4 FROM MODEL_PACKAGE M,inserted i WHERE M.PackageNO=i.PackageNO
		SELECT @OPrice=O.OptionPrice FROM OPTIONS O,inserted i WHERE O.OptionNO=i.OptNO
		UPDATE MODEL_PACKAGE SET PackagePrice=(@OPrice+@Price)*4/5 WHERE PackageNO=@NO
	END;

GO
CREATE TRIGGER SetPackagePrice2 on P_OPTION FOR DELETE
	AS BEGIN
		DECLARE @Price FLOAT
		DECLARE @OPrice FLOAT
		DECLARE @NO INT
		SELECT @NO=PackageNO FROM deleted
		SELECT @Price=M.PackagePrice*5/4 FROM MODEL_PACKAGE M,deleted i WHERE M.PackageNO=i.PackageNO
		SELECT @OPrice=O.OptionPrice FROM OPTIONS O,deleted i WHERE O.OptionNO=i.OptNO
		UPDATE MODEL_PACKAGE SET PackagePrice=(@Price-@OPrice)*4/5 WHERE PackageNO=@NO
	END;

GO
CREATE TRIGGER DefaultPackagePrice on MODEL_PACKAGE AFTER INSERT
	AS BEGIN
		DECLARE @No INT
		SELECT @No=PackageNO FROM inserted
		UPDATE MODEL_PACKAGE set PackagePrice=0 WHERE @No=PackageNO
	END;

GO
CREATE TRIGGER PaketEklemeKontrol on CAR_PACKAGE FOR  INSERT
	AS
		DECLARE @SNO VARCHAR(9)
		DECLARE @PNO INT
		SELECT @SNO=SerialNO,@PNO=PackageNO FROM inserted
		IF(EXISTS(SELECT * FROM OPTIONOFCARPACKAGE O,P_OPTION P WHERE O.OptNo=P.OptNO AND O.SerialNo=@SNO AND O.PackageNO<>@PNO AND @PNO=P.PackageNO) OR 
		   EXISTS(SELECT * FROM P_OPTION P,CAR_OPTION C WHERE C.OptNO=P.OptNO AND @SNO=C.SerialNO AND P.PackageNO=@PNO))
			BEGIN
				  RAISERROR('Ekledi�iniz PAKETTE BULUNAN OPS�YON mevcut',0,1)
                  ROLLBACK         
            END;

GO
CREATE TRIGGER OptionEklemeKontrol on CAR_OPTION FOR  INSERT
	AS
		DECLARE @SNO VARCHAR(9)
		DECLARE @ONO INT
		SELECT @SNO=SerialNO,@ONO=OptNO FROM inserted
		IF(EXISTS(SELECT * FROM OPTIONOFCARPACKAGE O WHERE @SNO=O.SerialNo and @ONO=O.OptNo)) 
			BEGIN
				  RAISERROR('Ekledi�iniz OPS�YON ARA�TA mevcut',0,1)
                  ROLLBACK         
            END;