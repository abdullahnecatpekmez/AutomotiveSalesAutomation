USE [AUTOMATION 1]
	SELECT * FROM CAR
	SELECT * FROM OPTIONS
	SELECT * FROM SALES
	SELECT * FROM SALESPERSON
	INSERT INTO CAR VALUES('555555555','AVANT','AUDÝ',28000);
	INSERT INTO SALESPERSON VALUES('504','ALÝ','313852');
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
		--satýlan araçlarýn serial numaralarýný listeleme
			SELECT SSerialNO
			FROM SALES

		--SPersonID'si 450 olan kiþinin sattýðý araclarýn sayýsý
			SELECT count(*) AS SattigiAracSay
			FROM SALES
			WHERE SPersonID='501'

		--111111111 serial numaralý araca satýlan option'larýn listesi
			SELECT OptName AS OptionName
			FROM OPTIONS
			WHERE OSerialNo='111111111'

	-- 2 TABLOYU KULLANAN SORGULAR
		--Birden fazla araç satan kiþilerin isimleri
			SELECT DISTINCT Name
			FROM SALESPERSON 
			WHERE  SPersonID IN ( SELECT SPersonID
								  FROM SALES 
								  GROUP BY SPersonID 
								  HAVING COUNT(*) >1);

		--satýlmayan araçlarýn modeli 
				SELECT Model
				FROM CAR LEFT JOIN SALES ON CSerialNo=SSerialNO
				WHERE SSerialNO IS NULL

		--satýlmiþ araçlarýn SAYISI 
				SELECT COUNT(*) AS SatilmiþAraçSAYISI
				FROM CAR LEFT JOIN SALES ON CSerialNo=SSerialNO
				WHERE SSerialNO IS not NULL

		--satýlmayan araçlarýn moldel ve manufactoru
			   SELECT Manufacturer  AS manufactorü,Model AS modeli
	   		   FROM CAR LEFT JOIN SALES ON CSerialNo=SSerialNO
			   WHERE SSerialNO IS NULL
		 
	--3 TABLOYU KULLANAN SORGULAR
		 --  satýlan arabalarýnýn optýonlarýn ismi ve fiyatý serialnosu
				SELECT *
				FROM optýons 
			   WHERE EXISTS (SELECT *
		                  FROM CAR,SALES
					      WHERE CSerialNo=SSerialNO);

		--502 kiþinin sattýgý arabalarýn modeli , fiyatý ,kiþinin ismi ve arabanýn satýþ fiyatý
				SELECT  S.SPrice,C.CPrice,P.Name,C.Model
			    FROM ((SALES S JOIN  SALESPERSON P ON P.SPersonID=S.SPersonID)JOIN CAR C ON C.CSerialNo=S.SSerialNO )
				 WHERE P.SPersonID='502';

		--kiþilerin sattýgý arabalarýn modeli , fiyatý ,kiþinin ismi ve arabanýn satýþ fiyatý
			 SELECT  S.SPrice,C.CPrice,P.Name,C.Model
			 FROM ((SALES S JOIN  SALESPERSON P ON P.SPersonID=S.SPersonID)JOIN CAR C ON C.CSerialNo=S.SSerialNO )
		
		  