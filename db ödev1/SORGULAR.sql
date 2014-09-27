USE [AUTOMATION 1]
	SELECT * FROM CAR
	SELECT * FROM OPTIONS
	SELECT * FROM SALES
	SELECT * FROM SALESPERSON
	INSERT INTO CAR VALUES('555555555','AVANT','AUD�',28000);
	INSERT INTO SALESPERSON VALUES('504','AL�','313852');
	INSERT INTO SALES  VALUES ('500','555555555',null,15000);
	DELETE FROM CAR WHERE cSerialNO='444556666';
	DELETE FROM OPTIONS WHERE OSerialNo='111111111' and OptName='Bluetooth';
	DELETE FROM SALESPERSON WHERE SPersonID='501'
	UPDATE SALES SET SPrice=28200 WHERE SSerialNO='111111111'
	UPDATE SALESPERSON SET SPersonID='450' WHERE SPersonID='500'
	UPDATE SALESPERSON SET Phone='3134371' WHERE SPersonID='450'
	SELECT * FROM CAR
	SELECT * FROM OPTIONS
	SELECT * FROM SALES
	SELECT * FROM SALESPERSON

	--1 TABLOYU KULLANAN SORGULAR
		--sat�lan ara�lar�n serial numaralar�n� listeleme
			SELECT SSerialNO
			FROM SALES

		--SPersonID'si 450 olan ki�inin satt��� araclar�n say�s�
			SELECT count(*) AS SattigiAracSay
			FROM SALES
			WHERE SPersonID='501'

		--111111111 serial numaral� araca sat�lan option'lar�n listesi
			SELECT OptName AS OptionName
			FROM OPTIONS
			WHERE OSerialNo='111111111'

	-- 2 TABLOYU KULLANAN SORGULAR
		--Birden fazla ara� satan ki�ilerin isimleri
			SELECT DISTINCT Name
			FROM SALESPERSON 
			WHERE  SPersonID IN ( SELECT SPersonID
								  FROM SALES 
								  GROUP BY SPersonID 
								  HAVING COUNT(*) >1);

		--sat�lmayan ara�lar�n modeli 
				SELECT Model
				FROM CAR LEFT JOIN SALES ON CSerialNo=SSerialNO
				WHERE SSerialNO IS NULL

		--sat�lmi� ara�lar�n SAYISI 
				SELECT COUNT(*) AS Satilmi�Ara�SAYISI
				FROM CAR LEFT JOIN SALES ON CSerialNo=SSerialNO
				WHERE SSerialNO IS not NULL

		--sat�lmayan ara�lar�n moldel ve manufactoru
			   SELECT Manufacturer  AS manufactor�,Model AS modeli
	   		   FROM CAR LEFT JOIN SALES ON CSerialNo=SSerialNO
			   WHERE SSerialNO IS NULL
		 
	--3 TABLOYU KULLANAN SORGULAR
		 --  sat�lan arabalar�n�n opt�onlar�n ismi ve fiyat� serialnosu
				SELECT *
				FROM opt�ons 
			   WHERE EXISTS (SELECT *
		                  FROM CAR,SALES
					      WHERE CSerialNo=SSerialNO);

		--502 ki�inin satt�g� arabalar�n modeli , fiyat� ,ki�inin ismi ve araban�n sat�� fiyat�
				SELECT  S.SPrice,C.CPrice,P.Name,C.Model
			    FROM ((SALES S JOIN  SALESPERSON P ON P.SPersonID=S.SPersonID)JOIN CAR C ON C.CSerialNo=S.SSerialNO )
				 WHERE P.SPersonID='502';

		--ki�ilerin satt�g� arabalar�n modeli , fiyat� ,ki�inin ismi ve araban�n sat�� fiyat�
			 SELECT  S.SPrice,C.CPrice,P.Name,C.Model
			 FROM ((SALES S JOIN  SALESPERSON P ON P.SPersonID=S.SPersonID)JOIN CAR C ON C.CSerialNo=S.SSerialNO )
		
		  