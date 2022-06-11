-- DDL(CREATE TABLE) 및 제약조건
 
-- DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
-- 객체(OBJECT)를 만들고(CREATE), 수정(ALTER)하고, 삭제(DROP)하는 구문
 
-- 오라클에서의 객체
-- : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE)
--   인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER),
--   동의어(SYNONYM), 프로시저(PROCEDURE), 함수(FUNCTION),
--   사용자(USER)

CREATE TABLE MEMBER(
  MEMBER_ID VARCHAR2(20),
  MEMBER_PWD VARCHAR2(20),
  MEMBER_NAME VARCHAR2(20)
);

SELECT
       M.*
  FROM MEMBER M;

-- 컬럼에 주석(COMMENT) 달기
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원명';

-- 테이블 삭제하기
DROP TABLE MEMBER;

-- 계정이 가진 테이블 확인
SELECT
       UT.*
  FROM USER_TABLES UT;
  
SELECT
       UTC.*
  FROM USER_TAB_COLUMNS UTC
 WHERE UTC.TABLE_NAME = 'MEMBER';
 
-- 제약조건
-- 테이블 작성시 각 컬럼에 값 기록에 대한 제약조건을 설정할 수 있다.
-- 데이터 무결성 보장을 목적으로 함
-- 입력/수정하는 데이터에 문제가 없는지 자동으로 검사해 주게 하기 위한 목적
-- PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY

SELECT
       UC.*
  FROM USER_CONSTRAINTS UC;         -- 컬럼에 대한 설명이 없다.

SELECT
       UCC.*
  FROM USER_CONS_COLUMNS UCC;       -- 컬럼과 제약조건 이름은 있지만 어떤 제약조건인지 알 수 없다.
  
-- 제약조건에 대한 필요한 설명들만 보기 위해 데이터 딕셔너리 2개를 조인한 쿼리
SELECT
       UC.TABLE_NAME
     , UC.CONSTRAINT_NAME
     , UCC.COLUMN_NAME
  FROM USER_CONSTRAINTS UC
  JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
 WHERE UC.TABLE_NAME = 'EMPLOYEE';

-- NOT NULL : 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
--            삽입/수정시 NULL값을 허용하지 않도록
--            컬럼 레벨에서 제한★★
CREATE TABLE USER_NOCONS(
  USER_NO NUMBER,
  USER_ID VARCHAR2(20),
  USER_PWD VARCHAR2(30),
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50)
);

INSERT
  INTO USER_NOCONS
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5678'
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_NOCONS
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  2
, NULL
, NULL
, NULL
, NULL
, '010-1234-5678'
, 'hong123@greedy.or.kr'
);

SELECT * FROM USER_NOCONS;

ROLLBACK;
COMMIT;

DROP TABLE USER_NOTNULL;
CREATE TABLE USER_NOTNULL(
  USER_NO NUMBER NOT NULL,          -- 컬럼 레벨에서 제약조건 설정
  USER_ID VARCHAR2(20) NOT NULL,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30) NOT NULL,
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50)
);

-- 데이터 딕셔너리들을 통해 제약조건이 제대로 적용이 되었는지 확인
SELECT
       UC.TABLE_NAME
     , UC.CONSTRAINT_NAME
     , UC.SEARCH_CONDITION
     , UC.CONSTRAINT_TYPE
     , UCC.COLUMN_NAME
  FROM USER_CONSTRAINTS UC
  JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME);
 WHERE UC.TABLE_NAME = 'EMPLOYEE';

INSERT
  INTO USER_NOTNULL
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5678'
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_NOTNULL
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  2
, NULL
, NULL
, NULL
, NULL
, '010-1234-5678'
, 'hong123@greedy.or.kr'
);

-- UNIQUE 제약조건 : 컬럼에 입력값에 대해 중복을 제한한다는 제약조건
--                  컬럼레벨에서 설정 가능, 테이블 레벨에서 설정 가능
CREATE TABLE USER_UNIQUE(
  USER_NO NUMBER,     
  USER_ID VARCHAR2(20) UNIQUE NOT NULL,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  UNIQUE(PHONE)
);

INSERT
  INTO USER_UNIQUE
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5678'
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_UNIQUE
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user02'                -- 중복되지 않게 하자, NULL이 아닌 값을 쓰자
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5679'         -- 중복되지 않게 하자
, 'hong123@greedy.or.kr'
);

SELECT
       UC.TABLE_NAME
     , UC.CONSTRAINT_NAME
     , UC.SEARCH_CONDITION
     , UC.CONSTRAINT_TYPE
     , UCC.COLUMN_NAME
  FROM USER_CONSTRAINTS UC
  JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
 WHERE UC.CONSTRAINT_NAME = 'SYS_C007040';

-- 두 개의 컬럼을 묶어서 하나의 UNIQUE 제약조건 설정 (컬럼 레벨에서는 이렇게 할 수 없다)
CREATE TABLE USER_UNIQUE2(
  USER_NO NUMBER,     
  USER_ID VARCHAR2(20),
  USER_PWD VARCHAR2(30),
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  UNIQUE(USER_NO, USER_ID)          -- 테이블 레벨에서 두 개 이상의 컬럼에 하나의 UNIQUE 제약 조건을 설정
);

INSERT
  INTO USER_UNIQUE2
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'                  -- USER_NO와 USER_ID가 동시에 일치하면 제약 조건에 위배 됨            
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5679'         
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_UNIQUE2
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  2
, 'user01'                
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5679'         
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_UNIQUE2
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user02'                
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5679'         
, 'hong123@greedy.or.kr'
);

-- CHECK 제약조건 : 컬럼에 기록되는 값에 조건 설정을 할 수 있다.
--                 컬럼 레벨에서 설정 가능, 테이블 레벨에서 설정 가능
-- CHECK (컬럼명 비교연산자 비교값)
-- 주의 : 비교값은 리터럴만 사용할 수 있음, 변하는 값이나 함수 사용 못함
CREATE TABLE USER_CHECK(
  USER_NO NUMBER,     
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10) CHECK(GENDER IN ('남','여')),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50)
);

INSERT
  INTO USER_CHECK
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user01'                
, 'pass01'
, '홍길동'
, '남'
, '010-1234-5679'         
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_CHECK
(
  USER_NO
, USER_ID
, USER_PWD
, USER_NAME
, GENDER
, PHONE
, EMAIL
)
VALUES
(
  1
, 'user02'                       -- UNIQUE 제약조건은 위반되지 않게 하자
, 'pass01'
, '홍길동'
, '여'                           -- '남' 또는 '여'라는 리터럴 값만 INSERT 할 수 있다.
, '010-1234-5679'         
, 'hong123@greedy.or.kr'
);

CREATE TABLE TBL_CHECK(
  C_NAME VARCHAR2(10),
  C_PRICE NUMBER CONSTRAINT CK_C_PRICE CHECK(C_PRICE >= 1 AND C_PRICE <= 99999),
  C_LEVEL CHAR(1),
  C_DATE DATE,
  CONSTRAINT CK_C_LEVEL CHECK(C_LEVEL = 'A' OR C_LEVEL = 'B' OR C_LEVEL = 'C'),
  CONSTRAINT CK_C_DATE CHECK(C_DATE >= TO_DATE('2016/01/01','YYYY/MM/DD'))
);

SELECT
       UC.TABLE_NAME
     , UC.CONSTRAINT_NAME
     , UC.SEARCH_CONDITION
     , UC.CONSTRAINT_TYPE
     , UCC.COLUMN_NAME
  FROM USER_CONSTRAINTS UC
  JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
 WHERE UC.TABLE_NAME = 'TBL_CHECK';

--------------
CREATE TABLE TBL_NCS_USER(
  USER_NO NUMBER,
  USER_ID VARCHAR2(50) NOT NULL,
  USER_PWD VARCHAR2(50) NOT NULL,
  PNO VARCHAR2(50) NOT NULL,
  GENDER VARCHAR2(3),
  PHONE VARCHAR2(50),
  ADDRESS VARCHAR2(100),
  STATUS VARCHAR2(1) NOT NULL,
  UNIQUE(USER_ID),
  UNIQUE(PNO),
  CHECK(GENDER IN ('남','여')),
  CHECK(STATUS IN ('Y','N'))
);









-------------------
-- 회원 가입용 테이블 생성(USER_TEST)
-- 컬럼명 : USER_NO(회원번호)
--         USER_ID(회원아이디) -- 중복 금지, NULL값 허용 안함
--         USER_PWD(회원비밀번호) -- NULL값 허용 안함
--         PNO(주민등록번호) -- 중복 금지, NULL값 허용 안함
--         GENDER(성별) -- '남' 혹은 '여'로 입력
--         PHONE(연락처)
--         ADDRESS(주소)
--         STATUS(탈퇴여부) -- NOT NULL, 'Y' 혹은 'N'으로 입력
-- 각 컬럼에 제약조건 이름 부여
-- 5명 이상 회원 정보 INSERT
-- 각 컬럼별로 코멘트 작성




CREATE TABLE TBL_NCS_USER(
  USER_NO NUMBER,
  USER_ID VARCHAR2(250) CONSTRAINT NN_USER_ID NOT NULL,
  USER_PWD VARCHAR2(250) CONSTRAINT NN_USER_PWD NOT NULL,
  PNO VARCHAR2(250) CONSTRAINT NN_PNO NOT NULL,
  GENDER VARCHAR2(3),
  PHONE VARCHAR2(250),
  ADDRESS VARCHAR2(250),
  STATUS VARCHAR2(1) CONSTRAINT NN_STATUS NOT NULL,
  CONSTRAINT UK_USER_ID UNIQUE(USER_ID),
  CONSTRAINT UK_PNO UNIQUE(PNO),
  CONSTRAINT CK_GENDER CHECK(GENDER IN ('남','여')),
  CONSTRAINT CK_STATUS CHECK(STATUS IN ('Y','N'))
);



COMMENT ON COLUMN TBL_NCS_USER.USER_NO IS '회원번호';
COMMENT ON COLUMN TBL_NCS_USER.USER_ID IS '회원아이디';
COMMENT ON COLUMN TBL_NCS_USER.USER_PWD IS '회원비밀번호';
COMMENT ON COLUMN TBL_NCS_USER.PNO IS '주민등록번호';
COMMENT ON COLUMN TBL_NCS_USER.GENDER IS '성별';
COMMENT ON COLUMN TBL_NCS_USER.PHONE IS '연락처';
COMMENT ON COLUMN TBL_NCS_USER.ADDRESS IS '주소';
COMMENT ON COLUMN TBL_NCS_USER.STATUS IS '탈퇴여부';

INSERT
  INTO TBL_NCS_USER
(
  USER_NO, USER_ID, USER_PWD
, PNO, GENDER, PHONE
, ADDRESS, STATUS
)
VALUES
(
  1, 'user01', 'pass01'
, '960420-2234567', '남', '010-1234-5678'
, '서울시 양천구 목동', 'N'
);

INSERT
  INTO TBL_NCS_USER
(
  USER_NO, USER_ID, USER_PWD
, PNO, GENDER, PHONE
, ADDRESS, STATUS
)
VALUES
(
  2, 'user02', 'pass01'
, '960420-1334567', '남', '010-1234-5678'
, '서울시 강서구 화곡동', 'N'
);

INSERT
  INTO TBL_NCS_USER
(
  USER_NO, USER_ID, USER_PWD
, PNO, GENDER, PHONE
, ADDRESS, STATUS
)
VALUES
(
  3, 'user03', 'pass01'
, '960420-1284567', '남', '010-1234-5678'
, '서울시 용산구 이촌동', 'N'
);

INSERT
  INTO TBL_NCS_USER
(
  USER_NO, USER_ID, USER_PWD
, PNO, GENDER, PHONE
, ADDRESS, STATUS
)
VALUES
(
  4, 'user04', 'pass01'
, '960420-1239567', '남', '010-1234-5678'
, '안양시 호계동', 'N'
);

INSERT
  INTO TBL_NCS_USER
(
  USER_NO, USER_ID, USER_PWD
, PNO, GENDER, PHONE
, ADDRESS, STATUS
)
VALUES
(
  5, 'user05', 'pass01'
, '960420-1234767', '남', '010-1234-5678'
, '서울시 강남구 서초동', 'N'
);

COMMIT;

SELECT * FROM TBL_NCS_USER;

SELECT
       UC.CONSTRAINT_NAME
     , UC.CONSTRAINT_TYPE    
     , UCC.COLUMN_NAME
  FROM USER_CONSTRAINTS UC
  JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
 WHERE UC.TABLE_NAME = 'TBL_NCS_USER';

-- PRIMARY KEY(기본키) 제약조건
-- : 테이블에서 한 행의 정보를 찾기 위해 사용할 컬럼을 의미한다.
--   테이블에 대한 식별자 역할을 한다.(한 행씩 구분하는 역할을 한다.)
--   NOT NULL + UNIQUE 제약조건의 의미
--   한 테이블당 한 개만 설정할 수 있음
--   컬럼 레벨, 테이블 레벨 둘 다 설정 가능함
--   한 개 컬럼에 설정할 수도 있고, 여러개의 컬럼을 묶어서 설정할 수도 있음(복합키)
DROP TABLE USER_PRIMARYKEY;
CREATE TABLE USER_PRIMARYKEY(
  USER_NO NUMBER CONSTRAINT PK_USER_NO PRIMARY KEY,    -- 컬럼레벨에서 제약조건 설정
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50)
);

INSERT
  INTO USER_PRIMARYKEY
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL
)
VALUES
(
  1, 'user01', 'pass01'
, '홍길동', '남', '010-123-1234'
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_PRIMARYKEY
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL
)
VALUES
(
  1, 'user02', 'pass01'                     --PK일 경우 중복값은 들어갈 수 없다.
, '홍길동', '남', '010-123-1234'
, 'hong123@greedy.or.kr'
);

INSERT
  INTO USER_PRIMARYKEY
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL
)
VALUES
(
  NULL, 'user03', 'pass01'                  --PK일 경우 NULL은 들어갈 수 없다.
, '홍길동', '남', '010-123-1234'
, 'hong123@greedy.or.kr'
);

DROP TABLE USER_PRIMARYKEY2;
CREATE TABLE USER_PRIMARYKEY2(
  USER_NO NUMBER,
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  CONSTRAINT PK_USER_NO_USER_ID PRIMARY KEY(USER_NO, USER_ID) -- 두 개 이상의 컬럼을 묶어서 기본키로 설정할 수 있다(테이블 레벨)
);

-- FOREIGN KEY(외부키 / 외래키) 제약조건 :
-- 참조(REFERENCES)된 다른 테이블에서 제공하는 값만 사용할 수 있음
-- 참조 무결성을 위배하지 않기 위해 사용
-- FOREIGN KEY제약조건에 의해서
-- 테이블 간의 관계(RELATIONSHIP)가 형성됨
-- 제공되는 값 외에는 NULL을 사용할 수 있음

-- 컬럼 레벨일 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]
-- 
-- 테이블 레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- 참조할 테이블의 참조할 컬럼명이 생략되면
-- PRIMARY KEY로 설정된 컬럼이 자동 참조할 컬럼이 됨
-- 참조될 수 있는 컬럼은 PRIMARY KEY 컬럼과,
-- UNIQUE로 지정된 컬럼만 외래키로 사용할 수 있음
DROP TABLE USER_GRADE;
CREATE TABLE USER_GRADE(
  GRADE_CODE NUMBER PRIMARY KEY,
  GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT
  INTO USER_GRADE
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  10
, '일반회원'
);

INSERT
  INTO USER_GRADE
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  20
, '우수회원'
);

INSERT
  INTO USER_GRADE
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  30
, '특별회원'
);

SELECT * FROM USER_GRADE;

DROP TABLE USER_FOREIGNKEY;
CREATE TABLE USER_FOREIGNKEY(
  USER_NO NUMBER PRIMARY KEY,    -- 컬럼레벨에서 제약조건 설정
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  GRADE_CODE NUMBER,
  CONSTRAINT FK_GRADE_CODE FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE (GRADE_CODE)
);

INSERT
  INTO USER_FOREIGNKEY
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  1, 'user01', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', 10
);

INSERT
  INTO USER_FOREIGNKEY
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  2, 'user02', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', NULL
);

INSERT
  INTO USER_FOREIGNKEY
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  3, 'user03', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', 40                   -- USER_GRADE 테이블의 GRADE_CODE에 없는 값은 FK제약조건이 걸린 컬럼에 넣을 수 없다.
);

-- 삭제 옵션
-- : 부모테이블의 데이터 삭제시 자식 테이블의 데이터를
-- 어떤식으로 처리할 지에 대한 내용을 설정할 수 있다.
DELETE
  FROM USER_GRADE
 WHERE GRADE_CODE = 10;
 
 
-- ON DELETE SET NULL : 부모키를 삭제시 자식키를 NULL로 변경하는 옵션
CREATE TABLE USER_GRADE2(
  GRADE_CODE NUMBER PRIMARY KEY,
  GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT
  INTO USER_GRADE2
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  10
, '일반회원'
);

INSERT
  INTO USER_GRADE2
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  20
, '우수회원'
);

INSERT
  INTO USER_GRADE2
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  30
, '특별회원'
);

DROP TABLE USER_FOREIGNKEY2;
CREATE TABLE USER_FOREIGNKEY2(
  USER_NO NUMBER PRIMARY KEY,    -- 컬럼레벨에서 제약조건 설정
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  GRADE_CODE NUMBER,
  CONSTRAINT FK_GRADE_CODE2 FOREIGN KEY (GRADE_CODE) 
  REFERENCES USER_GRADE2 (GRADE_CODE) ON DELETE SET NULL
);

INSERT
  INTO USER_FOREIGNKEY2
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  1, 'user01', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', 10
);


INSERT
  INTO USER_FOREIGNKEY2
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  2, 'user02', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', 20
);

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_FOREIGNKEY2;

DELETE
  FROM USER_GRADE2
 WHERE GRADE_CODE = 10;

DELETE
  FROM USER_GRADE2
 WHERE GRADE_CODE = 20;
 
COMMIT;

-- ON DELETE CASCADE : 부모키 삭제시 자식키를 가진 행도 함께 삭제
CREATE TABLE USER_GRADE3(
  GRADE_CODE NUMBER PRIMARY KEY,
  GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT
  INTO USER_GRADE3
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  10
, '일반회원'
);

INSERT
  INTO USER_GRADE3
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  20
, '우수회원'
);

INSERT
  INTO USER_GRADE3
(
  GRADE_CODE
, GRADE_NAME
)
VALUES
(
  30
, '특별회원'
);

DROP TABLE USER_FOREIGNKEY3;
CREATE TABLE USER_FOREIGNKEY3(
  USER_NO NUMBER PRIMARY KEY,    -- 컬럼레벨에서 제약조건 설정
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  GRADE_CODE NUMBER,
  CONSTRAINT FK_GRADE_CODE3 FOREIGN KEY (GRADE_CODE) 
  REFERENCES USER_GRADE3 (GRADE_CODE) ON DELETE CASCADE
);

INSERT
  INTO USER_FOREIGNKEY3
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  1, 'user01', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', 10
);

INSERT
  INTO USER_FOREIGNKEY3
(
  USER_NO, USER_ID, USER_PWD
, USER_NAME, GENDER, PHONE
, EMAIL, GRADE_CODE
)
VALUES
(
  2, 'user02', 'pass01'
, '홍길동', '남', '010-1234-5678'
, 'hong123@greedy.or.kr', 20
);

COMMIT;

DELETE
  FROM USER_GRADE3
 WHERE GRADE_CODE = 10;

SELECT * FROM USER_GRADE3;
SELECT * FROM USER_FOREIGNKEY3;

ROLLBACK;
COMMIT;

-- 서브쿼리를 이용한 테이블 생성(제약조건은 NOT NULL만 가져옴)
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;

SELECT
       *
  FROM EMPLOYEE_COPY;

-- 원본인 EMPLOYEE 테이블과 서브쿼리를 활용한 카피버전인 EMPLOYEE_COPY의 제약조건을 데이터 딕셔너리를 활용해 확인하기
SELECT
       UC.TABLE_NAME
     , UC.CONSTRAINT_NAME
     , UC.SEARCH_CONDITION
     , UC.CONSTRAINT_TYPE
     , UCC.COLUMN_NAME
  FROM USER_CONSTRAINTS UC
  JOIN USER_CONS_COLUMNS UCC ON(UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
 WHERE UC.TABLE_NAME IN ('EMPLOYEE', 'EMPLOYEE_COPY');
 
-- 제약조건 추가
-- ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
-- ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명)
--                         REFERENCES 테이블명 (컬럼명)
-- ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
-- ALTER TABLE 테이블명 ADD CHECK(컬럼명 비교연산자 비교값)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL ★★★★★
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- 실습
-- EMPLOYEE 테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조컬럼은 DEPARTMENT의 기본키
-- DEPARTMENT 테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조 테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키
-- EMPLOYEE 테이블의 JOB_CODE에 외래키 제약조건 추가
-- 참조 테이블은 JOB 테이블, 참조 컬럼은 JOB테이블의 기본키
-- EMPLOYEE 테이블의 SAL_LEVEL에 외래키 제약조건 추가
-- 참조테이블은 SAL_GRADE테이블, 참조 컬럼은 SAL_GRADE테이블 기본키
-- EMPLOYEE테이블의 ENT_YN컬럼에 CHECK제약조건 추가('Y','N')
-- 단, 대 소문자를 구분하기 때문에 대문자로 설정
-- EMPLOYEE테이블의 SALARY 컬럼에 CHECK제약조건 추가(양수)
-- EMPLOYEE테이블의 EMP_NO컬럼에 UNIQUE 제약조건 추가

ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE);
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE(SAL_LEVEL);
ALTER TABLE EMPLOYEE ADD CHECK (ENT_YN IN ('Y', 'N'));
ALTER TABLE EMPLOYEE ADD CHECK(SALARY > 0);
ALTER TABLE EMPLOYEE ADD UNIQUE(EMP_NO);