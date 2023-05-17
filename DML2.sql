-- DML (DATA MANUPULATION LANGUAGE)
-- INSETR, UPDATE, DELETE
-- : 데이터 조작 언어, 테이블에 데이터를 삽입하거나 수정하거나 삭제하는 언어

-- INSERT : 새로운 행을 추가하는 구문
--          테이블의 행 갯수가 증가한다

-- INSERT ALL : INSERT시에 사용하는 서브쿼리가 같은 경우 두 개 이상의 테이블에
--              INSERT ALL을 이용하여 한 번에 데이터를 삽입할 수 있다
--              단, 각 서브쿼리의 조건절이 같아야 한다 (찾아서 쓸 수 있을 정도로!)

-- [표현식]
-- 테이블의 일부 컬럼에 INSERT 할 때
-- INSERT INTO 테이블명 (컬럼명, 컬럼명,....) VALUES (데이터1, 데이터2,...);

-- 테이블의 모든 컬럼에 INSERT 할 때
-- INSERT INTO 테이블명 VALUES (데이터, 데이터,...);

-- 모든 컬럼에 INSERT 할 때도 컬럼명을 기술하는 것이 의미 파악에 좋다

SELECT * FROM EMPLOYEE ;

INSERT --(행 추가)
    INTO EMPLOYEE E(
    E.EMP_ID, E.EMP_NAME, E.EMP_NO, E.EMAIL, E.PHONE,
    E.DEPT_CODE, E.JOB_CODE, E.SAL_LEVEL, E.SALARY, E.BONUS,
    E.MANAGER_ID, E.HIRE_DATE, E.ENT_DATE
    )VALUES(
    '900', '장채현', '901123-232312', 'JANG@GMAIL.COM', '01023232323',
    'D1', 'J7', 'S3', 4300000, 0.2, '200', SYSDATE, NULL
    );
    
ROLLBACK;
SELECT * FROM EMPLOYEE;
COMMIT ;

-- INSERT시 VALUES  대신 서브쿼리를 이용할 수 있다 
CREATE TABLE EMP_01( 
 EMP_ID NUMBER,
 EMP_NAME VARCHAR2(30),
 DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

INSERT
  INTO EMP_01 D
  (
  D.EMP_ID,
  D.EMP_NAME,
  D.DEPT_TITLE
  )(
    SELECT E.EMP_ID, --조회된 수 만큼 실행 (여기서 리턴되는 열 수가 위에 D랑 맵핑이 되야 함)
           E.EMP_NAME,
           D.DEPT_TITLE
      FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    );  
    
SELECT * FROM EMP_01;

-- CREATE TABLE AS SELECT
-- SELECT 문장을 이용하여 다른 테이블에 있는 데이터를 복사하여 새로운 테이블을 생성한다
-- [표현식] : CREATE TABLE [테이블명] AS [서브쿼리];

CREATE TABLE EMP_DEPT_01 --필드 정의하고 값을 넣어줌
AS
SELECT E.EMP_ID,
       E.EMP_NAME,
       E.DEPT_CODE,
       E.HIRE_DATE
  FROM EMPLOYEE E
 WHERE 1 = 0;

 SELECT * FROM EMP_DEPT_01;
 
CREATE TABLE EMP_MANAGER
AS
SELECT E.EMP_ID,
       E.EMP_NAME,
       E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE 1 = 0; 
 --조건절에 동적쿼리 때문에 사용, 1=0 FALSE라서 입력 값이 안들어가고 1=1이면 TRUE라서 값이 들어간다 
 
 SELECT * FROM EMP_MANAGER;
 
 CREATE TABLE EMP_MANAGER2
AS
SELECT E.EMP_ID,
       E.EMP_NAME,
       E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE 1 = 1; 
 
 SELECT * FROM EMP_MANAGER2;
 


 /*
 EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의
 사번, 이름, 입사일, 급여를 조회하여 EMP_OLD 테이블에 삽입하고
 그 이후에 입사한 사원은 EMP_NEW 테이블에 삽입하세요
 
 1. EMPLOYEE 테이블 조회
 2. 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원 조회하기
 3. 사번, 이름, 입사일, 급여를 조회하기
 4. EMP_OLD 테이블 삽입하기
 5. 2000년 1월 1일 이후에 입사한 사원은 EMP_NEW 삽입
 */ 

 CREATE TABLE EMP_OLD
 AS
 SELECT E.EMP_ID,
        E.EMP_NAME,
        E.HIRE_DATE,
        E.SALARY
   FROM EMPLOYEE E
  WHERE 1=0;
  
SELECT * FROM EMP_OLD;

CREATE TABLE EMP_NEW
AS
 SELECT E.EMP_ID,
        E.EMP_NAME,
        E.HIRE_DATE,
        E.SALARY
   FROM EMPLOYEE E
  WHERE 1=0;

SELECT * FROM EMP_NEW;

INSERT ALL
   WHEN HIRE_DATE < '2000/01/01'
   THEN
   INTO EMP_OLD
  VALUES(
       EMP_ID, EMP_NAME, HIRE_DATE, SALARY
  )
   WHEN HIRE_DATE >= '2000/01/01'
   THEN
   INTO EMP_NEW
  VALUES(
        EMP_ID, EMP_NAME, HIRE_DATE, SALARY
  )SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.HIRE_DATE,
        E.SALARY
   FROM EMPLOYEE E;
   
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;