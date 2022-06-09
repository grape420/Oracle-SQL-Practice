-- 조인(JOIN)
-- JOIN : 한 개 이상의 테이블을 하나로 합쳐서 하나의 결과(RESULT SET)으로 조회하기 위해 사용 된다.

-- 오라클 전용 구문
-- FROM절에 ','로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시한다.

-- 연결에 사용할 두 컬럼명이 다른경우
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , DEPT_TITLE
     , LOCATION_ID
  FROM EMPLOYEE
    ,  DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID;

-- 연결에 사용할 두 컬럼명이 같은 경우
SELECT
       EMPLOYEE.EMP_ID
     , EMPLOYEE.EMP_NAME
     , EMPLOYEE.JOB_CODE
     , JOB.JOB_NAME
  FROM EMPLOYEE
    ,  JOB
 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 테이블에서 FROM절에서 별칭 사용
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , J.JOB_NAME
  FROM EMPLOYEE E
    ,  JOB J
 WHERE E.JOB_CODE = J.JOB_CODE;

-- ANSI 표준 구문
-- ★컬럼명에 대한 조건을 ON()을 사용할 수 있다.★
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);
 
-- 컬럼명이 같은 경우 USING()을 사용할 수 있음
SELECT
       EMP_ID
     , EMP_NAME
     , JOB_CODE
     , JOB_NAME
  FROM EMPLOYEE 
  JOIN JOB USING(JOB_CODE);
  
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
 
-- 부서 테이블과 지역 테이블을 조인하여 테이블에 모든 데이터를 조회해 보자.
-- ANSI 표준
SELECT
       *
  FROM DEPARTMENT
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 오라클 전용
SELECT
       *
  FROM DEPARTMENT D
     , LOCATION L
 WHERE D.LOCATION_ID = L.LOCAL_CODE;
 
-- 조인은 기본이 EQUAL JOIN이다. (EQU JOIN이라고도 함)
-- 연결되는 컬럼의 값이 일치하는 행들만 조인됨

-- 일치하는 값이 없는 행은 조인에서 제외되는 것을 INNER JOIN이라고 한다.

-- JOIN의 기본은 INNER JOIN & EQU JOIN이다.

-- OUTER JOIN : 두 테이블의 지정하는 컬럼 값이 일치하는 않는 행도 조인에 포함시킴
--              반드시 OUTER JOIN임을 명시해야 한다.
 
-- 1. LEFT OUTER JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술 된
--                      테이블의 행의 수를 기준으로 JOIN

-- 2. RIGHT OUTER JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술 된
--                       테이블의 행의 수를 기준으로 JOIN

-- 3. FULL OUTER JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을
--                      결과에 포함하여 JOIN

-- ANSI 표준의 INNER JOIN
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
  
-- 1. LEFT OUTER JOIN
-- ANSI 표준의 LEFT OUTER JOIN
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
--  LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);            -- LEFT OUTER은 OUTER 생략 가능
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
 
-- 오라클 전용 LEFT OUTER JOIN
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
     , DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID(+);
 
-- 2. RIGHT OUTER JOIN
-- ANSI 표준  
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
 RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
 
-- 오라클 전용 구문
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
     , DEPARTMENT
 WHERE DEPT_CODE(+) = DEPT_ID;
 
-- 3. FULL OUTER JOIN
-- ANSI 표준
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
  
-- 오라클 전용 구문
-- 오라클 전용 구문으로는 FULL OUTER JOIN을 하지 못한다.
 
 
-- CROSS JOIN : 카테이션곱 이라고도 한다.
--              조인되는 테이블들의 각 행들이 모두 매핑되게 데이터를 검색하는 방법이다.(의도하지 않고 잘못된 방법)
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
 CROSS JOIN DEPARTMENT;


-- NON EQUAL JOIN(NON EQU JOIN)
-- : 지정한 컬럼의 값이 정확히 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식

-- ANSI 표준
SELECT
       EMP_NAME
     , SALARY
     , E.SAL_LEVEL
     , S.SAL_LEVEL
  FROM EMPLOYEE E
  JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);
  
SELECT * FROM EMPLOYEE;
SELECT * FROM SAL_GRADE;
 
-- 오라클 표준
SELECT
       EMP_NAME
     , SALARY
     , E.SAL_LEVEL
     , S.SAL_LEVEL
  FROM EMPLOYEE E
     , SAL_GRADE S
 WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;
 
-- SELE JOIN : 같은 테이블을 조인하는 경우
--             자기 자신 테이블과 조인을 맺는 것이다.

-- ANSI 표준
SELECT 
       E1.EMP_ID 
     , E1.EMP_NAME 사원이름
     , E1.DEPT_CODE
     , E1.MANAGER_ID
     , E2.EMP_NAME 관리자이름
  FROM EMPLOYEE E1
  LEFT JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID)
 ORDER BY 1;
 
-- 오라클 전용
SELECT 
       E1.EMP_ID 
     , E1.EMP_NAME 사원이름
     , E1.DEPT_CODE
     , E1.MANAGER_ID
     , E2.EMP_NAME 관리자이름
  FROM EMPLOYEE E1
     , EMPLOYEE E2 
 WHERE E1.MANAGER_ID = E2.EMP_ID(+)
 ORDER BY 1;

-- 다중 JOIN : N개(3개 이상)의 테이블을 조회할 때 사용(조인 순서(테이블 순서)가 중요!!!)
-- ANSI 표준
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , L.NATIONAL_CODE
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  LEFT JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE EMP_ID = '210';
  
-- 오라클 전용
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , L.NATIONAL_CODE
  FROM EMPLOYEE E
     , DEPARTMENT D 
     , LOCATION L 
 WHERE E.DEPT_CODE = D.DEPT_ID(+)
   AND D.LOCATION_ID = L.LOCAL_CODE(+)
   AND EMP_ID = '210';

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하시오.
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , E.SALARY
  FROM EMPLOYEE E
      JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
      JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
      JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE J.JOB_NAME = '대리'
   AND L.LOCAL_NAME LIKE 'ASIA%';
   
-- 오라클 전용  
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , E.SALARY
  FROM EMPLOYEE E
     , JOB J 
     , DEPARTMENT D 
     , LOCATION L 
 WHERE E.JOB_CODE = J.JOB_CODE(+)
   AND E.DEPT_CODE = D.DEPT_ID(+)
   AND D.LOCATION_ID = L.LOCAL_CODE(+)
   AND J.JOB_NAME = '대리'
   AND L.LOCAL_NAME LIKE 'ASIA%';
   
--------------------------------------------------------------------------------------
-- JOIN 연습문제

-- 1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
SELECT
       TO_CHAR(TO_DATE('20201225', 'RRRRMMDD'), 'DAY')
  FROM DUAL;


-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT
       E.EMP_NAME 사원명
     , E.EMP_NO 주민번호
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE E.EMP_NAME LIKE '전%'
   AND E.EMP_NO LIKE '7%'
   AND SUBSTR(EMP_NO, 8,1) IN ('2', '4');


-- 3. 가장 나이가 적은 직원의 사번, 사원명, 
--    나이, 부서명, 직급명을 조회하시오.
SELECT
       EMP_ID 사번
     , EMP_NAME 사원명
     , FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE((SUBSTR(EMP_NO, 1, 6)), 'RRMMDD'))/12) + 1 나이
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);





-- 4. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 부서명을 조회하시오.
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.DEPT_TITLE
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON (A.DEPT_CODE = B.DEPT_ID)
 WHERE A.EMP_NAME LIKE '%형%';

-- 5. 해외영업팀에 근무하는 사원명, 
--    직급명, 부서코드, 부서명을 조회하시오.
SELECT
       A.EMP_ID
     , C.JOB_NAME
     , A.DEPT_CODE
     , B.DEPT_TITLE
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 WHERE A.DEPT_CODE IN ('D5', 'D6');

-- 6. 보너스포인트를 받는 직원들의 사원명, 
--    보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT
       A.EMP_NAME
     , A.BONUS
     , B.DEPT_TITLE
     , C.LOCAL_NAME
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  JOIN LOCATION C ON(B.LOCATION_ID = C.LOCAL_CODE)
 WHERE A.BONUS IS NOT NULL;


-- 7. 부서코드가 D2인 직원들의 사원명, 
--    직급명, 부서명, 근무지역명을 조회하시오.
SELECT
       A.EMP_NAME
     , C.JOB_NAME
     , B.DEPT_TITLE
     , D.LOCAL_NAME
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
  JOIN LOCATION D ON(B.LOCATION_ID = D.LOCAL_CODE)
 WHERE DEPT_CODE = 'D2';

-- 8. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하시오.
--    연봉에 보너스포인트를 적용하시오.
SELECT
       A.EMP_NAME 사원명
     , B.JOB_NAME 직급명
     , A.SALARY 급여
     , (SALARY * (1 + NVL(A.BONUS, 0) * 12)) 연봉
     , C.MIN_SAL 최소급여
  FROM EMPLOYEE A
  JOIN JOB B ON(A.JOB_CODE = B.JOB_CODE)
  JOIN SAL_GRADE C ON(A.SAL_LEVEL = C.SAL_LEVEL)
 WHERE C.MIN_SAL < A.SALARY;
 
-- 9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT
       A.EMP_NAME
     , B.DEPT_TITLE
     , D.LOCAL_NAME
     , E.NATIONAL_NAME
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  JOIN LOCATION D ON(B.LOCATION_ID = D.LOCAL_CODE)
  JOIN NATIONAL E ON(D.NATIONAL_CODE = E.NATIONAL_CODE);

-- 10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 
--     동료이름을 조회하시오.self join 사용
SELECT
       A.EMP_NAME
     , A.DEPT_CODE
     , B.EMP_NAME
  FROM EMPLOYEE A
  JOIN EMPLOYEE B ON(B.DEPT_CODE = B.DEPT_CODE)
 WHERE A.EMP_NO = B.EMP_NO;
 
 -- 상사이름 
SELECT
       A.EMP_NAME
     , A.DEPT_CODE
     , B.EMP_NAME
  FROM EMPLOYEE A
  JOIN EMPLOYEE B ON(A.MANAGER_ID = B.EMP_ID)
 WHERE A.DEPT_CODE = B.DEPT_CODE;


-- 11. 보너스포인트가 없는 직원들 중에서 직급코드가 
--     J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
--     단, join과 IN 사용할 것
SELECT
       A.EMP_NAME
     , B.DEPT_TITLE
     , A.SALARY
     , A.BONUS
     , A.JOB_CODE
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 WHERE A.BONUS IS NULL
   AND A.JOB_CODE IN('J7', 'J4');

-- 12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
SELECT
       DECODE(ENT_YN, 'Y', '퇴직자', 'N', '재직자')
     , COUNT(*)
  FROM EMPLOYEE
 GROUP BY ENT_YN;
 