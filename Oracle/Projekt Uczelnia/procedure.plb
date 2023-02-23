/*testowa procedura dodajaca dydaktyka*/

CREATE SEQUENCE SEQ_Osoba;

create or replace PROCEDURE Dodaj_dydaktyk (
p_Imie Varchar2, p_Nazwisko Varchar2, p_Stopien VARCHAR2, p_Plec Char)
AS
    v_Ile Integer;
    v_IdStopien Integer;
    v_Idosoba INTEGER;
    e_JuzJest Exception;
    v_Info VARCHAR2 (128);
BEGIN
SELECT COUNT (1) INTO v_Ile
FROM Stopnietytuly
WHERE stopien = p_Stopien;
    IF v_Ile > 0 THEN
        SELECT IdStopien INTO v_IdStopien FROM StopnieTytuly
        WHERE Stopien = p_Stopien;
    END IF;
    SELECT COUNT (1) INTO v_Ile
    FROM Dydaktyk D INNER JOIN Osoba O ON D. Idosoba = O.Idosoba
    LEFT JOIN StopnieTytuly ST ON ST.IdStopien = D.IdStopien
    WHERE Imie = p_Imie AND Nazwisko = p_Nazwisko
    AND (D.IdStopien = v_IdStopien OR v_IdStopien IS NULL);
    v_Info := p_Imie || ' ' || p_Nazwisko || '-' || p_Stopien;
    IF v_Ile > 0 THEN
        v_Info := 'Jest juz zatrudniony dydaktyk' || v_Info;
        Raise e_JuzJest;
    ELSE
        INSERT INTO Osoba (Idosoba, Nazwisko, Imie)
        VALUES (SEQ_Osoba.nextval, p_Imie, p_Nazwisko);
        INSERT INTO Dydaktyk (Idosoba, IdStopien)
        VALUES (SEQ_Osoba.currval, v_IdStopien);
        v_Idosoba := SEQ_Osoba.currval;
    UPDATE Dydaktyk SET Podlega =
        (SELECT O.Idosoba FROM Osoba O JOIN Dydaktyk D
        ON O. Idosoba = D.Idosoba
        WHERE Imie = 'Cezary' AND Nazwisko = 'Czosnek')
    WHERE Idosoba = v_Idosoba;
    COMMIT;
    v_Info := 'Zostal atrudniony dydaktyk ' || v_Info;
    dbms_output.put_line (v_Info);
END IF;
EXCEPTION
WHEN e_JuzJest THEN
    dbms_output.put_line (v_Info);
END;