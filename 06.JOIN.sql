/* 조인(JOIN) : 굉장히 중요!!
JOIN : 두 개의 테이블을 하나로 합쳐서 결과를 조회한다

오라클 전용 구문
FROM절에 ','로 구분하여 사용할 테이블을 다 기술한다.
WHERE절 합치기에 사용할 컬럼을 이용하여 조건을 기술한다.

연결에 사용할 두 컬럼명이 다른 경우*/

-- EMPLOYEE 테이블, DEPARTMENT 테이블
SELECT
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , DEPT_TITLE
   FROM EMPLOYEE
      , DEPARTMENT
  WHERE DEPT_CODE = DEPT_ID;
  -- 이너조인 (공통된 자료만 가져온다)/ DEPT_CODE-> EMPLOYEE테이블 DEPT_ID->DEPARTMENT테이블에 있음 
  -- EMPLOYEE테이블이랑 DEPARTMENT테이블에 참조해서 매칭이 되는 애들을 가져와
  
  -- 연결에 사용할 두 컬럼명이 같은 경우 (두 개의 컬럼이 중복되는 경우)
  -- EMPLOYEE 테이블, JOB 테이블
  SELECT
         EMPLOYEE.EMP_ID,
         EMPLOYEE.EMP_NAME,
         EMPLOYEE.JOB_CODE,
         JOB.JOB_NAME
    FROM EMPLOYEE
       , JOB
   WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;


-- 테이블에 별칭 사용
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.JOB_CODE,
        J.JOB_NAME
   FROM EMPLOYEE E
      , JOB J
  WHERE E.JOB_CODE = J.JOB_CODE;
  
-- ANSI 표준 구문 (SQL구문, 중복되는 값을 확인 하려고 사용)
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명) 상관없음 안써도

-- FK외래키 참조 되는 값만 넣을 수 있다 
-- 별칭 없이 USING 사용가능, 조인 했을때 필드명이 같으면 USING으로 처리 가능
-- (JOB_CODE) 중복이여서 별칭 사용 안해도 됌
-- JOB_CODE 자체가 외래키,EM잡코드랑 JOB에 잡코드랑 동일
SELECT
        EMP_ID
      , EMP_NAME
      , JOB_CODE
      , JOB_NAME
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE);
   
-- 연결에 사용할 컬럼명이 다른 경우 ON()을 사용(SQL 공통적으로 사용되는 JOIN)
SELECT
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , DEPT_TITLE
   FROM EMPLOYEE
   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- ON(조건), 중요 가장 많이 쓰는 대표적인 조인

-- 컬럼명이 같은 경우에도 ON()을 사용할 수 있다
SELECT
        E.EMP_ID
      , E.EMP_NAME
      , E.JOB_CODE
      , J.JOB_NAME
   FROM EMPLOYEE E
   JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
-- 중요 가장 많이 쓰는 대표적인 조인 (위에 코드에서 쓰는 방법만 바뀐거)

-- 부서 테이블과 지역 테이블을 조인하여 테이블의 모든 데이터를 조회한다
-- ANSI 표준
/*
1. 부서 테이블(DEPARTMENT), 지역 테이블(LOCATION) 조인한다
1-1. 조인 조건 지역 코드가 같아야 된다 ON(D.LOCATION_ID = L.LOCAL_CODE)
2. 테이블의 모든 데이터 조회한다 *
*/
-- [ANSI 표준 구문법 사용]
SELECT
       D.*,
       L.*
  FROM DEPARTMENT D
  JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
-- [OARACLE 표준 구문법 사용]
SELECT
       D.*,
       L.*
  FROM DEPARTMENT D
      ,LOCATION L
 WHERE D.LOCATION_ID = L.LOCAL_CODE;
 
 /* 조인의 기본이 EQUAL JOIN이다 (EQU JOIN이라고도 한다. = 등가조인)
 일치하는 값이 없는 행은 조인에서 제외하는 것을 INNER JOIN이라고 한다.(NULL값은 조인에서 제외)
 
 JOIN의 기본은 INNER JOIN & EQUAL JOIN이다 (같은것만 조회해서 가져온다)
 OUTER JOIN : 두 테이블의 지정하는 컬럼 값이 일치하지 않는 행도(NULL 값을 가진행)
              조인 결과에 포함시킴 OUTER JOIN을 명시해야 한다
              
1. LEFT OUTER JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 행의 수를 기준으로 JOIN
2. RIGHT OUTER JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 행의 수를 기준으로 JOIN
3. FULL OUTER JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함시켜 JOIN*/
-- 일반적인 JOIN
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- LEFT OUTER JOIN
-- ANSI 표준
-- 조인을 기준으로 왼쪽이야? EMPLOYEE 오른쪽이야? DEPARTMENT
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
  
-- 오라클 전용
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
     , DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID(+);
 
-- RIGHT OUTER JOIN
-- ANSI
SELECT
        EMP_NAME
      , DEPT_TITLE
   FROM EMPLOYEE 
  RIGHT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 전용
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
     , DEPARTMENT
 WHERE DEPT_CODE(+) = DEPT_ID;
  
-- FULL OUTER JOIN
-- ANSI 구문
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  FULL OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 전용 구문으로는 FULL OUTER JOIN을 할 수 없음
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
 WHERE DEPARTMENT(+)= DEPT_ID(+); -- 에러 발생
 
-- CROSS JOIN : 카테이션 급 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방식 (직원이 없어도 있는걸로 조회)
-- 컬럼의 조회 수는 왼쪽 * 오른쪽
-- 잘 사용하지 않음 
-- ANSI 구문
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
 CROSS JOIN DEPARTMENT;
 --오라클 전용 구문
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
     , DEPARTMENT;
     
-- NON EQUAL JOIN(NON EQU JOIN - 비등가 조인)
-- : 지정한 컬럼의 값이 일치하는 경우가 아닌 값의 범위에 포함되는 행들을 연결하는 방식
-- ANSI
SELECT
       EMP_NAME
     , SALARY
     , E.SAL_LEVEL
     , S.SAL_LEVEL
  FROM EMPLOYEE E
  JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);
-- 오라클 전용
SELECT                                 
       EMP_NAME,
       SALARY,
       E.SAL_LEVEL,
       S.SAL_LEVEL
  FROM EMPLOYEE E
     , SAL_GRADE S
 WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

 -- SELF JOIN : 동일한 테이블을 조인하는 것 (자가조인)
 -- ANSI
 SELECT                       
        E1.EMP_ID
      , E1.EMP_NAME AS "사원이름"
      , E1.DEPT_CODE
      , E1.MANAGER_ID
      , E2.EMP_NAME AS "관리자 이름"
   FROM EMPLOYEE E1
   JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);
-- 오라클
  SELECT                            
        E1.EMP_ID
      , E1.EMP_NAME AS "사원이름"
      , E1.DEPT_CODE
      , E1.MANAGER_ID
      , E2.EMP_NAME AS "관리자 이름"
   FROM EMPLOYEE E1
      , EMPLOYEE E2
  WHERE E1.MANAGER_ID = E2.EMP_ID;
  
-- 다중 조인 : 여러 개 테이블 조인
-- ANSI
SELECT                    
         EMP_ID
       , EMP_NAME
       , DEPT_CODE
       , DEPT_TITLE
       , LOCAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--오라클
SELECT
        EMP_ID
      , EMP_NAME
      , DEPT_CODE
      , DEPT_TITLE
      , LOCAL_NAME
FROM EMPLOYEE
    , DEPARTMENT
    , LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;

/* 
문제1
직급이 대리이면서 아시아 지역에 근무하는 직원 조회
사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회
조회시에는 모든 컬럼에 테이블 별칭을 붙여서 조회한다

1. 직급이 대리(J.JOB_CODE -> J6)인사람 조회
2. 아시아 지역에 근무하는 직원 조회 (L.LOCATION L1,L2,L3)
3. 사번 (E.EMP_ID), 이름 (E,EMP_NAME), 직급명(E.JOB_CODE,J.JOB NAME), 
   부서명(E.DEPT_CODE) ,근무지역명(L.LOCAL_NAME), 급여(E.SARALY) 조회
4. 모든 컬럼에 테이블 별칭 붙여서 조회
*/
SELECT
       E.EMP_ID AS "사번" ,
       E.EMP_NAME AS "이름" ,
       J.JOB_NAME AS "직급명" ,
       D.DEPT_TITLE AS "부서명" ,
       L.LOCAL_NAME AS "근무지명" ,
       E.SALARY AS "급여"
  FROM EMPLOYEE E
  JOIN DEPARTMENT  D ON (E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON (J.JOB_CODE = E.JOB_CODE)
  JOIN LOCATION L ON ( D.LOCATION_ID = L.LOCAL_CODE)
 WHERE J.JOB_CODE ='J6' AND (L.LOCAL_CODE = 'L1' OR L.LOCAL_CODE = 'L2' OR L.LOCAL_CODE = 'L3');
