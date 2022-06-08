-- SELECT 기본 문법 및 연산자

-- 모든 행 모든 컬럼 조회
-- EMPLOYEE 테이블에서 모든 정보 조회
SELECT
       *                -- 7칸 띄우기
  FROM EMPLOYEE;        -- 2칸 띄우기
  
-- CHAR 관련 문자에 대한 테스트
CREATE TABLE CHARTEST(
    CH1 CHAR(6),
    CH2 CHAR(9),
    CH3 CHAR(3),
    CH4 CHAR(3)
);

INSERT
  INTO CHARTEST
VALUES
(
  '김치'
, '김치'
, '김'
, ''
);

SELECT
       *
  FROM CHARTEST;

SELECT
       LENGTH(CH1)
     , LENGTH(CH2)
     , LENGTH(CH3)
     , LENGTH(CH4)
  FROM CHARTEST;
  
SELECT
       LENGTHB(CH1)
     , LENGTHB(CH2)
     , LENGTHB(CH3)
     , LENGTHB(CH4)
  FROM CHARTEST;
  
-- VARCHAR2 관련 문자에 대한 테스트
CREATE TABLE CHARTEST4(
    CH1 NVARCHAR2(2),
    CH2 NVARCHAR2(9),
    CH3 NVARCHAR2(3),
    CH4 NVARCHAR2(3)
);

INSERT
  INTO CHARTEST4
VALUES
(
  '김'
, '치'
, 'KIM'
, '김'
);

SELECT
       *
  FROM CHARTEST2;

SELECT
       LENGTH(CH1)
     , LENGTH(CH2)
     , LENGTH(CH3)
     , LENGTH(CH4)
  FROM CHARTEST4;
  
SELECT
       LENGTHB(CH1)
     , LENGTHB(CH2)
     , LENGTHB(CH3)
     , LENGTHB(CH4)
  FROM CHARTEST4;


-- 원하는 컬럼 조회
-- EMPLOYEE 테이블의 사번(사원번호), 이름 조회
SELECT
       *
  FROM EMPLOYEE;

SELECT
       EMP_ID
     , EMP_NAME
  FROM EMPLOYEE;

-- 원하는 행 조회
-- EMPLOYEE 테이블에서 부서코드가 D9인 사원 조회
SELECT
       *
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9';
 
-- EMPLOYEE 테이블에서 직급코드가 J1인 사원 조회
SELECT
       *
  FROM EMPLOYEE
 WHERE JOB_CODE = 'J1';
 
-- 원하는 행과 컬럼 조회
-- EMPLOYEE 테이블에서 급여가 300만원 이상인 사원의
-- 사번, 이름, 부서코드, 급여를 조회하세요
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY >= 3000000;
 
-- 컬럼에 별칭짓기
-- AS + 별칭을 기술하여 별칭을 지어줄 수 있다.
SELECT
       EMP_NAME 이름                                          -- AS 생략 가능
     , SALARY * 12 "1년 급여(원)"                              -- ""는 특수기호나 띄어쓰기가 있을 때는 반드시 작성해야 한다.
--     , (SALARY + (SALARY * BONUS)) * 12 AS "총 소득(원)"     -- BUNUS가 NULL인 사람은 계산 결과가 NULL이 됨
--     , SALARY * (1 + BONUS) * 12 AS "총 소득(원)"
     , SALARY * (1 + NVL(BONUS, 0)) * 12 AS "총 소득(원)"      -- NVL을 써서 NULL을 0으로 처리해서 계산 되게 함
  FROM EMPLOYEE;
  
-- NVL 함수를 통한 NULL 값 처리
SELECT
       EMP_ID
     , NVL(BONUS, 0) AS "NVL 처리"           -- NULLVALUE를 줄인말로 NULL값을 0으로 처리
  FROM EMPLOYEE;
  
-- DISTINCT 키워드 (SELECT 절에서 DISTINCT 키워드는 딱 한번만 쓸 수 있다.)
SELECT
       DISTINCT JOB_CODE
--     , DISTINCT DEPT_CODE
  FROM EMPLOYEE;
  
-- WHERE절
-- 테이블에서 조건을 만족하는 값을 가진 행(튜플)을 골라냄
-- 여러 개의 조건을 만족하는 행을 골라 낼 때는 AND 혹은 OR을 사용할 수 있다.

-- 부서코드가 D6이고 급여를 200만원보다 많이 받는 직원의
-- 이름, 부서코드, 급여 조회

SELECT
       EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D6'
   AND SALARY >= 2000000;
   
-- 보너스를 받지 않는 사원에 대해
-- 사번, 직원명, 급여, 보너스를 조회
SELECT
       EMP_ID
     , EMP_NAME
     , SALARY
     , BONUS
  FROM EMPLOYEE
-- WHERE BONUS IS NULL;         -- 보너스를 받지 않는 경우
 WHERE BONUS IS NOT NULL;       -- 보너스를 받는 경우
  
-- 연결 연산자(||)를 이용하여 여러 컬럼을 하나의 컬럼인 것처럼
-- 연결 할 수 있다.

-- 컬럼과 컬럼을 연결할 수 있다.
SELECT
       EMP_ID || EMP_NAME || SALARY "한방에 보는 컬럼"
  FROM EMPLOYEE;
  
SELECT
       EMP_NAME || '의 월급은' || SALARY || '원 입니다.'
  FROM EMPLOYEE;
    
-- 비교 연산자
-- = 같다, > 크냐, > 작냐, >= 크거나 같냐, <= 작거나 같냐
-- !=, ^=, <> 같지 않다
 
-- D9부서에서 근무하지 않는 사원의
-- 사번, 이름, 부서코드를 조회
 
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
  FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D9';
-- WHERE DEPT_CODE ^= 'D9';
 WHERE DEPT_CODE <> 'D9';
 
-- 풀어보기
-- EMPLOYEE 테이블에서 퇴사여부가 N인 직원을 조회하고
-- 사번, 이름, 입사일을 별칭을 사용해 조회해보기
-- (퇴사여부 컬럼은 ENT_YN이고 N은 퇴사 안 한사람, Y는 퇴사 한 사람) 
--SELECT * FROM EMPLOYEE;
SELECT
       EMP_ID 사번
     , EMP_NAME "이름"
     , HIRE_DATE AS "입사일"
     , '재직자' "퇴직여부"
  FROM EMPLOYEE
 WHERE ENT_YN = 'N';
 
-- EMPLOYEE 테이블에서 급여를 350만원 이상
-- 550만원 이하를 받는
-- 직원의 사번, 이름, 급여, 부서코드, 직급코드를 조회하세요
SELECT
       EMP_ID
     , EMP_NAME
     , SALARY
     , DEPT_CODE
     , JOB_CODE
  FROM EMPLOYEE
 WHERE SALARY >= 3500000
   AND SALARY <= 5500000;
   
-- BETWEEN AND 사용
-- 컬럼명 BETWEEN 하한값 AND 상한값
-- : 하한값 이상, 상한값 이하의 값
SELECT
       EMP_ID
     , EMP_NAME
     , SALARY
     , DEPT_CODE
     , JOB_CODE       
  FROM EMPLOYEE
 WHERE SALARY BETWEEN 3500000 AND 5500000;
 
-- 반대로 350만원 미만, 또는 550만원을 초과하는
-- 직원의 사번, 이름, 부서코드, 급여를 조회하시오.
SELECT
       EMP_ID
     , EMP_NAME
     , SALARY
     , DEPT_CODE
     , JOB_CODE
  FROM EMPLOYEE
-- WHERE SALARY < 3500000
--    OR SALARY > 5500000;
-- WHERE NOT SALARY BETWEEN 3500000 AND 5500000;  
 WHERE SALARY NOT BETWEEN 3500000 AND 5500000;
 
-- LIKE 연산자 : 문자 패턴이 일치하는 값을 조회할 때 사용
-- 컬럼명 LIKE '문자패턴'
-- 문자패턴 : '글자%'(글자로 시작하는 값),
--           '%글자%'(글자가 포함된 값),
--           '%글자'(글자로 끝나는 값)

-- EMPLOYEE 테이블에서 성이 김씨인 직원의
-- 사번, 이름, 입사일 조회
SELECT
       EMP_ID
     , EMP_NAME
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '김%';
 
-- EMPLOYEE 테이블에서 성이 김씨 성이 아닌 직원의
-- 사번, 이름, 입사일 조회
SELECT
       EMP_ID
     , EMP_NAME
     , HIRE_DATE
  FROM EMPLOYEE
-- WHERE EMP_NAME NOT LIKE '김%';
 WHERE NOT EMP_NAME LIKE '김%';
   
-- EMPLOYEE 테이블에서 '하'가 이름에 포함 된
-- 직원의 이름, 주민번호, 부서코드 조회
SELECT
       EMP_NAME
     , EMP_NO
     , NVL(DEPT_CODE, '부서 없음')
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '%하%';
 
-- 와일드카드 : _(글자 한자리), %(0개 이상의 글자)
 
-- EMPLOYEE 테이블에서 전화번호 국번이 3자리 이면서 9로 시작하는
-- 직원의 사번, 이름, 전화번호를 조회하세요
SELECT
       EMP_ID
     , EMP_NAME
     , PHONE
  FROM EMPLOYEE
 WHERE PHONE LIKE '___9%';
 
-- 9뒤에 7개의 번호가 있는 전화번호만 조회
SELECT
       EMP_ID
     , EMP_NAME
     , PHONE
  FROM EMPLOYEE
 WHERE PHONE LIKE '___9_______'; 
 
-- EMPLOYEE 테이블에서 _앞글자가 3자리인 이메일 주소를 가진
-- 사원의 사번, 이름, 이메일주소 조회
SELECT
       EMP_ID
     , EMP_NAME
     , EMAIL
  FROM EMPLOYEE
 WHERE EMAIL LIKE '___#_%' ESCAPE '#';
 
-- 이씨 성이 아닌 직원의 사번, 이름, 이메일 주소 조회
SELECT
       EMP_ID
     , EMP_NAME
     , EMAIL
  FROM EMPLOYEE
-- WHERE EMP_NAME NOT LIKE '이%';
 WHERE NOT EMP_NAME LIKE '이%';

-- IN 연산자 : 비교하려는 값 목록에 일치하는 값이 있는지 확인 (OR연산자를 대신 할 수 있다.)
-- D6부서 이거나 D8 부서인 직원들의 이름, 부서코드, 급여를 조회해보자.
SELECT
       EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6'
--    OR DEPT_CODE = 'D8'
--    OR DEPT_CODE = 'D9';
 WHERE DEPT_CODE IN ('D6', 'D8', 'D9');
 
-- D6부서나 D8부서가 아닌 사원 조회
SELECT
       EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
-- WHERE DEPT_CODE NOT IN ('D6', 'D8');
 WHERE NOT DEPT_CODE IN ('D6', 'D8');

-- 연산자 우선순위
/* 
 1. 산술연산자
 2. 연결연산자
 3. 비교연산자
 4. IS NULL/IS NOT NULL, LIKE/NOT LIKE, IN/NOT IN
 5. BETWEEN AND/NOT BETWEEN AND
 6. NOT
 7. AND
 8. OR
*/ 
-- J2직급이면서 급여 200만원 이상 받는 직원이거나
-- J7직급인 직원의 이름, 급여, 직급코드 조회
SELECT
       EMP_NAME
     , SALARY
     , JOB_CODE
  FROM EMPLOYEE
 WHERE JOB_CODE = 'J7'
    OR SALARY >= 2000000
   AND JOB_CODE = 'J2';
 
-- J2직급이거나 J7직급인 직원들 중에
-- 급여가 200만원 이상인 직원의
-- 이름, 급여, 직급코드를 조회
SELECT
       EMP_NAME
     , SALARY
     , JOB_CODE
  FROM EMPLOYEE
-- WHERE (JOB_CODE = 'J2'
--    OR JOB_CODE = 'J7')
--   AND SALARY >= 2000000;
 WHERE JOB_CODE IN ('J2', 'J7')
   AND SALARY >= 2000000;
