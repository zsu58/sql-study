/*
Normalization
  * 1st Normal Form
    * Table values must be atomic(no arrays
  * 2nd Normal Form
    * 1st Normal Form satisfied
    * all non-key columns are dependent on the table's PRIMARY KEY
      * 즉, 테이블의 모든 컬럼이 완전 함수적 종속을 만족(기본키의 특정 컬럼에만 부분적으로 종속되면 안됨)
  * 3nd Nomral Form
    * 2nd Normal Form satisfied
    * no transitive dependencies exist
      * 즉, 
정규화 참고: https://mangkyu.tistory.com/110
*/