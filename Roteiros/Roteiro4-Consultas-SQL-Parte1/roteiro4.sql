-- Questão 1
SELECT * FROM department;


-- Questão 2
SELECT * FROM dependent;


-- Questão 3
SELECT * FROM dept_locations;


-- Questão 4
SELECT * FROM employee;


-- Questão 5
SELECT * FROM project;


-- Questão 6
SELECT * FROM works_on;


-- Questão 7
SELECT e.fname, e.lname 
FROM employee e 
WHERE 
    e.sex = 'M';


-- Questão 8
SELECT e.fname 
FROM employee e 
WHERE 
    e.sex = 'M' and 
    e.superssn IS NULL; 


-- Questão 9
SELECT e.fname employee_fname, s.fname super_fname 
FROM employee e, employee s 
WHERE 
    e.superssn = s.ssn; 


-- Questão 10
SELECT e.fname 
FROM employee e, employee s 
WHERE 
    e.superssn = s.ssn and 
    s.fname = 'Franklin';


-- Questão 11
SELECT d.dname, dl.dlocation 
FROM department d, dept_locations dl 
WHERE 
    d.dnumber = dl.dnumber; 


-- Questão 12
SELECT d.dname 
FROM department d, dept_locations dl 
WHERE 
    d.dnumber = dl.dnumber and 
    dl.dlocation LIKE 'S%';


-- Questão 13
SELECT e.fname, e.lname, d.dependent_name 
FROM employee e, dependent d 
WHERE 
    e.ssn = d.essn;


-- Questão 14
SELECT e.fname ||' '|| e.minit ||' '|| e.lname full_name, e.salary salary 
FROM employee e 
WHERE 
    e.salary > 50000;


-- Questão 15
SELECT p.pname, d.dname
FROM project p, department d 
WHERE 
    p.dnum = d.dnumber;


-- Questão 16
SELECT p.pname, e.fname 
FROM project p, department d, employee e 
WHERE 
    p.dnum = d.dnumber and 
    d.mgrssn = e.ssn and 
    p.pnumber > 30; 


-- Questão 17
SELECT p.pname, e.fname
FROM project p, employee e, works_on w
WHERE 
    w.essn = e.ssn and 
    w.pno = p.pnumber;


-- Questão 18
SELECT e.fname, d.dependent_name, d.relationship
FROM employee e, dependent d, works_on w
WHERE 
    w.essn = e.ssn and 
    w.pno = 91 and 
    e.ssn = d.essn; 
    