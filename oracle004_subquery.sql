/*-----------------------------------------------------------------
서브쿼리
1. 스칼라 쿼리 : SELECT
2. 인라인 뷰 : FROM
3. 서브쿼리 : WHERE
-----------------------------------------------------------------*/
--90번 부서에 근무하는 Lex사원의 정보를 출력하시오.
SELECT * 
FROM employees
WHERE department_id = 90
AND first_name = 'Lex';

--90번 부서에 근무하는 'Lex'사원이 근무하는 부서명을 출력하시오.
SELECT department_name
FROM departments
WHERE department_id = 90;

--'Lex'가 근무하는 부서명을 출력하시오.
SELECT department_id
FROM employees
WHERE first_name = 'Lex';

SELECT department_name
FROM departments
WHERE department_id = 90;

--join 이용
SELECT d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
 AND e.first_name = 'Lex';

--subquery 이용
SELECT department_name
FROM departments
WHERE department_id = (
                    SELECT distinct department_id --하나만 가지고 와야한다.
                    FROM employees
                    WHERE first_name = 'Lex'
                  );

--'Lex'와 동일한 업무(job_id)를 가진 사원의 이름(first_name),
--업무명(job_title), 입사일(hire_date)을 출력하시오.
SELECT e.first_name AS 이름,
       j.job_title AS 업무명,
       e.hire_date AS 입사일
FROM employees e, jobs j
WHERE e.job_id = j.job_id
AND e.job_id = (
                SELECT job_id
                FROM employees
                WHERE first_name = 'Lex'
                );

--'IT'에 근무하는 사원이름(first_name), 부서번호를 출력하시오
SELECT first_name, department_id
FROM employees
WHERE department_id = (
                    SELECT department_id
                    FROM departments
                    WHERE department_name = 'IT'
                    );

--'Bruce'보다 급여를 많이 받은 사원이름(first_name), 부서명, 급여를 출력하시오.
SELECT e.first_name, d.department_name, e.salary
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND e.salary > (
                SELECT salary
                FROM employees
                WHERE first_name = 'Bruce'
                )
ORDER BY e.salary;

--in, all, any, some ,exists

--Steven과 같은 부서에서 근무하는 사원의 이름, 급여, 입사일을 출력하시오.(in)
SELECT e.first_name, e.salary, e.hire_date
FROM employees e
WHERE department_id IN (
                        SELECT department_id
                        FROM employees
                        WHERE first_name = 'Steven'
                        );

--부서별로 가장 급여를 많이 받는 사원이름, 부서번호, 급여를 출력하시오.(in)
SELECT e.first_name, e.department_id, e.salary
FROM employees e
--WHERE 에서 2개면 서브쿼리에서도 2개. 즉, 갯수가 동일해야한다.
WHERE (e.department_id, e.salary) IN (
                                    SELECT department_id, max(salary)
                                    FROM employees
                                    GROUP BY department_id
                                    --ORDER BY department_id 서브쿼리에는 ORDER BY를 사용못함
                                    )
ORDER BY e.department_id;


--all은 모든값에 대해 만족해야하고, any는 한 개의 값에만 만족하면 된다.

--30부서의 소속된 모든 사원들의 급여보다 더 많은 급여를 받는 
--사원이름, 급여, 입사일을 출력하시오. (ALL)
--(서브쿼리에서 max()함수를 사용하지않는다.)
SELECT salary
FROM employees
WHERE department_id=30; -- 11000

SELECT first_name, salary, hire_date
FROM employees
WHERE salary > ALL (
                    SELECT salary
                    FROM employees
                    WHERE department_id=30
                    )
ORDER BY salary;

--30부서의 소속된 모든 사원들의 급여 중 최소 급여보다 더 많은 급여를 받는 
--사원이름, 급여, 입사일을 출력하시오. (ANY)
--(서브쿼리에서 min()함수를 사용하지않는다.)
 SELECT salary
 FROM employees
 WHERE department_id=30;  --2500

SELECT first_name, salary, hire_date
FROM employees
WHERE salary > ANY (
                    SELECT salary
                    FROM employees
                    WHERE department_id=30
                    )
ORDER BY salary;


--exists 서브쿼리에 존재하면 무조건 true, 없으면 무조건 false

--20부서에 사원이 있으면 사원들의 사원명, 입사일, 급여, 부서번호를 출력하시오.
SELECT first_name, hire_date, salary, department_id
FROM employees
WHERE EXISTS (
             SELECT department_id
             FROM employees
             WHERE department_id = 20
            );

--사원이 있는 부서만 출력하시오.
SELECT count(*)
FROM departments; /*총 부서 : 27개*/

--IN
SELECT department_id, department_name
FROM departments
WHERE department_id IN (
                        SELECT distinct department_id
                        FROM employees
                        WHERE department_id IS NOT NULL
                        --GROUP BY department_id 
                        --그룹이 필요없지만 사용한 이유는 중복제거하기위함 == distinct
                        );

--exists
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (
              SELECT 1
              FROM employees e
              WHERE e.department_id = d.department_id --true이면 EXISTS 참
              );

--사원이 없는 부서만 출력하시오.
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (
              SELECT 1
              FROM employees e
              WHERE e.department_id = d.department_id --true이면 EXISTS 참
              );

--부서가 있는 사원의 정보를 출력하시오.
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e
WHERE EXISTS (
             SELECT 1
             FROM departments d
             WHERE d.department_id = e.department_id
            );

--부서가 없는 사원의 정보를 출력하시오.
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e
WHERE NOT EXISTS (
             SELECT 1
             FROM departments d
             WHERE d.department_id = e.department_id
             );

-- 관리자가 있는 사원의 정보를 출력하시오.
SELECT count(*)
FROM employees
WHERE manager_id IS NOT NULL;

SELECT w.employee_id, w.first_name, w.manager_id
FROM employees w
WHERE EXISTS (
                SELECT 1
                FROM employees m
                WHERE m.manager_id = w.manager_id
                );

-- 관리자가 없는 사원의 정보를 출력하시오.
SELECT count(*)
FROM employees
WHERE manager_id IS NOT NULL;

-- 메인쿼리에 있는 컬럼은 서브쿼리에서 참조 가능하지만
-- 반대로 서브쿼리에 있는 컬럼은 메인쿼리에서 참조할 수 없다.
SELECT w.employee_id, w.first_name, w.manager_id
FROM employees w
WHERE NOT EXISTS (
                SELECT 1
                FROM employees m
                WHERE m.manager_id = w.manager_id
                );

/*------------------------------------------------------------
Top-N 서브쿼리
  상위의 값을 추출할 때 사용한다.
  <, <= 연산자를 사용할 수 있다. 단, 비교되는 값이 1일때는 =도 가능하다.
  ORDER BY절을 사용할 수 있다.
------------------------------------------------------------*/

--급여가 가장 높은 상위 3명을 검색하시오.
SELECT emp.first_name, emp.salary
FROM (
        SELECT first_name, salary
        FROM employees
        ORDER BY salary DESC
     ) emp --가상의 table
WHERE rownum <= 3; /*rownum은 select의 출력순서이다.*/

--급여가 가장 높은 상위 4위부터 8위까지 검색하시오.
SELECT emp2.*
FROM(
    SELECT rownum AS rm, emp.*
    FROM(
        SELECT first_name, salary
        FROM employees
        ORDER BY salary DESC
        )emp
    )emp2
WHERE emp2.rm >=4 AND emp2.rm<=8;


--월 별 입사자 수를 조회하되 입사자수가 가장 많은 상위 3개만 출력되도록 하세요.
-- <출력 : 월   입사자수>
SELECT emp.*
FROM (
    SELECT to_char(hire_date, 'mm') AS 월,
           count(*) AS 입사자수
    FROM employees    
    GROUP BY to_char(hire_date, 'mm')
    ORDER BY 입사자수 DESC
    )emp
WHERE rownum<=3;

