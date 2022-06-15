-- 데이터 딕셔너리(Data Dictionary)
-- 자원을 효율적으로 관리하기 위해 다양한 정보를 저장하는 시스템 테이블
-- 사용자가 테이블을 생성하거나, 사용자를 변경하는 등의 작업을 할 때
-- 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
-- 사용자는 데이터 딕셔너리 내용을 직접 수정하거나 삭제할 수 없음
 
-- 원본 테이블을 커스터마이징 해서 보여주는 원본 테이블의
-- 가상 테이블 객체(VIEW)

-- 3개의 딕셔너리 뷰로 나뉨
-- 1. DBA_XXX : 데이터베이스 관리자만 접근이 가능한 객체 등의 정보 조회
-- 2. ALL_XXX : 자신의 계정 + 권한을 부여받은 객체의 정보 조회
-- 3. USER_XXX : 자신의 계정이 소유한 객체 등에 관한 정보 조회
CREATE OR REPLACE VIEW V_EMP
(
  사번
, 이름
, 부서
)
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
  FROM EMPLOYEE E;

SELECT * FROM V_EMP;

DROP VIEW V_EMP;

-- VIEW(뷰)
-- SELECT 쿼리문을 저장한 객체이다.
-- 실질적인 데이터를 저장하고 있지 않음
-- 테이블을 사용하는 것과 동일하게 사용할 수 있다.
-- CREATE [OR REPLACE] VIEW 뷰이름 AS 서브쿼리

-- 사번, 이름, 직급명, 부서명, 근무지역을 조회하고
-- 그 결과를 V_RESULT_EMP라는 뷰를 생성해서 저장하자.
CREATE OR REPLACE VIEW V_RESULT_EMP
AS
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , C.JOB_NAME
     , B.DEPT_TITLE
     , D.LOCAL_NAME
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
  LEFT JOIN LOCATION D ON(B.LOCATION_ID = D.LOCAL_CODE);

SELECT
       A.*
  FROM V_RESULT_EMP A
 WHERE A.EMP_ID = '205';
 
-- 뷰에 대한 정보를 확인하는 데이터 딕셔너리
SELECT
       A.*
  FROM USER_VIEWS A;
  
-- 베이스 테이블 정보가 변경되면
-- VIEW의 결과도 같이 변경된다.
UPDATE
       EMPLOYEE A
   SET A.EMP_NAME = '정중앙'
 WHERE A.EMP_ID = '205';

SELECT
       A.*
  FROM V_RESULT_EMP A
 WHERE A.EMP_ID = '205';

CREATE OR REPLACE VIEW V_RESULT_EMP
(
  사번
, 이름
, 직급명
, 부서명
, 지역명
)
AS
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , C.JOB_NAME
     , B.DEPT_TITLE
     , D.LOCAL_NAME
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
  LEFT JOIN LOCATION D ON(B.LOCATION_ID = D.LOCAL_CODE);

SELECT
       A.*
  FROM V_RESULT_EMP A;

-- 뷰 서브쿼리 안에 연산 결과의 컬럼도 포함할 수 있다.
CREATE OR REPLACE VIEW V_EMP_JOB
(
  사번
, 이름
, 직급명
, 성별
, 근무년수
)
AS
SELECT A.EMP_ID
     , A.EMP_NAME
     , B.JOB_NAME
     , DECODE(SUBSTR(A.EMP_NO, 8, 1), '1', '남', '여')
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM A.HIRE_DATE)
  FROM EMPLOYEE A
  JOIN JOB B ON(A.JOB_CODE = B.JOB_CODE);
  

-- 뷰로 INSERT시
CREATE OR REPLACE VIEW V_JOB
AS
SELECT A.JOB_CODE
     , A.JOB_NAME
  FROM JOB A;

SELECT * FROM V_JOB;

INSERT
  INTO V_JOB
VALUES
(
  'J8'
, '인턴'
);

SELECT * FROM JOB;

-- 뷰로 UPDATE시
UPDATE
       V_JOB A
   SET A.JOB_NAME = '알바'
 WHERE A.JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- 뷰로 DELETE시
DELETE
  FROM V_JOB A
 WHERE A.JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- DML 명령어로 조작이 불가능한 경우
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
-- 2. 뷰에 포함되지 않은 컬럼 중에,
--    베이스가 되는 테이블 컬럼이 NOT NULL 제약조건이 지정된 경우
-- 3. 산술표현식으로 정의된 경우
-- 4. JOIN을 이용해 여러 테이블을 연결한 경우
-- 5. DISTINCT를 포함한 경우
-- 6. 그룹함수나 GROUP BY 절을 포함한 경우

-- 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB2
AS
SELECT J.JOB_CODE
  FROM JOB J;
  
INSERT
  INTO V_JOB2
(
  JOB_CODE
, JOB_NAME
)
VALUES
(
  'J8'
, '인턴'
);    -- 에러 남

UPDATE
       V_JOB2 V
   SET V.JOB_NAME = '인턴'
 WHERE V.JOB_CODE = 'J7';  -- 에러남
 
-- DELETE는 사용 가능함
INSERT
  INTO V_JOB2
(
  JOB_CODE
)
VALUES
(
  'J8'
);

SELECT
       J.*
  FROM JOB J;
  
DELETE
  FROM V_JOB2 V
 WHERE V.JOB_CODE = 'J8';
 
-- 산술표현식으로 정의 된 경우
CREATE OR REPLACE VIEW EMP_SAL
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.SALARY
     , (E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12 연봉
  FROM EMPLOYEE E;
  
SELECT
       ES.*
  FROM EMP_SAL ES;
  
INSERT
  INTO EMP_SAL
(
  EMP_ID
, EMP_NAME
, SALARY
, 연봉       -- 뷰를 생성시 서브쿼리에서 별칭을 부여하면 뷰의 컬럼명도 별칭이 적용된다.
)
VALUES
(
  '800'
, '정진훈'
, 3000000
, 4000000
);           -- 에러남

UPDATE
       EMP_SAL ES
   SET ES.연봉 = 80000000
 WHERE ES.EMP_ID = '200';  -- 에러남
 
-- DELETE할 때는 사용 가능
DELETE
  FROM EMP_SAL ES
 WHERE ES.연봉 = 124800000;
 
SELECT
       E.*
  FROM EMPLOYEE E;

-- JOIN을 이용해 여러 테이블을 연결한 경우
CREATE OR REPLACE VIEW V_JOINEMP
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

SELECT
       V.*
  FROM V_JOINEMP V;
  
INSERT
  INTO V_JOINEMP
(
  EMP_ID
, EMP_NAME
, DEPT_TITLE
)
VALUES
(
  '888'
, '조세오'
, '인사관리부'
);                     -- 에러남

UPDATE
       V_JOINEMP V
   SET V.DEPT_TITLE = '인사관리부'
 WHERE V.EMP_ID = '219';      -- 에러남

-- 베이스 테이블에만 영향을 끼침 
DELETE
  FROM V_JOINEMP V
 WHERE V.EMP_ID = '219';

SELECT * FROM EMPLOYEE;    -- 베이스 테이블에서는 지워짐
SELECT * FROM DEPARTMENT;  -- 이 테이블은 지워지지 않음

-- DISTINCT를 포함한 경우
CREATE OR REPLACE VIEW V_DT_EMP
AS
SELECT DISTINCT JOB_CODE
  FROM EMPLOYEE;

INSERT
  INTO V_DT_EMP
(
  JOB_CODE
)
VALUES(
  'J9'
);             -- 에러남

UPDATE
       V_DT_EMP V
   SET V.JOB_CODE = 'J9'
 WHERE V.JOB_CODE = 'J7'; -- 에러남
 
DELETE
  FROM V_DT_EMP
 WHERE V.JOB_CODE = 'J7'; -- 에러남

-- 그룹 함수나 GROUP BY 절을 포함한 경우
CREATE OR REPLACE VIEW V_GROUPDEPT
AS
SELECT
       DEPT_CODE
     , SUM(SALARY) 합계
     , AVG(SALARY) 평균
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 
SELECT
       V.*
  FROM V_GROUPDEPT V;
  
INSERT
  INTO V_GROUPDEPT
(
  DEPT_CODE
, 합계
, 평균
)
VALUES
(
  'D0'
, 6000000
, 400000
);        -- 에러남

UPDATE
       V_GROUPDEPT V
   SET V.DEPT_CODE = 'D10'
 WHERE V.DEPT_CODE = 'D1';  -- 에러남

DELETE
  FROM V_GROUPDEPT V
 WHERE V.DEPT_CODE = 'D1';  -- 에러남

-- VIEW 옵션
-- OR REPLACE : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고
--              존재하지 않으면 새로 생성하는 옵션
-- FORCE : 서브쿼리에 사용 된 테이블이 존재하지 않아도 뷰 생성
CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT TCODE
     , TNAME
     , TCONTENTS
  FROM TT;
  
-- NOFORCE : 서브쿼리에 테이블이 존재해야만 뷰 생성함(기본값)
CREATE OR REPLACE /*NOFORCE*/ VIEW V_EMP
AS
SELECT TCODE
     , TNAME
     , TCONTENTS
  FROM TT;
  
-- WITH CHECK OPTION : 조건절에 사용된 컬럼의 값을 수정하지 못하게 한다.
CREATE OR REPLACE VIEW V_EMP2
AS
SELECT E.*
  FROM EMPLOYEE E 
 WHERE MANAGER_ID = '200'
  WITH CHECK OPTION;

UPDATE
       V_EMP2
   SET MANAGER_ID = '900'
 WHERE MANAGER_ID = '200';
 
-- WITH READ ONLY : DML 수행이 불가능
CREATE OR REPLACE VIEW V_DEPT
AS
SELECT D.*
  FROM DEPARTMENT D
  WITH READ ONLY;

DELETE
  FROM V_DEPT;
  
SELECT
       V.*
  FROM V_DEPT V;