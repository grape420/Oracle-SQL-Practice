-- GROUP BY와 HAVING 그리고 ORDER BY

-- ORDER BY 절 : SELECT한 결과(RESULT SET)에서 컬럼을 기준으로 정렬을 할 때 사용함
-- ORDER BY 컬럼명 | 컬럼별칭 | 컬럼나열 순번 (ASC) | DESC [NULLS FIRST | LAST]

-- ORDER BY 컬럼명 정렬방식, 컬럼명 정렬방식, 컬럼명 정렬방식...
-- 첫 번째 기준으로 하는 컬럼에 대해 정렬하고
-- 같은 값들에 대해 두 번째 기준 컬럼으로 정렬을 하게 되는 방식이 진행됨

-- SELECT 구문 맨 마지막에 위치함
-- ★★★실행 순서도 맨 마지막에 실행 됨★★★

/*
 5. SELECT
 1. FROM
 2. WHERE
 3. GROUP BY
 4. HAVING
 6. ORDER BY
*/

SELECT
       EMP_NAME
     , SALARY  급여
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '%하%'
-- ORDER BY SALARY ASC                -- SALARY 컬럼을 오름차순
-- ORDER BY SALARY ASC                -- ASC나 DESC를 안쓰면 기본이 오름차순
-- ORDER BY SALARY DESC;
-- ORDER BY 2;                        -- 숫자를 RESULT SET의 컬럼 순서를 뜻한다
 ORDER BY 급여;
 
SELECT
       *
  FROM EMPLOYEE
 ORDER BY DEPT_CODE DESC NULLS LAST, JOB_CODE DESC;
 
-- GROUP BY
SELECT
       DEPT_CODE
     , SUM(SALARY)
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 WHERE DEPT_CODE IS NOT NULL
 GROUP BY DEPT_CODE;
 
-- 부서별로 인원수를 세는데(COUNT 함수) 그룹별 인원수를 전체 출력할 수 도 있고 특정 기준 컬럼의 값이 NULL인 사람을 제외하고 셀 수도 있다.
SELECT
       COUNT(*)
     , COUNT(DEPT_CODE)
     , COUNT(BONUS)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 
-- 그룹 두 개이상 묶어보기
SELECT
       DEPT_CODE
     , JOB_CODE 
     , COUNT(*)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
        , JOB_CODE
 ORDER BY 1 NULLS FIRST;
 
-- 직원 테이블에서 부서 코드별 그룹을 지정하여
-- 부서코드, 그룹별 급여의 합계,
-- 그룹별 급여의 평균(정수처리), 인원수 조회하고
-- 부서코드 순으로 정렬(오름차순)하시오.

SELECT
       DEPT_CODE
     , SUM(SALARY)
     , FLOOR(AVG(SALARY))
     , COUNT(*)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
 ORDER BY 1;
 
-- 직원 테이블에서 직급별 직급코드, 보너스를 받는 사원수를 조회하여
-- 직급코드 순으로 오름차순 정렬하시오.

SELECT
       JOB_CODE
     , COUNT(*)
  FROM EMPLOYEE
 WHERE BONUS IS NOT NULL
 GROUP BY JOB_CODE
 ORDER BY 1;
 
-- 보너스를 안받는 직급도 결과(RESULT SET)으로 조회가 된다.
--SELECT
--       JOB_CODE
--     , COUNT(BONUS)
--  FROM EMPLOYEE
-- GROUP BY JOB_CODE
-- ORDER BY 1;
 
-- 직원 테이블에서 주민번호의 8번째 자리를 조회하여
-- 1이면 남, 2면 여로 결과 조회하고
-- 성별별 급여 평균(정수처리), 급여 합계, 인원수를 조회한 뒤
-- 인원수로 내림차순 정렬하시오.
SELECT
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별
     , FLOOR(AVG(SALARY)) "급여의 평균"
     , SUM(SALARY) "급여의 합계"
     , COUNT(*) "성별의 인원수"
  FROM EMPLOYEE
 GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여');
 
-- GROUP BY 절 : 같은 값들이 여러 개 기록된 컬럼(기존 테이블 컬럼 혹은 RESULT SET의 컬럼)을 가지고
--               같은 값들을 하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ...
-- 여러 개의 값을 묶어서 하나의 그룹단위로 처리 할 목적으로 사용한다.
-- 그룹으로 묶은 값에 대해서 SELECT절에서는 그룹함수를 사용한다.

-- HAVING 절 : 그룹함수로 구해 올 그룹에 대해 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

-- 300만원 이상을 받는 사원들의 부서별 평균 급여(SALARY)를 구해 보자. (개인별)
SELECT
       DEPT_CODE
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 WHERE SALARY >= 3000000                -- 단일행 함수만 쓸 수 있음
 GROUP BY DEPT_CODE
 ORDER BY 1;

-- 급여 평균이 300만원 이상인 부서 사원들의 부서별 평균 급여(SALARY)를 구해 보자. (그룹별)
-- HAVING은 그룹합수만 가능
SELECT
       DEPT_CODE
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000    --그룹 함수만 쓸 수 있음
 ORDER BY 1;

-- 급여 합계가 가장 많은 부서의 부서 코드와 급여 합계를 구하시오.

-- 급여 합계
SELECT
       MAX(SUM(SALARY))         
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;        -- 17700000

-- 부서코드와 급여 합계
SELECT
       DEPT_CODE
     , SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 서브 쿼리를 활용하면 하나의 쿼리로 작성이 가능하다.
SELECT
       DEPT_CODE
     , SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT
                             MAX(SUM(SALARY))         
                        FROM EMPLOYEE
                       GROUP BY DEPT_CODE);
                       
-- 집계함수
-- ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수
-- GROUP BY 절에서만 사용하는 함수
-- 그룹별로 묶여진 값에 대한 중간 집계와 총 집계를 구할 때 사용한다.
-- 그룹별로 계산된 결과값들에 대한 총 집계가 자동으로 추가됨.
SELECT
       JOB_CODE
     , SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY ROLLUP(JOB_CODE);

-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수
SELECT
       JOB_CODE
     , SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY CUBE(JOB_CODE)
 ORDER BY 1 NULLS LAST;
 
-- 인자 두개로 그룹을 만들어 집계함수 적용
SELECT
       DEPT_CODE
     , JOB_CODE
     , SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
 ORDER BY 1;
 
SELECT
       DEPT_CODE
     , JOB_CODE
     , SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY CUBE(DEPT_CODE, JOB_CODE)
 ORDER BY 1;

-- GROUPING 함수 : ROLLUP이나 CUBE에 의한 산출물이
-- 인자로 전달받은 컬럼 집합의 산출물이면 0을 반환하고,
-- 아니면 1을 반환하는 함수
SELECT
       DEPT_CODE
     , JOB_CODE
     , SUM(SALARY)
     , GROUPING(DEPT_CODE) "부서별 그룹묶인 상태"
     , GROUPING(JOB_CODE) "직급별 그룹묶인 상태"
  FROM EMPLOYEE
 GROUP BY CUBE(DEPT_CODE, JOB_CODE)
 ORDER BY 1;

SELECT
       DEPT_CODE
     , JOB_CODE
     , SUM(SALARY)
     , CASE
        WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별합계'
        WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직급별합계'
        WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1 THEN '총합계'
        ELSE '그룹별합계'
        END AS 구분
  FROM EMPLOYEE
 GROUP BY CUBE(DEPT_CODE, JOB_CODE)
 ORDER BY 1;
 
-- SET OPERATOR(집합 연산)
-- UNION : 여러 개의 쿼리 결과 튜플들을 하나로 합치는 연산자이다.
--         
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
UNION
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE SALARY > 3000000;
 
-- UNION ALL : 여러 개의 쿼리 결과 튜플들을 하나로 합치는 연산자이다.
--             UNION과 차이점은 중복 영역을 모두 포함시킨다는 것이다.
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE SALARY > 3000000
 ORDER BY 2;

-- INTERSECT : 여러 개의 SELECT한 결과에서 공통 부분만 결과로 추출(교집합)
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE SALARY > 3000000
 ORDER BY 2;

-- MINUS : 선행 SELECT 쿼리 결과 튜플들에서 다음 SELECT한 결과 튜플과 겹치는 부분을
--         제외한 나머지 부분만 추출(차집합) (순서를 주의하자)
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
MINUS
SELECT
      EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
 FROM EMPLOYEE
 WHERE SALARY > 3000000
 ORDER BY 2;

-- GROUPING SETS : 그룹별로 처리 된 여러 개의 SELECT문을 하나로
--                 합칠 때 사용한다. SET OPERATOR와 결과가 동일하다.
SELECT
       DEPT_CODE
     , JOB_CODE
     , MANAGER_ID
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID;

SELECT
       DEPT_CODE
     , MANAGER_ID
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE, MANAGER_ID;

SELECT
       JOB_CODE
     , MANAGER_ID
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 GROUP BY JOB_CODE, MANAGER_ID;

SELECT
       DEPT_CODE
     , JOB_CODE
     , MANAGER_ID
     , FLOOR(AVG(SALARY))
  FROM EMPLOYEE
 GROUP BY GROUPING SETS ((DEPT_CODE, JOB_CODE, MANAGER_ID)
                       , (DEPT_CODE, MANAGER_ID)
                       , (JOB_CODE, MANAGER_ID));

 
 .