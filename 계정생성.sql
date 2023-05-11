/*여러줄 주석일 경우*/
-- 한줄 주석일 경우

/*계정생성과 같은 명령어는 권한을 가진다.*/
-- C##EMPLOYEE라는 사용자를 추가하고 비밀번호는 EMPLOYEE로 하겠다.
-- 계정 앞에 오라클에선  C##를 붙여준다. 프로젝트땐 안붙인다
-- 공간을 할당 받을땐 안붙인다. ??
-- IDENTIFIED 비밀번호
--CREATE USER C##EMPLOYEE IDENTIFIED BY EMPLOYEE;
-- 한번씩 추가 가능 컨트롤 엔터


-- 권한: 유저룰 이라고 한다
-- RESOUTRCE(사용자정의 뷰 권한), (CONNECT 접속권한 조작문8가지 권한) 승인
-- GRANT RESOURCE, CONNECT TO C##EMPLOYEE;
--ALTER (수정) 변경한다. 
-- 계정 QUOTA용량 제한 UNLIMITED 시스템에 대한 용량 제한해제
--ALTER USER C##EMPLOYEE QUOTA UNLIMITED ON SYSTEM
-- 계정 UNLIMITED 
--ALTER USER C##EMPLOYEE QUOTA UNLIMITED ON USERS;
