--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_id_medicamento_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_funcionario_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_cliente_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_id_farmacia_fkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_cpf_gerente_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_id_medicamento_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_id_endereco_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_cpf_cliente_fkey;
ALTER TABLE ONLY public.endereco_cliente DROP CONSTRAINT endereco_cliente_cpf_cliente_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_tipo_excl;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_bairro_key;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_pkey;
ALTER TABLE ONLY public.endereco_cliente DROP CONSTRAINT endereco_cliente_pkey;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
DROP TABLE public.venda;
DROP TABLE public.medicamento;
DROP TABLE public.funcionario;
DROP TABLE public.farmacia;
DROP TABLE public.entrega;
DROP TABLE public.endereco_cliente;
DROP TABLE public.cliente;
DROP FUNCTION public.get_venda_exclusiva_por_receita_medicamento(id_medicamento integer);
DROP FUNCTION public.get_tipo_funcionario(cpf_funcionario character);
DROP FUNCTION public.endereco_pertence_a_cliente(id_endereco integer, cpf_cliente character);
DROP TYPE public.tipo_funcionario;
DROP TYPE public.estado_nordeste;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estado_nordeste; Type: TYPE; Schema: public; Owner: pedromha
--

CREATE TYPE public.estado_nordeste AS ENUM (
    'MA',
    'PI',
    'CE',
    'RN',
    'PB',
    'PE',
    'AL',
    'SE',
    'BA'
);


ALTER TYPE public.estado_nordeste OWNER TO pedromha;

--
-- Name: tipo_funcionario; Type: TYPE; Schema: public; Owner: pedromha
--

CREATE TYPE public.tipo_funcionario AS ENUM (
    'farmacêutico',
    'vendedor',
    'entregador',
    'caixa',
    'administrador'
);


ALTER TYPE public.tipo_funcionario OWNER TO pedromha;

--
-- Name: endereco_pertence_a_cliente(integer, character); Type: FUNCTION; Schema: public; Owner: pedromha
--

CREATE FUNCTION public.endereco_pertence_a_cliente(id_endereco integer, cpf_cliente character) RETURNS boolean
    LANGUAGE sql
    AS $_$

    SELECT EXISTS (SELECT * FROM endereco_cliente WHERE id = $1 AND cpf_cliente = $2);

$_$;


ALTER FUNCTION public.endereco_pertence_a_cliente(id_endereco integer, cpf_cliente character) OWNER TO pedromha;

--
-- Name: get_tipo_funcionario(character); Type: FUNCTION; Schema: public; Owner: pedromha
--

CREATE FUNCTION public.get_tipo_funcionario(cpf_funcionario character) RETURNS public.tipo_funcionario
    LANGUAGE sql
    AS $_$

    SELECT tipo FROM funcionario WHERE cpf = $1;

$_$;


ALTER FUNCTION public.get_tipo_funcionario(cpf_funcionario character) OWNER TO pedromha;

--
-- Name: get_venda_exclusiva_por_receita_medicamento(integer); Type: FUNCTION; Schema: public; Owner: pedromha
--

CREATE FUNCTION public.get_venda_exclusiva_por_receita_medicamento(id_medicamento integer) RETURNS boolean
    LANGUAGE sql
    AS $_$

    SELECT venda_exclusiva_por_receita FROM medicamento WHERE id = $1;

$_$;


ALTER FUNCTION public.get_venda_exclusiva_por_receita_medicamento(id_medicamento integer) OWNER TO pedromha;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.cliente (
    cpf character(11) NOT NULL,
    nome character varying(160) NOT NULL,
    data_nascimento date NOT NULL,
    telefone character varying(18) NOT NULL,
    email character varying(50),
    CONSTRAINT cliente_cpf_check CHECK ((length(cpf) = 11)),
    CONSTRAINT cliente_data_nascimento_check CHECK ((date_part('year'::text, age((('now'::text)::date)::timestamp with time zone, (data_nascimento)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.cliente OWNER TO pedromha;

--
-- Name: endereco_cliente; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.endereco_cliente (
    id integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    endereco text NOT NULL,
    tipo character(10) NOT NULL,
    CONSTRAINT endereco_cliente_tipo_check CHECK ((tipo = ANY (ARRAY['residência'::bpchar, 'trabalho'::bpchar, 'outro'::bpchar])))
);


ALTER TABLE public.endereco_cliente OWNER TO pedromha;

--
-- Name: entrega; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.entrega (
    id integer NOT NULL,
    id_medicamento integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    id_endereco integer NOT NULL,
    valor numeric,
    CONSTRAINT entrega_check CHECK (public.endereco_pertence_a_cliente(id_endereco, cpf_cliente))
);


ALTER TABLE public.entrega OWNER TO pedromha;

--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    cnpj character(18) NOT NULL,
    cpf_gerente character(11),
    tipo character(1) NOT NULL,
    nome character varying(160) NOT NULL,
    bairro character varying(120) NOT NULL,
    cidade character varying(50) NOT NULL,
    estado public.estado_nordeste NOT NULL,
    telefone character varying(18) NOT NULL,
    email character varying(50),
    CONSTRAINT farmacia_cnpj_check CHECK ((length(cnpj) = 18)),
    CONSTRAINT farmacia_cpf_gerente_check CHECK ((public.get_tipo_funcionario(cpf_gerente) = ANY (ARRAY['administrador'::public.tipo_funcionario, 'farmacêutico'::public.tipo_funcionario]))),
    CONSTRAINT farmacia_tipo_check CHECK ((tipo = ANY (ARRAY['S'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.farmacia OWNER TO pedromha;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome character varying(160) NOT NULL,
    data_nascimento date NOT NULL,
    endereco text NOT NULL,
    telefone character varying(18) NOT NULL,
    email character varying(50),
    tipo public.tipo_funcionario NOT NULL,
    id_farmacia integer,
    CONSTRAINT funcionario_cpf_check CHECK ((length(cpf) = 11))
);


ALTER TABLE public.funcionario OWNER TO pedromha;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nome character varying(160) NOT NULL,
    valor numeric NOT NULL,
    venda_exclusiva_por_receita boolean NOT NULL
);


ALTER TABLE public.medicamento OWNER TO pedromha;

--
-- Name: venda; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    cpf_funcionario character(11) NOT NULL,
    id_medicamento integer NOT NULL,
    cpf_cliente character(11),
    data date NOT NULL,
    CONSTRAINT venda_check CHECK (((public.get_venda_exclusiva_por_receita_medicamento(id_medicamento) = false) OR (cpf_cliente IS NOT NULL))),
    CONSTRAINT venda_cpf_funcionario_check CHECK ((public.get_tipo_funcionario(cpf_funcionario) = 'vendedor'::public.tipo_funcionario))
);


ALTER TABLE public.venda OWNER TO pedromha;

--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Data for Name: endereco_cliente; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Data for Name: entrega; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: pedromha
--



--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);


--
-- Name: endereco_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.endereco_cliente
    ADD CONSTRAINT endereco_cliente_pkey PRIMARY KEY (id);


--
-- Name: entrega_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_pkey PRIMARY KEY (id);


--
-- Name: farmacia_bairro_key; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_bairro_key UNIQUE (bairro);


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: farmacia_tipo_excl; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_tipo_excl EXCLUDE USING gist (tipo WITH =) WHERE ((tipo = 'S'::bpchar));


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id);


--
-- Name: venda_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: endereco_cliente_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.endereco_cliente
    ADD CONSTRAINT endereco_cliente_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: entrega_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: entrega_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.endereco_cliente(id);


--
-- Name: entrega_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES public.medicamento(id);


--
-- Name: farmacia_cpf_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_cpf_gerente_fkey FOREIGN KEY (cpf_gerente) REFERENCES public.funcionario(cpf);


--
-- Name: funcionario_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacia(id);


--
-- Name: venda_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: venda_cpf_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_funcionario_fkey FOREIGN KEY (cpf_funcionario) REFERENCES public.funcionario(cpf);


--
-- Name: venda_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES public.medicamento(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


--
-- COMANDOS ADICIONAIS
--

"""

--- (1)  Uma farmácia pode ser sede ou filial


-- inserindo uma farmácia como filial
-- deve ser executado com sucesso 
INSERT INTO farmacia (id, cnpj, cpf_gerente, tipo, nome, bairro, cidade, estado, telefone, email) 
VALUES
  (4871, '74.541.413/0001-10', null, 'F', 'Drogarias Big Bem', 'Jóquei', 'Teresina', 'PI', '(54) 43549-6054', null);


-- inserindo uma farmácia como sede
-- deve ser executado com sucesso 
INSERT INTO farmacia (id, cnpj, cpf_gerente, tipo, nome, bairro, cidade, estado, telefone, email) 
VALUES
  (1299, '51.419.624/0001-89', null, 'S', 'Drogaria do Povo', 'São Judas Tadeu', 'Parnaíba', 'PI', '(14) 34703-1642', null);


-- inserindo uma farmácia como agência
-- deve retornar um erro pois viola a constraint farmacia_tipo_check, uma vez que uma farmácia só pode ser sede ou filial
INSERT INTO farmacia (id, cnpj, cpf_gerente, tipo, nome, bairro, cidade, estado, telefone, email) 
VALUES
  (3726, '13.304.763/0001-78', null, 'A', 'Farma Cura', 'Cabo Branco', 'João Pessoa', 'PB', '(14) 34703-1642', null);

-- Erro exibido
--
-- ERROR:  new row for relation 'farmacia' violates check constraint 'farmacia_tipo_check'
-- DETAIL:  Failing row contains (3726, 13.304.763/0001-78, null, A, Farma Cura, Cabo Branco, João Pessoa, PB, (14) 34703-1642, null).


------------------------------------------------------------------------------------------------


--- (2)  Funcionários podem ser farmacêuticos, vendedores, entregadores, caixas ou administradores 
---      (e não se pretende criar outros tipos de funcionários)


-- inserindo um funcionário do tipo farmacêutico, vendedor, entregador, caixa e administrador
-- deve ser executado com sucesso 
INSERT INTO funcionario (cpf, nome, data_nascimento, endereco, telefone, email, tipo, id_farmacia) 
VALUES
  ('88851469024', 'Juan Cauã Vieira', '1991-12-27', '57052-402, Gruta de Lourdes, Rua Antônio Lima, 780', '(36) 50929-4175', null, 'farmacêutico', 4871),
  ('38050728056', 'Aurora Tânia Esther', '1992-08-06', '79017-632, Nova Lima, Rua Abílio Siqueira, 843', '(79) 62040-8093', null, 'vendedor', null),
  ('15161033002', 'Mateus Carlos Daniel', '1956-01-23', '78099-055, Pedra 90, Rua Onze, 158', '(86) 66337-6701', null, 'entregador', 1299),
  ('99500261057', 'Brenda Aline Almeida', '1943-05-19', '58056-190, Mangabeira, Rua Ana Leal Correia, 617', '(83) 98588-4298', 'bbrendaaline@group.com.br', 'caixa', 4871),
  ('91419231030', 'Helena Carolina Melissa', '1972-02-17', '77810-016, Jardim Bounganville, Avenida Jacuba, 236', '(63) 2969-4227', 'helenacarolina-76@riobc.com.br', 'administrador', null);


-- inserindo um funcionário do tipo cozinheiro
-- deve retornar um erro pois viola o enum tipo_funcionario utilizado na relação, uma vez que um funcionário só pode ser do tipo farmacêutico, vendedor, entregador, caixa ou administrador
INSERT INTO funcionario (cpf, nome, data_nascimento, endereco, telefone, email, tipo, id_farmacia) 
VALUES
  ('49486744351', 'Gael Luiz Nunes', '1993-07-24', '45651-314, Malhado, Avenida Uberlândia, 755', '(73) 99166-1178', null, 'cozinheiro', null);

-- Erro exibido
--
-- ERROR:  invalid input value for enum tipo_funcionario: 'cozinheiro'
-- LINE 3: ...venida Uberlândia, 755', '(73) 99166-1178', null, 'cozinheir...
--                                                              ^


------------------------------------------------------------------------------------------------


--- (3)  Cada funcionário está lotado em uma única farmácia
--- (5)  Funcionários podem não estar lotados em nenhuma farmácia


-- Estes requisitos são compridos graças a existência da coluna id_farmacia, na relação funcionario, que
-- é uma chave estrangeira para a coluna id da relação farmacia, devido a isso, cada funcionário 
-- só está relacionado a uma única farmácia, ou a nenhuma.


------------------------------------------------------------------------------------------------


--- (4)  Cada farmácia tem um (e apenas um) gerente (que é um funcionáio)


-- Este requisito é comprido graças a existência da coluna cpf_gerente, na relação farmacia, que
-- é uma chave estrangeira para a coluna cpf da relação funcionario, devido a isso, cada farmácia 
-- tem um (e apenas um) gerente (que é um funcionáio), ou nenhum gerente.


------------------------------------------------------------------------------------------------


--- (6)  Clientes podem ter mais de um endereço cadastrado
--- (7)  Os endereços do cliente podem ser residência, trabalho ou 'outro'


-- inserindo alguns clientes
-- deve ser executado com sucesso 
INSERT INTO cliente (cpf, nome, data_nascimento, telefone, email)
VALUES
  ('88821597954', 'Cecília Raimunda Lima', '1974-10-06', '(66) 3768-0895', null),
  ('60131778218', 'Rafael Pietro Sales', '1993-10-23', '(84) 99948-1647', 'rrafaelpietro144@corpocl.com.br'),
  ('11362040916', 'Luciana Betina Rezende', '1958-04-23', '(85) 2627-1073', null);


-- inserindo 4 endereços do tipo, residência, trabalho e 'outro', para um cliente
-- deve ser executado com sucesso
INSERT INTO endereco_cliente (id, cpf_cliente, endereco, tipo)
VALUES
  (13356, '60131778218', '66820-720, Tenoné, Rua Oito de Outubro, 834', 'residência'),
  (47012, '60131778218', '71828-027, Riacho Fundo I, Colônia Agrícola Sucupira, 108', 'trabalho'),
  (18800, '60131778218', '21241-970, Vigário Geral, Rua Correia Dias 256 Lojas G, H e I, 944', 'outro'),
  (29452, '60131778218', '29156-010, Cariacica Sede, Rua Goiás, 621', 'residência'); 


-- inserindo um endereço do tipo férias para um cliente
-- deve retornar um erro pois viola a constraint endereco_cliente_tipo_check, uma vez que os endereços do cliente só podem ser do tipo residência, trabalho ou 'outro'
INSERT INTO endereco_cliente (id, cpf_cliente, endereco, tipo)
VALUES
  (32842, '88821597954', '65095-465, Vila Esperança, Rua Trinta de Abril, 706', 'férias'); 

-- Erro exibido
--
-- ERROR:  new row for relation 'endereco_cliente' violates check constraint 'endereco_cliente_tipo_check'
-- DETAIL:  Failing row contains (32842, 88821597954, 65095-465, Vila Esperança, Rua Trinta de Abril, 706, férias).


------------------------------------------------------------------------------------------------


--- (8)  Medicamentos podem ter uma característica: venda exclusiva com receita


-- Este requisito é comprido graças a existência da coluna venda_exclusiva_por_receita, 
-- do tipo BOOLEAN, na relação medicamento.


------------------------------------------------------------------------------------------------


--- (9)  Entregas são realizadas apenas para clientes cadastrados (em algum endereço válido do cliente)


-- inserindo alguns medicamentos
-- deve ser executado com sucesso
INSERT INTO medicamento (id, nome, valor, venda_exclusiva_por_receita) 
VALUES
  (352147, 'Amoxicilina', 23.00, TRUE),
  (368390, 'Dipirona', 4.85, FALSE),
  (200079, 'Dorfles', 12.50, FALSE),
  (318600, 'Benegrip', 9.35, FALSE),
  (124476, 'Venalot', 75.00, TRUE),
  (230604, 'Cetoconazol', 14.80, TRUE),
  (799611, 'Profenid', 40.23, FALSE),
  (322219, 'Mioflex', 15.88, TRUE);


-- inserindo uma entrega para um cliente passando um de seus endereços
-- deve ser executado com sucesso
INSERT INTO entrega (id, id_medicamento, cpf_cliente, id_endereco, valor) 
VALUES
  (4627616, 368390, '60131778218', 13356, 5.00);


-- inserindo uma entrega para um cliente passando um endereço de outro cliente
-- deve retornar um erro pois viola a constraint entrega_check, uma vez que o endereço informado não é um dos endereços do cliente
INSERT INTO entrega (id, id_medicamento, cpf_cliente, id_endereco, valor) 
VALUES
  (4288965, 799611, '11362040916', 29452, 7.20);

-- Erro exibido
--
-- ERROR:  new row for relation 'entrega' violates check constraint 'entrega_check'
-- DETAIL:  Failing row contains (4288965, 799611, 11362040916, 29452, 7.20).


-- inserindo uma entrega para um cliente não cadastrado
-- deve retornar um erro pois viola a constraint not-null, uma vez que a entrega é para um cliente não cadastrado
INSERT INTO entrega (id, id_medicamento, cpf_cliente, id_endereco, valor) 
VALUES
  (1247751, 799611, null, 47012, 5.30);

-- Erro exibido
--
-- ERROR:  null value in column 'cpf_cliente' violates not-null constraint
-- DETAIL:  Failing row contains (1247751, 799611, null, 47012, 5.30).


------------------------------------------------------------------------------------------------


--- (10) Outras vendas podem ser realizadas para qualquer cliente (cadastrados ou não)
--- (18) Uma venda deve ser feita por um funcionário vendedor


-- inserindo uma venda de um funcionário vendedor para um cliente cadastrado
-- deve ser executado com sucesso
INSERT INTO venda (id, cpf_funcionario, id_medicamento, cpf_cliente, data) 
VALUES
  (95524713, '38050728056', 368390, '88821597954', '2020-11-06');


-- inserindo uma venda de um funcionário vendedor para um cliente não cadastrado
-- deve ser executado com sucesso
INSERT INTO venda (id, cpf_funcionario, id_medicamento, cpf_cliente, data) 
VALUES
  (41292584, '38050728056', 368390, null, '2020-03-12');


-- inserindo uma venda de um funcionário não vendedor para um cliente cadastrado
-- deve retornar um erro pois viola a constraint venda_cpf_funcionario_check, uma vez que uma venda só pode ser realizada por um funcionário vendedor
INSERT INTO venda (id, cpf_funcionario, id_medicamento, cpf_cliente, data) 
VALUES
  (95688297, '15161033002', 368390, '88821597954', '2021-08-01');

-- Erro exibido
--
-- ERROR:  new row for relation 'venda' violates check constraint 'venda_cpf_funcionario_check'
-- DETAIL:  Failing row contains (95688297, 15161033002, 368390, 88821597954, 2021-08-01).


-- inserindo uma venda de um funcionário não vendedor para um cliente não cadastrado
-- deve retornar um erro pois viola a constraint venda_cpf_funcionario_check, uma vez que uma venda só pode ser realizada por um funciobário vendedor
INSERT INTO venda (id, cpf_funcionario, id_medicamento, cpf_cliente, data) 
VALUES
  (67114918, '15161033002', 368390, null, '2020-06-13');

-- Erro exibido
--
-- ERROR:  new row for relation 'venda' violates check constraint 'venda_cpf_funcionario_check'
-- DETAIL:  Failing row contains (67114918, 15161033002, 368390, null, 2020-06-13).


------------------------------------------------------------------------------------------------


--- (11) Não deve ser possível excluir um funcionário que esteja vinculado a alguma venda


-- excluindo um funcionário vinculado a uma venda
-- deve retornar um erro pois viola a constraint venda_cpf_funcionario_fkey, uma vez que não é possível excluir um funcionário vinculado a alguma venda
DELETE FROM funcionario WHERE cpf = '38050728056';

-- Erro exibido
--
-- ERROR:  update or delete on table 'funcionario' violates foreign key constraint 'venda_cpf_funcionario_fkey' on table 'venda'
-- DETAIL:  Key (cpf)=(38050728056) is still referenced from table 'venda'.


------------------------------------------------------------------------------------------------


--- (12) Não deve ser possível excluir um medicamento que esteja vinculado a alguma venda


-- excluindo um medicamento vinculado a uma venda
-- deve retornar um erro pois viola a constraint entrega_id_medicamento_fkey, uma vez que não é possível excluir um medicamento vinculado a alguma venda
DELETE FROM medicamento WHERE id = '368390';

-- Erro exibido
--
-- ERROR:  update or delete on table 'medicamento' violates foreign key constraint 'venda_id_medicamento_fkey' on table 'venda'
-- DETAIL:  Key (id)=(368390) is still referenced from table 'venda'.


------------------------------------------------------------------------------------------------


--- (13) Clientes cadastrados devem ser maiores de 18 anos


-- inserindo um cliente com 18 anos
-- deve ser executado com sucesso 
INSERT INTO cliente (cpf, nome, data_nascimento, telefone, email)
VALUES
  ('07826662303', 'Débora Evelyn Simone Duarte', '2002-12-01', '(27) 99341-0628', null);


-- inserindo um cliente maior de 18 anos, com 19 anos
-- deve ser executado com sucesso 
INSERT INTO cliente (cpf, nome, data_nascimento, telefone, email)
VALUES
  ('97305209767', 'Giovana Letícia Moraes', '2002-03-13', '(63) 99294-6793', null);


-- inserindo um cliente menor de 18 anos, com 17 anos
-- deve retornar um erro pois viola a constraint cliente_data_nascimento_check, uma vez que não é possível inserir um cliente menor de 18 anos
INSERT INTO cliente (cpf, nome, data_nascimento, telefone, email)
VALUES
  ('02868824005', 'Eliane Marina da Rocha', '2003-12-19', '(85) 2627-1073', null);

-- Erro exibido
--
-- ERROR:  new row for relation 'cliente' violates check constraint 'cliente_data_nascimento_check'
-- DETAIL:  Failing row contains (02868824005, Eliane Marina da Rocha, 2003-12-19, (85) 2627-1073, null).


------------------------------------------------------------------------------------------------


--- (14) Só pode haver uma única farmácia por bairro


-- inserindo uma farmácia no bairro Floresta
-- deve ser executado com sucesso
INSERT INTO farmacia (id, cnpj, cpf_gerente, tipo, nome, bairro, cidade, estado, telefone, email) 
VALUES
  (5883, '94.659.979/0001-58', null, 'F', 'Farma Vida', 'Floresta', 'Joinville', 'BA', '(47) 2785-1728', null);


-- inserindo outra farmácia no bairro Floresta
-- deve retornar um erro pois viola a constraint farmacia_bairro_key, uma vez que só pode existir uma farmácia por bairro
INSERT INTO farmacia (id, cnpj, cpf_gerente, tipo, nome, bairro, cidade, estado, telefone, email) 
VALUES
  (1408, '45.638.753/0001-65', null, 'F', 'Farmácia Bom de Preço', 'Floresta', 'Joinville', 'BA', '(47) 98483-6214', null);

-- Erro exibido
--
-- ERROR:  duplicate key value violates unique constraint 'farmacia_bairro_key'
-- DETAIL:  Key (bairro)=(Floresta) already exists.


------------------------------------------------------------------------------------------------


--- (15) Há apenas uma sede


-- inserindo outra farmácia como sede
-- deve retornar um erro pois viola a constraint farmacia_tipo_excl, uma vez que só pode existir uma farmácia como sede
INSERT INTO farmacia (id, cnpj, cpf_gerente, tipo, nome, bairro, cidade, estado, telefone, email) 
VALUES
  (1813, '52.579.589/0001-28', null, 'S', 'Farmácia da Gente', 'Centenário', 'Boa Vista', 'AL', '(95) 98786-8953', null);

-- Erro exibido
--
-- ERROR:  conflicting key value violates exclusion constraint 'farmacia_tipo_excl'
-- DETAIL:  Key (tipo)=(S) conflicts with existing key (tipo)=(S).


------------------------------------------------------------------------------------------------


--- (16) Gerentes podem ser apenas administradores ou farmacêuticos


-- atualizando uma farmácia para que o cpf_gerente seja de um funcionário do tipo administrador
-- deveser executado com sucesso
UPDATE farmacia SET cpf_gerente = '91419231030' WHERE id = 4871; 


-- atualizando uma farmácia para que o cpf_gerente seja de um funcionário do tipo farmacêutico
-- deveser executado com sucesso
UPDATE farmacia SET cpf_gerente = '88851469024' WHERE id = 1299;


-- atualizando uma farmácia para que o cpf_gerente seja de um funcionário do tipo vendedor
-- deve retornar um erro pois viola a constraint farmacia_cpf_gerente_check, uma vez que o gerente de uma farmácia só pode ser do tipo administrador ou farmacêutico 
UPDATE farmacia SET cpf_gerente = '38050728056' WHERE id = 5883; 

-- Erro exibido
--
-- ERROR:  new row for relation 'farmacia' violates check constraint 'farmacia_cpf_gerente_check'
-- DETAIL:  Failing row contains (5883, 94.659.979/0001-58, 38050728056, F, Farma Vida, Floresta, Joinville, BA, (47) 2785-1728, null).


------------------------------------------------------------------------------------------------


--- (17) Medicamentos com venda exclusiva por receita só devem ser vendidos a clientes cadastrados


-- inserindo uma venda de um medicamento, com venda exclusiva por receita, para um cliente cadastrado
-- deve ser executado com sucesso
INSERT INTO venda (id, cpf_funcionario, id_medicamento, cpf_cliente, data) 
VALUES
  (62985281, '38050728056', 352147, '07826662303', '2019-08-03');


-- inserindo uma venda de um medicamento, com venda exclusiva por receita, para um cliente não cadastrado
-- deve retornar um erro pois viola a constraint venda_check, uma vez que os medicamentos com venda exclusiva por receita só devem ser vendidos a clientes cadastrados
INSERT INTO venda (id, cpf_funcionario, id_medicamento, cpf_cliente, data) 
VALUES
  (86554975, '38050728056', 352147, null, '2019-11-24');

-- Erro exibido
--
-- ERROR:  new row for relation 'venda' violates check constraint 'venda_check'
-- DETAIL:  Failing row contains (86554975, 38050728056, 352147, null, 2019-11-24).


------------------------------------------------------------------------------------------------


--- (19) Defina uma coluna na tabela farmácia para representar o estado onde está localizada e adicione um 
---      mecanismo para restringir os possíveis valores a serem inseridos nesta coluna: um dos 9 estados 
---      do nordeste. Não use CHECK para especificar esta constraint 


-- Este requisito é comprido graças a existência do enum estado_nordeste, que contem os valores:
-- ('MA','PI','CE','RN','PB','PE','AL','SE','BA'), e ele está definido como o tipo da coluna 
-- estado da relação farmacia.

"""
