--
--- Questão 1
--

-- Criando a relação pedida na questão
CREATE TABLE tarefas (
  codigo INTEGER,
  especificacao TEXT,
  codigo_responsavel CHAR(11),
  numero SMALLINT,
  categoria CHAR(1)
);

-- Inserções que devem funcionar (Comandos 1)
INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F'); -- inserção realizada
INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F'); -- inserção realizada
INSERT INTO tarefas VALUES (null, null, null, null, null); -- inserção realizada

-- Inserções que não devem funcionar (Comandos 1)
INSERT INTO tarefas VALUES (2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F'); -- inserção não realizada
INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF'); -- inserção não realizada


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 2
--

-- Comandos 2
-- Funcinou após executar o código da solução
INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A'); 

-- Erro exibido
"""
ERROR:  integer out of range
"""

-- Compreensão do erro
"""
Como a coluna codigo (primeira coluna da tabela), foi declarada como do tipo inteiro ele está limitada 
aos valores -2147483648 a +2147483647, logo para que posssa receber valores maiores como o 2147483648 
é preciso modificar seu tipo para um tipo numerico com um limite maior, como o bigint que pode conter 
valores de -9223372036854775808 a +9223372036854775807.
"""

-- Solução
ALTER TABLE tarefas ALTER COLUMN codigo TYPE BIGINT;


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 3 
--

ALTER TABLE tarefas ALTER COLUMN numero type SMALLINT;

-- Inserções que não devem funcionar (Comandos 3)
INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', 32768, 'A'); -- inserção não realizada
INSERT INTO tarefas VALUES (2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A'); -- inserção não realizada

-- Inserções que devem funcionar (Comandos 4)
INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A'); -- inserção realizada
INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A'); -- inserção realizada


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 4 
--

-- Comandos ALTER TABLE e ALTER COLUMN pedidos na questão 
-- Funcinou após executar o código da solução
ALTER TABLE tarefas ALTER COLUMN codigo SET NOT NULL;
ALTER TABLE tarefas RENAME COLUMN codigo TO id;

ALTER TABLE tarefas ALTER COLUMN especificacao SET NOT NULL;
ALTER TABLE tarefas RENAME COLUMN especificacao TO descricao;

ALTER TABLE tarefas ALTER COLUMN codigo_responsavel SET NOT NULL;
ALTER TABLE tarefas RENAME COLUMN codigo_responsavel TO func_resp_cpf;

ALTER TABLE tarefas ALTER COLUMN numero SET NOT NULL;
ALTER TABLE tarefas RENAME COLUMN numero TO prioridade;

ALTER TABLE tarefas ALTER COLUMN categoria SET NOT NULL;
ALTER TABLE tarefas RENAME COLUMN categoria TO status;

-- Erro exibido
"""
ERROR:  column 'codigo' contains null values
"""

-- Compreensão do erro
"""
Não posso definir uma coluna como NOT NULL enquanto houver tuplas com valores NULL nesta coluna. 
"""

-- Solução
DELETE FROM tarefas 
WHERE 
  codigo IS NULL OR
  especificacao IS NULL OR
  codigo_responsavel IS NULL OR
  numero IS NULL OR
  categoria IS NULL;


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 5 
--

-- Adicionando a eestrinção de integridade

-- Definindo a coluna id como chave primária
ALTER TABLE tarefas ADD PRIMARY KEY (id); 

-- Inserção que deve funcionar (Comandos 5) 
INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A'); -- inserção realizada

-- Inserção que não deve funcionar (Comandos 5)
INSERT INTO tarefas VALUES (2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A'); -- inserção não realizada


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 6 
--

--- (A)

-- Adicionando a constraint pedida na questão 
ALTER TABLE tarefas ADD CHECK (LENGTH(func_resp_cpf) = 11);

-- Realizando os testes da constraint

-- cpf com 10 caracteres
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '3232323291', 2, 'A'); -- inserção não realizada
-- cpf com 11 caracteres
INSERT INTO tarefas VALUES (2300000000, 'aparar as janelas do 4o andar', '32323232911', 3, 'A'); -- inserção realizada
-- cpf com 12 caracteres
INSERT INTO tarefas VALUES (2400000000, 'aparar as janelas do 4o andar', '323232329111', 3, 'A'); -- inserção não realizada

-- deletando as tuplas de testes inseridas na tabela
DELETE FROM tarefas WHERE id = 2300000000; -- delete realizado

--- (B)

-- Atualizando os valores da coluna status da tabela tarefas antes de adicionar o check
UPDATE tarefas SET status = 'P' WHERE status = 'A'; 
UPDATE tarefas SET status = 'E' WHERE status = 'R'; 
UPDATE tarefas SET status = 'C' WHERE status = 'F'; 

-- Adicionando o check pedido na questão
ALTER TABLE tarefas ADD CHECK (status IN ('P','E','C'));

-- Realizando os testes do check

-- Inserções que não devem funcionar
-- status = 'A'
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '32323232911', 3, 'A'); -- inserção não realizada
-- status = 'R'
INSERT INTO tarefas VALUES (2300000000, 'limpar portas do 4o andar', '32323232911', 3, 'R'); -- inserção não realizada
-- status = 'F'
INSERT INTO tarefas VALUES (2400000000, 'limpar portas do 5o andar', '32323232911', 3, 'F'); -- inserção não realizada
-- status = 'T'
INSERT INTO tarefas VALUES (2500000000, 'limpar portas do 6o andar', '32323232911', 3, 'T'); -- inserção não realizada

-- Inserções que devem funcionar
-- status = 'P'
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '32323232911', 3, 'P'); -- inserção realizada
-- status = 'E'
INSERT INTO tarefas VALUES (2300000000, 'limpar portas do 4o andar', '32323232911', 3, 'E'); -- inserção realizada
-- status = 'C'
INSERT INTO tarefas VALUES (2400000000, 'limpar portas do 5o andar', '32323232911', 3, 'C'); -- inserção realizada

-- deletando as tuplas de testes inseridas na tabela
DELETE FROM tarefas WHERE id = 2200000000 OR id = 2300000000 OR id = 2400000000;


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 7
--

-- Atualizando as tuplas com prioridade maior que 5
UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

-- Adicionando a constraint pedida na questão
ALTER TABLE tarefas ADD CHECK (prioridade >= 0 AND prioridade <= 5);

-- Realizando os testes do check

-- Inserções que não devem funcionar
-- prioridade = -1
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '32323232911', -1, 'P'); -- inserção não realizada
-- prioridade = -2
INSERT INTO tarefas VALUES (2300000000, 'limpar portas do 4o andar', '32323232911', -2, 'C'); -- inserção não realizada
-- prioridade = 6
INSERT INTO tarefas VALUES (2400000000, 'limpar portas do 5o andar', '32323232911', 6, 'P'); -- inserção não realizada
-- prioridade = 7
INSERT INTO tarefas VALUES (2500000000, 'limpar portas do 6o andar', '32323232911', 7, 'E'); -- inserção não realizada

-- Inserções que devem funcionar
-- prioridade = 0
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '32323232911', 0, 'P'); -- inserção realizada
-- prioridade = 3
INSERT INTO tarefas VALUES (2300000000, 'limpar portas do 4o andar', '32323232911', 3, 'E'); -- inserção realizada
-- prioridade = 5
INSERT INTO tarefas VALUES (2400000000, 'limpar portas do 5o andar', '32323232911', 5, 'C'); -- inserção realizada

-- deletando as tuplas de testes inseridas na tabela
DELETE FROM tarefas WHERE id = 2200000000 OR id = 2300000000 OR id = 2400000000;


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 8
--

-- Criando a relação pedida na questão
CREATE TABLE funcionario (
  cpf CHAR(11) PRIMARY KEY,
  data_nasc DATE NOT NULL,
  nome VARCHAR(120) NOT NULL,
  funcao CHAR(11) NOT NULL,
  nivel CHAR(1) NOT NULL,
  superior_cpf CHAR(11) REFERENCES funcionario (cpf),

  CHECK (funcao = 'SUP_LIMPEZA' OR (funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL)),
  CHECK (nivel IN ('J', 'P', 'S'))
);

-- Inserções que devem funcionar (Comandos 6)
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', null); -- inserção realizada

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911'); -- inserção realizada

-- Inserções que não devem funcionar (Comandos 6)
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678913', '1980-05-09', 'joao da Silva', 'LIMPEZA', 'J', null); -- inserção não realizada


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 9
--

-- Realizando a inserção de 10 tuplas válidas
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
VALUES
  ('12345678913', '1985-02-04', 'Carlos Almeida', 'SUP_LIMPEZA', 'S', null),
  ('12345678914', '1992-11-12', 'Kristian Viana', 'SUP_LIMPEZA', 'S', '12345678913'),
  ('12345678915', '1989-04-06', 'Rogério Ponte', 'SUP_LIMPEZA', 'P', null),
  ('12345678916', '2001-08-17', 'Evandro Figueira', 'LIMPEZA', 'J', '12345678914'),
  ('12345678917', '1999-12-01', 'Rafaella Ferraço', 'SUP_LIMPEZA', 'J', null),
  ('12345678918', '1992-08-24', 'Mara Lemes', 'LIMPEZA', 'P', '12345678913'),
  ('12345678919', '1980-06-18', 'Hugo Barreiros', 'SUP_LIMPEZA', 'S', null),
  ('12345678920', '1983-02-09', 'Roberto Souto', 'LIMPEZA', 'P', '12345678919'),
  ('12345678921', '1996-07-26', 'Leonel Cartaxo', 'SUP_LIMPEZA', 'P', null),
  ('12345678922', '1988-03-08', 'Estefany Andrade', 'SUP_LIMPEZA', 'J', '12345678919'); -- inserção realizada
  
-- 10 exemplos de inserções que não funcionam

-- nivel = 'A' não é permitido, só são permitidos os valores 'J', 'P' ou 'S'
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678923', '1985-02-19', 'Sara Lima', 'SUP_LIMPEZA', 'A', null); -- inserção não realizada 

-- funcao = 'LIMPEZA', mas superior_cpf = null, o que não é permitido
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678924', '1982-11-11', 'Ariana da Silva', 'LIMPEZA', 'S', null); -- inserção não realizada

-- a chave estrangeira, superio_cpf, aponta para um funcionário que não existe, o que não é permitido
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678925', '1986-05-08', 'Milene Cunha', 'LIMPEZA', 'J', '12345675820'); -- inserção não realizada

-- a chave primária, cpf, é igual a chave primária de outro funcionário, o que não é permitido
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678913', '1986-04-13', 'Afonso Pereira', 'SUP_LIMPEZA', 'P', null); -- inserção não realizada

-- funcao = 'GERENTE' não é permitido, só são permitidos os valores 'SUP_LIMPEZA' ou 'LIMPEZA'
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678932', '1987-01-02', 'Clara Barbosa', 'GERENTE', 'J', null); -- inserção não realizada

-- a chave primária, cpf, não pode ser null
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
(null, '1992-03-11', 'José Solano', 'SUP_LIMPEZA', 'S', null); -- inserção não realizada

-- a coluna data_nasc não pode ser null
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678928', null, 'Maria Fernanda', 'SUP_LIMPEZA', 'P', null); -- inserção não realizada

-- a coluna nome não pode ser null
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678929', '1999-10-03', null, 'SUP_LIMPEZA', 'P', null); -- inserção não realizada

-- a coluna funcao não pode ser null
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678930', '1986-06-16', 'Douglas Ramos', null, 'J', null); -- inserção não realizada

-- a coluna nivel não pode ser null
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('12345678931', '1987-07-18', 'Michael Mendes', 'SUP_LIMPEZA', null, null); -- inserção não realizada


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 10
--

--- (OPÇÃO 1) ON DELETE CASCADE

-- Adicionando a chave estrangeira de acordo com a OPÇÃO 1
-- Funcinou após executar o código da solução
ALTER TABLE tarefas ADD FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE CASCADE;

-- Erro exibido
"""
ERROR:  insert or update on table 'tarefas' violates foreign key constraint 'tarefas_func_resp_cpf_fkey'
DETAIL:  Key (func_resp_cpf)=(32323232955) is not present in table 'funcionario'.
"""

-- Compreensão do erro
"""
Os cpfs presentes nas tuplas da tabela tarefas na coluna func_resp_cpf 
não existem na coluna cpf da tabela funcionario.
"""

-- Solução 
-- Adicionando novos funcionários com um cpf que exista na coluna func_resp_cpf da tabela tarefas 
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) 
VALUES
  ('32323232955', '1985-02-19', 'Sara Ramos', 'SUP_LIMPEZA', 'S', null),
  ('32323232911', '1982-11-11', 'Ariana Mendes', 'SUP_LIMPEZA', 'S', '12345678911'),
  ('98765432111', '1986-05-08', 'Milene Solano', 'LIMPEZA', 'J', '12345678911'),
  ('98765432122', '1986-04-13', 'Afonso Barbosa', 'SUP_LIMPEZA', 'P', null); -- inserção realizada

-- Realizando a remoção do funcionário com o 'menor' cpf que possui alguma tarefa

-- 1° Passo
-- Executando um SQL para encontrar o funcionário requisitado
SELECT f.* FROM funcionario f INNER JOIN tarefas t ON
f.cpf = t.func_resp_cpf GROUP BY f.cpf ORDER BY CAST(f.cpf AS DECIMAL) LIMIT 1;

-- Resultado exibido da consulta realizada no 1° Passo
"""       
     cpf     | data_nasc  |     nome      |   funcao    | nivel | superior_cpf
-------------+------------+---------------+-------------+-------+--------------
 32323232911 | 1982-11-11 | Ariana Mendes | SUP_LIMPEZA | S     | 12345678911
"""

-- 2° Passo
-- Executando um SQL para deletar o funcionário encontrado no 1° Passo
DELETE FROM funcionario f WHERE f.cpf = '32323232911'; -- delete realizado


--- (OPÇÃO 2) ON DELETE RESTRICT

-- Adicionando a chave estrangeira de acordo com a OPÇÃO 2
ALTER TABLE tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE tarefas ADD FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE RESTRICT;

-- Executando um comando DELETE que seja bloqueado pela constraint adicionada 

-- Tentar remover algum funcionário que possui alguma tarefa
-- Executando um SQL para encontrar os funcionários requisitados
SELECT f.* FROM funcionario f INNER JOIN tarefas t ON
f.cpf = t.func_resp_cpf GROUP BY f.cpf;

-- Resultado da consulta realizada
"""       
     cpf     | data_nasc  |      nome      |   funcao    | nivel | superior_cpf
-------------+------------+----------------+-------------+-------+--------------
 32323232955 | 1985-02-19 | Sara Ramos     | SUP_LIMPEZA | S     |
 98765432111 | 1986-05-08 | Milene Solano  | LIMPEZA     | J     | 12345678911
 98765432122 | 1986-04-13 | Afonso Barbosa | SUP_LIMPEZA | P     |
"""

-- Executando um SQL para deletar o funcionário escolhido, Afonso Barbosa
DELETE FROM funcionario f WHERE f.cpf = '98765432122';

-- Erro exibido
"""
ERROR:  update or delete on table 'funcionario' violates foreign key constraint 'tarefas_func_resp_cpf_fkey' on table 'tarefas'
DETAIL:  Key (cpf)=(98765432122) is still referenced from table 'tarefas'.
"""

-- Compreensão do erro
"""
Como a chave estrangeira func_resp_cpf da tabela tarefas possui a constraint ON DELETE RESTRICT  
e como a sua referência é o cpf da tabela funcionario, então não se pode deletar um funcionario que 
possua alguma tarefa.
"""


------------------------------------------------------------------------------------------------------------------------------------- 


--
--- Questão 11 
--

-- Removendo da tabela tarefas o NOT NULL da coluna func_resp_cpf
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;

-- A coluna func_resp_cpf pode ser NULL somente se status for igual a 'P'

-- Removendo a constraint existente da coluna status para adicionala novamente acrescentando a condição imposta na coluna func_resp_cpf
ALTER TABLE tarefas DROP CONSTRAINT tarefas_status_check;
-- Adicionando a constraint pedida na questão
ALTER TABLE tarefas ADD CHECK ((status IN ('E', 'C') AND func_resp_cpf IS NOT NULL) OR status = 'P');

-- Realizando os testes da constraint

-- Inserções que não devem funcionar
-- func_resp_cpf = '12345678921', status = 'A'
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '12345678921', 3, 'A'); -- inserção não realizada
-- func_resp_cpf = '12345678921', status = 'R'
INSERT INTO tarefas VALUES (2300000000, 'limpar portas do 4o andar', '12345678921', 3, 'R'); -- inserção não realizada
-- func_resp_cpf = '12345678921', status = 'F'
INSERT INTO tarefas VALUES (2400000000, 'limpar portas do 5o andar', '12345678921', 3, 'F'); -- inserção não realizada
-- func_resp_cpf = '12345678921', status = 'T'
INSERT INTO tarefas VALUES (2500000000, 'limpar portas do 6o andar', '12345678921', 3, 'T'); -- inserção não realizada
-- func_resp_cpf = null, status = 'E'
INSERT INTO tarefas VALUES (2600000000, 'limpar portas do 3o andar', null, 5, 'E'); -- inserção não realizada
-- func_resp_cpf = null, status = 'C'
INSERT INTO tarefas VALUES (2700000000, 'limpar portas do 3o andar', null, 5, 'C'); -- inserção não realizada

-- Inserções que devem funcionar 
-- func_resp_cpf = '12345678921', status = 'P'
INSERT INTO tarefas VALUES (2200000000, 'limpar portas do 3o andar', '12345678921', 3, 'P'); -- inserção realizada
-- func_resp_cpf = null, status = 'P'
INSERT INTO tarefas VALUES (2300000000, 'limpar portas do 3o andar', null, 5, 'P'); -- inserção realizada
-- func_resp_cpf = '12345678921', status = 'E'
INSERT INTO tarefas VALUES (2400000000, 'limpar portas do 4o andar', '12345678921', 3, 'E'); -- inserção realizada
-- func_resp_cpf = '12345678921', status = 'C'
INSERT INTO tarefas VALUES (2500000000, 'limpar portas do 5o andar', '12345678921', 3, 'C'); -- inserção realizada

-- deletando as tuplas de testes inseridas na tabela
DELETE FROM tarefas WHERE func_resp_cpf = '12345678921' OR func_resp_cpf IS NULL; -- delete realizado

--- ON DELETE SET NULL

-- Adicionando a chave estrangeira de acordo com a questão
ALTER TABLE tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE tarefas ADD FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE SET NULL;

-- Realizando os testes da constraint

-- Testanto deletar um funcionário com três tarefas com status diferentes
-- Adicionando as tuplas de teste
INSERT INTO tarefas 
VALUES 
  (2200000000, 'limpar portas do 3o andar', '12345678921', 5, 'P'), 
  (2300000000, 'limpar janelas do 3o andar', '12345678921', 5, 'E'),
  (2400000000, 'limpar piso do 3o andar', '12345678921', 5, 'C'); -- inserção realizada

-- Deletando o funcionário
DELETE FROM funcionario WHERE cpf = '12345678921'; -- delete não realizado 

-- Erro exibido
"""
ERROR:  new row for relation 'tarefas' violates check constraint 'tarefas_check'
DETAIL:  Failing row contains (2300000000, limpar janelas do 3o andar, null, 5, E).
CONTEXT:  SQL statement 'UPDATE ONLY 'public'.'tarefas' SET 'func_resp_cpf' = NULL WHERE $1 OPERATOR(pg_catalog.=) 'func_resp_cpf''
"""

-- Compreensão do erro
"""
Como a chave estrangeira func_resp_cpf da tabela tarefas possui a constraint ON DELETE SET NULL  
e como a sua referência é o cpf da tabela funcionario, então não é possivel deletar um funcionario 
que possua alguma tarefa com o status igual a 'E' ou 'C', pois ao deletar um funcionário as suas tarefas 
ficarão o valor NULL na coluna func_resp_cpf, mas as tarefas de status igual a 'E' ou 'C' não podem 
ficar com o valor NULL na coluna func_resp_cpf.
"""

-- Testanto deletar 3 funcionários, onde cada um possui uma tarefa de status diferente
-- Atualizando as tuplas de teste
UPDATE tarefas SET func_resp_cpf = '12345678917' WHERE id = 2300000000;
UPDATE tarefas SET func_resp_cpf = '12345678918' WHERE id = 2400000000;

-- deletando o funcionário que está ligado a tarefa com o status igual a 'P'
DELETE FROM funcionario WHERE cpf = '12345678921'; -- delete realizado

-- deletando o funcionário que está ligado a tarefa com o status igual a 'E'
DELETE FROM funcionario WHERE cpf = '12345678917'; -- delete não realizado

-- Erro exibido
"""
ERROR:  new row for relation 'tarefas' violates check constraint 'tarefas_check'
DETAIL:  Failing row contains (2300000000, limpar janelas do 3o andar, null, 5, E).
CONTEXT:  SQL statement 'UPDATE ONLY 'public'.'tarefas' SET 'func_resp_cpf' = NULL WHERE $1 OPERATOR(pg_catalog.=) 'func_resp_cpf''
"""

-- Compreensão do erro
"""
Como a chave estrangeira func_resp_cpf da tabela tarefas possui a constraint ON DELETE SET NULL  
e como a sua referência é o cpf da tabela funcionario, então não é possivel deletar um funcionario 
que possua alguma tarefa com o status igual a 'E' ou 'C', pois ao deletar um funcionário as suas tarefas 
ficarão o valor NULL na coluna func_resp_cpf, mas as tarefas de status igual a 'E' ou 'C' não podem 
ficar com o valor NULL na coluna func_resp_cpf.
"""

-- deletando o funcionário que está ligado a tarefa com o status igual a 'C'
DELETE FROM funcionario WHERE cpf = '12345678918';-- delete não realizado

-- Erro exibido
"""
ERROR:  new row for relation 'tarefas' violates check constraint 'tarefas_check'
DETAIL:  Failing row contains (2400000000, limpar piso do 3o andar, null, 5, C).
CONTEXT:  SQL statement 'UPDATE ONLY 'public'.'tarefas' SET 'func_resp_cpf' = NULL WHERE $1 OPERATOR(pg_catalog.=) 'func_resp_cpf''
"""

-- Compreensão do erro
"""
Como a chave estrangeira func_resp_cpf da tabela tarefas possui a constraint ON DELETE SET NULL  
e como a sua referência é o cpf da tabela funcionario, então não é possivel deletar um funcionario 
que possua alguma tarefa com o status igual a 'E' ou 'C', pois ao deletar um funcionário as suas tarefas 
ficarão o valor NULL na coluna func_resp_cpf, mas as tarefas de status igual a 'E' ou 'C' não podem 
ficar com o valor NULL na coluna func_resp_cpf.
"""

-- deletando as tuplas de testes inseridas na tabela
DELETE FROM tarefas WHERE id = 2200000000 OR id = 2300000000 OR id = 2400000000;
