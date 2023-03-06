/*Wypisz imiona, nazwiska i rok urodzenia osób z tabeli OSOBA. Posortuj malej?co po roku
urodzenia i rosn?co po nazwisku. */

select imie, nazwisko, extract(YEAR FROM DataUrodzenia)
from  Osoba
order by extract(YEAR FROM DataUrodzenia) desc, nazwisko;

/*Wypisz w jednej kolumnie imiona i nazwiska wszystkich osób z tabeli OSOBA. Kolumn?
nazwij „Pracownicy i studenci”. Wynikowe rekordy posortuj rosn?co wg nazwisk.
*/

select imie  || ' ' || nazwisko || ' -student lub dydaktyk' "studenci i dydaktycy"
from osoba
order by nazwisko;

/*Sprawd?, ile miesi?cy, dni i lat up?yne?o od daty rekrutacji ka?dego studenta (podaj tylko
numer indeksu).*/

select nrindeksu,
extract(YEAR from sysdate) - extract(YEAR FROM DataRekrutacji) "lata",
months_between(sysdate, DataRekrutacji) "miesiace",
trunc (sysdate - DataRekrutacji) "dni"
from student;

/*Wypisz imiona i nazwiska wszystkich dydaktyków, tak?e tych nie posiadajacyh stopnia.*/

select imie, nazwisko
from Osoba O
JOIN Dydaktyk D
ON O.IdOsoba = D.IdOsoba
left JOIN StopnieTytuly ST
ON ST.IdStopien = D.IDStopien

/*Wypisz imiona i nazwiska wszystkich osób b?d?cych jednocze?nie studentami i
dydaktykami.*/

select imie, nazwisko
from osoba O
join student s 
on O.Idosoba  = s.IdOsoba
intersect
select imie, nazwisko
from osoba O
join Dydaktyk D
on O.IdOsoba = D.IdOsoba

/*Wypisz nazwiska wszystkich studentów, którzy maj? wystawion? ocen? z przedmiotu
„Relacyjne bazy danych”, ale nie maj? oceny z przedmiotu „Administracja systemów
operacyjnych”.*/

select nazwisko
from osoba os
join ocena o on os.idosoba = o.idstudent
join przedmiot p on p.idprzedmiot = o.idprzedmiot
where przedmiot = 'Relacyjne bazy danych'
except
select nazwisko
from osoba os
join ocena o on os.idosoba = o.idstudent
join przedmiot p on p.idprzedmiot = o.idprzedmiot
where przedmiot = 'RAdministracja systemów
operacyjnych'


/*Znajd? liczb? wystawionych ocen oraz ?redni? ocen? z ka?dego przedmiotu. Podaj nazw?
przedmiotu.*/
select przedmiot, count(*), avg(ocena)
from przedmiot p
join ocena o on o.idprzedmiot = p.idprzedmiot
group by przedmiot


/*Znajd? imiona i nazwiska studentów, którzy rozpocz?li studia w tym samym roku co
Gryzelda Gruszka i maj? ?redni? ocen wy?sz? ni? ?rednia ocen Salomona Selera. */

select imie, nazwisko, avg(ocena) 
from osoba os
join student s on s.idosoba = os.idosoba
join ocena o on os.idosoba = o.idstudent
where extract(year from DataRekrutacji) =
    (select extract(year from DataRekrutacji)
    from student 
    where idosoba = 
        (select idosoba
        from osoba
        where imie = 'Gryzelda' and nazwisko = 'Gruszka'))
group by imie, nazwisko
having avg(ocena) > 
    (select avg(ocena)
    from ocena
    where idstudent = 
        (select idosoba
        from osoba
        where imie = 'Salomon' and nazwisko = 'Seler'))
        
/*Dla ka?dego rocznika rekrutacji znajd? studenta z najwy?sz? ?redni? ocen*/        
        
select imie, nazwisko , extract(year from DataRekrutacji), avg(ocena)
from student s
join osoba o on o.idosoba = s.idosoba
join ocena oc on oc.idstudent = o.idosoba
group by imie, nazwisko,  extract(year from DataRekrutacji)
having avg(ocena) >=
    (select max(avg(ocena))
    from student s1
    join ocena oc1 on s1.idosoba = oc1.idstudent
    where extract(year from s1.DataRekrutacji) = extract(year from s.DataRekrutacji)
    group by idstudent)
    
