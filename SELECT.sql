===============================1===================================
SELECT PNAME, ENAME , EXTRACT(year FROM START_DATE) as Year
FROM EMP, PROJ, PROJ_EMP
WHERE EMP.EMPNO=PROJ_EMP.EMPNO 
AND PROJ.PROJNO=PROJ_EMP.PROJNO
AND EXTRACT(year FROM START_DATE) = '2016'
ORDER BY PNAME
 
===============================2=================================== 
SELECT EXTRACT(year FROM START_DATE)as Year,EXTRACT(month FROM START_DATE) as Month, COUNT(*)
FROM PROJ
WHERE EXTRACT(year FROM START_DATE) = '2016'
GROUP BY EXTRACT(year FROM START_DATE), EXTRACT(month FROM START_DATE)
ORDER BY Month

===============================3===================================
SELECT GRADE, COUNT(*)
FROM SALGRADE, EMP
WHERE SAL >= LOSAL AND SAL <= HISAL
GROUP BY GRADE
HAVING COUNT(*) > 2
ORDER BY GRADE

===============================4===================================
SELECT ENAME
FROM EMP,PROJ_EMP
WHERE EMP.EMPNO = PROJ_EMP.EMPNO
AND ENAME != 'KING'
AND PROJ_EMP.PROJNO = 
    (SELECT PROJNO
    FROM EMP, PROJ_EMP
    WHERE EMP.EMPNO = PROJ_EMP.EMPNO
    AND ENAME = 'KING')



===============================5===================================
SELECT PNAME, BUDGET, COUNT(*)
FROM PROJ, PROJ_EMP
WHERE PROJ.PROJNO = PROJ_EMP.PROJNO
GROUP BY PNAME, BUDGET
HAVING COUNT(*) =
    (
    SELECT MAX(COUNT(*))
    FROM PROJ, PROJ_EMP
    WHERE PROJ.PROJNO = PROJ_EMP.PROJNO
    GROUP BY PNAME
    )
    
===============================6===================================
SELECT DNAME, LOC, SUM(SAL)
FROM DEPT,EMP
WHERE DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DNAME,LOC
HAVING SUM(SAL) = 
(
SELECT MAX(SUM(SAL))
FROM DEPT, EMP
WHERE DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DNAME
)

===============================7===================================
SELECT ENAME
FROM EMP e
WHERE NOT EXISTS
(
SELECT *
FROM PROJ, PROJ_EMP
WHERE PROJ.PROJNO = PROJ_EMP.PROJNO
AND e.EMPNO = PROJ_EMP.EMPNO
)

===============================8===================================
SELECT PNAME, ENAME, e.SAL
FROM EMP e, PROJ p, PROJ_EMP pe
WHERE p.PROJNO = pe.PROJNO
AND e.EMPNO = pe.EMPNO
AND e.SAL =
(
SELECT MAX(EMP.SAL)
FROM EMP,PROJ, PROJ_EMP
WHERE PROJ.PROJNO = PROJ_EMP.PROJNO
AND EMP.EMPNO = PROJ_EMP.EMPNO
AND PROJ.PROJNO = p.PROJNO
)

===============================9===================================
SELECT EXTRACT(year FROM END_DATE)as Year,EXTRACT(month FROM END_DATE) as Month, COUNT(*)
FROM PROJ e
GROUP BY EXTRACT(year FROM END_DATE),EXTRACT(month FROM END_DATE)
HAVING COUNT(*) =
(
SELECT MAX(COUNT(*))
FROM PROJ
WHERE EXTRACT(year FROM PROJ.END_DATE) = EXTRACT(year FROM e.END_DATE)
GROUP BY EXTRACT(month FROM PROJ.END_DATE)
)

===============================10===================================
SELECT e.DEPTNO, e.ENAME, COUNT(*)
FROM EMP e, PROJ_EMP pe
WHERE e.EMPNO = pe.EMPNO
GROUP BY e.DEPTNO, e.ENAME
HAVING COUNT(*) =
(
SELECT MAX(COUNT(*))
FROM EMP, PROJ_EMP
WHERE EMP.EMPNO = PROJ_EMP.EMPNO
AND EMP.DEPTNO = e.DEPTNO
GROUP BY ENAME
)
ORDER BY e.deptno
