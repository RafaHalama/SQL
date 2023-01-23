
CREATE VIEW Prac
(nr, nazwisko, stanowisko, placa, premia, data_zatr, nr_oddz, oddz, lok)
AS SELECT EMPNO, ENAME, JOB, SAL, COMM, HIREDATE, emp.DEPTNO, DNAME, LOC 
FROM emp, dept
WHERE emp.deptno = dept.deptno AND loc = 'NEW YORK';

SELECT nr, nazwisko, placa*12 + nvl(premia,0)*12 FROM prac;

UPDATE Prac SET PLACA = PLACA * 1.2;
rollback;

UPDATE Prac SET oddz = 'NowaNazwa'; 

INSERT INTO Prac (nr, nazwisko, stanowisko, placa, premia, data_zatr, nr_oddz)
VALUES (7899, 'KOWALSKI', 'CLERK', 2250, null, sysdate, 10);
ROLLBACK;



CREATE VIEW Prac3000 (nr, nazwisko, stanowisko, placa)
AS SELECT EMPNO, ENAME, JOB, SAL
FROM emp
WHERE sal < 3000
WITH CHECK OPTION;

UPDATE Prac3000 SET placa = placa +1000;
UPDATE Prac3000 SET placa = placa +10;
UPDATE Prac3000 SET placa = placa +100 WHERE placa < 2900;
ROLLBACK;



CREATE VIEW PracMgr (nr, nazwisko, stanowisko, placa)
 AS SELECT EMPNO, ENAME, JOB, SAL
 FROM emp
 WHERE job = 'MANAGER' WITH READ ONLY;
 
 UPDATE PracMGR SET placa = placa +10;
 
 
 CREATE VIEW Pracownicy
(nazwisko, stanowisko, placa, premia, data_zatr, nr_oddz, oddz, lok)
AS SELECT ENAME, JOB, SAL, COMM, HIREDATE, emp.DEPTNO, DNAME, LOC 
FROM emp, dept
WHERE emp.deptno = dept.deptno;


CREATE or replace TRIGGER Pracownicy_insert
INSTEAD OF INSERT ON Pracownicy
FOR EACH ROW
DECLARE
  p NUMBER;
  Lp NUMBER;
BEGIN 
  SELECT Count(*) INTO p FROM Dept 
  WHERE Dept.Deptno = :NEW.nr_oddz;  
  IF p=0 THEN 
       INSERT INTO Dept VALUES(:NEW.nr_oddz, :NEW.oddz, :NEW.lok);
  END IF;
  SELECT Count(*) INTO p FROM Emp
  WHERE Emp.ename = :NEW.nazwisko;
  IF p=0 THEN 
    Select NVL(max(empno)+1,1) into Lp from emp;
    INSERT INTO Emp VALUES(Lp, :NEW.Nazwisko , :NEW.stanowisko, null, :NEW.data_zatr,:NEW.placa, :NEW.premia,:NEW.nr_oddz);
  ELSE
    UPDATE Emp SET JOB =:NEW.stanowisko, HIREDATE=:NEW.data_zatr, SAL=:NEW.placa, COMM =:NEW.premia,  deptno=:NEW.nr_oddz
    WHERE Emp.Ename = :NEW.nazwisko;
  END IF;
end;




select nazwisko, stanowisko, placa, oddz
from Pracownicy

insert into Pracownicy
 (nazwisko, stanowisko, placa, premia, data_zatr, nr_oddz, oddz, lok) 
 values('Halama','CLERK',4000,3333,sysdate,50, 'PJWSTK','W-wa');
 
 UPDATE Pracownicy SET placa = placa +50 where nazwisko = 'Halama';

select * from Pracownicy;
select * from EMP;
select * from DEPT;


CREATE OR REPLACE VIEW  PracownicyDzialy
(nazwisko, stanowisko, placa, premia, data_zatr, oddz, lok)
AS SELECT ENAME, JOB, SAL, COMM, HIREDATE, DNAME, LOC 
FROM emp, dept
WHERE emp.deptno = dept.deptno;



CREATE or replace TRIGGER PracownicyDzialy_insert
INSTEAD OF INSERT ON PracownicyDzialy
FOR EACH ROW
DECLARE
  p NUMBER;
  Lp NUMBER;
  Lp1 NUMBER;
BEGIN 
  SELECT Count(*) INTO p FROM Dept 
  WHERE Dept.dname = :NEW.oddz;  
  IF p=0 THEN
       SELECT NVL(Max(deptno)+10, 10) INTO Lp1 FROM DEPT;
       INSERT INTO Dept VALUES(Lp1, :NEW.oddz, :NEW.lok);
  ELSE
       UPDATE Dept SET LOC = :NEW.lok
       WHERE Dept.dname = :NEW.oddz;
       SELECT Deptno into Lp1 from dept  where dept.dname = :NEW.oddz;
  END IF;
  SELECT Count(*) INTO p FROM Emp
  WHERE Emp.ename = :NEW.nazwisko;
  IF p=0 THEN 
    Select NVL(max(empno)+1,1) into Lp from emp;
    INSERT INTO Emp VALUES(Lp, :NEW.Nazwisko , :NEW.stanowisko, null, :NEW.data_zatr,:NEW.placa, :NEW.premia,Lp1);
  ELSE
    UPDATE Emp SET JOB =:NEW.stanowisko, HIREDATE=:NEW.data_zatr, SAL=:NEW.placa, COMM =:NEW.premia,  deptno=Lp1
    WHERE Emp.Ename = :NEW.nazwisko;
  END IF;
end;

insert into PracownicyDzialy
 (nazwisko, stanowisko, placa, premia, data_zatr, oddz, lok) 
 values('Halama','CLERK',4000,3333,sysdate, 'PJWSTK','Krakow');
 
 insert into PracownicyDzialy
 (nazwisko, stanowisko, placa, premia, data_zatr, oddz, lok) 
 values('dfdf','CLERdK',4000,3333,sysdate, 'Test','Krakow');
 
select * from PracownicyDzialy;
select* from dept;
rollback;

CREATE OR REPLACE VIEW  PracProj(nazwisko, stanowisko, placa, data_zatr, nr_dzialu, Nazwa_proj, budzet, Data_startu)
AS SELECT ENAME, JOB, SAL, HIREDATE, emp.DEPTNO,PNAME, BUDGET, START_DATE
FROM emp,proj,proj_emp
WHERE emp.empno = proj_emp.empno and
proj.projno = proj_emp.projno

select * from pracproj

CREATE or replace TRIGGER PracProj_insert
INSTEAD OF INSERT ON PracProj
FOR EACH ROW
DECLARE
  l_parentnotfound    exception;
  p NUMBER;
  Lp NUMBER;
  Lp1 NUMBER;
BEGIN 
  SELECT Count(*) INTO p FROM Dept
  WHERE Dept.deptno = :NEW.nr_dzialu;
  IF p=0 THEN
    raise_application_error(-20500, 'taki dept nie istnieje');
  END IF;
  SELECT Count(*) INTO p FROM Proj 
  WHERE Proj.pname = :NEW.Nazwa_proj;  
  IF p=0 THEN
       Select NVL(max(projno)+1,1) into Lp from proj; 
       INSERT INTO PROJ VALUES(Lp, :NEW.Nazwa_proj, :NEW.budzet, :NEW.Data_startu, NULL);
  ELSE
       UPDATE Proj
       SET BUDGET = :NEW.budzet, START_DATE = :NEW.Data_startu, END_DATE = NULL
       WHERE PNAME = :NEW.Nazwa_proj;
    
       SELECT projno INTO Lp FROM proj WHERE pname = :NEW.Nazwa_proj;
  END IF;
  SELECT Count(*) INTO p FROM Emp
  WHERE Emp.ename = :NEW.nazwisko;
  IF p=0 THEN 
    Select NVL(max(empno)+1,1) into Lp1 from emp;
    INSERT INTO Emp VALUES(Lp1, :NEW.nazwisko , :NEW.stanowisko, null, :NEW.data_zatr,:NEW.placa, NULL,:NEW.nr_dzialu);
  ELSE
    UPDATE Emp SET JOB =:NEW.stanowisko, HIREDATE=:NEW.data_zatr, SAL=:NEW.placa,  deptno=:NEW.nr_dzialu
    WHERE Ename = :NEW.nazwisko;
    
    SELECT EMPNO INTO Lp1 FROM EMP WHERE ENAME = :NEW.nazwisko;
  END IF;
  
  SELECT Count(*) INTO p
  FROM PROJ_EMP
  WHERE PROJNO = Lp   AND EMPNO = Lp1;

  IF p = 0 THEN
        INSERT INTO PROJ_EMP VALUES(Lp, Lp1);
  END IF;
  
  
end;


INSERT INTO PracProj VALUES('Kowalski', 'DEV', 5555, CURRENT_DATE,40, 'NEW_PROJECT1', 30000, CURRENT_DATE);
 SELECT * FROM PROJ_EMP;
 SELECT * FROM PROJ;
 SELECT * FROM EMP;
 
 INSERT INTO PracProj VALUES('Kowalski', 'DEV', 5000, CURRENT_DATE,40, 'PROJECT1', 30000, CURRENT_DATE);
SELECT * FROM PROJ;

 INSERT INTO PracProj VALUES('Kowalski', 'DEV', 5000, CURRENT_DATE,70, 'PROJECT1', 30000, CURRENT_DATE);
 
rollback;