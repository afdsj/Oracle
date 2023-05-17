-- SUBQUERY (서브쿼리)
-- 사원명이 노옹철인 사람의 부서 조회
SELECT
        E.DEPT_CODE
   FROM EMPLOYEE E
  WHERE E.EMP_NAME = '노옹철';
  
-- 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회 
-- JOIN을 이용해서 문제를 접근하려고 했으나 문제가 발생됨 ( 문제 : 이름이 3번씩 나옴)
SELECT
        E.DEPT_CODE,
        E2.EMP_NAME
   FROM EMPLOYEE E
   JOIN EMPLOYEE E2 ON (E.DEPT_CODE = E2.DEPT_CODE)
  WHERE E.DEPT_CODE = 'D9';
  
-- 이를 해결하고자 서브 쿼리를 이용함 (중복값 제거)
SELECT
        E.EMP_NAME
   FROM EMPLOYEE E
  WHERE E.DEPT_CODE = (SELECT E2. DEPT_CODE
                         FROM EMPLOYEE E2
                        WHERE E2.EMP_NAME = '노옹철');
                        
/*
전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 
사번, 이름, 직급코드, 급여를 조회하세요 

1. 전 직원의 급여를 조회한다 SELECT EMPLOYEE (SUBQUERY)
2. 급여 평균을 구한다 AVG(SALARY) (SUBQUERY)
3. 평균보다 많은 급여를 받는 직원을 조회한다 WHERE E.SALARY > (1~2 조건)
4. 사번, 이름, 직급코드, 급여를 조회한다 SELECT
*/ -- 단일행
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.JOB_CODE,
        E.SALARY
   FROM EMPLOYEE E
  WHERE E.SALARY > ( SELECT
                            FLOOR(AVG(E2.SALARY))
                       FROM EMPLOYEE E2
                    );
                    
-- 서브쿼리의 유형 (= 스칼라 서브쿼리)
-- 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다르다
/*단일행 서브쿼리 : 쿼리 결과가 단일행만을 반환하는 서브쿼리
단일행 서브쿼리 앞에는 일반 비교 연산자 사용 가능
>, <, >=, <=, =, !=/<>/^= */
/* 다중행 서브쿼리 : 쿼리 결과가 다중행을 반환하는 서브쿼리 */
/* 다중열 서크쿼리 : 쿼리 결과가 다중 컬럼을 반환하는 서브쿼리 */
/* 다중행 다중열 서브쿼리 */

/* 문제1 
노옹철 사원의 급여보다 많은 급여를 받는 직원의
사번, 이름, 부서, 직급, 급여를 조회하세요

1. 노옹철 사원 급여 조회 SALARY (서브쿼리)
2. 노옹철 사원보다 급여를 많이 받는 직원 조회 노옹철 < SALARY (서브쿼리)
3. 사번, 이름, 부서, 직급, 급여 조회*/
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.DEPT_CODE,
        E.JOB_CODE,
        E.SALARY
   FROM EMPLOYEE E 
  WHERE E.SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

*/
-- 서브쿼리는 SELECT, FROM, WHERE,ORDER BY절에서 사용이 가능하다
-- 부서별 급여의 합계 중 가장 큰 부서의 부서명 급여 합계를 구한다
SELECT
        D.DEPT_TITLE,
        SUM(E.SALARY)
   FROM EMPLOYEE E
   LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  GROUP BY D.DEPT_TITLE --부서 이름을 기준으로 그룹을 묶어줘
 HAVING SUM(E.SALARY) = (SELECT MAX(SUM(E2.SALARY)) 
                           FROM EMPLOYEE E2
                          GROUP BY DEPT_CODE);
/* 문제2
대리 직급의 직원들 중 과장 직급의 최소 급여보다 많이 받는 직원의
사번, 이름, 직급명, 급여를 조회하세요
1. 대리들의 급여 조회 
2. 과장 직급 최소 급여 조회
   대리들의 급여 > 과장 최소 급여
*/
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        J.JOB_NAME,
        E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE J.JOB_NAME = '대리'
    AND E.SALARY > ANY(SELECT --ANY 최소값
                             SALARY
                        FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                       WHERE JOB_NAME = '과장');
/*문제
차장 직급 급여의 가장 큰 값보다 많이 받는 과장 직급의
사번, 이름, 직급, 급여를 조회한다
단, >ALL 혹은 <ALL 연산자를 이용한다
*/
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        J.JOB_NAME,
        E.SALARY
   FROM EMPLOYEE E
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  WHERE J.JOB_NAME = '과장'
    AND E.SALARY > ALL (SELECT  --ALL을 사용하면 가장 큰거를 가져온다
                                E2.SALARY
                           FROM EMPLOYEE E2 
                           JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                          WHERE J2.JOB_NAME = '차장'
                           );
                           
-- EXISTS 값이 존재하면 모든 값을 가지고온다                          
SELECT 
        E.*
   FROM EMPLOYEE E
  WHERE EXISTS (SELECT 
                        E2.*
                   FROM EMPLOYEE E2
                  WHERE E2.EMP_ID = '200');

/*
자기 직급(직급 전체)의 평균 급여를 받고 있는 직원의
사번, 이름, 직급코드, 급여를 조회한다
단, 급여와 평균은 만원단위로 계산한다 (TRUNC(컬럼명,-5)

1. 직급 평균 급여 계산하기 AVG(SALARY)
2. 평균 급여를 받고 있는 직원 조회
3. 조건! 급여와 평균은 만원단위로 계산
*/
--1번 평균 급여
SELECT
        E2.JOB_CODE
        TRUNC(AVG(E2.SALARY),-5)
   FROM EMPLOYEE E2
  GROUP BY E2.JOB_CODE);
-- 2번, 3번(WHERE절)                 
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.JOB_CODE,
        E.SALARY
   FROM EMPLOYEE E
  WHERE E.SALARY IN(SELECT
                           TRUNC(AVG(E2.SALARY),-5)
                      FROM EMPLOYEE E2
                     GROUP BY E2.JOB_CODE);
/*문제
퇴사한 여직원과 같은 부서, 같은 직급에 해당되는 사원의
이름, 직급, 부서코드, 입사일 조회

1. 퇴사한 여직원(재직여부, 성별 여부)
2. 퇴사한 여직원 부서, 직급
3. 사원에 대한 정보 조회
*/ -- 다중열
-- 1번
SELECT
        E2.DEPT_CODE,
        E2.JOB_CODE
   FROM EMPLOYEE E2
  WHERE SUBSTR(E2.EMP_NO, 8,1) = '2'
    AND E2.ENT_YN = 'Y';
-- 2번
SELECT
        E.EMP_NAME,
        E.JOB_CODE,
        E.DEPT_CODE,
        E.HIRE_DATE
   FROM EMPLOYEE E
  WHERE (E.DEPT_CODE, E.JOB_CODE) IN(
                                       SELECT
                                              E2.DEPT_CODE,
                                              E2.JOB_CODE
                                         FROM EMPLOYEE E2
                                        WHERE SUBSTR(E2.EMP_NO, 8,1) = '2'
                                          AND E2.ENT_YN = 'Y'
                                     )
   AND E.ENT_YN = 'N';

/* 인라인 뷰 : 뷰 형태로 테이블을 반환하는 서브쿼리 
   FROM절에 서브쿼리를 사용할 수 있다
   가상의 테이블*/
-- 직급별 급여가 평균 급여랑 같은 직원들을 조회해줘!
SELECT 
        E.EMP_NAME,
        J.JOB_NAME,
        E.SALARY
   FROM (SELECT E2.JOB_CODE
              , TRUNC(AVG(E2.SALARY), -5) AS JOBAVG
           FROM EMPLOYEE E2
          GROUP BY E2.JOB_CODE) V
   JOIN EMPLOYEE E ON(V.JOBAVG = E.SALARY AND E.JOB_CODE = V.JOB_CODE) -- 직급별 급여 평균을 알 수 있음
   JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE) -- 직급을 알 수 있음(J.JOB_NAME)
  ORDER BY J.JOB_NAME;
  
-- 위에 FROM절 안에 있는 인라인뷰를 분리해서 따로 작성
SELECT
        V.JOBAVG
   FROM (SELECT E2.JOB_CODE
              , TRUNC(AVG(E2.SALARY), -5) AS JOBAVG
           FROM EMPLOYEE E2
          GROUP BY E2.JOB_CODE) V;
          
SELECT -- 가상의 테이블
        V.직원명, -- 컬럼에 접근
        V.부서명,
        V.직급이름
   FROM (SELECT 
                EMP_NAME 직원명,
                DEPT_TITLE AS "부서명",
                JOB_NAME AS "직급이름"
           FROM EMPLOYEE E
           LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
           JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
         ) V
   WHERE V.부서명 = '인사관리부'; 
-- 인라인뷰를 활용한 TOP-N분석
SELECT
        ROWNUM, -- 가상의 컬럼
        E.EMP_NAME,
        E.SALARY
   FROM EMPLOYEE E
  ORDER BY ROWNUM ASC;
        
SELECT
        ROWNUM, --컬럼에 인덱스
        V.EMP_NAME,
        V.SALARY
   FROM (SELECT E.*
           FROM EMPLOYEFE E
          ORDER BY E.SALARY DESC) V
   WHERE ROWNUM <= 5;

SELECT
        V2.RNUM,
        V2.EMP_NAME,
        V2.SALARY
  FROM (SELECT ROWNUM RNUM, --인라인뷰 가상의 테이블 만들었음
               V.EMP_NAME,
               V.SALARY
          FROM (SELECT E.EMP_NAME, -- 인라인뷰 가상의 테이블 만들었음
                       E.SALARY
                  FROM EMPLOYEE E
                 ORDER BY E.SALARY DESC) V
        ) V2
  WHERE RNUM BETWEEN 6 AND 10;
  
/*문제
급여 평균 3위안에 드는 부서의 부서코드, 부서명, 평균급여를 조회하세요

1. 급여 평균 구하기 E.SALARY 
2. 3위 안에 드는 부서 조회하기 E.DEPT_CODE 
3. 부서코드, 부서명 ,평균급여 조회하기*/
  
SELECT
        V.DEPT_CODE,
        V.DEPT_TITLE,
        V.평균급여
   FROM (SELECT
                E.DEPT_CODE,
                D.DEPT_TITLE,
                AVG(SALARY) 평균급여
           FROM EMPLOYEE E
           JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
          GROUP BY E.DEPT_CODE, D.DEPT_TITLE
          ORDER BY AVG(E.SALARY) DESC
        )V
  WHERE ROWNUM <= 3;
-- 위에랑 다른 방식으로 풀기
-- 1. 부서별 평균 급여 구하기
SELECT
        DEPT_CODE,
        AVG(SALARY)
   FROM EMPLOYEE
  WHERE ROWNUM <= 3
  GROUP BY DEPT_CODE
  ORDER BY AVG(SALARY) DESC;
-- 2. 평균3위에 있는 부서 구하기
SELECT                                           
        V.DEPT_CODE,
        D.DEPT_TITLE,
        V.평균급여
     FROM (SELECT
                DEPT_CODE,
                AVG(SALARY) 평균급여
           FROM EMPLOYEE 
          GROUP BY DEPT_CODE
          ORDER BY AVG(SALARY) DESC
         )V 
    JOIN  DEPARTMENT D ON(V.DEPT_CODE = D.DEPT_ID)
 WHERE ROWNUM <=3;

-- RANK() : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰고 순위를 계산하는 방식
-- DENSE_RANK() : 중복되는 순위 이후의 등수를 이후 등수로 처리하는 방식
-- 19번 동일
SELECT
        E.EMP_NAME,
        E.SALARY,
        RANK() OVER (ORDER BY SALARY DESC) 순위
   FROM EMPLOYEE E;
-- 19번 동일한 숫자 나온 다음에 20번째부터 시작
SELECT
        E.EMP_NAME,
        E.SALARY,
        DENSE_RANK() OVER(ORDER BY E.SALARY DESC) 순위
   FROM EMPLOYEE E;
-- 10~19사이의 순위만 나오기
SELECT
        V.*
  FROM (SELECT 
               E.EMP_NAME,
               E.SALARY,
               RANK() OVER(ORDER BY E.SALARY DESC) 순위
          FROM EMPLOYEE E) V
  WHERE V.순위 BETWEEN 10 AND 19;
  
-- 상[호연]관 서브쿼리
-- 메인쿼리의 값이 변경되는거에 따라 서브쿼리에 영향을 미치고
-- 서브쿼리가 만들어진 값을 메인쿼리가 사용하는 상호 연관되어 있는 서브쿼리
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.DEPT_CODE,
        E.MANAGER_ID
   FROM EMPLOYEE E
  WHERE EXISTS (SELECT 
                        E2.EMP_ID
                   FROM EMPLOYEE E2
                  WHERE E.MANAGER_ID = E2.EMP_ID);
-- 스칼라 서브쿼리
-- 단일행 서브쿼리 + 상관쿼리

-- 동일한 직급의 평균 급여보다 급여를 많이 받고 있는 직원의 정보 조회
SELECT
        E.EMP_NAME,
        E.JOB_CODE,
        E.SALARY
   FROM EMPLOYEE E
  WHERE E.SALARY > (SELECT TRUNC(AVG(E2.SALARY),-5)
                      FROM EMPLOYEE E2
                     WHERE E.JOB_CODE = E2.JOB_CODE);
-- SELECT절에서 스칼라 서브쿼리 이용
-- 모든 사원의 사번, 이름, 관리자사번, 관리자명 조회
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.MANAGER_ID,
        NVL((SELECT E2.EMP_NAME
               FROM EMPLOYEE E2
              WHERE E.MANAGER_ID = E2.EMP_ID), '없음') AS 관리자명
  FROM EMPLOYEE E
 ORDER BY 1;

/*ORDER BY절에서 스칼라 서브쿼리 이용
모든 직원의 사번, 이름, 소속부서 조회
단 부서명 내림차순 정렬

1 모든 직원의 사번, 이름, 소속부서 조회
2. 부서명은 내림차순 정렬
3. ORDER BY절에서 서브쿼리 이용
*/
SELECT
        E.EMP_ID,
        E.EMP_NAME,
        E.DEPT_CODE
   FROM EMPLOYEE E
  ORDER BY (SELECT 
                   D.DEPT_TITLE
              FROM DEPARTMENT D
             WHERE E.DEPT_CODE = D.DEPT_ID) DESC;
/* ORDER BY절에서 스칼라 서브쿼리 이용
모든 직원의 사번, 이름, 소속부서 조회
단 부서지역명 내림차순 정렬

1. 모든 직원의 사번,이름,소속부서 조회
2. 조건1)ORDER BY절에서 스칼라 서브쿼리 이용 
3. 조건2)부서지역명 내림차순 정렬
*/

SELECT
        E.EMP_ID,
        E.EMP_NAME,
        D.DEPT_TITLE
   FROM EMPLOYEE E
   JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  ORDER BY (SELECT
                   L.LOCAL_NAME
              FROM LOCATION L
             WHERE L.LOCAL_CODE = D.LOCATION_ID) DESC;

/*회사에서 매니저 활동중인 직원들에게 추가 보너스 0.5%를 지급하고자 한다
조회는 다음과 같다.
1. 사원 아이디
2. 사원 이름
3. 관리 직원수
4. 인상된 보너스
단 관리직원이 없는 직원은 제외된다
정렬은 관리직원이 많은 순서로 정렬한다
*/
SELECT
        V.EMP_ID,
        V.EMP_NAME,
        V.관리직원수,
        V."인상된 보너스"
   FROM (SELECT --가상의 테이블 생성
                E.EMP_ID,
                E.EMP_NAME,
                (SELECT COUNT(*) -- 서브쿼리 생성 
                   FROM EMPLOYEE E2
                  WHERE E.EMP_ID = E2.MANAGER_ID) AS "관리직원수",
                NVL((E.BONUS + 0.5), 0.5) AS "인상된 보너스"
           FROM EMPLOYEE E) V
   WHERE 관리직원수 > 0
   ORDER BY 관리직원수 DESC;