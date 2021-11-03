--- Questão 1

-- (A)
CREATE VIEW vw_dptmgr AS
    SELECT d.dnumber d_number, e.fname d_mgr_fname
    FROM department d, employee e
    WHERE d.mgrssn = e.ssn;

-- (B) 
CREATE VIEW vw_empl_houston AS
    SELECT ssn e_ssn, fname e_fname
    FROM employee
    WHERE address LIKE '%Houston%';

-- (C) 
CREATE VIEW vw_deptstats AS
    SELECT d.dnumber d_number, d.dname d_name, count(*) d_num_emp 
    FROM department d, employee e
    WHERE d.dnumber = e.dno
    GROUP BY d.dnumber;

-- (D) 
CREATE VIEW vw_projstats AS
    SELECT p.pnumber p_number, count(*) p_num_emp 
    FROM project p LEFT JOIN works_on w ON p.pnumber = w.pno
    GROUP BY p.pnumber;

----------------------------------------------------------------------------------------------------

--- Questão 2

-- Consulta da view (vw_dptmgr)
SELECT * FROM vw_dptmgr;

-- Retorno da consulta
"""
 d_number | d_mgr_fname
----------+-------------
        5 | Franklin
        4 | Jennifer
        1 | James
        6 | Jared
        7 | Alex
        8 | John
(6 rows)
"""

-- Consulta da view (vw_empl_houston)
SELECT * FROM vw_empl_houston;

-- Retorno da consulta
"""
   e_ssn   | e_fname
-----------+----------
 888665555 | James
 333445555 | Franklin
 123456789 | John
 453453453 | Joyce
 987987987 | Ahmad
(5 rows)
"""

-- Consulta da view (vw_deptstats)
SELECT * FROM vw_deptstats;

-- Retorno da consulta
"""
 d_number |     d_name     | d_num_emp
----------+----------------+-----------
        8 | Sales          |        14
        4 | Administration |         3
        1 | Headquarters   |         1
        5 | Research       |         4
        6 | Software       |         8
        7 | Hardware       |        10
(6 rows)
"""

-- Consulta da view (vw_projstats)
SELECT * FROM vw_projstats;

-- Retorno da consulta
"""
 p_number | p_num_emp
----------+-----------
       20 |         3
       10 |         3
        2 |         3
       91 |         8
       30 |         3
       62 |         8
       92 |         3
        1 |         2
        3 |         2
       61 |         9
       63 |         4
(11 rows)
"""

----------------------------------------------------------------------------------------------------

--- Questão 3

DROP VIEW vw_dptmgr;
DROP VIEW vw_empl_houston;
DROP VIEW vw_deptstats;
DROP VIEW vw_projstats;

----------------------------------------------------------------------------------------------------

--- Questão 4

CREATE OR REPLACE FUNCTION check_age (emp_ssn CHAR)
RETURNS VARCHAR(7) AS
$$
    DECLARE
        emp_age SMALLINT;
    BEGIN
        -- Atribuindo a idade do funcionário a variável  
        SELECT date_part('year', AGE(CURRENT_DATE, bdate)) 
        INTO emp_age
        FROM employee
        WHERE ssn = emp_ssn;
        
        -- Fazendo a checagem da idade do funcionário
        IF (emp_age >= 50) THEN 
            RETURN 'SENIOR';
        ELSIF (emp_age < 50 AND emp_age >= 0) THEN 
            RETURN 'YOUNG';
        ELSIF (emp_age < 0) THEN 
            RETURN 'INVALID';
        ELSE 
            RETURN 'UNKNOWN';
        END IF;
    END;
$$  LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------

--- Questão 5

CREATE OR REPLACE FUNCTION check_mgr () RETURNS trigger AS $check_mgr$
    DECLARE
        emp_dno INTEGER;
        emp_num_sub SMALLINT;
        emp_type VARCHAR(7);
    BEGIN
        -- Atribuindo os dados do gerente as variáveis
        SELECT emp.dno, count(sub), check_age(emp.ssn)
        INTO emp_dno, emp_num_sub, emp_type 
        FROM employee emp LEFT OUTER JOIN employee sub ON emp.ssn = sub.superssn
        WHERE emp.ssn = NEW.mgrssn
        GROUP BY emp.ssn;

        -- O gerente não é um funcionário atualmente alocado no departamento ou não existe
        IF emp_dno <> NEW.dnumber OR emp_dno IS NULL THEN
            RAISE EXCEPTION 'manager must be a department''s employee';
        END IF;

        -- O gerente não possui subordinados
        IF emp_num_sub = 0 THEN
            RAISE EXCEPTION 'manager must have supevisees';
        END IF;

        -- O gerente não é 'SENIOR'
        IF emp_type <> 'SENIOR' THEN
            RAISE EXCEPTION 'manager must be a SENIOR employee';
        END IF;

        RETURN NEW;
    END;
$check_mgr$ LANGUAGE plpgsql;

CREATE TRIGGER check_mgr 
BEFORE INSERT OR UPDATE ON 
department FOR EACH ROW EXECUTE PROCEDURE check_mgr();
