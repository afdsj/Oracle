/*
VIEW(뷰)
SELECT 쿼리문을 저장한 객체이다
실질적인 데이터를 저장하고 있지는 않는다
테이블을 사용하는 것과 동일하게 사용할 수 있다
CREATE [OR REPLACE] VIEW 뷰이름 AS 서브쿼리
!마치 진짜로 존재하는 것처럼 사용이 가능하다!
!조건을 많이 걸어야 하는 경우에 사용한다!
*/

/* 사번, 이름, 직급명, 부서명, 근무지역을 조회하고
 그 결과를 v_result_emp라는 뷰를 생성해서 저장하세요*/
CREATE OR REPLACE VIEW V_RESULT_EMP
AS
SELECT E.EMP_ID ,
       E.EMP_NAME ,
       J.JOB_NAME , -- JOB_CODE를 참조하고 있어서 변하지 않는다
       D.DEPT_TITLE ,
       L.LOCAL_NAME
  FROM EMPLOYEE E
  LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

SELECT * FROM V_RESULT_EMP;
/* 질문해서 확인하려고 만든 구문
UPDATE V_RESULT_EMP
SET JOB_NAME = '인턴';
WHERE EMP_ID = 216;
*/
  
  
 --가상의 테이블을 만들어서 저장, 
 --뷰를 만든시점 이후에 추가된 데이터는 추가 될 수 없다
SELECT *
  FROM V_RESULT_EMP
 WHERE EMP_ID = '100';
 
--UPDATE 쿼리는 가능

UPDATE V_RESULT_EMP -- 원본에 영향을 준다
   SET EMP_ID = '100'
 WHERE EMP_ID = '205';
 


-- 데이터 딕셔너리(DATE DICTIONARY)
-- 자원을 효율적으로 관리하기 위해 다양한 정보를 저장하는 시스템 테이블
-- 사용자가 테이블을 생성하거나, 사용자를 변경하는 등의 작업을 할 때
-- 데이터베이스는 서버에 의해 자동으로 갱신되는 테이블
-- 사용자는 데이터 딕셔너리 내용을 직접 수정하거나 삭제할 수 없다

-- 원본 테이블을 커스터마이징 해서 보여주는 원본 테이블의 가상 테이블 객체(VIEW)

-- 3개의 딕셔너리 뷰로 나뉜다
-- 1.DBA_XXX : 데이터베이스 관리자만 접근이 가능한 객체등의 정보 조회
-- 2.ALL_XXX : 자신의 계정 _ 권한을 부여받은 객체의 정보 조회
-- 3.USER_XXX : 자신 계정이 소유한 객체들에 관한 정보 조회

-- 뷰에 대한 정보를 확인하는 데이터 딕셔너리
SELECT
        *
  FROM USER_VIEWS UV;
  
-- 뷰에 별칭 부여1
CREATE OR REPLACE VIEW V_EMP(
사번,
이름,
부서
)AS
 SELECT
        E.EMP_ID ,
        E.EMP_NAME ,
        E.DEPT_CODE 
   FROM EMPLOYEE E;

SELECT * FROM V_EMP;

-- 뷰를 지울때
-- 표현식 DROP VIEW 테이블명
DROP VIEW V_EMP;

-- 베이스 테이블의 정보가 변경되면 VIEW도 같이 변경된다
COMMIT;

SELECT * FROM V_RESULT_EMP;

UPDATE
       EMPLOYEE E
   SET E.EMP_NAME = '차태연'
 WHERE E.EMP_ID = '217';

DROP VIEW V_RESULT_EMP;

-- 뷰의 별칭 부여 2 
--REPLACE 뷰가 없으면 생성, 뷰가 있을 경우 덮어씌우기
CREATE OR REPLACE VIEW V_EMPLOYEE
(
 사번,
 이름,
 부서,
 지역
)AS
 SELECT
        E.EMP_ID ,
        E.EMP_NAME ,
        D.DEPT_TITLE ,
        N.NATIONAL_NAME
   FROM EMPLOYEE E
   LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
   LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
   LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);

SELECT * FROM V_EMPLOYEE;

CREATE OR REPLACE VIEW V_EMPLOYEE
(
 사번,
 이름,
 직급,
 성별,
 근무년수
)AS
 SELECT
        E.EMP_ID ,
        E.EMP_NAME ,
        J.JOB_NAME ,
        DECODE (SUBSTR(E.EMP_NO, 8,1) ,1, '남', '여') ,
        EXTRACT (YEAR FROM SYSDATE) - EXTRACT(YEAR FROM E.HIRE_DATE) 
   FROM EMPLOYEE E
   JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
 
SELECT * FROM V_EMPLOYEE;

-- DML명령어로 조작이 불가능한 경우 (오류 CASE만 작성함)
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
-- 2. 뷰에 포함되지 않은 컬럼 중에서 베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우
-- 3. 산술표현식으로 정의된 경우
-- 4. JOIN을 이용해 여러 테이블을 연결한 경우
-- 5. DISTINCT 포함한 경우
-- 6. 그룹함수나 GROUP BY절을 포함한 경우

-- 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB2
AS
SELECT J.JOB_CODE --잡코드만 가져옴
  FROM JOB J;
  
SELECT * FROM V_JOB2;

INSERT
  INTO V_JOB2
  (
    JOB_CODE,
    JOB_NAME
  )VALUES( --JOB_NAME에다가 값을 넣어주려고 해서 오류
    'J8',
    '인턴'
  );
  
UPDATE --JOB_NAME이 있어서 오류
       V_JOB2 V
   SET V.JOB_NAME = '인턴'
 WHERE V.JOB_CODE = 'J7';

SELECT * FROM V_JOB2;

DELETE 
  FROM V_JOB2 V
 WHERE V.JOB_CODE ='J7';
 
 -- 산술 표현식으로 정의된 경우
CREATE OR REPLACE VIEW EMP_SAL
AS
SELECT
        E.EMP_ID ,
        E.EMP_NAME , 
        E.SALARY ,
       (E.SALARY + (E.SALARY + NVL(E.BONUS,0))) * 12 연봉
  FROM EMPLOYEE E;

SELECT * FROM EMP_SAL;

INSERT 
  INTO EMP_SAL
  (
   EMP_ID ,
   EMP_NAME ,
   SALARY , 
   연봉
  )VALUES(
   '800' ,
   '정지훈' ,
   3000000,
   4000000
  );

SELECT * FROM EMP_SAL;

DELETE FROM EMP_SAL WHERE 연봉 = 192000003.6;

-- JOIN을 이용해 여러 테이블을 연결한 경우  오류 !!!!!
CREATE OR REPLACE VIEW V_JOINEMP
AS
SELECT
       E.EMP_ID ,
       E.EMP_NAME ,
       D.DEPT_TITLE --무결성제약조건 위배 
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

SELECT * FROM V_JOINEMP;

INSERT
  INTO V_JOINEMP
  (EMP_ID ,
   EMP_NAME ,
   DEPT_TITLE
  )
  VALUES
  ( 888 ,
   '조세오' ,
   '인사관리부' --에러가 나는 이유가 DEPT_TITLE값은 부모테이블에서 가지고 와야 함 VIEW 자체에 값을 추가하려고 해서 안되는거
              --참조하는게 없을 경우에 가능
  );
  
UPDATE  
        V_JOINEMP V
   SET V.DEPT_TITLE = '인사관리부';
   
DELETE -- 뷰 자체에서 값을 삭제하면 원본(부모테이블)에 영향을 미친다
  FROM V_JOINEMP
 WHERE V.EMP_ID = '201';
 
SELECT * FROM EMPLOYEE;
ROLLBACK;

-- VIEW 옵션
-- OR REPLACE : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고 존재하지 않으면 새로 생성하는 옵션
-- FORCE 옵션 : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT TCODE , -- 테이블이 없어도 있다고 생각하고 만들어준다
       TNAME , 
       TCONTENTS
  FROM TEST; 

SELECT * FROM V_EMP;

-- NOFORCE 옵션 : 서브쿼리에 테이블이 존재해야만 뷰 생성함 (기본값)
CREATE OR REPLACE /*NOFORCE*/ VIEW V_EMP2 --원래 기본값으로 생성
AS
SELECT TCODE,
       TNAME,
       TCONTENTS
  FROM TEST;

SELECT * FROM V_EMP2;
-- WITH CHECK 옵션 : 컬럼의 값을 수정하지 못하게 한다
-- WITH CHECK OPTION : 조건절에 사용된 컬럼의 값을 수정하지 못하게 한다
CREATE OR REPLACE VIEW V_EMP3
AS
SELECT *
  FROM EMPLOYEE 
 WHERE MANAGER_ID = '200'
  WITH CHECK OPTION;
  
UPDATE
       V_EMP3
   SET MANAGER_ID = '900'
 WHERE MANAGER_ID = '200';
 
-- WITH READ ONLY = DML 수행 불가능 (객체 조작을 못하게 하는 옵션)
CREATE OR REPLACE VIEW V_DEPT
AS
SELECT * 
  FROM DEPARTMENT D
  WITH READ ONLY;
  
DELETE FROM V_DEPT; 
SELECT * FROM V_DEPT; --읽기만 가능하고 지우는거 불가능