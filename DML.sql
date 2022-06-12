-- DML(Data Manipulation Language)
-- INSERT, UPDATE, DELETE, SELECT(DQL)
-- : 데이터 조작언어, 테이블에 값을 삽입하거나, 수정하거나,
--   삭제하거나, 조회하는 언어
-- INSERT : 새로운 행을 추가하는 구문이다.
--          테이블의 행 갯수가 증가한다.
-- INSERT INTO 테이블명 VALUES(데이터, 데이터, ...)
-- 테이블에 모든 컬럼에 대해 값을 INSERT할 때 사용한다.
-- 테이블의 일부 컬럼에 대해 INSERT를 하기 위해서는
-- INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명, ...)
-- VALUES (데이터, 데이터, 데이터, ...);

DESC EMPLOYEE;

INSERT
  INTO EMPLOYEE
(
  EMP_ID, EMP_NAME, EMP_NO
, EMAIL, PHONE, DEPT_CODE
, JOB_CODE, SAL_LEVEL, SALARY
, BONUS, MANAGER_ID, HIRE_DATE
, ENT_DATE, ENT_YN
)
VALUES
(
  900, '장채현', '90112301080503'
, 'JANG_CH@GREEDY.CO.KR', '01055556912', 'D1'
, 'J1', 'S5', 2800000
, 0.1, '200', SYSDATE
, NULL, DEFAULT
);

-- DEFAULT는 INSERT시에 DEFAULT값을 넣어라 라고 하면 애초에 테이블에 만들어진 당시에
-- 해당 컬럼에 DEFAULT값으로 설정된 값이 INSERT 된다.
-- 혹은 INSERT 시에 해당 컬럼을 INSERT 하지 않으면 DEFAULT 값이 해당 컬럼에 들어간다.(NULL 대신)

SELECT 
       * 
  FROM EMPLOYEE
 WHERE EMP_ID = 900;

COMMIT;

-- INSERT시에 VALUES 대신 서브쿼리를 이용할 수 있다.(VALUES를 쓰지 않음)
DROP TABLE EMP_01;
CREATE TABLE EMP_01(
  EMP_ID NUMBER,
  EMP_NAME VARCHAR2(30),
  DEPT_TITLE VARCHAR2(20)
);

INSERT
  INTO EMP_01
(
  SELECT
         E.EMP_ID
       , E.EMP_NAME
       , D.DEPT_TITLE
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
);

SELECT * FROM EMP_01 ORDER BY 1;


-- INSERT ALL : INSERT시에 사용하는 서브쿼리가 같은 경우
--              두 개 이상의 테이블에 INSERT ALL을 이용하여
--              한번에 데이터를 삽입할 수 있다.
--              단, 각 서브쿼리의 조건절이 같아야 한다.
DROP TABLE EMP_DEPT_D1;
CREATE TABLE EMP_DEPT_D1
AS
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.HIRE_DATE
  FROM EMPLOYEE E
 WHERE 1 = 0;
 
SELECT
       ED.*
  FROM EMP_DEPT_D1 ED;

DROP TABLE EMP_MANAGER;  
CREATE TABLE EMP_MANAGER
AS
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE 1 = 0;
 
SELECT
       EM.*
  FROM EMP_MANAGER EM;
  
-- EMP_DEPT_D1 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인
-- 직원을 조회해서, 사번, 이름, 소속부서, 입사일을 삽입하고
-- EMP_MANAGER 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인
-- 직원을 조회해서 사번, 이름, 관리자 사번을 조회해서 삽입하세요.
INSERT
  INTO EMP_DEPT_D1
(
  SELECT
         E.EMP_ID
       , E.EMP_NAME
       , E.DEPT_CODE
       , E.HIRE_DATE
    FROM EMPLOYEE E
   WHERE E.DEPT_CODE = 'D1'
);

INSERT
  INTO EMP_MANAGER
(
  SELECT
         E.EMP_ID
       , E.EMP_NAME
       , E.MANAGER_ID
    FROM EMPLOYEE E
   WHERE E.DEPT_CODE = 'D1'
);

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

DELETE
  FROM EMP_DEPT_D1;

DELETE 
  FROM EMP_MANAGER;
  
INSERT ALL
  INTO EMP_DEPT_D1
VALUES
(
  EMP_ID
, EMP_NAME
, DEPT_CODE
, HIRE_DATE
)
  INTO EMP_MANAGER
VALUES
(
  EMP_ID
, EMP_NAME
, MANAGER_ID
)
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.HIRE_DATE
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE E.DEPT_CODE = 'D1';
 
SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

-- EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한
-- 사원의 사번, 이름, 입사일, 급여를 조회하여
-- EMP_OLD 테이블에 삽입하고
-- 그 이후에 입사한 사원은 EMP_NEW 테이블에 삽입하시오.
CREATE TABLE EMP_OLD
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE 1 = 0;
 
CREATE TABLE EMP_NEW
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE 1 = 0;
  
INSERT ALL
  WHEN HIRE_DATE < TO_DATE('2000/01/01', 'RRRR/MM/DD')
  THEN
  INTO EMP_OLD
VALUES
(
  EMP_ID
, EMP_NAME
, HIRE_DATE
, SALARY
)
  WHEN HIRE_DATE >= TO_DATE('2000/01/01', 'RRRR/MM/DD')
  THEN
  INTO EMP_NEW
VALUES
(
  EMP_ID
, EMP_NAME
, HIRE_DATE
, SALARY
)
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
  FROM EMPLOYEE E;
  
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-- UPDATE : 테이블에 기록된 컬럼의 값을 수정하는 구문이다.
--          테이블의 전체 행 갯수는 변화가 없다.(회원탈퇴)

CREATE TABLE DEPT_COPY
AS
SELECT D.*
  FROM DEPARTMENT D;
  
SELECT * FROM DEPT_COPY;

-- UPDATE 테이블명 SET 컬럼명 = 바꿀값, 컬럼명 = 바꿀값, ...
--   [WHERE 컬럼명 비교연산자 비교값]

UPDATE
       DEPT_COPY DC
   SET DC.DEPT_TITLE = '전략기획팀'
 WHERE DEPT_ID = 'D9';

COMMIT;

-- UPDATE시에도 서브쿼리를 이용할 수 있다.
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)
CREATE TABLE EMP_SALARY
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.SALARY
     , E.BONUS
  FROM EMPLOYEE E;
  
  
SELECT 
       ES.*
  FROM EMP_SALARY ES
 WHERE EMP_NAME IN ('유재식', '방명수');
 
-- 평상시에 유재식 사원을 부러워하던 방명수 사원의
-- 급여와 보너스울을 유재식 사원과 동일하게 변경해 주기로 했다.
-- 이를 반영하는 UPDATE 문을 작성해 보시오.

UPDATE
       EMP_SALARY ES
   SET ES.SALARY = (SELECT E1.SALARY
                      FROM EMP_SALARY E1
                    WHERE E1.EMP_NAME = '유재식'
                   )
     , ES.BONUS = (SELECT E1.BONUS
                      FROM EMP_SALARY E1
                    WHERE E1.EMP_NAME = '유재식'
                  )
 WHERE ES.EMP_NAME = '방명수';
 
SELECT 
       ES.*
  FROM EMP_SALARY ES
 WHERE EMP_NAME IN ('유재식', '방명수');
 
-- 다중열 서브쿼리를 이용한 업데이트문
-- 방명수 사원의 급여 인상 소식을 전해들은 다른 직원들이
-- 단체로 파업을 진행했다.
-- 노옹철, 전형돈, 정중하, 하동운 사원의 급여와 보너스를
-- 유재식 사원의 급여 및 보너스와 같게 변경하는 UPDATE문을 작성해보시오.
UPDATE
       EMP_SALARY ES
   SET (ES.SALARY, ES.BONUS) = (SELECT E1.SALARY, E1.BONUS
                                  FROM EMP_SALARY E1
                                 WHERE E1.EMP_NAME = '유재식'
                               )
 WHERE ES.EMP_NAME IN('노옹철', '전형돈', '정중하', '하동운'); 
 
SELECT 
       ES.*
  FROM EMP_SALARY ES
 WHERE ES.EMP_NAME IN ('유재식', '노옹철', '전형돈', '정중하', '하동운');
 
-- 다중행 서브쿼리를 이용한 UPDATE
-- EMP_SALARY 테이블에서 아시아 근무지역에 근무하는 직원의
-- 보너스를 0.5로 변경하시오.

-- EMP_SALARY 테이블에서 아시아 지역에서 근무하는 직원
SELECT
       E.EMP_ID
     , L.LOCAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
 WHERE L.LOCAL_NAME LIKE 'ASIA%';
 
UPDATE
       EMP_SALARY ES
   SET ES.BONUS = 0.5
 WHERE ES.EMP_ID IN (SELECT E.EMP_ID
                       FROM EMPLOYEE E
                       JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
                       JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
                      WHERE L.LOCAL_NAME LIKE 'ASIA%'
                    );
                    
SELECT * FROM EMP_SALARY;

COMMIT;

-- UPDATE시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되지 않도록 해야 함.
UPDATE
       EMPLOYEE E
   SET E.DEPT_CODE = '10'               -- FOREIGN KEY 제약조건 위배됨
 WHERE E.DEPT_CODE = 'D6';

UPDATE
       EMPLOYEE E
   SET E.EMP_NAME = NULL               -- NOT NULL 제약조건 위배됨
 WHERE E.EMP_ID = '200';
 
UPDATE
       EMPLOYEE E
   SET E.EMP_NO = '621215-1985634'               -- UNIQUE 제약조건 위배됨
 WHERE E.EMP_ID = '201';
 
UPDATE
       EMPLOYEE E
   SET E.ENT_YN = DEFAULT           
 WHERE E.EMP_ID = '222';
 
ROLLBACK;

-- DELETE : 테이블의 행을 삭제하는 구문이다.
--          테이블의 행의 갯수가 줄어든다.
-- DELETE FROM 테이블명 WHERE 조건절
-- 만약 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제된다.
DELETE
  FROM EMPLOYEE;
  
SELECT * FROM EMPLOYEE;

ROLLBACK;

DELETE
  FROM EMPLOYEE E
 WHERE E.EMP_ID = 900;
 
-- FOREIGN KEY 제약조건이 설정되어 있는 경우
-- 자식테이블에 의해 참조되고 있는 값에 대해서는 부모테이블에서 삭제할 수 없다.
DELETE
  FROM DEPARTMENT D
 WHERE D.DEPT_ID = 'D1';                -- 참조되고 있는 값을 지닌 튜플은 지울 수 없다.(삭제룰 없을 때)
 
 
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

DELETE
  FROM DEPARTMENT D
 WHERE D.DEPT_ID = 'D3';                -- 참조되고 있지 않는 값을 지닌 튜플은 지울 수 있다.
 
ROLLBACK;

-- TRUNCATE : 테이블의 전체 행을 삭제할 시 사용한다.
--            DELETE보다 수행 속도가 더 빠르다.
--            ROLLBACK을 통해 복구할 수 없다.
SELECT * FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY;              -- TRUNCATE를 통해 TABLE 초기화

-- MERGE : 구조가 같은 두 개의 테이블을 하나의 테이블을 기준으로 합치기(병합) 기능을 한다.
--         테이블에서 지정하는 조건의 값이 존재하면 UPDATE
--         조건의 값이 없으면 INSERT 됨
CREATE TABLE EMP_M01
AS 
SELECT E.*
  FROM EMPLOYEE E;
  
CREATE TABLE EMP_M02
AS 
SELECT E.*
  FROM EMPLOYEE E
 WHERE E.JOB_CODE = 'J4';
 
INSERT 
  INTO EMP_M02
VALUES
(
  999, '김종현', '960420-1234567', 'GRAPE420@NAVER.COM', '01012345678'
, 'D9', 'J4', 'S1', 8900000, 0.5
, NULL, SYSDATE, NULL, DEFAULT
);

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

UPDATE
       EMP_M02 EM
   SET EM.SALARY = 0;


-- MERGE
MERGE 
 INTO EMP_M01 M1
USING EMP_M02 M2
   ON(M1.EMP_ID = M2.EMP_ID)
 WHEN MATCHED THEN
UPDATE 
   SET M1.EMP_NAME = M2.EMP_NAME
     , M1.EMP_NO = M2.EMP_NO
     , M1.EMAIL = M2.EMAIL
     , M1.PHONE = M2.PHONE
     , M1.DEPT_CODE = M2.DEPT_CODE
     , M1.JOB_CODE = M2.JOB_CODE
     , M1.SAL_LEVEL = M2.SAL_LEVEL
     , M1.SALARY = M2.SALARY
     , M1.BONUS = M2.BONUS
     , M1.MANAGER_ID = M2.MANAGER_ID
     , M1.HIRE_DATE = M2.HIRE_DATE
     , M1.ENT_DATE = M2.ENT_DATE
     , M1.ENT_YN = M2.ENT_YN
WHEN NOT MATCHED THEN
INSERT 
(
  M1.EMP_ID, M1.EMP_NAME, M1.EMP_NO, M1.EMAIL, M1.PHONE
, M1.DEPT_CODE, M1.JOB_CODE, M1.SAL_LEVEL, M1.SALARY, M1.BONUS
, M1.MANAGER_ID, M1.HIRE_DATE, M1.ENT_DATE, M1.ENT_YN
)
VALUES 
(
  M2.EMP_ID, M2.EMP_NAME, M2.EMP_NO, M2.EMAIL, M2.PHONE
, M2.DEPT_CODE, M2.JOB_CODE, M2.SAL_LEVEL, M2.SALARY, M2.BONUS
, M2.MANAGER_ID, M2.HIRE_DATE, M2.ENT_DATE, M2.ENT_YN
);

SELECT * FROM EMP_M01 WHERE JOB_CODE = 'J4';