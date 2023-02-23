
DROP TABLE EMP cascade CONSTRAINTS;
DROP TABLE DEPT cascade CONSTRAINTS;
DROP TABLE SALGRADE cascade CONSTRAINTS;


CREATE TABLE DEPT (
 DEPTNO              NUMBER(2) NOT NULL,
 DNAME               VARCHAR2(14),
 LOC                 VARCHAR2(13),
 CONSTRAINT DEPT_PRIMARY_KEY PRIMARY KEY (DEPTNO));

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) NOT NULL,
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) CONSTRAINT EMP_SELF_KEY REFERENCES EMP (EMPNO),
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) NOT NULL,
 CONSTRAINT EMP_FOREIGN_KEY FOREIGN KEY (DEPTNO) REFERENCES DEPT (DEPTNO),
 CONSTRAINT EMP_PRIMARY_KEY PRIMARY KEY (EMPNO));

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,TO_DATE('17-11-1981','DD-MM-YYYY'), 5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,TO_DATE('1-05-1981','DD-MM-YYYY'), 2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,TO_DATE('9-06-1981','DD-MM-YYYY'), 2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,TO_DATE('2-04-1981','DD-MM-YYYY'), 2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,TO_DATE('28-10-1981','DD-MM-YYYY'), 1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,TO_DATE('20-02-1981','DD-MM-YYYY'), 1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,TO_DATE('8-10-1981','DD-MM-YYYY'), 1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,TO_DATE('3-12-1981','DD-MM-YYYY') ,950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,TO_DATE('22-02-1981','DD-MM-YYYY'), 1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,TO_DATE('3-12-1981','DD-MM-YYYY'), 3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,TO_DATE('17-12-1980','DD-MM-YYYY'), 800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,TO_DATE('09-12-1982','DD-MM-YYYY'), 3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,TO_DATE('12-01-1983','DD-MM-YYYY'), 1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,TO_DATE('23-01-1982','DD-MM-YYYY'), 1300,NULL,10);


CREATE TABLE SALGRADE (
 GRADE               NUMBER,
 LOSAL               NUMBER,
 HISAL               NUMBER);

INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-RRRR';

DROP TABLE PROJ_EMP cascade CONSTRAINTS;
DROP TABLE PROJ cascade CONSTRAINTS;


CREATE TABLE PROJ
   (PROJNO NUMBER(2,0) PRIMARY KEY, 
	 PNAME VARCHAR2(14 BYTE), 
	 BUDGET NUMBER(10,2), 
	 START_DATE DATE, 
	 END_DATE DATE
   ) ;
Insert into PROJ  values (1,'PROJECT1',15000,'01-10-2016','31-10-2016');
Insert into PROJ  values (2,'PROJECT2',23000,'15-10-2016','30-11-2016');
Insert into PROJ  values (3,'PROJECT3',48000,'15-11-2016','31-12-2016');
Insert into PROJ  values (4,'PROJECT4',21000,'10-12-2016','20-12-2016');
--------------------------------------------------------

CREATE TABLE PROJ_EMP
   (PROJNO NUMBER(2) NOT NULL CONSTRAINT PROJ_PROJEMP_KEY REFERENCES PROJ (PROJNO), 
    EMPNO  NUMBER(4) NOT NULL CONSTRAINT EMP_PROJEMP_KEY REFERENCES EMP (EMPNO),
    CONSTRAINT PROJ_EMP_PRIMARY_KEY PRIMARY KEY (PROJNO,EMPNO) 
   );

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

Insert into PROJ  values (5,'PROJECT5',24000,'10-10-2017','29-12-2017');
Insert into PROJ_EMP values(5,7369);
Insert into PROJ_EMP values(5,7788);
Insert into PROJ_EMP values(5,7876);


COMMIT;



