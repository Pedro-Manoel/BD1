-- Questão 1
SELECT count(*) 
FROM employee
WHERE
    sex = 'F';


-- Questão 2
SELECT avg(salary) 
FROM employee 
WHERE 
    sex = 'M' and
    address LIKE '%TX';


-- Questão 3
SELECT s.ssn ssn_supervisor, count(*) qtd_supervisionados
FROM employee e LEFT OUTER JOIN employee s ON e.superssn = s.ssn
GROUP BY s.ssn
ORDER BY count(*);


-- Questão 4 
SELECT s.fname nome_supervisor, count(*) qtd_supervisionados
FROM employee e INNER JOIN employee s ON e.superssn = s.ssn
GROUP BY s.ssn
ORDER BY count(*);


-- Questão 5
SELECT s.fname nome_supervisor, count(*) qtd_supervisionados
FROM employee e LEFT OUTER JOIN employee s ON e.superssn = s.ssn
GROUP BY s.ssn
ORDER BY count(*);


-- Questão 6
SELECT count(*) qtd FROM (
    SELECT w.pno pno, count(*) count_project
    FROM project p, employee e, works_on w
    WHERE
        w.essn = e.ssn and
        w.pno = p.pnumber
    GROUP BY w.pno
    ) r
GROUP BY r.count_project
HAVING count(*) = min(r.count_project);


-- Questão 7
SELECT r.pno num_projeto, r.count_project qtd_func FROM (
    SELECT w.pno pno, count(*) count_project
    FROM project p, employee e, works_on w
    WHERE
        w.essn = e.ssn and
        w.pno = p.pnumber
    GROUP BY w.pno
    ) r
   WHERE r.count_project = (
        SELECT min(s.qtd) FROM (
            SELECT count(*) qtd
            FROM project p, employee e, works_on w
            WHERE
                w.essn = e.ssn and
                w.pno = p.pnumber
            GROUP BY w.pno
        ) s
    );


-- Questão 8
SELECT w.pno num_proj, avg(e.salary) media_sal 
FROM project p, employee e, works_on w
WHERE
    w.essn = e.ssn and
    w.pno = p.pnumber
GROUP BY w.pno;


-- Questão 9
SELECT w.pno proj_num, p.pname proj_nome, avg(e.salary) media_sal 
FROM project p, employee e, works_on w
WHERE
    w.essn = e.ssn and
    w.pno = p.pnumber
GROUP BY w.pno, p.pname;


-- Questão 10
SELECT e.fname, e.salary
FROM employee e LEFT OUTER JOIN works_on w ON e.ssn = w.essn and w.pno != 92 
WHERE
    e.salary > ALL (
            SELECT e.salary 
            FROM employee e INNER JOIN works_on w ON w.essn = e.ssn and w.pno = 92     
        );


-- Questão 11
SELECT e.ssn, count(w.pno)
FROM 
    employee e LEFT OUTER JOIN works_on w ON e.ssn = w.essn
GROUP BY e.ssn
ORDER BY count(w.pno);


-- Questão 12
SELECT w.pno num_proj, count(e.ssn) qtd_func
FROM 
    employee e LEFT OUTER JOIN works_on w ON e.ssn = w.essn
GROUP BY w.pno
HAVING count(e.ssn) < 5
ORDER BY count(e.ssn);


-- Questão 13
SELECT fname
FROM employee
WHERE ssn IN (
        SELECT essn
        FROM works_on
        WHERE pno IN (
            SELECT pnumber
            FROM project
            WHERE plocation = 'Sugarland' 
        )
    ) and ssn IN (SELECT essn FROM dependent);


-- Questão 14
SELECT dname
FROM department
WHERE
    dnumber != ALL (SELECT dnum FROM project);


-- Questão 15
SELECT fname, lname
FROM employee 
WHERE
    NOT EXISTS (
        (
            SELECT pno
            FROM works_on
            WHERE  
                essn = '123456789'
        )
        EXCEPT (
            SELECT pno
            FROM works_on
            WHERE  
                ssn = essn and
                ssn != '123456789'
        )
    );


-- Questão 16
SELECT e.fname, e.salary
FROM 
    employee e LEFT OUTER JOIN works_on w ON e.ssn = w.essn
    and w.pno != 
    (
        SELECT p.pnumber
        FROM works_on w, employee e, project p
        WHERE
            w.essn = e.ssn and
            w.pno = p.pnumber
        GROUP BY p.pnumber
        HAVING avg(e.salary) = (
            SELECT max(avg)
            FROM (
                    SELECT p.pnumber, avg(e.salary)
                    FROM works_on w, employee e, project p
                    WHERE
                        w.essn = e.ssn and
                        w.pno = p.pnumber
                    GROUP BY p.pnumber
                ) r1
        )
    ) 
WHERE
    e.salary > ALL (
            SELECT e.salary 
            FROM 
                employee e INNER JOIN works_on w ON w.essn = e.ssn 
                and w.pno = (
                    SELECT p.pnumber
                    FROM works_on w, employee e, project p
                    WHERE
                        w.essn = e.ssn and
                        w.pno = p.pnumber
                    GROUP BY p.pnumber
                    HAVING avg(e.salary) = (
                        SELECT max(avg)
                        FROM (
                                SELECT p.pnumber, avg(e.salary)
                                FROM works_on w, employee e, project p
                                WHERE
                                    w.essn = e.ssn and
                                    w.pno = p.pnumber
                                GROUP BY p.pnumber
                            ) r2
                    )
                )     
        );
