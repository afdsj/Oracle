-- 그룹함수와 단일행 함수
-- 단일행 함수 (single row function) : n개의 값을 넣어서 n개의 결과를 리턴
-- 그룹 함수 (group function) : n개의 값을 넣어 1개의 결과를 리턴

-- 그룹 함수 : sum, avg, max, min, count
-- sum(숫자) : 합계를 구하여 리턴
SELECT  
             SUM (SALARY)
   FROM EMPLOYEE;
   
-- AVG(숫자) : 평균 구하기
SELECT
              AVG (SALARY)
   FROM EMPLOYEE;
   
-- MIN(숫자 | 문자 | 날짜) :  가장 작은 값 리턴
SELECT
              MIN (EMAIL) 
            , MIN (HIRE_DATE)
            , MIN (SALARY)
   FROM EMPLOYEE;

-- CONUT(* | 컬럼명)  (모든 필드의 값을 찾을거냐
-- CONUT(*) : 모든 행의 수 리턴
-- CONUT(컬럼명) : NULL을 제외한 실제 값이 기록된 행의 수 리턴 (중복된 값을 제외하고 찾을거냐)
SELECT
              COUNT (*) 
            , COUNT (DEPT_CODE) 
            , COUNT (DISTINCT DEPT_CODE) 
    FROM EMPLOYEE; 
    
-- 단일행 함수
-- 문자 관련 함수
-- : LENGTH, LENGTHB, SUBSTR, UPPER, LOWER, INSTR

-- LENGTH : 문자 길이, LENGTHB :  바이트 길이; 1바이트당 한글자
-- DUAL : DUMMY TABLE 실험할때 사용 ?
SELECT
             LENGTH ('오라클')  
           , LENGTHB ('오라클') 
   FROM DUAL;
   
SELECT
             LENGTH (EMAIL)
           , LENGTHB (EMAIL)
   FROM EMPLOYEE;
   
-- INSTR ('문자열' | 컬럼명, '문자열', 찾을 위치의 시작값, [빈도])
-- (-)일경우는 역순으로 세기
-- 빈도는 몇개가 들어가는지 확인
SELECT INSTR ('AAABBACAABBAA', 'B') FROM DUAL;
SELECT INSTR ('AAABBACAABBAA', 'B', 1) FROM DUAL;
SELECT INSTR ('AAABBACAABBAA', 'B', -1) FROM DUAL; 
SELECT INSTR ('AAABBACAABBAA', 'B', 1, 4) FROM DUAL;
             
SELECT
             EMAIL
           , INSTR (EMAIL, '@', -1) 위치
   FROM EMPLOYEE;
   
-- INSTR 문자의 위치를 반환 0보다 크다는건 성이 '하'인 사람을 찾는거
SELECT
              EMP_NAME
   FROM EMPLOYEE
 WHERE INSTR (EMP_NAME, '하') > 0;
 
-- LPAD 값이 비어있을 경우 왼쪽부터 #으로 채워준다
SELECT
              LPAD (EMAIL, 20, '#') 
   FROM EMPLOYEE;
--RPAD 값이 비어있을 경우 오른쪽부터 #으로 채워준다
SELECT
              RPAD (EMAIL, 20, '#')
   FROM EMPLOYEE;
   
SELECT
              LPAD (EMAIL, 10, '#')
   FROM EMPLOYEE;
   
SELECT
              RPAD (EMAIL, 10, '#')
   FROM EMPLOYEE;

-- LTRIM / RTRIM : 주어진 컬럼이나 문자열 왼쪽 / 오른쪽에서 지정한 문자를 제거한 나머지를 반환
SELECT  '           GREEDY' FROM DUAL;
SELECT LTRIM ('     GREEDY', ' ') FROM DUAL;
SELECT LTRIM ('0000GREEDY', '0') FROM DUAL;
SELECT LTRIM ('12341234GREEDY', '123') FROM DUAL;
SELECT LTRIM ('ABCabGREEDY', 'ABC') FROM DUAL;
SELECT LTRIM ('34234GREEDY', '0123456789') FROM DUAL;

SELECT 'GREEDY0000'  FROM DUAL;
SELECT RTRIM('GREEDY0000', '0')  FROM DUAL;

SELECT
             EMP_ID
           , EMP_NAME
   FROM EMPLOYEE
 WHERE EMP_NAME = RTRIM ('선동일 ');

-- TRIM : 주어진 컬럼이나 문자열 앞/뒤에 지정한 문자를 제거
SELECT TRIM('       GREEDY      ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZZGREEDYZZZ') FROM DUAL;
SELECT TRIM(LEADING 'Z' FROM 'ZZZZGREEDYZZZ') FROM DUAL;
SELECT TRIM(TRAILING 'Z' FROM 'ZZZZGREEDYZZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZZGREEDYZZZ') FROM DUAL;

-- SUBSTR : 컬럼이나 문자열에서 지정한 위치로부터 지정한 갯수의 문자열을 잘라서 리턴
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

 --SUBSTR 는 문자 쪼개기 -1을 써줘야지 출력 될 때 @가 포함 안된다
 SELECT
              EMP_NAME
            , EMAIL
            , SUBSTR (EMAIL, 1, INSTR (EMAIL, '@')-1) 
   FROM EMPLOYEE;

-- 여직원의 이름, 주민번호 조회
SELECT
             EMP_NAME
           , EMP_NO
   FROM EMPLOYEE
 WHERE SUBSTR (EMP_NO, 8, 1) IN ('2', '4');
 
 --  EMPLOYEE 테이블에서 직원의 주민번호를 조회하여 
 -- 사원명(EMP_NAME), 생년(EMP_NO), 생월(EMP_NO), 생일(EMP_NO)을 각각 분리하여 조회
 -- 단 컬럼명의 별칭은 사원명, 생년, 생월, 생일로 구분한다.
 -- 완료시 남사원의 정보만 표현하도록 수정한다.
 /* 
1. EMPLOYEE 테이블에서 조회하기 - FROM EMPLOYEE
2. 사원명, 생년, 생월, 생일 각각 분리하여 조회 - SELECT
3. 컬럼의 별칭은 사원명 ,생년, 생월, 생일 구분 - SELECT AS ' '
4. 남사원의 정보만 표현한다. - WHERE
*/
 SELECT
             EMP_NAME AS 사원명
           , SUBSTR (EMP_NO, 1, 2) AS  생년
           , SUBSTR (EMP_NO, 3, 2) AS  생월
           , SUBSTR (EMP_NO, 5, 2) AS  생일
   FROM EMPLOYEE
 WHERE  SUBSTR (EMP_NO, 8,1) IN ('1','3');
 
 /*
  서브쿼리 (스칼라 쿼리)
 (SELECT AVG (SALARY) FROM EMPLOYEE) -> EMPLOYEE에서 SALARY 평균을 낸 값이
 SALARY 보다 작거나 같은 사람만 출력
 */
 SELECT
              EMP_ID
            , EMP_NAME
            , SALARY
   FROM EMPLOYEE
 WHERE SALARY >= (SELECT AVG (SALARY) FROM EMPLOYEE) ;
 
/*
 문제
 EMPLOYEE 테이블에서 사원명, 주민번호 조회
 단, 주민번호는 생년월일만 보이게 하고 -다음 값은 *로 변경하여 출력한다.
 컬럼명은 사원명, 주민번호로 변경한다.
 분석
 1. EMPLOYEE 테이블에서 조회하기 - FROM EMPLOYEE
 2. 사원명, 주민번호 - SELECT 컬럼 (필드)
 3. 주민번호는 생년월일만 보이고 -> SUBSTR 
     나머지 값은 *로 출력 - SELECT  ->RPAD말고 ||도 사용 가능하고 다른 문법들도 가능 함'
 4. 컬럼명은 사원명, 주민번호로 변경 - SELECT 별칭
 
 SUBSTR(EMP_NO, 1,7) -> 문자열
 */
 SELECT
              EMP_NAME AS 사원명
            , RPAD (SUBSTR(EMP_NO, 1,7) , 14,  '*')  AS  주민번호
   FROM EMPLOYEE;
/*
SELECT
            EMP_NAME AS 사원명
          , SUBSTR(EMP_NO,1,7) || '*******' AS 주민번호
  FROM EMPLOYEE;  이렇게도 가능
*/

-- LOWERT / UPPER / INITCAP : 대소문자 변경해주는 함수
SELECT LOWER ('Welcome to My World') FROM DUAL;
SELECT UPPER ('Welcome to My World') FROM DUAL;
SELECT INITCAP ('Welcome to My World') FROM DUAL;

-- CONCAT  : 문자열 두 개를 하나의 문자열로 합친 후 리턴
SELECT CONCAT ('가나다라', 'ABCD') FROM DUAL;
SELECT '가나다라' || 'ABCD' FROM DUAL;
 
 --REPLACE : 컬럼 혹은 문자열을 입력받아 변경하고자 하는 문자열을 변경하려고 하는 문자열로 바꾼 후 리턴
SELECT REPLACE('서울시 강남구 역삼동','역삼동','삼성동') FROM DUAL;
    
-- 숫자 처리 함수 : ABS, MOD, ROUND FLOOR, TRUNC, CELL

-- ABS (숫자 | 컬럼) : 절대값 구하는 함수
SELECT
            ABS (-10)
          , ABS (10)
 FROM DUAL;
 
-- MOD(숫자, 숫자) : 두 수를 나누어서 나머지를 구하는 함수 (자바 %함수)
--                            첫 번째 인자는 나누어지는 수 두 번째 인자는 나눌 수 
SELECT
            MOD (10,5)
          , MOD (10,3)
  FROM DUAL;
  
-- 사번이 짝수인 직원의 사번, 이름, 급여, 부서코드 조회
SELECT
             EMP_ID
           , EMP_NAME
           , SALARY
           , DEPT_CODE
   FROM EMPLOYEE
 WHERE MOD (EMP_ID, 2) = 0;
 
-- FLOOR (숫자) : 내림처리를 한 정수를 반환하는 정수
SELECT FLOOR (123.785) FROM DUAL;

-- TRUNC (숫자, [위치]) : 내림처리(절삭) 함수
-- 양수면 .을 기준으로 앞으로 음수면 .을 기준으로 뒤로
SELECT TRUNC (123.456) FROM DUAL;
SELECT TRUNC (123.456, 1) FROM DUAL;
SELECT TRUNC (123.456, -1) FROM DUAL;
SELECT TRUNC (123.756) FROM DUAL;

-- CELL(숫자) : 올림처리 함수
SELECT CEIL (1234.456) FROM DUAL;

SELECT
             ROUND (1234.2324)
           , ROUND (1234.2324)
           , ROUND (1234.2324)
           , CEIL (1234.2324)
   FROM DUAL;