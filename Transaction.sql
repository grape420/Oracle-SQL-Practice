-- TCL(Transaction Control Language)
-- 트랜젝션 제어 언어
-- COMMIT과 ROLLBACK이 있다.

-- 트랜젝션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말한다.
-- 논리적 작업 단위(Logical Unit of Work : LUW)
-- 하나의 트랜젝션으로 이루어진 작업은 반드시 한꺼번에 완료(COMMIT)
-- 되어야 하며, 그렇지 않은 경우에는 한꺼번에 취소(ROLLBACK)되어야 함

-- COMMIT : 트랜젝션 작업이 정상 완료되면 변경 내용을 영구히 저장
-- ROLLBACK : 트랜젝션 작업을 취소하고 최근 COMMIT한 시점으로 이동
--            (UPDATE, INSERT, DELETE 단위로 돌아가기도 함)
-- SAVEPOINT 세이브포인트명 : 현재 트랜젝션 작업 시점에 이름을 정해줌
--                          하나의 트랜젝션 안에 구역을 나눔
-- ROLLBACK TO 세이브포인트명 : 트랜젝션 작업을 취소하고
--                            SAVIEPOINT 시점으로 이동

CREATE TABLE USER_TBL(
  USER_NO NUMBER UNIQUE
, USER_ID VARCHAR2(20) PRIMARY KEY
, USER_PASSWORD VARCHAR2(30) NOT NULL
);

INSERT
  INTO USER_TBL
(
  USER_NO
, USER_ID
, USER_PASSWORD
)
VALUES
(
  1
, 'TEST1'
, 'PASS1'
);

INSERT
  INTO USER_TBL
(
  USER_NO
, USER_ID
, USER_PASSWORD
)
VALUES
(
  2
, 'TEST2'
, 'PASS2'
);

INSERT
  INTO USER_TBL
(
  USER_NO
, USER_ID
, USER_PASSWORD
)
VALUES
(
  3
, 'TEST3'
, 'PASS3'
);


COMMIT;

SELECT * FROM USER_TBL;

INSERT
  INTO USER_TBL
(
  USER_NO
, USER_ID
, USER_PASSWORD
)
VALUES
(
  4
, 'TEST4'
, 'PASS4'
);

ROLLBACK;                   -- 이전 COMMIT 시점까지 되돌리게 된다.

INSERT
  INTO USER_TBL
(
  USER_NO
, USER_ID
, USER_PASSWORD
)
VALUES
(
  4
, 'TEST4'
, 'PASS4'
);

SAVEPOINT SP1;

INSERT
  INTO USER_TBL
(
  USER_NO
, USER_ID
, USER_PASSWORD
)
VALUES
(
  5
, 'TEST5'
, 'PASS5'
);

SELECT * FROM USER_TBL;

ROLLBACK TO SP1;

SELECT * FROM USER_TBL;             -- 이전에 SAVEPOINT로 잡은 시점까지 되돌아간다.