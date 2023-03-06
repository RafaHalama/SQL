/* Do tabeli OSOBA dodaj kolumn? klucza obcego IdMiasto, wskazuj?c? na miasto
zamieszkania osoby. Utwórz wi?zy referencyjne do tabeli MIASTO.*/

Alter Table Osoba
Add (IdMiasto Int);

Alter Table Osoba
ADD CONSTRAINT Miasto_Osoba_FK1
Foreign Key (IdMiasto) references Miasto(IdMiasto)

/* Osoby o IdOsoba zakresu 1 – 8 zrób mieszka?cami Warszawy, o IdOsoba równym
10, 12, 14 zrób mieszka?cami Aten, a imionach rozpoczynaj?cych si? od liter G, H, J
mieszka?cami Poznania.*/

Update Osoba 
set IdMiasto = (Select IdMiasto from Miasto where Miasto = 'Warszawa')
where IdOsoba between 1 and 8;

Update Osoba 
set IdMiasto = (Select IdMiasto from Miasto where Miasto = 'Ateny')
where IdOsoba In (10,12,14);

Update Osoba 
set IdMiasto = (Select IdMiasto from Miasto where Miasto = 'Pozna?')
where Imie Like 'G%' or Imie Like 'H%' or Imie Like 'J'

set IdMiasto = (Select IdMiasto from Miasto where Miasto = 'Ateny')

/*Utwórz tabel? KATEDRA (IdKatedra PK, Katedra Not Null).*/

CREATE TABLE Katedra (
IdKatedra Int Primary Key,
Katedra VarChar(64) not null)

/*Do tabeli DYDAKTYK dodaj kolumn? IdKatedra, utwórz wi?zy referencyjne do tabeli
KATEDRA. Rol? utworzonego klucza obcego b?dzie przechowywanie informacji o
przynale?no?ci dydaktyków do poszczególnych katedr. Wi?zy uzupe?nij definicj? akcji*/

Alter table Dydaktyk
Add(IdKatedra Int)

Alter table Dydaktyk
ADD CONSTRAINT Katedra_Dydaktyk_FK1 Foreign Key 
(IdKatedra) References Katedra (IdKatedra)

/* Do tabeli KATEDRA dodaj kolumn? IdOsoba, utwórz wi?zy referencyjne do tabeli
DYDAKTYK. Rol? utworzonego klucza obcego b?dzie przechowywanie informacji o
dydaktykach b?d?cych kierownikami poszczególnych katedr. Zagwarantuj niemo?no??
usuni?cia dydaktyka b?d?cego kierownikiem katedry.*/

Alter table Katedra
Add(IdOsoba Int)

Alter table Katedra
ADD CONSTRAINT Dydaktyk_Katedra_FK1 FOREIGN KEY
(IDOsoba) References Dydaktyk (IdOsoba)


/* Do tabeli KATEDRA wpisz katedry: Baz danych, In?ynierii oprogramowania, Sztucznej
inteligencji.
*/
INSERT all
INTO Katedra (IdKatedra, Katedra) VALUES (1 , 'Baz danych')
INTO Katedra (IdKatedra, Katedra) VALUES (2 , 'Inzynierii oprogramowania')
INTO Katedra (IdKatedra, Katedra) VALUES (3 , 'Sztucznej inteligencji')
Select * from dual;

/*Do tabeli DYDAKTYK dodaj kolumn? Placa z wi?zami DEFAULT = 2000. Wype?nij kolumn?, przypisuj?c in?ynierom i
magistrom p?ac? w wysoko?ci 2500, pozosta?ym 5000.
*/

ALTER TABLE DYDAKTYK Add Placa NUMBER (6,2) DEFAULT 2000;
UPDATE Dydaktyk SET Placa = 2500 Where IdStopien = (Select IdStopien from StopnieTytuly where Stopien = 'Magister')
UPDATE Dydaktyk SET Placa = 2500 Where IdStopien = (Select IdStopien from StopnieTytuly where Stopien = 'In?ynier')
UPDATE Dydaktyk SET Placa = 5000 Where IdStopien IN (Select IdStopien from StopnieTytuly where Stopien != 'In?ynier' and Stopien != 'Magister')


/*Zaktualizuj p?ace u?ywaj?c sk?adni CASE. Tym razem ustalamy nast?puj?c? siatk? p?ac:
?Profesor Doktor habilitowany 3500 z?
?Doktor habilitowany 3000 z?
  Doktor 2500 z?
?Magister 2000 z?
?In?ynier 1800 z? */

UPDATE Dydaktyk
SET Placa = (SELECT CASE Stopien WHEN 'Profesor Doktor habilitowany' THEN 3500
								 WHEN 'Doktor habilitowany' THEN 3000
								 WHEN 'Doktor' THEN 2500
								 WHEN 'Magister' THEN 2000
								 WHEN 'In?ynier' THEN 1800
			END
			FROM StopnieTytuly
			WHERE StopnieTytuly.IdStopien = Dydaktyk.IdStopien);

/*Do tabeli OSOBA dodaj wi?zy CHECK na kolumnie DataUrodzenia pilnuj?c, aby w
bazie nie pojawi?y si? osoby urodzone po 1999-01-01 ani przed 1900-01-01.*/

ALTER TABLE Osoba
ADD CONSTRAINT Chk_data_ur
CHECK (DataUrodzenia between TO_DATE('1900-01-01','YYYY-MM-DD') 
and  TO_DATE('1999-01-01','YYYY-MM-DD'));

