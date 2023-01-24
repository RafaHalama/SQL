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