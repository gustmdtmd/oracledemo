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

