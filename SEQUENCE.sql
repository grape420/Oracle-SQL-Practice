-- 시퀀스(SEQUENCE)
-- 자동 번호 발생기 역할을 하는 객체
-- 순차적으로 정수값을 자동으로 생성해 줌

/* 
 CREATE SEQUENCE 시퀀스명
[START WITH 숫자 ] - 처음 발생시킬 시작 값 지정, 기본값 1
[INCREMENT BY 숫자 ] - 다음 값에 대한 증가치, 기본값 1
[MAXVALUE 숫자 | NOMAXVALUE ] - 발생시킬 최대값 지정, 10의 27승 -1까지 가능
[MINVALUE 숫자 | NOMINVALUE ] – 발생시킬 최소값 지정, -10의 26승
[CYCLE | NOCYCLE ] – 시퀀스가 최대값까지 증가를 완료하면 CYCLE은 START WITH 설정값으로
                     돌아가고, NOCYCLE은 에러발생
[CACHE | NOCACHE] – CACHE는 메모리상에서 시퀀스값을 관리, 기본값 20
*/

DROP SEQUENCE SEQ_EMPID;
CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
MINVALUE 300
CYCLE
NOCACHE;

--SELECT SEQ_EMPID.CURRVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;         -- 처음에 NEXTVAL을 반드시!! 한번 해 주어야 하고 그럼 초기값을 확인할 수 있다.
SELECT SEQ_EMPID.CURRVAL FROM DUAL;         -- CURRVAL는 기본적으로 현재값을 표현하지만 이전의 NEXTVAL 후 값이라고 기억하는 것이 좋다.
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.CURRVAL FROM DUAL;

SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

-- 시퀀스 변경
ALTER SEQUENCE SEQ_EMPID
INCREMENT BY 10
MAXVALUE 400
NOCYCLE;

-- START WITH 값은 변경이 불가능함.
-- START WITH 값을 변경시에는 DROP으로 삭제 후 다시 생성해야 한다!!!

-- 참고사항
-- SELECT문에서 사용가능
-- INSERT문에서 SELECT 구문 사용 가능(서브쿼리)
-- INSERT문에서 VALUES 절에서 사용 가능
-- UPDATE문에서 SET절에서 사용 가능
-- 
-- 단, 일반적인 서브쿼리의 SELECT문에서는 사용불가
-- VIEW의 SELECT절에서 사용 불가
-- DISTINCT 키워드가 있는 SELECT문에서 사용 불가
-- GROUP BY, HAVING절에 있는 SELECT문에서는 사용 불가
-- ORDER BY 절에서 사용 불가
-- CREATE TABLE, ALTER TABLE의 DEFAULT값으로 사용 불가

-- VALUES를 활용한 INSERT문에서의 SEQUENCE 활용
CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

INSERT
  INTO EMPLOYEE
VALUES
(
  SEQ_EID.NEXTVAL, '홍길동', '555555-5555555', 'hong_gd@greedy.or.kr', '01012345555'
, 'D2', 'J7', 'S1', 50000000, 0.1
, '200', SYSDATE, NULL, DEFAULT
);

SELECT * FROM EMPLOYEE;

CREATE SEQUENCE SEQ_EID2;