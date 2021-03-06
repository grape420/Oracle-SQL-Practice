-- FUNCTION
-- : 프로시저와 사용 용도가 거의 비슷하다.
--   실행 결과를 되돌려 받을 수 있다. (RETURN)
CREATE OR REPLACE FUNCTION BONUS_CALC
(
  V_EMP EMPLOYEE.EMP_ID%TYPE
)
RETURN NUMBER
IS
  V_SAL EMPLOYEE.SALARY%TYPE;
  V_BONUS EMPLOYEE.BONUS%TYPE;
  CALC_SAL NUMBER;
BEGIN
  SELECT E.SALARY
       , NVL(E.BONUS, 0)
    INTO V_SAL
       , V_BONUS
    FROM EMPLOYEE E
   WHERE E.EMP_ID = V_EMP;
   
   CALC_SAL := (V_SAL + (V_SAL * V_BONUS)) * 12;
   
   RETURN CALC_SAL;
END;
/

VARIABLE VAR_CALC NUMBER;

EXEC :VAR_CALC := BONUS_CALC('&사원번호');

PRINT VAR_CALC;

SET AUTOPRINT ON;

-- 우리가 만든 함수는 단일행 함수다.(SELECT문에서 활용할 수 있다.)
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , BONUS_CALC(E.EMP_ID)
  FROM EMPLOYEE E
 WHERE BONUS_CALC(E.EMP_ID) > 30000000;