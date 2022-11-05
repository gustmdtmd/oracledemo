--테이블 생성
 CREATE TABLE book (
     num number constraint book_num_pk primary key,
     title varchar2(100),
     author varchar2(50)
 );

--시퀀스 생성
 CREATE SEQUENCE book_num_seq
 START WITH 1
 INCREMENT BY 1
 NOCACHE
 NOCYCLE;
 
--삽입
 INSERT INTO book(num, title, author)
 VALUES(book_num_seq.nextval, '홍길동전', '허균');
 
 SELECT * FROM book;
 
 commit;