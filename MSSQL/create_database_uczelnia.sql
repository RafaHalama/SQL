
/*SKRYPT ZAKŁADAJĄCY SCHEMAT UCZELNIA
MS SQL Server dla schematu UCZELNIA w wersji wyjściowej
-------------------------------------
--Usuwamy wszystkie obiekty
*/
IF OBJECT_ID('StudentGrupa') IS NOT NULL
	DROP TABLE StudentGrupa;
Go

IF OBJECT_ID('Grupa') IS NOT NULL
	DROP TABLE Grupa;
Go

IF OBJECT_ID('RokAkademicki') IS NOT NULL
	DROP TABLE RokAkademicki;
Go

IF OBJECT_ID('Ocena') IS NOT NULL
	DROP TABLE Ocena;
Go

IF OBJECT_ID('Program') IS NOT NULL
	DROP TABLE Program;
Go

IF OBJECT_ID('PrzedmiotPoprzedzajacy') IS NOT NULL
	DROP TABLE PrzedmiotPoprzedzajacy;
Go

IF OBJECT_ID('Egzamin') IS NOT NULL
	DROP TABLE Egzamin;
Go

IF OBJECT_ID('Przedmiot') IS NOT NULL
	DROP TABLE Przedmiot;
Go

IF OBJECT_ID('Budzet') IS NOT NULL
	DROP TABLE Budzet;
Go

----------ale tu są dwustronne więzy, więc może być potrzebne ręczne wspomaganie
IF OBJECT_ID('Katedra') IS NOT NULL
BEGIN

DECLARE @Dropcons Varchar(max);
SELECT @Dropcons =
    'ALTER TABLE [' +  OBJECT_SCHEMA_NAME(parent_object_id) +
    '].[' + OBJECT_NAME(parent_object_id) + 
    '] DROP CONSTRAINT [' + name + ']'
FROM sys.foreign_keys
WHERE referenced_object_id = object_id('Katedra');
SELECT @Dropcons;
EXECUTE (@Dropcons);

	DROP TABLE Katedra;
END;
Go

IF OBJECT_ID('Wydzial') IS NOT NULL
	DROP TABLE Wydzial;
Go

IF OBJECT_ID('SiatkaPlac') IS NOT NULL
	DROP TABLE SiatkaPlac
Go

IF OBJECT_ID('Dydaktyk') IS NOT NULL
	DROP TABLE Dydaktyk
Go

IF OBJECT_ID('StopnieTytuly') IS NOT NULL
	DROP TABLE StopnieTytuly;
Go

IF OBJECT_ID('Student') IS NOT NULL
	DROP TABLE Student
Go

IF OBJECT_ID('Osoba') IS NOT NULL
DROP TABLE Osoba
Go

IF OBJECT_ID('Miasto') IS NOT NULL
DROP TABLE Miasto
Go

IF OBJECT_ID('Panstwo') IS NOT NULL
DROP TABLE Panstwo
Go

IF OBJECT_ID('ListaImion') IS NOT NULL
DROP TABLE ListaImion
Go

IF OBJECT_ID('V_Dydaktyk') IS NOT NULL
DROP VIEW V_Dydaktyk
Go

IF OBJECT_ID('V_OcenaIns') IS NOT NULL
DROP VIEW V_OcenaIns
Go

--Rozpoczynamy tworzenie tabel
/* RokAkademicki.*/
CREATE TABLE RokAkademicki ( 
	IdRokAkademicki char(7) not null,
	Data_rozp date not null,
	Data_zak date not null)  
Go

ALTER TABLE RokAkademicki
	ADD CONSTRAINT RokAkademicki_PK PRIMARY KEY (IdRokAkademicki)   
Go

/* StudentGrupa.*/  
CREATE TABLE StudentGrupa ( 
	IdOsoba int not null,
	IdGrupa int not null)  
Go

ALTER TABLE StudentGrupa
	ADD CONSTRAINT StudentGrupa_PK PRIMARY KEY (IdGrupa, IdOsoba)   
Go

/* Grupa.*/  
CREATE TABLE Grupa (
	IdGrupa Int Identity not null,
	NrGrupy char(10) not null,
	SemestrNauki int not null,
	IdRokAkademicki char(7) not null)  
Go

ALTER TABLE Grupa
	ADD CONSTRAINT Grupa_PK PRIMARY KEY (IdGrupa)   
Go

/* PrzedmiotPoprzedzajacy.*/  
CREATE TABLE PrzedmiotPoprzedzajacy ( 
	IdPoprzednik int not null,
	IdPrzedmiot int not null)  
Go

ALTER TABLE PrzedmiotPoprzedzajacy
	ADD CONSTRAINT PrzedmiotPoprzedzajacy_PK PRIMARY KEY (IdPoprzednik, IdPrzedmiot)   
Go

/* Przedmiot.*/  
CREATE TABLE Przedmiot ( 
	IdPrzedmiot int identity not null,
	Przedmiot varchar(128) not null,
	Symbol char(3) not null
	--,IdKatedra int null
	)  
Go

ALTER TABLE Przedmiot
	ADD CONSTRAINT Przedmiot_PK PRIMARY KEY (IdPrzedmiot)   
Go

/* StopnieTytuly.*/  
CREATE TABLE StopnieTytuly ( 
	IdStopien int identity not null,
	Stopien varchar(32) not null,
	Skrot varchar(10) not null)  
Go

ALTER TABLE StopnieTytuly
	ADD CONSTRAINT StopnieTytuly_PK PRIMARY KEY (IdStopien)   
Go

/* Ocena.*/  
CREATE TABLE Ocena ( 
	IdStudent int not null,
	IdPrzedmiot int not null,
	DataWystawienia date not null,
	IdDydaktyk int not null,
	Ocena decimal(2,1) not null)
Go

ALTER TABLE Ocena
	ADD CONSTRAINT Ocena_PK PRIMARY KEY (IdStudent, DataWystawienia, IdPrzedmiot)   
Go

/* Panstwo.*/  
CREATE TABLE Panstwo ( 
	IdPanstwo int identity not null,
	Panstwo varchar(64) not null)  
Go

ALTER TABLE Panstwo
	ADD CONSTRAINT Panstwo_PK PRIMARY KEY (IdPanstwo)   
Go

/* Osoba.*/  
CREATE TABLE Osoba ( 
	IdOsoba int identity not null,
	Nazwisko varchar(62) not null,
	Imie varchar(32) not null,
	DataUrodzenia date null
	)  
Go

ALTER TABLE Osoba
	ADD CONSTRAINT Osoba_PK PRIMARY KEY (IdOsoba)   
Go

/* Student.*/  
CREATE TABLE Student ( 
	IdOsoba int not null,
	NrIndeksu char(10) not null,
	DataRekrutacji date not null)  
Go

ALTER TABLE Student
	ADD CONSTRAINT Student_PK PRIMARY KEY (IdOsoba)   
Go

/* Dydaktyk.*/  
CREATE TABLE Dydaktyk ( 
	IdOsoba int not null
	,IdStopien int null
	,Podlega int null
	)  
Go

ALTER TABLE Dydaktyk
	ADD CONSTRAINT Dydaktyk_PK PRIMARY KEY (IdOsoba)   
Go


CREATE TABLE Miasto (IdMiasto Int Identity not null,
Miasto Varchar(64) not null,
IdPanstwo Int not null
)

go

ALTER TABLE Miasto
	ADD CONSTRAINT Miasto_PK PRIMARY KEY (IdMiasto)   
Go

ALTER TABLE Miasto
	ADD CONSTRAINT Panstwo_Miasto_FK1 foreign key (
		IdPanstwo)
	 references Panstwo (
		IdPanstwo) on update no action on delete no action  
Go

CREATE TABLE Katedra (IdKatedra Int Identity Primary Key,
					Katedra Varchar(64) NOT NULL,
					IdOsoba Int FOREIGN KEY References Dydaktyk /*kierownik katedry*/);

ALTER TABLE Katedra ADD Constraint UQ_KatedraName UNIQUE (Katedra);
ALTER TABLE Dydaktyk ADD IdKatedra INT Foreign Key References Katedra; --zatrudnienie


/* Add foreign key constraints to table StudentGrupa.*/
ALTER TABLE StudentGrupa
	ADD CONSTRAINT Student_StudentGrupa_FK1 foreign key (
		IdOsoba)
	 references Student (
		IdOsoba) on update no action on delete no action  
Go

ALTER TABLE StudentGrupa
	ADD CONSTRAINT Grupa_StudentGrupa_FK1 foreign key (
		IdGrupa)
	 references Grupa (
		IdGrupa) on update no action on delete no action  
Go

/* Add foreign key constraints to table Grupa.*/
ALTER TABLE Grupa
	ADD CONSTRAINT RokAkad_GrupaStud_FK1 foreign key (
		IdRokAkademicki)
	 references RokAkademicki (
		IdRokAkademicki) on update no action on delete no action  
Go

ALTER TABLE Grupa
	ADD CONSTRAINT UQ_Rok_Nr UNIQUE (NrGrupy, IdRokAkademicki)
Go

/* Add foreign key constraints to table PrzedmiotPoprzedzajacy.*/
ALTER TABLE PrzedmiotPoprzedzajacy
	ADD CONSTRAINT Przedmiot_PrzedmiotPop_FK1 foreign key (
		IdPoprzednik)
	 references Przedmiot (
		IdPrzedmiot) on update no action on delete no action  
Go

ALTER TABLE PrzedmiotPoprzedzajacy
	ADD CONSTRAINT Przedmiot_PrzedmiotPop_FK2 foreign key (
		IdPrzedmiot)
	 references Przedmiot (
		IdPrzedmiot) on update no action on delete no action  
Go

/* Add foreign key constraints to table Ocena.*/
ALTER TABLE Ocena
	ADD CONSTRAINT Dydaktyk_Ocena_FK1 foreign key (
		IdDydaktyk)
	 references Dydaktyk (
		IdOsoba) on update no action on delete no action  
Go

ALTER TABLE Ocena
	ADD CONSTRAINT Student_Ocena_FK1 foreign key (
		IdStudent)
	 references Student (
		IdOsoba) on update no action on delete no action  
Go

ALTER TABLE Ocena
	ADD CONSTRAINT Przedmiot_Ocena_FK1 foreign key (
		IdPrzedmiot)
	 references Przedmiot (
		IdPrzedmiot) on update no action on delete no action  
Go

/* Add foreign key constraints to table Student.*/
ALTER TABLE Student
	ADD CONSTRAINT Osoba_Student_FK1 foreign key (
		IdOsoba)
	 references Osoba (
		IdOsoba) on update no action on delete no action  
Go

/* Add foreign key constraints to table Dydaktyk.*/
ALTER TABLE Dydaktyk
	ADD CONSTRAINT Osoba_Dydaktyk_FK1 foreign key (
		IdOsoba)
	 references Osoba (
		IdOsoba) on update no action on delete no action  
Go

ALTER TABLE Dydaktyk
	ADD CONSTRAINT StopnieTytuly_Dydaktyk_FK1 foreign key (
		IdStopien)
	 references StopnieTytuly (
		IdStopien) on update no action on delete no action  
Go

ALTER TABLE Dydaktyk
	ADD CONSTRAINT Dydaktyk_Dydaktyk_FK1 foreign key (
		Podlega)
	 references Dydaktyk (
		IdOsoba) on update no action on delete no action  
Go

/* This is the end of the Microsoft Visual Studio generated SQL DDL script.*/
-------------------------------------------------------------------------------
INSERT INTO RokAkademicki (IdRokAkademicki, Data_rozp, Data_zak)
VALUES ('2011_12', '2011-10-01', '2012-08-31'),
		('2012_13', '2012-10-01', '2013-08-31'),
		('2013_14', '2013-10-01', '2014-08-31'),
		('2014_15', '2014-10-01', '2015-08-31');
-------------------------------------------------------------------------------
INSERT INTO Grupa (NrGrupy, SemestrNauki, IdRokAkademicki)
VALUES ('WIs I.1', 1, '2011_12'),
		('WIs I.2', 1, '2011_12'),
		('WIs II.1', 2, '2011_12'),
		('WIs II.2', 2, '2011_12'),

		('WIs I.1', 1, '2012_13'),
		('WIs I.2', 1, '2012_13'),
		('WIs II.1', 2, '2012_13'),
		('WIs II.2', 2, '2012_13'),
		('WIs III.1', 3, '2012_13'),
		('WIs III.2', 3, '2012_13'),
		('WIs IV.1', 4, '2012_13'),
		('WIs IV.2', 4, '2012_13'),

		('WIs I.1', 1, '2013_14'),
		('WIs I.2', 1, '2013_14'),
		('WIs II.1', 2, '2013_14'),
		('WIs II.2', 2, '2013_14'),
		('WIs III.1', 3, '2013_14'),
		('WIs III.2', 3, '2013_14'),
		('WIs IV.1', 4, '2013_14'),
		('WIs IV.2', 4, '2013_14'),
		('WIs V.1', 5, '2013_14'),
		('WIs VI.1', 6, '2013_14'),

		('WIs I.1', 1, '2014_15'),
		('WIs I.2', 1, '2014_15'),
		('WIs II.1', 2, '2014_15'),
		('WIs II.2', 2, '2014_15');
-------------------------------------------------------------------------------
SET Identity_insert Przedmiot ON 
Go

INSERT INTO Przedmiot (IdPrzedmiot, Przedmiot, Symbol)
VALUES	(1,'Systemy baz danych', 'SBD'),
		(2,'Relacyjne bazy danych', 'RBD'),
		(3,'Algebra liniowa i geometria', 'ALG'),
		(4,'Matematyka dyskretna', 'MAD'),
		(5,'Systemy operacyjne', 'SOP'),
		(6,'Analiza matematyczna I', 'AM1'),
		(7,'Inżynieria oprogramowania', 'INO'),
		(8,'Projektowanie baz danych', 'BDA'),
		(9,'Administrowanie bazą danych', 'ADM'),
		(10,'Analiza matematyczna II', 'AM2'),
		(11,'Algorytmy i struktury danych', 'ASD'),
		(12,'Administracja systemów operacyjnych', 'ASO');
SET Identity_insert Przedmiot OFF
Go
INSERT INTO PrzedmiotPoprzedzajacy (IdPoprzednik, IdPrzedmiot)
VALUES (2,1),(3,4), (6, 10), (4, 11), (5,12);
go
-------------------------------------------------------------------------------
SET Identity_insert StopnieTytuly ON 
Go

alter table Stopnietytuly alter column skrot varchar(16)
INSERT INTO StopnieTytuly (IdStopien, Skrot, Stopien)
VALUES	(1, 'Prof. Dr hab.', 'Profesor Doktor habilitowany')
		,(2, 'Dr hab.', 'Doktor habilitowany')
		,(3, 'Dr', 'Doktor')
		,(4, 'Mgr', 'Magister')
		,(5, 'Inż', 'Inżynier');

SET Identity_insert StopnieTytuly OFF
Go
-------------------------------------------------------------------------------
SET Identity_insert Panstwo ON 
Go

INSERT INTO Panstwo (IdPanstwo, Panstwo)
VALUES (14, 'Białoruś'),
		(4, 'Czechy'),
		(15, 'Francja'),
		(10, 'Niemcy'),
		(3,	'Polska'),
		(12, 'Rosja'),
		(18, 'Rumunia'),
		(11, 'Słowacja'),
		(16, 'Słowenia'),
		(13, 'Ukraina'),
		(2, 'USA'),
		(19,'Hiszpania'),
		(23,'Turcja'),
		(21,'Finlandia'),
		(22,'Wlochy'),
		(24, 'Grecja');

SET Identity_insert Panstwo OFF
Go

--Dydaktycy------------------------
SET Identity_insert osoba ON 
Go

INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES
(1,
 'Apolinary',
 'Anyżek',
'1960-12-01'
);
Go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(1 ,1);
Go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (2, 'Balbina', 'Bakłażan', '1991-02-03');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(2,4);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (3, 'Baltazar', 'Bigos','1995-09-04');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(3,5);
go

-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (4, 'Cezary', 'Czosnek', '1958-11-11');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(4, 1);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (5, 'Domicella', 'Dynia', '1982-06-30');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(5 ,3);

-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (6, 'Bazyli', 'Brokuł', '1971-03-08');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(6,2);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (7, 'Kajetan', 'Kalafior', '1989-05-03');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(7,4);

-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (8, 'Kunegunda', 'Karp', '1995-10-21');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(8,5);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (9, 'January', 'Jajecznica', '1965-05-22');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(9,2);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (10, 'Archibald', 'Agrest', '1978-09-05');
go	
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(10,3);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko,
 DataUrodzenia
)
VALUES (11, 'Kleofas', 'Klops', '1977-11-11');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(11, 4);
go
-----------------------------------------------------------------------------------------------
INSERT INTO osoba
(IdOsoba,
 Imie,
 Nazwisko
)
VALUES (23, 'Winicjusz', 'Wężymord');
go
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(23, NULL);
go
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
UPDATE Dydaktyk SET Podlega = 1 WHERE IdOsoba IN (6,10,2,3);
UPDATE Dydaktyk SET Podlega = 4 WHERE IdOsoba IN (5, 9)
UPDATE Dydaktyk SET Podlega = 9 WHERE IdOsoba IN (7, 11);
UPDATE Dydaktyk SET Podlega = 5 WHERE IdOsoba IN (8, 23);
-----------------------------------------------------------------------------------------------
--Studenci
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (12,'Alberta', 'Ananas', '1991-03-05');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)	
VALUES	(12, '2011-09-12','s2121');
INSERT	INTO Dydaktyk (IdOsoba, IdStopien)
VALUES	(12, 5);
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (13, 'Salomea', 'Œliwka', '1992-05-15');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(13, '2011-09-13','s2126');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (14, 'Pulchernia', 'Pączek', '1993-08-14');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(14, '2011-08-19','s2101');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (15, 'Gryzelda', 'Gruszka', '1990-12-24');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(15, '2011-10-01','s2135');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (16, 'Tymoteusz', 'Tymianek', '1993-11-21');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(16, '2012-08-12','s3162');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (17, 'Klara', 'Koperek', '1994-03-22');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(17, '2012-09-23','s3177');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (18, 'Melchior', 'Melon', '1995-08-09');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(18, '2012-07-22','s3045');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (19, 'Hieronim', 'Kapusta', '1994-08-09');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(19, '2013-08-05','s4120');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (20, 'Brunchilda', 'Banan', '1995-07-07');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(20, '2013-07-16','s4022');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (21, 'Salomon', 'Seler', '1994-11-05');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(21, '2013-07-06','s4004');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (22, 'Bonifacy', 'Bób', '1996-03-09');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(22, '2013-09-22','s4321');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (24, 'Pafnucy', 'Papryka', '1997-02-19');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(24, '2013-09-22','s4322');
go
-----------------------------------------------------------------------------------------------
INSERT	INTO osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia) VALUES (25, 'Pankracy', 'Por', '1995-07-09');
go
INSERT	INTO Student (IdOsoba, DataRekrutacji, NrIndeksu)
VALUES	(25, '2013-09-22','s4323');
go
-----------------------------------------------------------------------------------------------
INSERT INTO Osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia)
VALUES (26, 'Cecylia', 'Cebula', '1997-12-02');
Go
INSERT INTO Student (Idosoba, NrIndeksu, DataRekrutacji)
VALUES (26, 5122, '2014-06-11');
Go
-----------------------------------------------------------------------------------------------
INSERT INTO Osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia)
VALUES (27, 'Dezydery', 'Dąb', '1998-01-22');
Go
INSERT INTO Student (Idosoba, NrIndeksu, DataRekrutacji)
VALUES (27, 5131, '2014-07-17');
Go
-----------------------------------------------------------------------------------------------
INSERT INTO Osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia)
VALUES (28, 'Konstancja', 'Koperek', '1996-02-02');
Go
INSERT INTO Student (Idosoba, NrIndeksu, DataRekrutacji)
VALUES (28, 5138, '2014-07-22');
Go
-----------------------------------------------------------------------------------------------
INSERT INTO Osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia)
VALUES (29, 'Judyta', 'Jarmuż', '1997-08-28');
Go
INSERT INTO Student (Idosoba, NrIndeksu, DataRekrutacji)
VALUES (29, 5141, '2014-08-12');
Go
-----------------------------------------------------------------------------------------------
INSERT INTO Osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia)
VALUES (30, 'Klaudiusz', 'Karczoch', '1996-09-06');
Go
INSERT INTO Student (Idosoba, NrIndeksu, DataRekrutacji)
VALUES (30, 5144, '2014-08-22');
Go
-----------------------------------------------------------------------------------------------
INSERT INTO Osoba (IdOsoba, Imie, Nazwisko, DataUrodzenia)
VALUES (31, 'Sykstus', 'Szczaw', '1997-10-05');
Go
INSERT INTO Student (Idosoba, NrIndeksu, DataRekrutacji)
VALUES (31, 5149, '2014-09-01');
Go
SET Identity_insert osoba OFF
Go
-----------------------------------------------------------------------------------------------
-----------------Studenci w grupach----------------------------------------------------------
-----------------------------------------------------------------------------------------------
INSERT INTO StudentGrupa (IdOsoba, IdGrupa)
VALUES (12, 1), (12, 3), (12,9), (12, 11), (12,21), (12, 22), (13, 1), (13, 3), (13,9), (13, 11), (13,21), (13, 22),
		(14, 1), (14, 3), (14,9), (14, 11), (14,21), (14, 22), (15, 1), (15, 3), (15,9), (15, 11), (15,21), (15, 22),
		(16, 5), (17, 5), (18, 5), (16, 7), (17, 7), (18, 7),(16, 17), (17, 17), (18, 17), (16, 19), (17, 19), (18, 19),
		(19,13), (20,13), (21,13), (22, 14), (24, 14), (25,14), (19,15), (20, 15), (21,15), (22, 16), (24, 16), (25, 16), 
		(26, 23), (27,23), (28, 23), (29, 24), (30, 24),(31, 24), (26, 25), (27, 25), (28, 25), (29, 26),(30, 26), (31, 26);
-----------------------------------------------------------------------------------------------
-----------------Oceny-------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
INSERT	INTO Ocena (IdStudent, IdPrzedmiot, DataWystawienia, Ocena, IdDydaktyk)
VALUES (12, 6, '2012-01-20', 4.0, 1),
		(13, 6, '2012-01-20', 4.5, 1),
		(14, 6, '2012-01-20', 3.0, 1),
		(15, 6, '2012-01-20', 5.0, 1),

		(16, 6, '2013-01-25', 2.0, 1),
		(17, 6, '2013-01-25', 4.5, 1),
		(18, 6, '2013-01-25', 3.0, 1),
		(16, 6, '2013-02-02', 3.0, 1),

		(19, 6, '2014-01-18', 5.0, 1),
		(20, 6, '2014-01-18', 4.0, 1),
		(21, 6, '2014-01-18', 4.5, 1),
		(22, 6, '2014-01-18', 2.0, 1),
		(22, 6, '2014-01-30', 4.0, 1),

		(12, 2, '2012-01-22', 5.0, 9),
		(13, 2, '2012-01-22', 4.5, 9),
		(14, 2, '2012-01-22', 4.0, 9),
		(15, 2, '2012-01-22', 5.0, 9),

		(16, 2, '2013-01-23', 5.0, 9),
		(17, 2, '2013-01-23', 4.5, 9),
		(18, 2, '2013-01-23', 2.0, 9),
		(18, 2, '2013-02-01', 3.0, 9),

		(19, 2, '2014-01-18', 3.0, 9),
		(20, 2, '2014-01-18', 4.0, 9),
		(21, 2, '2014-01-18', 3.5, 9),
		(22, 2, '2014-01-18', 5.0, 9),

		(12, 12, '2014-01-18', 4.0, 8),
		(13, 12, '2014-01-18', 4.5, 8),
		(14, 12, '2014-01-18', 4.0, 8),
		(15, 12, '2014-01-18', 3.0, 8);


		
INSERT INTO Miasto (Miasto, IdPanstwo)
VALUES ('Warszawa', 3),
	('New York',	2),
	('Dallas',	2),
	('Chicago',	2),
	('Boston',	2),
	('Los Angeles',	2),
	('Bonn',	10),
	('Detroit',	2),
	('Bratysława',	11),
	('Praga',	4),
	('Paryż',	15),
	('Lyon',	15),
	('Honolulu',	2),
	('Helsinki',	21),
	('Kraków',	3),
	('Poznań',	3),
	('San Francisco', 2),
	('Rzym',	22),
	('Neapol',	22),
	('Wrocław',	3),
	('Kielce',	3),
	('Kijów',	13),
	('Madryt',	19),
	('Lizbona',	19),
	('Saloniki',	24),
	('Zakhyntos',	24),
	('Ateny',	24),
	('Aachen',	10),
	('Mszana Dolna', 3),
	('San Pedro del Alcantara',	19),
	('Marbella',	19),
	('Granada',	19),
	('Koluszki',	3),
	('Kadzidło',	3),
	('Nowy Targ',	3),
	('Pcim',	3),
	('Barcelona',	19),
	('Magdeburg',	10),
	('Essen',	10),
	('San Sebastian', 19),
	('Stambuł', 23);

	
INSERT INTO Katedra (Katedra) VALUES ('Baz danych')
									,('Sztucznej inteligencji')
									,('Inżynierii oprogramowania')
									,('Multimediów');

UPDATE Katedra SET IdOsoba =
	(SELECT IdOsoba
	FROM Osoba
	WHERE Nazwisko = 'Dynia' AND Imie = 'Domicella')
WHERE Katedra = 'Baz danych';

UPDATE Katedra SET IdOsoba =
	(SELECT IdOsoba
	FROM Osoba
	WHERE Nazwisko = 'Agrest' AND Imie = 'Archibald')
WHERE Katedra = 'Inżynierii oprogramowania';
