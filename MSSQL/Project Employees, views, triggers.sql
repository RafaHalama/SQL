﻿/* TWORZENIE BAZY PRACOWNIKOW MSSQL */

DROP TABLE PROJ_EMP;
DROP TABLE PROJ;
DROP TABLE EMP;
DROP TABLE DEPT;
DROP TABLE SALGRADE;

CREATE TABLE EMP
       (EMPNO INT NOT NULL,
        ENAME VARCHAR(10),
        JOB VARCHAR(9),
        MGR INT,
        HIREDATE DATETIME,
        SAL INT,
        COMM INT,
        DEPTNO INT);

ALTER TABLE EMP
ADD CONSTRAINT EMP_PK PRIMARY KEY (EMPNO)   
Go

ALTER TABLE DEPT
ADD CONSTRAINT DEPT_PK PRIMARY KEY (DEPTNO)   
Go

ALTER TABLE SALGRADE
ADD CONSTRAINT SALGRADE_PK PRIMARY KEY (GRADE)   
Go

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        CONVERT(DATETIME,'17-DEC-1980'),  800, NULL, NULL);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        CONVERT(DATETIME,'20-FEB-1981'), 1600,  300, 30);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        CONVERT(DATETIME,'22-FEB-1981'), 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        CONVERT(DATETIME,'2-APR-1981'),  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        CONVERT(DATETIME,'28-SEP-1981'), 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        CONVERT(DATETIME,'1-MAY-1981'),  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        CONVERT(DATETIME,'9-JUN-1981'),  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        CONVERT(DATETIME,'09-DEC-1982'), 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        CONVERT(DATETIME,'17-NOV-1981'), 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        CONVERT(DATETIME,'8-SEP-1981'),  1100,    0, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        CONVERT(DATETIME,'12-JAN-1983'), 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        CONVERT(DATETIME,'3-DEC-1981'),   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        CONVERT(DATETIME,'3-DEC-1981'),  3000, NULL, 20);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        CONVERT(DATETIME,'23-JAN-1982'), 1300, NULL, 10);

CREATE TABLE DEPT
       (DEPTNO INT,
        DNAME VARCHAR(14),
        LOC VARCHAR(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE SALGRADE
        (GRADE INT NOT NULL,
         LOSAL INT NOT NULL,
         HISAL INT NOT NULL);

INSERT INTO SALGRADE VALUES (1,  700, 1200);
INSERT INTO SALGRADE VALUES (2, 1201, 1400);
INSERT INTO SALGRADE VALUES (3, 1401, 2000);
INSERT INTO SALGRADE VALUES (4, 2001, 3000);
INSERT INTO SALGRADE VALUES (5, 3001, 9999);




CREATE TABLE PROJ
   (PROJNO int not null, 
	 PNAME VARCHAR(14) not null, 
	 BUDGET int not null, 
	 START_DATE DATE, 
	 END_DATE DATE
   ) ;



ALTER TABLE PROJ
	ADD CONSTRAINT PROJ_PK PRIMARY KEY (PROJNO)   


Insert into PROJ  values (1,'PROJECT1',15000,'2016-10-1','2016-10-31');
Insert into PROJ  values (2,'PROJECT2',23000,'2016-10-15','2016-11-30');
Insert into PROJ  values (3,'PROJECT3',48000,'2016-11-15','2016-12-31');
Insert into PROJ  values (4,'PROJECT4',21000,'2016-12-10','2016-12-20');
--------------------------------------------------------


CREATE TABLE PROJ_EMP
   (PROJNO int NOT NULL , 
    EMPNO  int NOT NULL ,
    CONSTRAINT PROJ_EMP_PRIMARY_KEY PRIMARY KEY (PROJNO,EMPNO) 
   );

ALTER TABLE PROJ_EMP
	ADD CONSTRAINT EMP_PROJ_EMP_FK1 foreign key (
		EMPNO)
	 references EMP (
		EMPNO) on update no action on delete no action  


ALTER TABLE PROJ_EMP
	ADD CONSTRAINT PROJ_PROJ_EMP_FK2 foreign key (
		PROJNO)
	 references PROJ (
		PROJNO) on update no action on delete no action  


Insert into PROJ_EMP values(1,7782);
Insert into PROJ_EMP values(1,7788);
Insert into PROJ_EMP values(1,7369);
Insert into PROJ_EMP values(1,7566);

Insert into PROJ_EMP values(2,7839);
Insert into PROJ_EMP values(2,7782);
Insert into PROJ_EMP values(2,7902);
Insert into PROJ_EMP values(2,7698);


Insert into PROJ_EMP values(3,7566);
Insert into PROJ_EMP values(3,7902);
Insert into PROJ_EMP values(3,7369);
Insert into PROJ_EMP values(3,7788);
Insert into PROJ_EMP values(3,7876);

Insert into PROJ_EMP values(4,7698);
Insert into PROJ_EMP values(4,7900);
Insert into PROJ_EMP values(4,7902);

Insert into PROJ  values (5,'PROJECT5',24000,'2017-10-10','2017-12-29');
Insert into PROJ_EMP values(5,7369);
Insert into PROJ_EMP values(5,7788);
Insert into PROJ_EMP values(5,7876);



----------------------------------------------------------------------------------
/*perspektywa wybierającą wszystkie dane dotyczące pracowników */

CREATE VIEW Prac
(
    nr,
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    nr_oddz,
    oddz,
    lok
)
AS
SELECT EMPNO,
       ENAME,
       JOB,
       SAL,
       COMM,
       HIREDATE,
       emp.DEPTNO,
       DNAME,
       LOC
FROM emp,
     dept
WHERE emp.deptno = dept.deptno
      AND loc = 'NEW YORK';

SELECT nr,
       nazwisko,
       placa * 12 + COALESCE(premia * 12, 0)
FROM prac;

UPDATE Prac
SET PLACA = PLACA * 1.2;

UPDATE Prac
SET oddz = 'NowaNazwa';

INSERT INTO Prac
(
    nr,
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    nr_oddz
)
VALUES
(7899, 'KOWALSKI', 'CLERK', 2250, null, GETDATE(), 10);

----------------------------------------------------------------------------------
/*perspektywa pracowników zarabiających poniżej 3000*/

CREATE VIEW Prac3000
(
    nr,
    nazwisko,
    stanowisko,
    placa
)
AS
SELECT EMPNO,
       ENAME,
       JOB,
       SAL
FROM emp
WHERE sal < 3000
WITH CHECK OPTION;

SELECT nr,
       nazwisko,
       placa
FROM prac3000;

--NIE MOZNA PRZEZ CHECK OPTION
UPDATE Prac3000
SET placa = placa + 1000;


----------------------------------------------------------------------------------
/*Wyzwalacz działający na persepktywie pozwalający na dodanie nowych pracowników i działow
*/
CREATE VIEW Pracownicy
(
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    nr_oddz,
    oddz,
    lok
)
AS
SELECT ENAME,
       JOB,
       SAL,
       COMM,
       HIREDATE,
       emp.DEPTNO,
       DNAME,
       LOC
FROM emp,
     dept
WHERE emp.deptno = dept.deptno;

CREATE or ALTER TRIGGER Pracownicy_insert
ON Pracownicy
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @Deptno Int,
            @Empno Int;
    IF NOT EXISTS (SELECT 1 FROM DEPT D, inserted I WHERE D.DNAME = I.oddz)
    BEGIN
        SELECT @Deptno = isnull(MAX(deptno), 0) + 10
        FROM DEPT;
        INSERT INTO DEPT
        (
            DEPTNO,
            DNAME,
            LOC
        )
        SELECT @dEPTNO,
               oddz,
               lok
        FROM inserted;
    END;
    IF NOT EXISTS (SELECT 1 FROM EMP E, inserted I WHERE E.ENAME = I.nazwisko)
    BEGIN
        SELECT @Empno = Isnull(MAX(empno), 0) + 1
        from EMP;
        INSERT INTO EMP
        (
            EMPNO,
            ENAME,
            JOB,
            HIREDATE,
            SAL,
            DEPTNO
        )
        SELECT @Empno,
               nazwisko,
               stanowisko,
               data_zatr,
               placa,
               nr_oddz
        FROM inserted;
    END;
END;


select nazwisko,
       stanowisko,
       placa,
       oddz
from Pracownicy

insert into Pracownicy
(
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    nr_oddz,
    oddz,
    lok
)
values
('Halama', 'CLERK', 4000, 3333, GETDATE(), 50, 'PJWSTK', 'W-wa');

UPDATE Pracownicy
SET placa = placa + 50
where nazwisko = 'Halama';


----------------------------------------------------------------------------------
/*Wyzwalacz działający na persepktywie pozwalający na dodanie nowych pracowników i działow
Jeżeli nazwisko pracownika istnieje, zmienamy dane na nowe
Jeżeli nazwa działu juz istnieje, zmieniamy dane na nowe
*/

CREATE OR ALTER VIEW PracownicyDzialy
(
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    oddz,
    lok
)
AS
SELECT ENAME,
       JOB,
       SAL,
       COMM,
       HIREDATE,
       DNAME,
       LOC
FROM emp,
     dept
WHERE emp.deptno = dept.deptno;


CREATE or ALTER TRIGGER PracownicyDzialy_insert
ON PracownicyDzialy
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @Deptno Int,
            @Empno Int;
    IF NOT EXISTS (SELECT 1 FROM DEPT D, inserted I WHERE D.DNAME = I.oddz)
    BEGIN
        SELECT @Deptno = isnull(MAX(deptno), 0) + 10
        FROM DEPT;
        INSERT INTO DEPT
        (
            DEPTNO,
            DNAME,
            LOC
        )
        SELECT @dEPTNO,
               oddz,
               lok
        FROM inserted;

    END
    ELSE
    BEGIN
        UPDATE DEPT
        SET loc = I.lok
        FROM DEPT,
             inserted I
        WHERE DEPT.DNAME = I.oddz
        SELECT @Deptno =
        (
            SELECT Deptno from dept, inserted I where dept.dname = I.oddz
        )
    END

    IF NOT EXISTS (SELECT 1 FROM EMP E, inserted I WHERE E.ENAME = I.nazwisko)
    BEGIN
        SELECT @Empno = Isnull(MAX(empno), 0) + 1
        from EMP;
        INSERT INTO EMP
        (
            EMPNO,
            ENAME,
            JOB,
            HIREDATE,
            SAL,
            COMM,
            DEPTNO
        )
        SELECT @Empno,
               nazwisko,
               stanowisko,
               data_zatr,
               placa,
               premia,
               @Deptno
        FROM inserted;
    END;
    ELSE
    BEGIN
        UPDATE EMP
        SET JOB = I.stanowisko,
            HIREDATE = I.data_Zatr,
            SAL = I.placa,
            COMM = I.premia,
            deptno = @Deptno
        FROM EMP,
             inserted I
        WHERE Emp.Ename = I.nazwisko
    END
END;

insert into PracownicyDzialy
(
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    oddz,
    lok
)
values
('Halama', 'CLERK', 40000, 3333, GETDATE(), 'PJWSTK', 'Warszawa');

insert into PracownicyDzialy
(
    nazwisko,
    stanowisko,
    placa,
    premia,
    data_zatr,
    oddz,
    lok
)
values
('dfdf', 'CLERdK', 4000, 3333, GETDATE(), 'Test', 'Krakow');

select *
from PracownicyDzialy;
select *
from dept;

----------------------------------------------------------------------------------
/* Wyzwalacz działający na perspektywie pozwalający na wstawienie nowych pracowników i nowych projektów
Gdy nazwisko pracownika istnieje, zmieniamy dane na nowe
Gdy nazwa projektu istnieje, zmieniamy dane na nowe
Jeżeli nr departamentu nie istnieje, wywołujemy error
*/


CREATE OR ALTER VIEW PracProj
(
    nazwisko,
    stanowisko,
    placa,
    data_zatr,
    nr_dzialu,
    Nazwa_proj,
    budzet,
    Data_startu
)
AS
SELECT ENAME,
       JOB,
       SAL,
       HIREDATE,
       emp.DEPTNO,
       PNAME,
       BUDGET,
       START_DATE
FROM emp,
     proj,
     proj_emp
WHERE emp.empno = proj_emp.empno
      and proj.projno = proj_emp.projno




CREATE or ALTER TRIGGER PracProj_insert
ON PracProj
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @Deptno Int,
            @Empno Int,
            @Projno Int;
    IF NOT EXISTS
    (
        SELECT 1
        FROM DEPT D,
             inserted I
        WHERE D.deptno = I.nr_dzialu
    )
    BEGIN TRY
        RAISERROR('taki dept nie istnieje', 15, 1);

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT ERROR_NUMBER() AS ErrorNumber,
               ERROR_SEVERITY() AS ErrorSeverity,
               ERROR_STATE() AS ErrorState,
               ERROR_PROCEDURE() AS ErrorProcedure,
               ERROR_LINE() AS ErrorLine,
               ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
    ELSE
    BEGIN
        SELECT @Deptno =
        (
            SELECT Deptno from dept, inserted I where dept.deptno = I.nr_dzialu
        )
    END

    IF NOT EXISTS
    (
        SELECT 1
        FROM Proj P,
             inserted I
        WHERE P.pname = I.Nazwa_proj
    )
    BEGIN
        SELECT @Projno = Isnull(MAX(Projno), 0) + 1
        from proj;
        INSERT INTO Proj
        (
            Projno,
            pname,
            budget,
            start_date
        )
        SELECT @Projno,
               Nazwa_proj,
               budzet,
               Data_startu
        FROM inserted;
    END
    ELSE
    BEGIN
        UPDATE Proj
        SET budget = I.budzet,
            start_Date = I.Data_startu
        FROM EMP,
             inserted I
        WHERE proj.pname = I.Nazwa_proj
        SELECT @Projno =
        (
            SELECT Projno from Proj, inserted I where Proj.pname = I.Nazwa_proj
        )
    END
    IF NOT EXISTS (SELECT 1 FROM EMP E, inserted I WHERE E.ENAME = I.nazwisko)
    BEGIN
        SELECT @Empno = Isnull(MAX(empno), 0) + 1
        from EMP;
        INSERT INTO EMP
        (
            EMPNO,
            ENAME,
            JOB,
            HIREDATE,
            SAL,
            DEPTNO
        )
        SELECT @Empno,
               nazwisko,
               stanowisko,
               data_zatr,
               placa,
               @Deptno
        FROM inserted;
    END
    ELSE
    BEGIN
        UPDATE EMP
        SET JOB = I.stanowisko,
            HIREDATE = I.data_Zatr,
            SAL = I.placa,
            deptno = @Deptno
        FROM EMP,
             inserted I
        WHERE Emp.Ename = I.nazwisko
        SELECT @Empno =
        (
            SELECT Empno from emp, inserted I where emp.ename = I.nazwisko
        )
    END
    IF NOT EXISTS
    (
        SELECT 1
        FROM PROJ_EMP,
             inserted I
        WHERE Projno = @Projno
              and Empno = @Empno
    )
    BEGIN
        INSERT INTO PROJ_EMP
        (
            PROJNO,
            EMPNO
        )
        VALUES
        (@Projno, @Empno)
    END
END


SELECT *
FROM PROJ_EMP;
SELECT *
FROM PROJ;
SELECT *
FROM EMP;

INSERT INTO PracProj
VALUES
('Kowalski', 'DEV', 5555, GETDATE(), 40, 'NEW_PROJECT1', 30000, GETDATE());

INSERT INTO PracProj
VALUES
('Kowalski', 'DEV', 5555, GETDATE(), 80, 'NEW_PROJECT88', 300, GETDATE());