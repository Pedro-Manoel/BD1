--- 8.24 


-- (a)
{ 
  e.Fname, e.Lname | EMPLOYEE(e) 
  and (e.Dno = 5) -- projetos do departamento 5 
  and (∃ p) (∃ w) (
    PROJECT(p) and WORKS_ON(w) 
    and e.Ssn = w.Essn and w.Pno = p.Pnumber -- condição de junção
    and p.Pname = 'ProdutoX' and w.Hours > 10 -- condição de seleção
  ) 
}

-- (b)
{
 e.Fname, e.Lname | EMPLOYEE(e)
 and (∃ d) (
   DEPENDENT(d)
   and e.Ssn = d.Essn -- condição de junção
   and e.Fname = d.Dependent_name -- condição de seleção
 )  
}

-- (c)
{
  e.Fname, e.Lname | EMPLOYEE(e)
  and (∃ s) (
    EMPLOYEE(s)
    and e.Super_ssn = s.Ssn -- condição de junção
    and s.Fname = 'Franklin' and s.Lname = 'Wong' -- condição de seleção
  ) 
}

-- (e) 
{
  e.Fname, e.Lname | EMPLOYEE(e)
  and (∀ p) (
    not(PROJECT(p))
    or (∃ w) (
      and w.Essn = e.ssn 
      and w.Pno = p.Pnumber
    )
  )
}

-- (f)
{
  e.Fname, e.Lname | EMPLOYEE(e)
  and not(∃ w) (
    WORKS_ON(w)
    and w.Essn = e.ssn
  )
}

-- (i)
{
  e.Fname, e.Lname, e.Address | EMPLOYEE(e)
  and (∃ w) (∃ p) not(∃ dl) (
    WORKS_ON(w) and PROJECT(p) and DEPT_LOCATIONS(dl) 
    and w.Essn = e.ssn -- funcionário que tem projeto
    and w.Pno = p.Pnumber -- projetos do funcionário
    and p.Plocation = 'Houston' -- localização do projeto em Houston
    and dl.Dnumber = e.Dno -- localização do departamento do funcionário
    and dl.Dlocation == 'Houston' -- localização do departamento em Houston
  ) 
}

-- (j)
{
  e.Lname | EMPLOYEE(e)
  and (∃ d) not(∃ de) (
    DEPARTMENT(d) and DEPENDENT(de)
    and e.Ssn = d.Mgr_ssn
    and e.Ssn = de.Essn
  )
}


--- 8.26 


-- (c) 
-- Não é possível

-- (d)
{
  s.Name, c.Course_name, c.Course_number, c.Credit_hours, se.Semester, se.Year, g.Grade  | STUDENT(s) and COURSE(c) and SECTION(se) and GRADE_REPORT(g)
  and s.Class = 5
  and s.Major = 'CS'  
  and s.Student_number = g.Student_number
  and g.Section_identifier = se.Section_identifier
  and c.Course_number = se.Course_number 
}

-- (e)
{
  s.Name, s.Major | STUDENT(s)
  and (∀ g) (
    not(GRADE_REPORT(g))
    or not(s.Student_number = g.Student_number)
    or g.Grade = 'A'
  )
}


--- 8.30


-- (a) σ A=c (R(A, B, C))
{
  r | R(r) and r.A = r.C
}

-- (b) π <A, B> (R(A, B, C))
{
  r.A, r.B | R(r)
}

-- (c) R(A, B, C) * S(C, D, E)
{
  r.A, r.B, s.D, s.E | R(r) and S(s)
  and r.C = s.C
}

-- (d) R(A, B, C) U S(A, B, C)
{
  t | R(t) or S(t)
}

-- (e) R(A, B, C) ∩ S(A, B, C)
{
  t | R(t) and S(t)
}

-- (f) R(A, B, C)  ̶ S(A, B, C)
{
  t | R(t) and not(S(t))
}

-- (g) R(A, B, C) X S(D, E, F)
{
  r.A, r.B, r.C, s.D, s.E, s.F | R(r) and S(s)
}
