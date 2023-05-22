/* 인덱스 (INDEX)
   SQL 명령문의 검색 처리 속도를 향상시키기 위해 컬럼에 대해서 생성하는 오라클 객체이다.
   하드디스크의 어느 위치 인지에 대한 정보를 가진 주소로
   DATA - ROWID로 구성
   
   인덱스의 내부 구조는 이진트리 형식으로 구성되어 있고
   인덱스를 생성하기 위해서는 사간이 필요하다
   또한 인덱스를 위한 추가 저장공간이 필요하기 때문에 반드시 좋은 것은 아니다
   인덱스가 생성된 컬럼에 DML(데이터 조작 언어) 작업이 빈번한 경우 처리속도가 느려진다
   따라서 일반적으로 테이블 전체 로우 수의 15% 이하의 데이터를 조회할 때 인덱스를 생성
   
   장점
   검색 속도가 빨라짐
   시스텡메 걸리는 부하를 줄여서 시스템 전체의 성능을 향상시킴
   
   단점
   인덱스를 위한 추가 저장공간이 필요함
   인덱스를 생성하는데 시간이 걸림
   데이터의 변경작업(INSERT/UPDATE/DELETE)가 자주 일어나는 경우
   REBUID 작업을 주기적으로 해줘야하며, REBUILD를 자주하지 않으면 성능이 저하된다
*/

-- 인덱스를 관리하는 데이터 딕셔너리
SELECT * FROM USER_IND_COLUMNS;

-- ROWID 구조 : 오브젝트 번호, 상대파일 번호, 블록 번호, 데이터 번호

-- DATA FULL SCAN
SELECT
       ROWID , 
       EMP_ID ,
       EMP_NAME
  FROM EMPLOYEE;


-- 인덱스의 종류
/* 1. 고유 인덱스(UNIQUE INDEX)
   2. 비고유 인덱스 (NONUNIQUE INDEX)
   3. 단일 인덱스 (SINGLE INDEX)
   4. 결합 인덱스 (COMPOSITE INDEX)
   5. 함수기반 인덱스 (FUNCTION BASED INDEX)
*/
-- UNIQUE INDEX
-- UNIQUE INDEX로 생성된 컬럼에서는 중복값이 포함될 수 없음
-- 오라클 PRIMARY KEY 제약조건을 생성하면
-- 자동으로 해당 컬럼에 UNIQUE INDEX가 생성된다
-- PRIMARY KEY를 이용하여 ACCESS 경우에는 성능 향상의 효과가 있음

-- 인덱스 힌트
-- 일반적으로는 옵티마이저가 적절한 인덱스를 타거나 풀 스캐닝을 해서 비용이 적게 드는 효율적인 방식으로 검색
-- 하지만 우리가 원하는 테이블에 있는 인덱스를 사용할 수 있도록 해주는 구문(힌트)를 통해 선택 가능
-- SELECT절 첫줄에 힌트 주석(/*내용*/)하여 적절한 인덱스를 부여할 수 있다
-- 주석에 '*'을 반드시 붙이고 /** 다음에 스페이스를 반드시 줘야 한다
*/


-- UNIZUE INDEX활용
SELECT /**INDEX_DESC(EMPLOYEE 엔터티1_PK */
       *
  FROM EMPLOYEE;

-- 인덱스가 내림차순으로 생성되어 INDEX_DESC로 인덱스 영역에서 역방향으로 스캔하라는 뜻
-- 예전에 넣었던 데이터부터 순서대로 나오도록 정렬
SELECT /** INDEX_DESC(EMPLOYEE 엔터티1_PK*/
       E.*
  FROM EMPLOYEE E
 WHERE E.EMP_ID > '0';
 
CREATE UNIQUE INDEX IDX_EMPNO
ON EMPLOYEE(EMP_NO); -- UNIQUE 제약조건에 의해 이미 인덱스가 존재한다

-- PRIMARYKEY나 UNIQUE에 있는 인덱스들은 DROP을 할 수도 엇다
SELECT
       UIC.*
  FROM USER_IND_COLUMNS UIC;

DROP INDEX SYS_C008419; --지워지지 않는걸 보여줌

-- 중복값이 있는 컬럼은 UNIQUE 인덱스 생성하지 못함
CREATE UNIQUE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);

-- NONUNIQUE INDEX
-- WHERE절에서 빈번하게 사용되는 일반적 컬럼을 대상으로 생성
-- 주로 성능 향상을 위한 목적으로 생성함
CREATE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);

-- 결합 인덱스 (COMPOSITE INDEX)
-- 결합 인덱스시에는 카디널리타(집합의 유니크(UNIQUE)한 값의 개수)가 늘고,
-- 중복값이 낮은 값이 먼저 오는 것이 검색 속도를 향상 시킨다
-- 따라서 결합한 인덱스를 작성 시 카디널리타가 높은 것을 먼저 적는 것이 좋다
CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID, DEPT_TITLE);

DROP INDEX IDX_DEPT;

CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID, DEPT_TITLE);

SELECT /** INDEX_DESC(DEPARTMENT IDX_DEPT)*/
       D.DEPT_ID
  FROM DEPARTMENT D
 WHERE D.DEPT_TITLE > '0'
   AND D.DEPT_ID > '0';
   
-- 함수 기반 인덱스
-- SELECT절이나 WHERE절에서 산술 계산식이나 함수가 사용된 경우
-- 계산에 포함된 컬렁믄 인덱스의 적용을 하지 않는다
-- 계산식으로 검색하는 경우가 많다면, 수식이나 함수식으로 이루어진 컬럼을 인덱스로 만들 수 있다
SELECT * FROM EMPLOYEE;
CREATE TABLE EMP02
AS SELECT * FROM EMPLOYEE;

CREATE INDEX IDX_EMP02_SALCALC
ON EMP02((SALARY+(SALARY+NVL(BONUS,0)))*12);

SELECT /** INDEX_DESC(EMPLOYEE IDX_EMP02_SALCALC)*/
       E.EMP_ID ,
       E.EMP_NAME ,
      ((E.SALARY + (E.SALARY * NVL(E.BONUS,0)))*12) 연봉
  FROM EMP02 E
 WHERE ((E.SALARY + (E.SALARY * NVL(E.BONUS,0)))*12) > 10000000;
 
