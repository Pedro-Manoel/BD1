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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(120) NOT NULL,
    funcao character(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcionario_check CHECK (((funcao = 'SUP_LIMPEZA'::bpchar) OR ((funcao = 'LIMPEZA'::bpchar) AND (superior_cpf IS NOT NULL)))),
    CONSTRAINT funcionario_nivel_check CHECK ((nivel = ANY (ARRAY['J'::bpchar, 'P'::bpchar, 'S'::bpchar])))
);


ALTER TABLE public.funcionario OWNER TO pedromha;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: pedromha
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao text NOT NULL,
    func_resp_cpf character(11),
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT tarefas_check CHECK ((((status = ANY (ARRAY['E'::bpchar, 'C'::bpchar])) AND (func_resp_cpf IS NOT NULL)) OR (status = 'P'::bpchar))),
    CONSTRAINT tarefas_func_resp_cpf_check CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT tarefas_prioridade_check CHECK (((prioridade >= 0) AND (prioridade <= 5)))
);


ALTER TABLE public.tarefas OWNER TO pedromha;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: pedromha
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA    ', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1985-02-04', 'Carlos Almeida', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1992-11-12', 'Kristian Viana', 'SUP_LIMPEZA', 'S', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1989-04-06', 'Rogério Ponte', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '2001-08-17', 'Evandro Figueira', 'LIMPEZA    ', 'J', '12345678914');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1999-12-01', 'Rafaella Ferraço', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1992-08-24', 'Mara Lemes', 'LIMPEZA    ', 'P', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1980-06-18', 'Hugo Barreiros', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920', '1983-02-09', 'Roberto Souto', 'LIMPEZA    ', 'P', '12345678919');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '1988-03-08', 'Estefany Andrade', 'SUP_LIMPEZA', 'J', '12345678919');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1985-02-19', 'Sara Ramos', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1986-05-08', 'Milene Solano', 'LIMPEZA    ', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1986-04-13', 'Afonso Barbosa', 'SUP_LIMPEZA', 'P', NULL);


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: pedromha
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pedromha
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--
