 -- 시퀀스(SEQUENCE) 중요!!!!!
-- 자동 번호 발생기 역할을 하는 객체
-- 순차적으로 정수값을 자동으로 생성해줌

/*
[표현문]
CREATE SEQUENCE 시퀀스 이름 (중요)
    [INCERMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1 기본 (값을 몇씩 증가시킬거야? 조건식)
    [START WITH 숫자] -- 처음 발생시킬 값 지정, 생략하면 자동 1 기본
    [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승)
    [MINVALUES 숫자 | NOMINVALUE]] -- 최소값 지정 (-10의 26승)
    [CYCLE | NOCYCLE]] -- 값 순환여부 (PRIMARY KEY는 NOCYCLE로 사용한다)
    [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소는 2바이트
*/

CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- NEXTVAL 1회 수행 후 실행 가능 (CURRVAL 현재값 확인)
SELECT SEQ_EMPID.CURRVAL FROM DUAL;

SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

SELECT * FROM USER_SEQUENCES;

-- 시퀀스 변경
ALTER SEQUENCE SEQ_EMPID
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

/*
-- START WITH 값은 변경이 불가능함
   START WITH 값 변경시에는 DROP으로 삭제 후 다시 생성해야 한다
   
   SELECT문에서 사용가능
   INSERT문에서 SELECT 구문 사용가능
   INSERT문에서 VALUES절에 사용가능
   UPDATE문에서 SET절에 사용가능
   
   단, 서브쿼리의 SELECT문에서 사용불가
   VIEW의 SELECT절에 사용불다
   DISTINCT 키워드가 있는 SELECT문에서 사용불가
   GROUP BY, HAVING절이 있는 SELECT문에서 사용불가
   ORDER BY절에서 사용 불가
   CREATE TABLE, ALTER TABLE의 DEFAULT값으로 사용불가
*/

CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 100000
NOCYCLE
NOCACHE;

INSERT INTO EMPLOYEE A 
(
    A.EMP_ID, A.EMP_NAME, A.EMP_NO, A.EMAIL, A.PHONE,
    A.DEPT_CODE, A.JOB_CODE, A.SAL_LEVEL, A.SALARY, A.BONUS,
    A.MANAGER_ID, A.HIRE_DATE, A.ENT_DATE, A.ENT_YN
)VALUES(
    SEQ_EID.NEXTVAL, '홍길동', '666666-366666', 'HONE_GO@GMAIL.COM', '01023232323',
    'D2', 'J7', 'S1', 50000000, 0.1,
    200, SYSDATE, NULL, DEFAULT
);
-- 
SELECT SEQ_EID.CURRVAL FROM DUAL;
SELECT SEQ_EID.NEXTVAL FROM DUAL;

SELECT * FROM EMPLOYEE E;


