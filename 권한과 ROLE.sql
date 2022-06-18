-- 시스템 계정으로 하기!!!!!
-- <사용자 관리>
-- : 사용자의 계정과 암호설정, 권한 부여
 
-- 오라클 데이터베이스를 설치하면 기본적으로 제공되는 계정
-- 1. SYS
-- 2. SYSTEM
-- 3. SCOTT(교육용 샘플 계정) : 11G는 별도로 생성해야 함
-- 4. HR(샘플 계정) : 처음에는 잠겨 있음
-- <SYSTEM 계정으로 가서 실행>
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY HR;
-- ID:HR, PWD:HR인 상태로 접속 가능

-- 보안을 위한 데이터베이스 관리자
-- : 사용자가 데이터베이스의 객체(테이블, 뷰 등)에 대해
--   특정 권한을 가질 수 있게 하는 권한이 있음
--   다수의 사용자가 공유하는 데이터베이스 정보에 대한 보안 설정
--   데이터베이스에 접근하는 사용자마다 서로 다른 권한과 롤을 부여함

-- 내가 다른 사용자에게 부여한 객체 권한을 조회
-- <SYSTEM 계정으로 가서 실행>
SELECT
       UTPR.*
  FROM USER_TAB_PRIVS_RECD UTPR;

-- 나에게 부여된 객체 권한, 객체 이름을 조회
SELECT
       UTPM.*
  FROM USER_TAB_PRIVS_MADE UTPM;

-- 1. 시스템 권한 : 데이터베이스 관리자가 가지고 있는 권한으로
--                오라클 접속, 테이블, 뷰, 인덱스 등의 생성 권한
--                CREATE USER(사용자 계정 만들기)
--                DROP USER(사용자 계정 삭제)
--                DROP ANY TABLE(임의의 테이블 삭제)
--                QUERY REWRITE(함수 기반 인덱스 생성 권한)
--                BACKUP ANY TABLE(테이블 백업)

-- 시스템 관리자가 사용자에게 부여하는 권한
--                CREATE SESSION(데이터베이스에 접속)
--                CREATE TABLE(테이블 생성)
--                CREATE VIEW(뷰 생성)
--                CREATE SEQUENCE(시퀀스 생성)
--                CREATE PROCEDURE(프로시져 생성 권한)

-- <SYSTEM 계정으로 가서 실행>
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;
GRANT CREATE SESSION TO SAMPLE;
GRANT CREATE TABLE TO SAMPLE;

-- 생성한 SAMPLE 계정으로 접속 해보자.
-- 접속 후 테이블 생성(TABLESAPCE에 용량 권한 및 용량 부족으로 에러 뜸)
-- CREATE TABLE TEST_TABLE(
--   COL1 VARCHAR2(20),
--   COL2 NUMBER
-- );

-- <SYSTEM 계정으로 가서 실행>
ALTER USER SAMPLE QUOTA 1024M ON SYSTEM; -- TABLESPACE에 1G권한 할당
-- 이후 테이블 생성 가능

-- WITH ADMIN OPTION
-- : 사용자에게 시스템 권한을 부여할 때 사용함
--   권한을 부여 받은 사용자는 다른 사용자에게 권한을 지정할 수 있음
-- <SYSTEM 계정으로 확인하기>
GRANT CREATE SESSION TO SAMPLE
WITH ADMIN OPTION;

-- 아래 구문들로 확인하기
-- <SYSTEM 계정으로 확인하기>
-- SAMPLE2 계정 생성하기
CREATE USER SAMPLE2 IDENTIFIED BY SAMPLE2;
-- 
-- <SAMPLE 계정으로 확인하기>
-- SAMPLE 계정이 SAMPLE2 계정에게 권한 부여 가능함을 확인
-- GRANT CREATE SESSION TO SAMPLE2
-- WITH ADMIN OPTION;

-- 2. 객체 권한 : 사용자가 특정 객체(테이블, 뷰, 시퀀스, 함수)를 조작 하거나 접근 할 수 있는 권한
--              DML(SELECT/INSERT/UPDATE/DELETE)
--              GRANT 권한종류 [(컬럼명)] | ALL
--              ON 객체명 | ROLE 이름 | PUBLIC
--              TO 사용자 이름;
       
-- 객체를 DML처리하는 권한 종류
--              ALTER TABLE, SEQUENCE
--              DELETE TABLE, VIEW
--              EXECUTE PROCEDURE
--              INDEX TABLE
--              REFERENCES TABLE
--              INSERT TABLE, VIEW
--              SELECT TABLE, VIEW, SEQUENCE
--              UPDATE TABLE, VIEW

-- WITH GRANT OPTION
-- : 사용자가 특정 객체를 조작하거나 접근 할 수 있는 권한을 부여받으면서
--   그 권한을 다른 사용자에게 다시 부여할 수 있는 권한 옵션

-- <SYSTEM 계정으로 하기>
-- GRANT SELECT ON EMPLOYEE.EMPLOYEE TO SAMPLE
-- WITH GRANT OPTION;

-- <SAMPLE 계정으로 확인하기>
-- SAMPLE 계정이 EMPLOYEE 계정의 EMPLOYEE 테이블 접속 되는 것 확인
-- SELECT
--        EE.*
--   FROM EMPLOYEE.EMPLOYEE EE;

-- SAMPLE 계정이 SAMPLE2계정에게 권한 부여 가능함을 확인
-- GRANT SELECT ON EMPLOYEE.EMPLOYEE TO SAMPLE2
-- WITH GRANT OPTION;

-- 권한 철회
-- : REVOKE 명령어 사용
-- <SYSTEM 계정으로 하기>
REVOKE SELECT ON EMPLOYEE.EMPLOYEE FROM SAMPLE;

-- 참고
-- WITH GRANT OPTION은 REVOKE시 다른 사용자에게도 부여한 권한을 같이 회수
-- WITH ADMIN OPTION은 특정 사용자의 권한만 회수가 되고 나머지 다른 사용자에게
-- 부여한 권한은 회수가 되지 않음


-- 롤(ROLE)
-- : 사용자에게 보다 간편하게 부여할 수 있도록
--   여러개의 권한을 묶어 놓은 것
--   => 사용자 권한 관리를 보다 간편하고 효율적으로 할 수 있게 함
--      다수의 사용자에게 공통적으로 필요한 권한들을 하나의 롤로 묶고
--      사용자에게는 특정 롤에 대한 권한을 부여할 수 있도록 함
--
--      사용자에게 부여한 권한을 수정하고자 할 때도
--      롤만 수정하면 그 롤에 대한 권한을 부여받은 사용자들의 권한이
--      자동으로 수정된다.
--      롤을 활성화 하거나 비활성화 해서 일시적으로 권한을 부여하고
--      철회할 수 있음

-- 딕셔너리 뷰에서 롤과 관련된 딕셔너리 뷰들만 보기
SELECT
       D.*
  FROM DICT D
 WHERE D.TABLE_NAME LIKE '%ROLE%';
 
-- 롤의 종류
-- 1. 사전 정의된 롤
-- : 오라클 설치시 시스템에서 기본적으로 제공됨
--   CONNECT ROLE
--   RESOURCE ROLE

-- 2. 사용자가 정의하는 롤
-- : CREATE ROLE 명령으로 롤 생성
--   롤 생성은 반드시 DBA권한이 있는 사용자만 할 수 있음
--   CREATE ROLE 롤이름; -- 1. 롤 생성
--   GRANT 권한종류 TO 롤이름; -- 2. 생성된 롤에 권한 추가
--   GRANT 롤이름 TO 사용자이름; -- 3. 사용자에게 롤 부여

-- <SYSTEM 계정에서 하기>
-- CREATE ROLE MYROLE;
-- DROP ROLE MYROLE;

-- GRANT CREATE VIEW, CREATE SEQUENCE TO MYROLE;
-- REVOKE CREATE SEQUENCE FROM MYROLE;
-- GRANT MYROLE TO SAMPLE;

-- <SAMPLE 계정에서 하기>
-- SAMPLE 계정은 ROLE을 부여 받으면 반드시!! 접속 해제했다가 다시 접속해야 ROLE의 권한들이 적용된다.
-- CREATE OR REPLACE FORCE VIEW V_TT
-- AS
-- SELECT *
--   FROM TT;