/*------------------------------
문제
------------------------------*/
--1) 모든사원에게는 상관(Manager)이 있다. 하지만 employees테이블에 유일하게 상관이
--   없는 로우가 있는데 그 사원(CEO)의 manager_id컬럼값이 NULL이다. 상관이 없는 사원을
--   출력하되 manager_id컬럼값 NULL 대신 CEO로 출력하시오.
    SELECT first_name, nvl(to_char(manager_id), 'CEO')
    FROM employees
    ORDER BY manager_id DESC;

--2) 가장최근에 입사한 사원의 입사일과 가장오래된 사원의 입사일을 구하시오.
   SELECT max(hire_date), min(hire_date)
   FROM employees;
 
--3) 부서별로 커미션을 받는 사원의 수를 구하시오.
   SELECT department_id, count(commission_pct)
   FROM employees
   WHERE commission_pct Is NOT NULL
   GROUP BY department_id;
   
--4) 부서별 최대급여가 10000이상인 부서만 출력하시오.   
   SELECT department_id, max(salary)
   FROM employees
   GROUP BY department_id
   HAVING max(salary) >= 10000
   ORDER BY department_id;

--5) employees 테이블에서 직종이 'IT_PROG'인 사원들의 급여평균을 구하는 SELECT문장을 기술하시오.
   SELECT avg(salary)
   FROM employees
   GROUP BY job_id
   HAVING job_id = 'IT_PROG';

   SELECT avg(salary)
   FROM employees
   WHERE job_id = 'IT_PROG';

--6) employees 테이블에서 직종이 'FI_ACCOUNT' 또는 'AC_ACCOUNT' 인 사원들 중 최대급여를  구하는    SELECT문장을 기술하시오.     
   SELECT max(salary)
   FROM employees
   WHERE job_id = 'FI_ACCOUNT' OR job_id = 'AC_ACCOUNT';
  
   SELECT max(salary)
   FROM employees
   WHERE job_id IN('FI_ACCOUNT', 'AC_ACCOUNT');
   
--7) employees 테이블에서 50부서의 최소급여를 출력하는 SELECT문장을 기술하시오.
    SELECT department_id, min(salary)
    FROM employees
    GROUP BY department_id
    HAVING department_id = 50;
    
    SELECT min(salary)
    FROM employees
    WHERE department_id = 50;
    
--8) employees 테이블에서 아래의 결과처럼 입사인원을 출력하는 SELECT문장을 기술하시오.
--   <출력:  2001		   2002		       2003
 --  	     1              7                6   >
   SELECT  to_char(hire_date, 'yyyy'), COUNT(*)
   FROM employees
   GROUP BY to_char(hire_date, 'yyyy')
   ORDER BY to_char(hire_date, 'yyyy');
   
   SELECT sum(decode(to_char(hire_date, 'yyyy'), '2001', 1, 0)) AS "2001",
          sum(decode(to_char(hire_date, 'yyyy'), '2002', 1, 0)) AS "2002",
          sum(decode(to_char(hire_date, 'yyyy'), '2003', 1, 0)) AS "2003",
          sum(decode(to_char(hire_date, 'yyyy'), '2004', 1, 0)) AS "2004",
          sum(decode(to_char(hire_date, 'yyyy'), '2005', 1, 0)) AS "2005",
          sum(decode(to_char(hire_date, 'yyyy'), '2006', 1, 0)) AS "2006",
          sum(decode(to_char(hire_date, 'yyyy'), '2007', 1, 0)) AS "2007",
          sum(decode(to_char(hire_date, 'yyyy'), '2008', 1, 0)) AS "2008"
   FROM employees;
    
--9) employees 테이블에서 각 부서별 인원이 10명 이상인 부서의 부서코드,
--  인원수,급여의 합을 구하는  SELECT문장을 기술하시오.
   SELECT department_id, count(*), sum(salary)
   FROM employees
   GROUP BY department_id
   HAVING count(*) >=10;
  
--10) employees 테이블에서 이름(first_name)의 세번째 자리가 'e'인 직원을 검색하시오.
   SELECT  first_name
   FROM employees
   where first_name LIKE '__e%';
   
--   SELECT  first_name
--   FROM employees
--   where instr(first_name, 'e') = 3;
   
   --instr(데이터, 찾을 문자, 시작위치, 순서)
   SELECT  first_name
   FROM employees
   where instr(first_name, 'e', 3, 1) = 3;
   
   --substr(데이터, 시작위치, 갯수)
   SELECT first_name
   FROM employees
   WHERE substr(first_name, 3, 1) = 'e';
   
   SELECT instr('korea', 'e', 2, 2)
   FROM dual; --0
   
   --instr('koreae', 'e', 2, 2) korea에서 e를 2번째인덱스(o)부터 첫번째로 나오는 e를 찾아라.
   SELECT instr('koreae', 'e', 2, 2)
   FROM dual; --6
   
   



