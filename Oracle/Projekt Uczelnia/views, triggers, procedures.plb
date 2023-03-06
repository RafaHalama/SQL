/*Utwórz widok V_DYDAKTYK prezentuj?cy dane dydaktyków – Imi?, Nazwisko, Stopie?
(tekst), Miasto (tekst). Perspektywa powinna uwzgl?dnia? dydaktyków nieposiadaj?cych
?adnego stopnia naukowego, a tak?e tych, którzy nie podali swojego miejsca zamieszkania.
Sprawd? dzia?anie widoku.*/

CREATE VIEW V_DYDAKTYK(Imie, Nazwisko, Stopien, Miasto)
AS
SELECT Imie, Nazwisko, Stopien, Miasto
from Osoba O
Join Dydaktyk D on D.IdOsoba = O.IdOsoba
left Join StopnieTytuly St on St.IdStopien = D.IdStopien
left Join Miasto M on M.IdMiasto = O.IdMiasto;

select * from v_dydaktyk


/*Wykonaj widok V_OcenaIns s?u??cy do wpisywania ocen. Zagwarantuj niemo?liwo??
wstawienia poprzez ten widok oceny spoza zbioru {2, 3.0, 3.5, 4.0, 4.5, 5.0}.*/

CREATE VIEW V_OcenaIns
AS
SELECT DataWystawienia,
    IdDydaktyk,
    Ocena,
    IdPrzedmiot,
    IdStudent
From Ocena O
Where O.Ocena IN (2.0, 3.0, 3,5, 4.0, 4.5, 5.0)
WITH CHECK OPTION;


/*Napisz prosty program w (PL/SQL). Zadeklaruj zmienn?, przypisz na t?
zmienn? liczb? rekordów w tabeli OSOBA (lub jakiejkolwiek innej) i wypisz uzyskany
wynik u?ywaj?c  dbms_output (PL/SQL), w postaci napisu np.
"W tabeli jest 10 rekordów".*/

Insert into V_OcenaIns(DataWystawienia,
    IdDydaktyk,
    Ocena,
    IdPrzedmiot
    ,IdStudent)
VALUES (sysdate, 5, 5.0, 1,15)

SET Serveroutput ON;
SET Feedback OFF;
DECLARE
    v_Ile Int;
    v_Info Varchar2(64);
BEGIN
    SELECT Count(1) INTO v_ile FROM Osoba;
    v_info := 'W tabeli Osoba jest ' || v_ile || ' rekordow';
    dbms_output.put_line(v_info);
END;



/*U?ywaj?c (PL/SQL), policz dydaktyków z tabeli DYDAKTYK. Je?li ich liczba
jest mniejsza ni? 16, wstaw dydaktyka: pani? doktor Celestyn? Cykori? i wypisz
odpowiedni komunikat. Je?li liczba pracowników jest wi?ksza ni? 15, wypisz komunikat
informuj?cy o tym, ?e nie wstawiono danych z powodu braku etatów*/

SET Serveroutput ON;
SET Feedback OFF;
DECLARE
v_Ile Int;
v_Info Varchar2(64);
v_Id Int;
BEGIN
    SELECT Count(1) INTO v_ile FROM Dydaktyk;
    If v_Ile < 16 THEN
        SELECT Max(NVL(IdOsoba,0)) + 1 Into v_Id From Osoba;
        INSERT INTO Osoba (IdOsoba, Imie, Nazwisko)
        VALUES (v_Id, 'Celestyna', 'Cykoria');
        INSERT INTO Dydaktyk (IdOsoba, IdStopien, IdKatedra)
        Select v_Id, IdStopien, IdKatedra From StopnieTytuly, Katedra
        where stopien = 'Doktor' AND Katedra ='Sztucznej inteligencji';
        v_info:= 'Dopisano do bazy';
    ELSE
        v_info:= 'Nie dopisano do bazy';
    END IF;
    dbms_output.put_line(v_info);
END;


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