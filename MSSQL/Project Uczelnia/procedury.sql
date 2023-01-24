/*Tworzenie kolumyn placa dla Dydaktyka*/

ALTER TABLE Dydaktyk ADD Placa Money DEFAULT 1500;

/*Ustawienie placy w zaleznosci od wyksztalcenia*/

UPDATE Dydaktyk
SET Placa = (SELECT CASE Stopien WHEN 'Profesor Doktor habilitowany' THEN 3500
								 WHEN 'Doktor habilitowany' THEN 3000
								 WHEN 'Doktor' THEN 2500
								 WHEN 'Magister' THEN 2000
								 WHEN 'Inżynier' THEN 1800
			END
			FROM StopnieTytuly
			WHERE StopnieTytuly.IdStopien = Dydaktyk.IdStopien);

/* Procedura zwiekszajaca lub zmniejszajaca wynagrodzenie Dydaktyka w zaleznosci od jego zarobkow*/

CREATE OR ALTER PROCEDURE PlacaUpd @Upsal Money, @Downsal Money
As
DECLARE PlacaKorekta CURSOR FOR SELECT IdOsoba, Isnull (Placa, 0) FROM Dydaktyk
WHERE Placa < @DownSal OR Placa > @Upsal;
DECLARE @IdOsoba Int,
		@Placa Money,
		@ImieNazwisko Varchar (100),
		@Info Varchar(64);
BEGIN
OPEN PlacaKorekta
FETCH NEXT FROM PlacaKorekta INTO @IdOsoba, @Placa;
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT	@ImieNazwisko = Imie + ' ' + Nazwisko
	FROM	Osoba
	WHERE	IdOsoba = @IdOsoba;
	IF @Placa < @Downsal
		SET @Placa = @Placa + 1.1
	ELSE
		SET @Placa = @Placa *0.9;
	UPDATE Dydaktyk SET Placa = @Placa WHERE IdOSoba = @IdOsoba;
	PRINT 'Dydaktyk ' + @ImieNazwisko + ' ma płacę zmienioną na ' + 
	Cast(@Placa As Varchar);
	FETCH NEXT FROM PlacaKorekta INTO @IdOsoba, @Placa;
END;
CLOSE PlacaKorekta;
DEALLOCATE PlacaKorekta;
END;

EXEC PlacaUpd 2000, 3000;

====================================================================================

/*Tworzenie tabeli płac*/

CREATE TABLE SiatkaPlac (IdStopien Int FOREIGN KEY references StopnieTytuly, Stawka Money);

/*Procedure wypelniajaca tabele stawką minimalną dla każdego stopnia naukowego
Najwyższy IdStopien jest dla inzyniera ktory zarabia najmniej, im ważniejszy stopien tym nizszy Id*/

CREATE OR ALTER PROCEDURE Sub_SiatkaPlac @MinStawka Money
AS
SET Nocount ON;
DECLARE StawkaIns CURSOR FOR Select IdStopien, Stopien FROM StopnieTytuly
							 ORDER BY IdStopien Desc;
DECLARE @IdStopien Int, @Stopien Varchar(32);
BEGIN
OPEN StawkaIns;
FETCH NEXT FROM StawkaIns INTO @IdStopien, @Stopien
WHILE @@FETCH_STATUS =0
BEGIN
	IF EXISTS (SELECT 1 FROM SiatkaPlac WHERE IdStopien = @IdStopien)
		UPDATE SiatkaPlac SET Stawka = @MinStawka WHERE IdStopien = @IdStopien;
	ELSE
		INSERT INTO SiatkaPlac (IdStopien, Stawka)
		VALUES (@IdStopien, @MinStawka);
		PRINT 'Stawka podstawowa dla stopnia ' + @Stopien + ' wynosi ' + Cast(@MinStawka as Varchar);
		SET @MinStawka = @MinStawka *1.2;
		FETCH NEXT FROM StawkaIns INTO @IdStopien, @Stopien;
	END;
CLOSE StawkaIns;
DEALLOCATE StawkaIns;
END;

exec Sub_SiatkaPlac 3140;

UPDATE Dydaktyk 
SET Placa = Stawka
FROM SiatkaPlac
WHERE SiatkaPlac.IdStopien = Dydaktyk.IdStopien;

Select * from Dydaktyk