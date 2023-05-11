/* 
 SELECT 기본 문법 및 연산자
 */
 
 -- EMPLOYEE 테이블의 모든 정보 조회
 -- EMPLOYEE에서 선택해서 모든 데이터를 가지고 온다
 -- 동작 순서 : FROM -> SELECT
SELECT --선택한다
             *
  FROM EMPLOYEE; --어디서 ? EMPLOYEE에서

-- 특정 컬럼을 조회
SELECT
            EMP_ID
          , EMP_NAME
  FROM EMPLOYEE;

-- 원하는 행을 조회
-- EMPLOYEE 테이블에서 부서코드가 D9 사원 조회
SELECT
              *
   FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9'; //WHERE -> 조건이 있을때 사용, 

-- EMPLOYEE 테이블에서 직급코드가 J1인 사원 조회
SELECT
              *
   FROM EMPLOYEE
 WHERE JOB_CODE = 'J1';

-- EMPLOYEE 테이블에서 급여가 300만원 이상인 사원의 
-- 사번, 이름, 부서코드, 급여를 조회하세요
SELECT
              EMP_ID
            , EMP_NAME
            , DEPT_CODE
            , SALARY
   FROM EMPLOYEE
 WHERE SALARY >= 3000000;

-- 컬럼에 별칭 짓기
-- AS + 별칭을 기술하여 별칭을 지을 수 있다.
-- 단, 숫자, 특수문자 등이 들어가는 별칭을 이용하는 경우 ""로 별칭을 감싸야 한다.
-- AS 생략 가능함
SELECT 
            EMP_NAME AS  이름
          , SALARY * 12 AS "1년 급여"
          , (SALARY + (SALARY * NVL(BONUS,0))) * 12 "보너스 포함 연봉"
  FROM EMPLOYEE;

-- 임의로 지정한 문자열을 SELECT절에서 사용할 수 있다.
SELECT 
            EMP_ID
          , EMP_NAME
          , SALARY
          , '원' AS 단위
   FROM EMPLOYEE;

-- DISTINCT 키워드는 SELECT 절에서 딱 한 번만 사용 가능하다
-- 여러 개 컬럼을 묶어서 중복을 제외시킨다.
SELECT
            DISTINCT JOB_CODE
          , DEPT_CODE
 FROM EMPLOYEE;

/* WHERE 절
테이블에서 조건을 만족하는 행을 골라낼 때 사용한다.
조건이 다중인 경우 AND 혹은 OR을 사용할 수 있다.
*/

-- 부서코드가 D6이고 급여를 200만원 보다 많이 받는 직원의
-- 이름(EMP_NAME), 부서코드 (EDPT_CODE), 급여(SALARY)를 조회한다.
SELECT -- 선택한다
              EMP_NAME
            , DEPT_CODE
            , SALARY
   FROM EMPLOYEE -- EMPLOYEE에서
 WHERE DEPT_CODE = 'D6' -- 어디서
      AND SALARY >2000000 ;

-- 보너스를 지급받지 않는 사원의 사번, 이름, 급여, 보너스를 조회한다.
SELECT
             EMP_ID
           , EMP_NAME
           , SALARY  
           , BONUS
   FROM EMPLOYEE
 WHERE BONUS IS NULL;

-- 보너스를 지급받는 사원을 조회한다
-- 조회 기준은 위와 동일하다.
SELECT
             EMP_ID
           , EMP_NAME
           , SALARY
           , BONUS
  FROM EMPLOYEE
-- WHERE BONUS IS NOT NULL; 이거랑 밑에랑 둘 다 가능
 WHERE NOT BONUS IS NULL;

-- 연결 연산자를 이용하여 여러 컬럼의 값을 하나의 컬럼의 값인 것 처럼 연결 할 수 있다. (||)
SELECT
             EMP_ID || EMP_NAME || SALARY AS "연결연산자" --연결 연산자가 컬럼의 별칭이다
  FROM EMPLOYEE;

-- 비교 연산자
-- = 같냐?, >크냐?, <작냐?, >= 크거나같냐?, <= 작거나같냐?
-- !=, ^=, <> 같지 않냐?

SELECT
             EMP_ID
           , EMP_NAME
           , DEPT_CODE
  FROM EMPLOYEE
-- WHERE DEPT_CODE<> 'D9'
-- WHERE DEPT_CODE != 'D9;
 WHERE DEPT_CODE ^= 'D9';
 
 -- EMPLOYEE 테이블에서 급여를 350만원 이상 550만원 이하를 받는
 -- 직원의 사번(EMP_ID), 이름(EMP_NAME), 부서코드(DEPT_CODE), 직급코드(JOB_CODE)를 조회하세요
 
 SELECT
              EMP_ID
            , EMP_NAME
            , DEPT_CODE
            , JOB_CODE
   FROM EMPLOYEE
 WHERE SALARY >= 3500000 AND SALARY <= 5500000;  
 
 -- BETWEEN AND 연산자
 -- 컬럼명 BETWEEN 하한값 AND 상한값  (BETWEEN은 범위, 시간 범위에 자주 사용함)
 -- 하한값 이상, 상한값 이하의 값
 SELECT
              EMP_ID
            , EMP_NAME
            , DEPT_CODE
            , JOB_CODE
   FROM EMPLOYEE
 WHERE SALARY BETWEEN 3500000 AND 5500000;
 
 -- LIKE 연산자 : 문자 패턴이 일치하는 값을 조회할 때 사용
 -- 컬럼명 LIKE : '문자패턴'
 --                    '문자%'    (문자로 시작하는 값)
 --                    '%문자%' (문자를 포함하는 값)
 --                    '%문자'    (문자로 끝나는 값)
 SELECT
              EMP_ID
            , EMP_NAME
            , HIRE_DATE
   FROM EMPLOYEE
 WHERE NOT EMP_NAME LIKE '김%';
 
 /* 와일드 카드 _*/
 SELECT
              EMP_ID
            , EMP_NAME
            , PHONE
   FROM EMPLOYEE
 WHERE PHONE LIKE '___9%'; --숫자중에 중간에 9가 들어가 있을때 조회 하고 싶으면 ___ 사용하기
 
 SELECT
              EMP_ID
            , EMP_NAME
            , EMAIL
   FROM EMPLOYEE
 WHERE EMAIL LIKE '___#_%' ESCAPE '#'; -- ESCAPE 문자는 식별하기 위해서 설정하는 것 #이 아니여도 되는데 통상적임 /가 이스케이프문
 
 -- IN 연산자 : 비교하려는 값 목록에 일치하는 값이 있는지 확인
 SELECT
              EMP_ID
            , DEPT_CODE
            , SALARY
   FROM EMPLOYEE
 WHERE DEPT_CODE IN ('D6', 'D8');
 
 /* 연산자 우선순위
 1. 산술 연산자
 2. 연결 연산자
 3. 비교연산자
 4. IS NULL / IS NOT NULL, LIKE/ NOT LIKE, IN / NOT IN
 5. BETWEEN AND / NOT BETWEEN AND
 6. NOT
 7. AND
 8. OR
 */