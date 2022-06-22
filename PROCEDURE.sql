-- 프로시저(PROCEDURE)
-- : PL/SQL문을 저장하는 객체이다.
--   필요 할 때마다 복잡한 구문을 다시 입력 할 필요 없이
--   호출을 통해서 간단히 실행시키기 위한 목적으로 사용된다.
CREATE TABLE EMP_DUP
AS
SELECT E.*
  FROM EMPLOYEE E;
  
SELECT * FROM EMP_DUP;

-- 프로시저 생성
CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
BEGIN
  DELETE
    FROM EMP_DUP;
  COMMIT;
END;
/

EXECUTE DEL_ALL_EMP;

-- 줄여서 쓸 수 있다.
EXEC DEL_ALL_EMP;       

SELECT * FROM EMP_DUP;

-- 프로시저를 관리하는 데이터 딕셔너리
SELECT
       US.*
  FROM USER_SOURCE US;
  
-- 매개변수 있는 프로시저
CREATE OR REPLACE PROCEDURE DEL_EMP_ID
(
  V_EMP_ID EMPLOYEE.EMP_ID%TYPE
)
IS
BEGIN
  DELETE
    FROM EMPLOYEE E
   WHERE E.EMP_ID = V_EMP_ID;
END;
/

EXEC DEL_EMP_ID('&사원번호');

SELECT * FROM EMPLOYEE;

-- IN/OUT 매개변수 있는 프로시저
-- IN은 매개변수가 프로시저 내부로 전달 되면 연산에만 사용되고 더 이상 반환되지 않는다.
-- OUT은 프로시저 내부로 전달 되지는 않지만 호출한 곳에서 값을 전달 받을 수 있다.
CREATE OR REPLACE PROCEDURE SELECT_EMP_ID
(
  V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
  V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
  V_SALARY OUT EMPLOYEE.SALARY%TYPE,
  V_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS
BEGIN
  SELECT E.EMP_NAME
       , E.SALARY
       , NVL(E.BONUS, 0)
    INTO V_EMP_NAME
       , V_SALARY
       , V_BONUS
    FROM EMPLOYEE E
   WHERE E.EMP_ID = V_EMP_ID;
END;
/

VARIABLE VAR_EMP_NAME VARCHAR2(30);
VARIABLE VAR_SALARY NUMBER;
VARIABLE VAR_BONUS NUMBER;

EXEC SELECT_EMP_ID('206', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);
 
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

-- 자동으로 PRINT 구문이 실행된다.
SET AUTOPRINT ON;