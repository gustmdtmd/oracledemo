/*================================================
ROLLUP () 함수, CUBE () 함수
================================================*/
SELECT department_id, job_id, count(*)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

/*
ROLLUP(column1, column2)
 (column1, column2)
 (column1)
 ()
 
 ROLLUP(department_id, job_id)
 20	MK_MAN	1  --그룹
 20	MK_REP	1  --그룹
 20         2  --그룹
           107 --총계
*/

SELECT department_id, count(*)
FROM employees
GROUP BY rollup(department_id)
ORDER BY department_id;

SELECT department_id, job_id, count(*)
FROM employees
GROUP BY rollup(department_id, job_id)
ORDER BY department_id, job_id;

/*
 CUBE()함수
 CUBE(column1, column2)
     (column1, column2)
     (column1)
     (column2)
     ()

 CUBE(department_id, job_id)
 20	MK_MAN	1  --그룹
 20	MK_REP	1  --그룹
 20         2  --소계
    MK_MAN  1  --소계
    MK_REP  1  --소계
           107 --총계
*/

SELECT department_id, count(*)
FROM employees
GROUP BY CUBE(department_id)
ORDER BY department_id;

SELECT department_id, job_id, count(*)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id, job_id;

SELECT department_id, job_id, count(*)
FROM employees
GROUP BY CUBE((department_id, job_id))
ORDER BY department_id, job_id;

/*-----------------------------------------------
GROUPING SETS() 함수
-----------------------------------------------*/

SELECT department_id, job_id, count(*)
FROM employees
GROUP BY GROUPING SETS(department_id, job_id)
ORDER BY department_id, job_id;

SELECT department_id, job_id, count(*)
FROM employees
-- 분리해서 할 경우 GROUPING SETS을 빼고 할 때와 같다
GROUP BY GROUPING SETS(department_id), (job_id)
ORDER BY department_id, job_id;
--위의 식과 같은 결과
SELECT department_id, job_id, count(*)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

SELECT CASE department_id 
        WHEN 10 THEN 'A'
        WHEN 20 THEN 'B'
        ELSE 'C'
    END AS "alias"
FROM employees;

--그루핑은 rollup or cube와 함께 사용
--GROUP BY d.department_name, rollup(job_id)
SELECT CASE GROUPING(d.department_name) --부서명으로 그룹을 지음
            WHEN 1 THEN 'ALL Departments' -- 1 = 집계
            ELSE d.department_name -- rollup안에 있지않기때문에 나오지않음.
        END AS "DNAME",
        CASE GROUPING(e.job_id) --업무명으로 그룹을 지음
            WHEN 1 THEN 'ALL Jobs' -- 1 = 집계
            ELSE e.job_id
        END AS "JOB",
/* SELECT   department_name, job_id,*/
        count(*) AS "Total sal",
        sum(e.salary) AS "Total sal"
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name, rollup(job_id);
--ORDER BY JOB;

-- GROUP BY rollup(d.department_name, job_id)
SELECT CASE GROUPING(d.department_name)
            WHEN 1 THEN 'ALL Departments'
            ELSE d.department_name
        END AS "DNAME",
        CASE GROUPING(e.job_id)
            WHEN 1 THEN 'ALL Jobs'
            ELSE e.job_id
        END AS "JOB",
        count(*) AS "Total sal",
        sum(e.salary) AS "Total sal"
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY rollup(d.department_name, job_id);

/*--------------------------------------------------------
그룹내 순위관련함수
RANK() OVER() : 특정 컬럼에 대한 순위를 구하는 함수로 동일한 값에 대해서는 동일한 순위를 준다.
DENSE_RANK() OVER() : 동일한 순위를 하나의 건수로 취급한다.
ROW() OVER() : 동일한 값이라도 고유한 순위를 부여한다.
--------------------------------------------------------*/
SELECT job_id, first_name, salary, rank() over(ORDER BY salary DESC)
FROM employees; -- 1 2 2 4 같은 순위가 있으면 다음 순위가 그만큼 밀려난다.

-- 그룹별로 순위를 부여할 때 사용 : PARTITION BY
SELECT job_id, first_name, salary, rank() over(PARTITION BY job_id ORDER BY salary DESC)
FROM employees; -- 1 1 1 ... 1 2 3 4 5 ..

SELECT job_id, first_name, salary, dense_rank() over(ORDER BY salary DESC)
FROM employees; -- 1 2 2 3 같은 순위가 있어도 다음순위는 밀리지 않고 나온다.

SELECT job_id, first_name, salary, row_number() over(ORDER BY salary DESC)
FROM employees; -- 1 2 3 4 같은 점수이면 먼저 나온 값에 먼저 순위를 준다.



/*=====================================================================================================
 계층형 질의
 1. START WITH 절은 계층구조 전개이 시작 위치를 지정하는 구문이다. 
 2. CONNECT BY 절은 다음에 전개될 자식 데이터를 지정하는 구문이다. 
 3. 루트 데이터는 LEVEL 1이다. (0이 아님) (의사컬럼)
    (1)CONNECT_BY_ROOT(의사컬럼)  
       - 현재 조회된 최상위 정보 
    (2)CONNECT_BY_ISLEAF(의사컬럼) 
       - 현재 행이 마지막 계층의 데이터인지 확인 
       - LEAF을 만나면 1을 반환하고 0을 반환
    (3) SYS_CONNECT_BY_PATH( 컬럼, 구분자)(의사컬럼)
        - 루트 노드부터 해당 행까지의 경로를 입력한 컬럼기준으로 구분자를 사용해서 보여줌  
    (4)CONNECT_BY_ISCYCLE(의사컬럼)  
       - 현재 행의 조상이기도 한 자식을 갖는 경우 1을 반환 
       - 이 의사컬럼을 사용하기 위해서 CONNECT BY다음에 NOCYCLE을 사용해야한다.
 4. PRIOR 자식 = 부모 (부모->자식 방향으로 전개. 순방향 전개)
    PRIOR 부모 = 자식 (자식->부모 방향으로 전개. 역방향 전개)
 ================================================================================*/
SELECT first_name, lpad(first_name, 10)
FROM employees;

SELECT first_name, lpad(first_name, 10, '*')
FROM employees;

--매니저 -> 사원
SELECT employee_id, manager_id, LEVEL, lpad(' ',3*(LEVEL-1)) || first_name
FROM employees
START WITH manager_id IS NULL --시작점
CONNECT BY PRIOR employee_id = manager_id; --사원이 매니저랑 같음


SELECT employee_id, first_name, manager_id
FROM employees;


-- 사원 -> 매니저
SELECT employee_id, manager_id, LEVEL, lpad(' ',3*(LEVEL-1)) || first_name
FROM employees
START WITH manager_id IS NOT NULL
CONNECT BY PRIOR manager_id = employee_id;


--CONNECT_BY_ROOT : 최상위 루트값을 가져올때 사용.
SELECT employee_id, manager_id, LEVEL, lpad(' ',3*(LEVEL-1)) || first_name,
        CONNECT_BY_ROOT employee_id 
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;


--CONNECT_BY_ISLEAF : 최하위값인지 물어볼때 사용. true 이면 1, false 이면 0
SELECT employee_id, manager_id, LEVEL, lpad(' ',3*(LEVEL-1)) || first_name,
        CONNECT_BY_ROOT employee_id , CONNECT_BY_ISLEAF 
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;

--ORDER SIBLINGS BY : 레벨 단위로 정렬해줌.
SELECT employee_id, manager_id, LEVEL, lpad(' ',3*(LEVEL-1)) || first_name,
        CONNECT_BY_ROOT employee_id , CONNECT_BY_ISLEAF , SYS_CONNECT_BY_PATH(first_name, '/')
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY first_name; 










