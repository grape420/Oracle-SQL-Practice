-- PL/SQL (PROCEDURE LANGUAGE EXTENSION TO SQL 또는 PROCEDURE LANGUAGE/SQL)
-- 오라클 자체에 내장 된 절차적 언어
-- SQL의 단점을 보완하여 SQL문장 내에서
-- 변수의 정의, 조건처리, 반복처리, 예외처리 등을 지원한다.
 
-- PL/SQL 구조
-- 선언부, 실행부, 예외처리부로 구성되어 있음
-- 선언부 : DECLARE로 시작, 변수나 상수를 선언하는 부분
-- 실행부 : BEGIN으로 시작, 제어문, 반복문, 함수의 정의 등 로직 작성
-- 예외처리부 : EXCEPTION으로 시작, 예외처리 내용 작성
 
BEGIN
  DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

SET SERVEROUTPUT ON;     
-- PL/SQL을 통해 출력을 하고자 하면 반드시 실행 하여야 함

-- 변수의 초기화, 변수 값 출력
DECLARE
  EMP_ID NUMBER;
  EMP_NAME VARCHAR2(30);
BEGIN
  EMP_ID := 888;
  EMP_NAME := '배장남';
  
  DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
  DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

-- %TYPE 
-- : 테이블의 하나의 컬럼을 참조하는 경우 사용 
-- 레퍼런스 변수의 선언과 초기화, 변수값 출력 
DECLARE 
  EMP_ID EMPLOYEE.EMP_ID%TYPE;
  EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN 
  SELECT E.EMP_ID
       , E.EMP_NAME
    INTO EMP_ID
       , EMP_NAME
    FROM EMPLOYEE E
   WHERE E.EMP_ID = '&EMP_ID'; 
    
  DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID); 
  DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME); 
END;
/

-- 레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE,
-- SALARY를 선언하고, EMPLOYEE 테이블에서
-- 사번, 이름, 직급코드, 부서코드, 급여를 조회하여
-- 선언한 레퍼런스 변수에 담아 출력하시오.
-- 단, 입력받은 이름과 일치하는 조건의 직원을 조회 하시오.
DECLARE
  EMP_ID EMPLOYEE.EMP_ID%TYPE;
  EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
  DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
  JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
  SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
  SELECT E.EMP_ID
       , E.EMP_NAME
       , E.DEPT_CODE
       , E.JOB_CODE
       , E.SALARY
    INTO EMP_ID
       , EMP_NAME
       , DEPT_CODE
       , JOB_CODE
       , SALARY
    FROM EMPLOYEE E
   WHERE E.EMP_NAME = '&사원이름';
   
   DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID);
   DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || DEPT_CODE);
   DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || JOB_CODE);
   DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
END;
/

-- %ROWTYPE
-- : 테이블의 모든 컬럼과 컬럼의 자료형을 참조하는 경우 사용
DECLARE
  EMP EMPLOYEE%ROWTYPE;
BEGIN
  SELECT E.*
    INTO EMP
    FROM EMPLOYEE E
   WHERE E.EMP_ID = '&사번';
   
   DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP.EMP_ID);
   DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP.EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || EMP.DEPT_CODE);
   DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || EMP.JOB_CODE);
   DBMS_OUTPUT.PUT_LINE('SALARY : ' || EMP.SALARY);
END;
/
 
-- IF문(조건문)
-- 연봉을 구하는 PL/SQL블럭 작성
DECLARE
  EM EMPLOYEE%ROWTYPE;
  YSALARY NUMBER;
BEGIN
  SELECT E.*
    INTO EM
    FROM EMPLOYEE E
   WHERE E.EMP_NAME = '&사원명';
   
   IF(EM.BONUS IS NULL) THEN YSALARY := EM.SALARY * 12;
   ELSIF(EM.BONUS IS NOT NULL) THEN YSALARY := (EM.SALARY + (EM.SALARY * EM.BONUS)) * 12;
   END IF;
   
   DBMS_OUTPUT.PUT_LINE(EM.EMP_ID || '     ' || EM.EMP_NAME || '     ' 
                        || TO_CHAR(YSALARY, 'L999,999,999'));
END;
/

-- 점수를 입력 받아 SCORE 변수에 저장하고
-- 90점 이상은 'A', 80점 이상은 'B', 70점 이상은 'C',
-- 60점 이상은 'D', 60점 미만은 'F'로 조건 처리하여
-- GRADE 변수에 저장하여
-- '당신의 점수는 90점 이고, 학점은 A학점 입니다' 형태로 출력하세요.
 
DECLARE
  SCORE NUMBER;
  GRADE VARCHAR2(1);
BEGIN
  SCORE := '&점수';
  
  IF SCORE >= 90 THEN GRADE := 'A';
  ELSIF SCORE >= 80 THEN GRADE := 'B';
  ELSIF SCORE >= 70 THEN GRADE := 'C';
  ELSIF SCORE >= 60 THEN GRADE := 'D';
  ELSE GRADE := 'F';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('당신의 점수는' || SCORE
                       || '점이고, 학점은 ' || GRADE
                       || '학점 입니다.');
  
END;
/

-- 사번을 입력하면 해당 사원의 부서명이 나올 수 있도록 해보자.(JOIN 사용 안하고 IF문 사용)
DECLARE
  VEMPNO EMPLOYEE.EMP_ID%TYPE;
  VENAME EMPLOYEE.EMP_NAME%TYPE;
  VDEPTNO EMPLOYEE.DEPT_CODE%TYPE;
  VDNAME VARCHAR2(20) := NULL;
BEGIN
  SELECT E.EMP_ID
       , E.EMP_NAME
       , E.DEPT_CODE
    INTO VEMPNO
       , VENAME
       , VDEPTNO
    FROM EMPLOYEE E
   WHERE E.EMP_ID = '&사번';
   
   IF(VDEPTNO = 'D1') THEN VDNAME := '인사관리부';
   END IF;
   IF(VDEPTNO = 'D2') THEN VDNAME := '회계관리부';
   END IF;
   IF(VDEPTNO = 'D3') THEN VDNAME := '마케팅부';
   END IF;
   IF(VDEPTNO = 'D4') THEN VDNAME := '국내영업부';
   END IF;
   IF(VDEPTNO = 'D5') THEN VDNAME := '해외영업1부';
   END IF;
   IF(VDEPTNO = 'D6') THEN VDNAME := '해외영업2부';
   END IF;
   IF(VDEPTNO = 'D7') THEN VDNAME := '해외영업3부';
   END IF;
   IF(VDEPTNO = 'D8') THEN VDNAME := '기술지원부';
   END IF;
   IF(VDEPTNO = 'D9') THEN VDNAME := '총무부';
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('사번       이름       부서명');
   DBMS_OUTPUT.PUT_LINE('----------------------------');
   DBMS_OUTPUT.PUT_LINE(VEMPNO || '      ' || VENAME || '      '
                        || VDNAME);
   
END;
/

-- CASE문
DECLARE
  VEMPNO EMPLOYEE.EMP_ID%TYPE;
  VENAME EMPLOYEE.EMP_NAME%TYPE;
  VDEPTNO EMPLOYEE.DEPT_CODE%TYPE;
  VDNAME VARCHAR2(20) := NULL;
BEGIN
  SELECT E.EMP_ID
       , E.EMP_NAME
       , E.DEPT_CODE
    INTO VEMPNO
       , VENAME
       , VDEPTNO
    FROM EMPLOYEE E
   WHERE E.EMP_ID = '&사번';
   
   VDNAME := CASE VDEPTNO
               WHEN 'D1' THEN '인사관리부'
               WHEN 'D2' THEN '회계관리부'
               WHEN 'D3' THEN '마케팅부'
               WHEN 'D4' THEN '국내영업부'
               WHEN 'D5' THEN '해외영업1부'
               WHEN 'D6' THEN '해외영업2부'
               WHEN 'D7' THEN '해외영업3부'
               WHEN 'D8' THEN '기술지원부'
               WHEN 'D9' THEN '총리부'
             END;
   
   DBMS_OUTPUT.PUT_LINE('사번       이름       부서명');
   DBMS_OUTPUT.PUT_LINE('----------------------------');
   DBMS_OUTPUT.PUT_LINE(VEMPNO || '      ' || VENAME || '      '
                        || VDNAME);
   
END;
/

-- LOOP문(자바의 while문 같은 것)
DECLARE
  N NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(N);
    N := N + 1;
    IF N > 5 THEN EXIT;
    END IF;
  END LOOP;
END;
/

-- FOR IN문(자바의 for문 같은 것)
CREATE TABLE TEST1(
  BUNHO NUMBER,
  NALJJA DATE
);

BEGIN
  FOR I IN 1..10
    LOOP
      INSERT
        INTO TEST1
        (
          BUNHO
        , NALJJA
        )
        VALUES
        (
          I
        , SYSDATE + I
        );
  END LOOP;
END;
/
SELECT * FROM TEST1;

ROLLBACK;
COMMIT;

-- 구구단 짝수단 출력하기
DECLARE
  RESULT NUMBER;
BEGIN
  FOR DAN IN 2..9
    LOOP
           FOR SU IN 1..9
               LOOP
                 RESULT := DAN * SU;
                 DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
               END LOOP;
               DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 테이블 타입의 변수(일종의 배열) 선언 및 값 대입 출력
DECLARE
  TYPE EMP_ID_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_ID%TYPE
  INDEX BY BINARY_INTEGER;
  TYPE EMP_NAME_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_NAME%TYPE
  INDEX BY BINARY_INTEGER;
  
  EMP_ID_TABLE EMP_ID_TABLE_TYPE;
  EMP_NAME_TABLE EMP_NAME_TABLE_TYPE;
  
  I BINARY_INTEGER := 0;
BEGIN
  I := 1;
  FOR K IN (SELECT EMP_ID, EMP_NAME FROM EMPLOYEE)
    LOOP
      EMP_ID_TABLE(I) := K.EMP_ID;
      EMP_NAME_TABLE(I) := K.EMP_NAME;
      I := I+1;
    END LOOP;
  FOR J IN 1..(I-1) LOOP
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID_TABLE(J)
                        || ', EMP_NAME : ' || EMP_NAME_TABLE(J));
  END LOOP;
 
END;
/

-- 레코드 타입의 변수 선언 및 값 대입 출력
DECLARE
  TYPE EMP_RECORD_TYPE IS RECORD(
    EMP_ID EMPLOYEE.EMP_ID%TYPE,
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
    JOB_NAME JOB.JOB_NAME%TYPE
  );
  
  EMP_RECORD EMP_RECORD_TYPE;
BEGIN
  SELECT E.EMP_ID
       , E.EMP_NAME
       , D.DEPT_TITLE
       , J.JOB_NAME
    INTO EMP_RECORD
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    LEFT JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
   WHERE E.EMP_NAME = '&EMP_NAME';
   
   DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_RECORD.EMP_ID);
   DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_RECORD.EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('부서 : ' || EMP_RECORD.DEPT_TITLE);
   DBMS_OUTPUT.PUT_LINE('직급 : ' || EMP_RECORD.JOB_NAME);
   
END;
/

-- 예외처리
-- 기존에 오라클에 정의 되어 있는 예외 처리
BEGIN
  UPDATE EMPLOYEE
     SET EMP_ID = '&사번'
   WHERE EMP_ID = 899;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/

SELECT * FROM EMPLOYEE;
ROLLBACK;

-- 정의되지 않은 예외처리
-- PRAGMA EXCEPTION_INIT문장으로 예외 이름과 오라클 오류 번호 결합
-- -00001은 유일성 제약조건(UNIQUE) 위반
DECLARE
  DUP_EMPNO EXCEPTION;
  PRAGMA EXCEPTION_INIT(DUP_EMPNO, -00001);
BEGIN
  UPDATE EMPLOYEE E
     SET E.EMP_ID = '&사번'
   WHERE E.EMP_ID = '200';
EXCEPTION
  WHEN DUP_EMPNO THEN
  DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다');
END;
/

--예외명	예외 코드	설명
--ACCESS_INTO_NULL	ORA-06530	LOB과 같은 객체 초기화 되지 않은 상태에서 사용
--CASE_NOT_FOUND	ORA-06592	CASE문 사용시 구문 오류
--CURSOR_ALREADY_OPEN	ORA-06511	커서가 이미 OPEN된 상태인데 OPEN 하려고 시도
--DUP_VAL_ON_INDEX	ORA-00001	유일 인덱스가 있는 컬럼에 중복값으로 INSERT, UPDATE 수행
--INVALID_CURSOR	ORA-01001	존재하지 않는 커서를 참조
--INVALID_NUMBER	ORA-01722	문자를 숫자로 변환할 때 실패할 경우
--LOGIN_DENIED	ORA-01017	잘못된 사용자 이름이나 비밀번호로 로그인을 시도
--NO_DATA_FOUND	ORA-01403	SELECT INTO 시 데이터가 한 건도 없을 경우
--NOT_LOGGED_ON	ORA-01012	로그온되지 않았는데 DB를 참조할 때
--PROGRAM_ERROR	ORA-06501	PL/SQL 코드상에서 내부 오류를 만났을 때, 이 오류가 발생하면 “오라클에 문의(Contact Oracle Support)”란 메시지가 출력됨
--STORAGE_ERROR	ORA-06500	프로그램 수행 시 메모리가 부족할 경우
--TIMEOUT_ON_RESOURCE	ORA-00051	데이터베이스 자원을 기다리는 동안 타임아웃 발생 시
--TOO_MANY_ROWS	ORA-01422	SELECT INTO 절 사용할 때 결과가 한 로우 이상일 때
--VALUE_ERROR	ORA-06502	수치 또는 값 오류
--ZERO_DIVIDE	ORA-01476	0으로 나눌 때

--출처 : https://thebook.io/006696/part02/ch10/01/03/