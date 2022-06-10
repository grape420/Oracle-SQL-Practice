-- SUBQUERY(서브쿼리)
-- 서브쿼리 : 쿼리문 안에서 사용된 쿼리문
 
-- 사원명이 노옹철인 사람의 부서 조회
SELECT
       DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '노옹철';
 
-- 부서코드가 D9인 직원의 이름을 조회
SELECT
       EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9';
 
-- 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
SELECT
       EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '노옹철'
                   );

-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하세요
SELECT
       AVG(SALARY)
  FROM EMPLOYEE;
  
SELECT
       E1.EMP_ID
     , E1.EMP_NAME
     , E1.JOB_CODE
     , E1.SALARY
  FROM EMPLOYEE E1
 WHERE E1.SALARY > (SELECT AVG(E2.SALARY)
                      FROM EMPLOYEE E2
                   );
                   
-- 서브쿼리의 유형
-- 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 1개의 행일 때
-- 다중행 서브쿼리 : 서브쿼리의 조회 결과값의 행이 여러개일 때
-- 다중열 서브쿼리 : 서브쿼리의 조회 결과값의 컬럼이 여러개일 때
-- 다중행 다중열 서브쿼리 : 조회 결과 행의 수와 열의 수가 여러개일 때

-- 서브쿼리의 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름
-- 단일행 서브쿼리 앞에는 일반 비교 연산자 사용
-- >, <, >=, <=, =, !=/<>/^= (서브쿼리)
 
-- 노옹철 사원의 급여보다 많이 받는 사원의
-- 사번, 이름, 부서코드, 직급코드, 급여를 조회하시오
SELECT
       SALARY
  FROM EMPLOYEE
 WHERE EMP_NAME = '노옹철';
 
SELECT
       E1.EMP_ID
     , E1.EMP_NAME
     , E1.DEPT_CODE
     , E1.JOB_CODE
     , E1.SALARY
  FROM EMPLOYEE E1
 WHERE E1.SALARY > (SELECT SALARY
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '노옹철'
                   );
                   
-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급코드, 부서코드, 급여, 입사일을 조회하세요
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , A.JOB_CODE
     , A.DEPT_CODE
     , A.SALARY
     , A.HIRE_DATE
  FROM EMPLOYEE A
 WHERE A.SALARY = (SELECT MIN(B.SALARY)
                     FROM EMPLOYEE B
                  );
                  
-- 서브쿼리는 SELECT, FROM, WHERE, HAVING, ORDER BY 절에서도 사용할 수 있다.
-- 부서별 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계를 구하시오.
SELECT
       MAX(SUM(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 
SELECT
       D.DEPT_TITLE
     , SUM(E.SALARY)
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) IN (SELECT MAX(SUM(E2.SALARY))
                          FROM EMPLOYEE E2
                         GROUP BY E2.DEPT_CODE
                       );                    

-- 다중행 서브쿼리
-- 다중행 서브쿼리 앞에서는 일반 비교 연산자 사용 못함
-- IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
--               혹은 없다면이라는 의미
-- > ANY, < ANY : 여러 개의 결과값 중에서 한 개라도 큰 / 작은 경우
--                가장 작은 값보다 크냐? / 가장 큰 값보다 작냐?
--                (서브쿼리의 결과들 중에 어떤 것보다도 크거나 작기만 하면 된다.)
-- > ALL, < ALL : 모든 값보다 큰 / 작은 경우
--                가장 큰 값보다 크냐? / 가장 작은 값보다 작냐?
--                (모든 서브쿼리의 결과들 보다 크거나 작아야 한다.)
-- EXISTS / NOT EXISTS : 서브쿼리에만 사용하는 연산자로
--                       값이 존재하냐? / 존재하지 않느냐?

-- 부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여 조회
SELECT
       DEPT_CODE
     , MAX(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 
SELECT
       A.EMP_NAME
     , A.JOB_CODE
     , A.DEPT_CODE
     , A.SALARY
  FROM EMPLOYEE A
 WHERE A.SALARY IN (SELECT MAX(SALARY)
                      FROM EMPLOYEE
                     GROUP BY DEPT_CODE
                   );
                   
-- 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의
-- 정보를 추출하여 조회 하시오
-- (사번, 이름, 부서명, 직급명, '관리자' AS 구분 / '직원' AS 구분)
-- (상사를 두고 있는 사원들(MANAGER_ID가 NULL이 아닌 사람들)의 상사를 중복값 없이 추출)
 
SELECT
       DISTINCT MANAGER_ID
  FROM EMPLOYEE
 WHERE MANAGER_ID IS NOT NULL;

-- 관리자 조회
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.DEPT_TITLE
     , C.JOB_NAME
     , '관리자' AS 구분
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 WHERE A.EMP_ID IN (SELECT DISTINCT MANAGER_ID
                      FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL
                   );

-- 직원 조회
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.DEPT_TITLE
     , C.JOB_NAME
     , '직원' AS 구분
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 WHERE A.EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                          FROM EMPLOYEE
                         WHERE MANAGER_ID IS NOT NULL
                       );

-- 직원 전체 조회
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.DEPT_TITLE
     , C.JOB_NAME
     , '관리자' AS 구분
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 WHERE A.EMP_ID IN (SELECT DISTINCT MANAGER_ID
                      FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL
                   )
UNION
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.DEPT_TITLE
     , C.JOB_NAME
     , '직원' AS 구분
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 WHERE A.EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                          FROM EMPLOYEE
                         WHERE MANAGER_ID IS NOT NULL
                       );

-- 차장 직급 급여의 가장 큰 값보다 많이 받는 과장 직급의(모든 차장들보다 급여를 많이 받는 과장)
-- 사번, 이름, 직급명, 급여를 조회하시오.
-- 단, > ALL 혹은 < ALL 연산자를 사용
  
-- 차장 직급의 급여
SELECT
       A.SALARY
  FROM EMPLOYEE A
  JOIN JOB B ON(A.JOB_CODE = B.JOB_CODE)
 WHERE B.JOB_NAME = '차장';
 
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.JOB_NAME
     , A.SALARY
  FROM EMPLOYEE A
  JOIN JOB B ON(A.JOB_CODE = B.JOB_CODE)
 WHERE B.JOB_NAME = '과장'
   AND A.SALARY > ALL (SELECT A1.SALARY
                         FROM EMPLOYEE A1
                         JOIN JOB B1 ON(A1.JOB_CODE = B1.JOB_CODE)
                        WHERE B1.JOB_NAME = '차장'
                      );
                      
-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는(과장 중에 아무나 한명 보다만 많이 받으면 됨)
-- 직원의 사번, 이름, 직급명, 급여를 조회하시오.
-- 단, > ANY 혹은 < ANY 연산자 사용
SELECT
       A1.SALARY
  FROM EMPLOYEE A1
  JOIN JOB B1 ON(A1.JOB_CODE = B1.JOB_CODE)
 WHERE B1.JOB_NAME = '과장';
 
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.JOB_NAME
     , A.SALARY
  FROM EMPLOYEE A
  JOIN JOB B ON(A.JOB_CODE = B.JOB_CODE)
 WHERE B.JOB_NAME = '대리'
   AND A.SALARY > ANY (SELECT A1.SALARY
                         FROM EMPLOYEE A1
                         JOIN JOB B1 ON(A1.JOB_CODE = B1.JOB_CODE)
                        WHERE B1.JOB_NAME = '과장'
                      );
                      
-- EXISTS / NOT EXISTS
SELECT
       *
  FROM EMPLOYEE
 WHERE EMP_ID = '100';
 
SELECT
       *
  FROM EMPLOYEE
-- WHERE NOT EXISTS (SELECT
--                          *
--                     FROM EMPLOYEE
--                    WHERE EMP_ID = '100');
 WHERE 1 = 0;

-- 자기 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하시오.
-- 단, 급여와 급여 평균은 만원 단위로 계산하시오.(TRUNC(컬럼명, -4))
 
SELECT
       TRUNC(1234567, -4)
  FROM DUAL;
  
-- 직급별 평균 급여(만원단위)
SELECT
       JOB_CODE
     , TRUNC(AVG(SALARY), -4)
  FROM EMPLOYEE
 GROUP BY JOB_CODE;

SELECT
       A.EMP_ID
     , A.EMP_NAME
     , A.JOB_CODE
     , A.SALARY
  FROM EMPLOYEE A
 WHERE A.SALARY IN (SELECT TRUNC(AVG(A1.SALARY), -4)
                      FROM EMPLOYEE A1
                     GROUP BY A1.JOB_CODE);

-- 문제를 정확하게(본인 직급인 것까지 고려해서) 풀기 위해서는 다중열 서브쿼리를 사용해야 한다.
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , A.JOB_CODE
     , A.SALARY
  FROM EMPLOYEE A
 WHERE (A.JOB_CODE, A.SALARY) IN (SELECT A1.JOB_CODE
                                       , TRUNC(AVG(A1.SALARY), -4)
                                    FROM EMPLOYEE A1
                                   GROUP BY A1.JOB_CODE); 
 
-- 다중열 서브쿼리
 
-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회하시오.
SELECT
       DEPT_CODE
     , JOB_CODE
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = 2
   AND ENT_YN = 'Y';
   
SELECT
       A.EMP_NAME
     , A.JOB_CODE
     , A.DEPT_CODE
     , A.HIRE_DATE
  FROM EMPLOYEE A
 WHERE A.DEPT_CODE IN (SELECT A1.DEPT_CODE
                         FROM EMPLOYEE A1
                        WHERE SUBSTR(A1.EMP_NO, 8, 1) = 2
                          AND A1.ENT_YN = 'Y'
                      )
   AND A.JOB_CODE IN (SELECT A2.JOB_CODE
                        FROM EMPLOYEE A2
                       WHERE SUBSTR(A2.EMP_NO, 8, 1) = 2
                         AND A2.ENT_YN = 'Y'
                      )
   AND A.EMP_ID NOT IN (SELECT A3.EMP_ID                        -- 퇴사자들은 제외해야 한다.
                          FROM EMPLOYEE A3
                         WHERE SUBSTR(A3.EMP_NO, 8, 1) = 2
                           AND A3.ENT_YN = 'Y'
                       );

-- 다중열 서브쿼리로 변경
SELECT
       A.EMP_NAME
     , A.JOB_CODE
     , A.DEPT_CODE
     , A.HIRE_DATE
  FROM EMPLOYEE A
 WHERE (A.DEPT_CODE, A.JOB_CODE) IN (SELECT A1.DEPT_CODE
                                          , A1.JOB_CODE  
                                       FROM EMPLOYEE A1
                                      WHERE SUBSTR(A1.EMP_NO, 8, 1) = 2
                                        AND A1.ENT_YN = 'Y'
                                    )
   AND A.EMP_ID NOT IN (SELECT A3.EMP_ID                        -- 퇴사자들은 제외해야 한다.
                          FROM EMPLOYEE A3
                         WHERE SUBSTR(A3.EMP_NO, 8, 1) = 2
                           AND A3.ENT_YN = 'Y'
                       ); 

-- 서브쿼리의 사용 위치 :
-- SELECT절, FROM절, WHERE절, GROUP BY절, HAVING절, ORDER BY절
-- DML 구문 : INSERT문, UPDATE문
-- DDL 구문 : CREATE TABLE문, CREATE VIEW문
 
-- FROM절에서 서브쿼리를 사용할 수 있다 : 테이블 대신에 사용
-- 인라인 뷰(INLINE VIEW)라고 함
-- : 서브쿼리가 만든 결과 집합(RESULT SET)으로부터 시작              
    
-- 직급별 급여 평균(만원단위)
SELECT
       JOB_CODE
     , TRUNC(AVG(SALARY), -4)
  FROM EMPLOYEE
 GROUP BY JOB_CODE;

-- 인라인 뷰에서 연산으로 처리된 컬럼은 메인 쿼리에서 별칭으로만 조회할 수 있다.
SELECT
       JOB_CODE
     , JOBAVG
  FROM (SELECT
               JOB_CODE
             , TRUNC(AVG(SALARY), -4) AS JOBAVG
          FROM EMPLOYEE
         GROUP BY JOB_CODE);

-- 위와같은 인라인 뷰에서 사원명, 급여, 직급명을 알고 싶을 때(추가)
SELECT
       A.JOB_CODE
     , A.JOBAVG
     , B.EMP_NAME
     , B.SALARY
     , C.JOB_NAME
  FROM (SELECT
               JOB_CODE
             , TRUNC(AVG(SALARY), -4) AS JOBAVG
          FROM EMPLOYEE
         GROUP BY JOB_CODE) A
  JOIN EMPLOYEE B ON(B.JOB_CODE = A.JOB_CODE AND A.JOBAVG = B.SALARY)
  JOIN JOB C ON(B.JOB_CODE = C.JOB_CODE);
  
-- 서브쿼리에서 쓰인 별칭은 메인쿼리에서 쓸 수 있다.
SELECT
       A.EMP_NAME 이름
     , B.DEPT_TITLE 부서명
     , C.JOB_NAME 직급명
  FROM EMPLOYEE A
  LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  LEFT JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE);
  
-- 인라인 뷰의 서브쿼리의 컬럼에 별칭을 달면 메인 쿼리에서는 반드시 별칭을 달아줘야 한다.
-- 만약 별칭이 없다면 연산식이 아닌 컬럼일 경우는 메인쿼리에서 컬럼명으로 조회가 가능하다.
-- 단, 인라인 뷰의 서브쿼리에 연산식으로 도출된 컬럼이 있다면 그 때는 인라인뷰에서 반드시
-- 별칭을 달고 메인 쿼리에서도 별칭으로만 조회할 수 있다.
SELECT
       V.이름
     , V.부서명
     , V.직급명
  FROM (SELECT E.EMP_NAME 이름
             , D.DEPT_TITLE 부서명
             , J.JOB_NAME 직급명
          FROM EMPLOYEE E 
          LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
          LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)) V
 WHERE V.부서명 = '총무부';
 
-- ★★ 인라인 뷰를 활용한 TOP-N분석 ★★
-- ORDER BY 한 결과에 ROWNUM을 붙임
-- ROWNUM : 행 번호(순번)을 의미함
SELECT
       ROWNUM
     , SALARY
  FROM EMPLOYEE
 ORDER BY SALARY;
 
-- 급여를 많이 받는 사원을 10명 추출
SELECT
       ROWNUM
     , A.SALARY  
  FROM (SELECT *                              -- 정렬한 결과로부터 출발할 수 있게 인라인 뷰를 활용해야 한다.
          FROM EMPLOYEE
         ORDER BY SALARY DESC) A
 WHERE ROWNUM <= 10;
-- ROWNUM을 조건절에 사용 시에는 반드시 1순위부터 포함되게 범위를 지정해야 한다. ★★★★★
-- 그리고 ROWNUM은 FROM의 결과 행(튜플)에 자동으로 순번이 달리게 된다.
 
-- 급여 평균 3위 안에 드는 부서들의
-- 부서 코드와 부서명, 평균 급여를 조회하시오.
 
SELECT
       A.DEPT_CODE
     , B.DEPT_TITLE
     , AVG(A.SALARY)
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
 GROUP BY A.DEPT_CODE, B.DEPT_TITLE
 ORDER BY 3 DESC;
 
SELECT
       V.DEPT_CODE
     , V.DEPT_TITLE
     , V.평균급여
  FROM (SELECT
               A.DEPT_CODE
             , B.DEPT_TITLE
             , AVG(A.SALARY) 평균급여
          FROM EMPLOYEE A
          JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
         GROUP BY A.DEPT_CODE, B.DEPT_TITLE
         ORDER BY 3 DESC) V
 WHERE ROWNUM <= 3;
  
-- RANK() 함수 : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너뛰고
--               다음 순위를 계싼하는 방식
-- DENSE_RANK() 함수 : 중복되는 순위 이후의 등수를 건너뛰지 않고 이후 등수로 처리
-- FROM 이후 바로 순위를 작성하지 않고 매개변수로 넘어온 정렬 기준대로 정렬 되고 나서 순위를 정함
 
-- 직원 정보에서 급여를 가장 많이 받는 순으로 이름, 급여, 순위를 조회 하시오.
SELECT
       EMP_NAME
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC)
  FROM EMPLOYEE;
  
SELECT
       EMP_NAME
     , SALARY
     , DENSE_RANK() OVER(ORDER BY SALARY DESC)
  FROM EMPLOYEE;
 
-- 직원 테이블에서 보너스 포함한 연봉이 높은 5명의
-- 사번, 이름, 부서명, 직급명, 입사일을 조회하시오.
-- (보너스 포함한 연봉 : 급여 * (1 + 보너스(NVL)) * 12)
-- 인라인 뷰(ORDER BY적용, ROWNUM활용) -> TOP-N분석
SELECT
       A.EMP_ID
     , A.EMP_NAME
     , B.DEPT_TITLE
     , C.JOB_NAME
     , A.HIRE_DATE
     , A.SALARY * (1 + NVL(A.BONUS, 0)) * 12 연봉
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
  JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
 ORDER BY 연봉 DESC;
 
SELECT
       V.사번
     , V.이름
     , V.부서명
     , V.직급명
     , V.입사일
  FROM (SELECT
               A.EMP_ID 사번
             , A.EMP_NAME 이름
             , B.DEPT_TITLE 부서명
             , C.JOB_NAME 직급명
             , A.HIRE_DATE 입사일
             , A.SALARY * (1 + NVL(A.BONUS, 0)) * 12 연봉
          FROM EMPLOYEE A
          JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
          JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
         ORDER BY 연봉 DESC
       ) V
 WHERE ROWNUM <= 5;
 
-- RANK OVER
SELECT
       V.사번
     , V.이름
     , V.부서명
     , V.직급명
     , V.입사일
     , V.순위
  FROM (SELECT
               A.EMP_ID 사번
             , A.EMP_NAME 이름
             , B.DEPT_TITLE 부서명
             , C.JOB_NAME 직급명
             , A.HIRE_DATE 입사일
             , A.SALARY * (1 + NVL(A.BONUS, 0)) * 12 연봉
             , RANK() OVER(ORDER BY A.SALARY * (1 + NVL(A.BONUS, 0)) * 12) 순위   -- OVER의 매개변수에서는 컬럼을 별칭을 쓸 수 없다.
          FROM EMPLOYEE A
          JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
          JOIN JOB C ON(A.JOB_CODE = C.JOB_CODE)
       ) V
 WHERE ROWNUM <= 5;
 
SELECT
       A.EMP_NAME
     , A.SALARY
     , RANK() OVER(ORDER BY SALARY DESC)
  FROM EMPLOYEE A;
  
SELECT
       V.사원명
     , V.급여
     , V.순위
  FROM (SELECT
               A.EMP_NAME 사원명
             , A.SALARY 급여
             , RANK() OVER(ORDER BY SALARY DESC) 순위
          FROM EMPLOYEE A
       ) V
  WHERE ROWNUM <= 5;
 
-- WITH 이름 AS (서브쿼리문)
-- 서브쿼리에 이름을 붙여주고 메인쿼리에서 사용시 이름을 사용하게 됨
-- 인라인뷰로 사용 될 서브쿼리에서 이용됨
-- 같은 서브쿼리가 여러 번 사용 될 경우 중복 작성을 줄일 수 있다.
-- 실행 속도도 빨라진다는 장점이 있고 가독성도 좋다.

  WITH
       TOPN_SAL
    AS (SELECT E.EMP_ID
             , E.EMP_NAME
             , E.SALARY
          FROM EMPLOYEE E
         ORDER BY E.SALARY DESC
       )
SELECT
       ROWNUM
     , T.EMP_NAME
     , T.SALARY
  FROM TOPN_SAL T
 WHERE ROWNUM <= 3;
 
-- 서브쿼리를 다양한 곳에서 써보자.
 
-- 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은
-- 부서의 부서명과 부서별 급여 합계 조회
SELECT
       SUM(SALARY) * 0.2
  FROM EMPLOYEE;
  
SELECT
       B.DEPT_TITLE
     , SUM(A.SALARY)
  FROM EMPLOYEE A
  JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID) 
 GROUP BY B.DEPT_TITLE
HAVING SUM(A.SALARY) > (SELECT SUM(SALARY) * 0.2
                          FROM EMPLOYEE);

-- 인라인 뷰 적용   
SELECT
       V.DT
     , V.SSAL
  FROM (SELECT B.DEPT_TITLE DT
             , SUM(A.SALARY) SSAL
          FROM EMPLOYEE A
          JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID) 
         GROUP BY B.DEPT_TITLE) V
 WHERE V.SSAL > (SELECT SUM(SALARY) * 0.2
                   FROM EMPLOYEE);     
     
-- WITH AS로 서브쿼리 여러개 저장하기
  WITH
       TOTAL_SAL
    AS (SELECT SUM(E.SALARY)
          FROM EMPLOYEE E
       )
     , AVG_SAL
    AS (SELECT AVG(E2.SALARY)
          FROM EMPLOYEE E2
       )
SELECT
       T.*
  FROM TOTAL_SAL T
UNION
SELECT
       A.*
  FROM AVG_SAL A;
  
-- 상[호연]관 서브쿼리
-- 일반적으로는 서브쿼리가 만든 결과값을 메인 쿼리가 비교 연산
-- 메인쿼리가 사용하는 테이블의 값을 서브쿼리가 이용해서 결과를 만듦
-- 메인쿼리의 테이블 값이 변경되면, 서브쿼리의 결과값도 바뀌게 됨
 
-- 관리자 사번이 EMPLOYEE 테이블에 EMP_ID로 존재하는 직원에 대한 조회
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE EXISTS (SELECT E2.EMP_ID
                 FROM EMPLOYEE E2
                WHERE E.MANAGER_ID = E2.EMP_ID
              );
              
-- 동일 직급의 급여 평균보다 급여를 많이 받고 있는 직원의
-- 사번, 직급코드, 급여를 조회하시오.
SELECT
       E.EMP_ID
     , E.JOB_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE E.SALARY > (SELECT AVG(E2.SALARY)
                     FROM EMPLOYEE E2
                    WHERE E.JOB_CODE = E2.JOB_CODE
                  );
                  
-- 스칼라 서브쿼리
-- 상관쿼리 + 단일행 서브쿼리
-- SELECT절, WHERE절, ORDER BY절 사용 가능
 
-- SELECT절에서 스칼라 서브쿼리 이용
-- 모든 사원의 사번, 이름, 관리자 사번, 관리자명을 조회하시오.
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
     , NVL((SELECT M.EMP_NAME
              FROM EMPLOYEE M
             WHERE E.MANAGER_ID = M.EMP_ID
           ), '없음')
  FROM EMPLOYEE E;
  
-- ORDER BY 절에서 스칼라 서브쿼리 이용
-- 모든 사원의 사번, 이름, 부서코드 조회
-- (단, 부서명 내림차순 정렬)(feat. 조인 안쓰기)
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
  FROM EMPLOYEE E
 ORDER BY(SELECT D.DEPT_TITLE
            FROM DEPARTMENT D
           WHERE E.DEPT_CODE = D.DEPT_ID) DESC NULLS LAST;                

------------------------------------------------------------------------------------------------

-- JOIN 연습문제

-- 1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
SELECT 
       TO_CHAR(TO_DATE('20201225', 'YYYYMMDD'), 'DAY')
  FROM DUAL;

-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , E.EMP_NO
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE SUBSTR(E.EMP_NO, 1,2) >= 70 
   AND SUBSTR(E.EMP_NO, 1,2) < 80
   AND SUBSTR(E.EMP_NO, 8,1) = 2
   AND E.EMP_NAME LIKE '전%';

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , E.EMP_NO
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND J.JOB_CODE = E.JOB_CODE
   AND SUBSTR(E.EMP_NO, 1,2) >= 70 
   AND SUBSTR(E.EMP_NO, 1,2) < 80
   AND SUBSTR(E.EMP_NO, 8,1) = 2
   AND E.EMP_NAME LIKE '전%';

-- 3. 가장 나이가 적은 직원의 사번, 사원명, 
--    나이, 부서명, 직급명을 조회하시오.
SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1) 
  FROM EMPLOYEE; -- 34
  
-- ANSI 표준
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 AS 나이
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 = 34;
 
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 AS 나이
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1) 
                                                                                                    FROM EMPLOYEE
                                                                                                 );
              
-- ORACLE 전용
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 AS 나이
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 = 34;
                                                                                                
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 AS 나이
     , D.DEPT_TITLE
     , J.JOB_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1) 
                                                                                                   FROM EMPLOYEE
                                                                                                );

-- 4. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 직급명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE E.EMP_NAME LIKE '%형%';

-- 오라클 전용
SELECT 
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.EMP_NAME LIKE '%형%';

-- 5. 해외영업팀(해외영업1부, 해외영업2부)에 근무하는 사원명, 
--    직급명, 부서코드, 부서명을 조회하시오.
-- 해외 영업팀 부서 코드 확인용
SELECT 
       E.EMP_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);    -- D5, D6

-- ANSI표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 WHERE D.DEPT_ID IN('D5', 'D6');

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.DEPT_CODE
     , D.DEPT_TITLE
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND D.DEPT_ID IN('D5', 'D6');

-- 6. 보너스포인트를 받는 직원들의 사원명, 
--    보너스포인트, 부서명, 근무지역명을 조회하시오.
-- ANSI표준
SELECT 
       E.EMP_NAME
     , E.BONUS
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.BONUS IS NOT NULL;

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , E.BONUS
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.BONUS IS NOT NULL;

-- 7. 부서코드가 D2인 직원들의 사원명, 
--    직급명, 부서명, 근무지역명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
WHERE E.DEPT_CODE = 'D2';

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
     , LOCATION L
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.DEPT_CODE = 'D2';

-- 8. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하시오.
--    연봉에 보너스포인트를 적용하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
     , E.SALARY * 12 + E.SALARY * NVL(E.BONUS, 0)
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN SAL_GRADE S ON(E.SAL_LEVEL = S.SAL_LEVEL)
 WHERE E.SALARY > S.MIN_SAL;

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
     , E.SALARY * 12 + E.SALARY * NVL(E.BONUS, 0) 
  FROM EMPLOYEE E
     , JOB J
     , SAL_GRADE S
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.SAL_LEVEL = S.SAL_LEVEL
   AND E.SALARY > S.MIN_SAL;

-- 9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하시오.
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
  JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
 WHERE N.NATIONAL_NAME IN('한국', '일본');

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
     , NATIONAL N
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND N.NATIONAL_NAME IN('한국', '일본');

-- 10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 
--     동료이름을 조회하시오.self join 사용
-- ANSI 표준
-- 동료이름
SELECT
       A.EMP_NAME
     , A.DEPT_CODE
     , B.EMP_NAME
  FROM EMPLOYEE A
  JOIN EMPLOYEE B ON(B.DEPT_CODE = B.DEPT_CODE)
 WHERE A.EMP_NO != B.EMP_NO;    -- 462

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
-- ANSI 표준
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE NVL(E.BONUS, 0)= 0 
   AND J.JOB_CODE IN('J4', 'J7');

-- 오라클 전용
SELECT 
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND NVL(E.BONUS, 0)= 0 
   AND J.JOB_CODE IN('J4', 'J7');

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
SELECT 
       DECODE(ENT_YN, 'Y', '퇴사자', '재직자')
     , COUNT(*)
  FROM EMPLOYEE
 GROUP BY ENT_YN;