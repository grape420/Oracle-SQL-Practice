-- CURSOR
-- : 처리 결과가 여러 개의 행으로 구해지는 SELECT문을 처리하기 위해
-- 처리 결과를 저장해 놓은 객체이다.
--  CURSOR~ OPEN~ FETCH~ CLOSE 단계로 진행된다.

-- CURSOR의 상태
-- %NOTFOUND : 커서 영역의 자료가 모두 인출(FETCH)되어
--             다음 영역이 존재 하지 않으면 TRUE
-- %FOUND    : 커서 영역에 자료가 아직 있으면 TRUE
-- %ISOPEN   : 커서가 OPEN된 상태면 TRUE
-- %ROWCOUNT : 커서가 얻어 온 레코드(ROW)의 개수
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
  V_DEPT DEPARTMENT%ROWTYPE;
  CURSOR C1
  IS
  SELECT D.*
    FROM DEPARTMENT D;
BEGIN
  OPEN C1;
  LOOP
    FETCH C1
     INTO V_DEPT.DEPT_ID
        , V_DEPT.DEPT_TITLE
        , V_DEPT.LOCATION_ID;
     EXIT WHEN C1%NOTFOUND;
     
     DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID
                        || ', 부서명 : ' || V_DEPT.DEPT_TITLE
                        || ', 지역 : ' || V_DEPT.LOCATION_ID);
  END LOOP;
  CLOSE C1;   
END;
/

SET SERVEROUTPUT ON;

EXEC CURSOR_DEPT;

-- FOR IN LOOP를 이용하면
-- 반복시에 자동으로 CURSOR OPEN하고,
-- 인출(FETCH)도 자동으로 한다.
-- LOOP를 종료할 때 자동으로 CLOSE 한다.
 
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
  V_DEPT DEPARTMENT%ROWTYPE;
  CURSOR C1
  IS
  SELECT D.*
    FROM DEPARTMENT D;
BEGIN
  FOR V_DEPT IN C1
    LOOP
      DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID
                        || ', 부서명 : ' || V_DEPT.DEPT_TITLE
                        || ', 지역 : ' || V_DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;