-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-09-04 14:04:41.005

-- tables
-- Table: EQUIPE
CREATE TABLE EQUIPE (
    id int  NOT NULL,
    nome varchar(120)  NOT NULL,
    cidade varchar(60)  NOT NULL,
    estado char(2)  NOT NULL,
    CONSTRAINT check_estado CHECK (LENGTH(estado) = 2) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT EQUIPE_pk PRIMARY KEY (id)
);

-- Table: JOGADOR
CREATE TABLE JOGADOR (
    cpf char(14)  NOT NULL,
    equipe_id int  NOT NULL,
    equipe_data_in date  NOT NULL,
    nome varchar(120)  NOT NULL,
    data_nasc date  NOT NULL,
    peso smallint  NOT NULL,
    altura real  NOT NULL,
    telefone varchar(15)  NOT NULL,
    email varchar(120)  NOT NULL,
    CONSTRAINT check_cpf CHECK (LENGTH(cpf) = 14) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT JOGADOR_pk PRIMARY KEY (cpf)
);

-- Table: JOGADOR_JOGO
CREATE TABLE JOGADOR_JOGO (
    jogo_id int  NOT NULL,
    jogador_cpf char(14)  NOT NULL,
    posicao varchar(11)  NOT NULL,
    CONSTRAINT check_cpf CHECK (LENGTH(jogador_cpf) = 14) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT check_posicao CHECK (posicao IN ('Goleiro', 'Fixo', 'Ala Equerda', 'Ala Direita', 'Pivô')) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT JOGADOR_JOGO_PK PRIMARY KEY (jogo_id,jogador_cpf)
);

-- Table: JOGO
CREATE TABLE JOGO (
    id int  NOT NULL,
    equipe1_id int  NOT NULL,
    equipe2_id int  NOT NULL,
    data date  NOT NULL,
    duracao time  NOT NULL,
    equipe1_gols smallint  NOT NULL,
    equipe2_gols smallint  NOT NULL,
    CONSTRAINT JOGO_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: JOGADOR_EQUIPE (table: JOGADOR)
ALTER TABLE JOGADOR ADD CONSTRAINT JOGADOR_EQUIPE
    FOREIGN KEY (equipe_id)
    REFERENCES EQUIPE (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: JOGADOR_JOGO_JOGADOR (table: JOGADOR_JOGO)
ALTER TABLE JOGADOR_JOGO ADD CONSTRAINT JOGADOR_JOGO_JOGADOR
    FOREIGN KEY (jogador_cpf)
    REFERENCES JOGADOR (cpf)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: JOGADOR_JOGO_JOGO (table: JOGADOR_JOGO)
ALTER TABLE JOGADOR_JOGO ADD CONSTRAINT JOGADOR_JOGO_JOGO
    FOREIGN KEY (jogo_id)
    REFERENCES JOGO (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: JOGO_EQUIPE1 (table: JOGO)
ALTER TABLE JOGO ADD CONSTRAINT JOGO_EQUIPE1
    FOREIGN KEY (equipe1_id)
    REFERENCES EQUIPE (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: JOGO_EQUIPE2 (table: JOGO)
ALTER TABLE JOGO ADD CONSTRAINT JOGO_EQUIPE2
    FOREIGN KEY (equipe2_id)
    REFERENCES EQUIPE (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

-- My Inserts

INSERT INTO EQUIPE (id, nome, cidade, estado) 
VALUES
   (9014, 'Cascavel', 'Cascavel', 'PR'),
   (7295, 'Intelli', 'São Carlos', 'SP'),
   (1307, 'Conilon Futsal', 'Vila Velha', 'ES'),
   (6418, 'Avaí', 'Florianópolis', 'SC'),
   (8202, 'JP Futsal', 'João Pessoa', 'PB'),
   (4633, 'Sumov', 'Fortaleza', 'CE'),
   (3308, 'John Deere', 'Horizontina', 'RS'),
   (2216, 'V&M Minas', 'Belo Horizonte', 'MG');
   
INSERT INTO JOGADOR (cpf, equipe_id, equipe_data_in, nome, data_nasc, peso, altura, telefone, email) 
VALUES
    ('344.313.896-95', 6418, '2017-04-19', 'Levi Emanuel Hugo Viana', '1986-11-18', 72, 1.64, '(31) 98434-6047', 'leviemanuel@gmail.com'),
    ('526.355.317-06', 7295, '2017-02-08', 'André Renato Henrique da Cruz', '1974-05-15', 82, 1.83, '(83) 99880-7614', 'andrerenatohenr-95@gmail.com'),
    ('144.836.894-44', 4633, '2016-10-01', 'Anderson Kevin Manoel da Paz', '1988-07-09', 70, 1.86, '(83) 98196-3402', 'aandersonkevin@megasurgical.com.br'),
    ('442.145.456-72', 9014, '2019-11-10', 'Yuri Bryan Monteiro', '2000-02-07', 91, 1.78, '(75) 99930-9935', 'yuribry84@salvagninigroup.com'),
    ('571.711.976-38', 3308, '2017-03-07', 'Arthur Ruan da Luz', '1990-01-11', 68, 1.82, '(51) 98720-7634', 'arthurruanda@bat.com'),
    ('363.347.989-95', 6418, '2017-04-19', 'André Cauê Theo Carvalho', '1992-04-12', 102, 1.86, '(61) 98519-6783', 'andrecaue222@eletroaquila.net'),
    ('557.011.724-57', 3308, '2017-03-07', 'Diego Pedro Henrique Tomás Almada', '1975-04-22', 90, 1.90, '(61) 98339-7264', 'diegopedro_@habby-appe.com.br'),
    ('157.328.511-00', 1307, '2018-05-22', 'Oliver Diego Duarte', '1993-12-18', 79, 1.70, '(68) 98857-0922', 'oliverdiegoduarte122@cenavip.com.br'),
    ('274.122.921-02', 8202, '2018-12-09', 'Thiago Matheus Paulo de Paula', '1994-04-18', 83, 1.75, '(82) 98979-4348', 'thiagomatheus@contabilsjc.com.br'),
    ('362.351.871-90', 9014, '2019-11-10', 'Vinicius José Victor Viana', '1990-11-11', 70, 1.62, '(27) 98442-1868', 'viniciusjose82@proimagem.com'),
    ('725.395.595-14', 8202, '2018-12-09', 'Guilherme Levi Silva', '1988-03-07', 108, 1.95, '(67) 99613-5534', 'guilhermelevisilva@fados.com.br'),
    ('441.228.640-11', 2216, '2018-11-06', 'Victor Nicolas Lucca Pereira', '2000-07-22', 98, 1.74, '(92) 99386-6430', 'victornicolas@maquinas.com.br'),
    ('320.456.260-32', 1307, '2018-05-22', 'Emanuel Filipe Anderson Figueiredo', '1998-06-17', 55, 1.67, '(96) 98983-5747', 'emanuelfil122@granvale.com.br'),
    ('002.792.455-64', 8202, '2018-12-09', 'Vicente Elias Vieira', '1998-02-01', 104, 1.97, '(66) 99789-9785', 'vicenteeliasvieira-87@somma.net.br'),
    ('159.735.990-43', 4633, '2016-10-01', 'Emanuel Bruno Igor Lopes', '1999-09-25', 92, 1.74, '(68) 99175-3679', 'brunogorlopes@finalcafe.com.br'),
    ('086.843.545-75', 9014, '2018-06-15', 'Manoel Pedro Cavalcanti', '1982-12-12', 106, 1.79, '(63) 98404-1036', 'manoelpedrocavalcanti@s2solucoes.com.br'),
    ('224.065.707-38', 6418, '2019-07-16', 'Sérgio Ruan da Cruz', '1988-11-28', 88, 1.86, '(81) 98974-5802', 'sergioruandacruz@trimempresas.com.br'),
    ('429.836.207-86', 1307, '2018-05-22', 'Filipe César Erick da Costa', '1984-04-14', 81, 1.92, '(84) 99958-6334', 'ffilipecesarerickdacosta@graffiti.net'),
    ('408.266.063-18', 2216, '2018-11-06', 'Luís Samuel Manoel Dias', '1986-06-13', 77, 1.94, '(27) 99264-6495', 'lluissamuel@amagno.com.br'),
    ('986.015.879-76', 7295, '2017-02-08', 'Lucca Levi Baptista', '1989-10-07', 81, 1.96, '(21) 98352-8077', 'llBaptista@gmail.com'),
    ('891.166.041-80', 2216, '2018-11-06', 'Severino Alexandre Carvalho', '1995-02-14', 88, 1.71, '(11) 99731-0673', 'sseverinoal@brasf.com.br'),
    ('100.780.610-91', 6418, '2017-04-19', 'Kaique Matheus Vicente Nunes', '1997-11-17', 104, 1.84, '(37) 99894-6637', 'kaiquematheusvicentenunes@bom.com.br'),
    ('406.310.135-55', 2216, '2018-11-06', 'Martin Eduardo Samuel Cavalcanti', '1989-08-08', 94, 1.82, '(62) 99532-3299', 'martineduardo@jammer.com.br'),
    ('564.892.576-02', 9014, '2018-06-15', 'Caio Daniel Pietro Jesus', '2000-03-13', 83, 1.78, '(84) 98172-7381', 'caiodaniel@castromobile.com.br'),
    ('758.202.467-21', 8202, '2019-07-19', 'Renan Nathan Manuel Assis', '1955-05-01', 74, 1.81, '(68) 98665-1527', 'renannathan100@barratravel.com.br'),
    ('505.798.616-35', 3308, '2017-03-07', 'Cauã Joaquim Mendes', '2002-01-22', 94, 1.61, '(68) 98919-9360', 'cauajoaqui_1@jardim.com.br'),
    ('229.956.638-41', 9014, '2019-11-10', 'Geraldo Danilo Anthony Barbosa', '1999-06-02', 74, 1.80, '(82) 98200-2947', 'geraldodanilo@baptistas.com.br'),
    ('968.939.115-13', 3308, '2017-03-07', 'Renato Francisco Geraldo Aragão', '1987-02-21', 69, 1.68, '(68) 99722-7823', 'renatofrancisco@futureteeth.com.br'),
    ('682.953.007-50', 6418, '2019-03-02', 'Heitor Cauê Raul Brito', '1989-11-20', 53, 1.84, '(61) 99676-8674', 'heitorcaueraulbrito@bastos.com.br'),
    ('651.657.256-93', 7295, '2020-07-18', 'Francisco Marcos Vinicius Vieira', '1991-01-06', 108, 1.93, '(11) 99244-3831', 'franciscomarc@hotmmail.com'),
    ('094.106.485-99', 8202, '2018-12-09', 'Heitor Manoel Vieira', '1989-09-03', 64, 1.83, '(11) 98155-5851', 'heitormanoelvieira@santosferreira.abv.br'),
    ('583.695.091-18', 9014, '2018-06-15', 'Daniel Tiago da Mota', '2001-01-02', 76, 1.73, '(83) 99394-3183', 'danieltiagodamota@entretenimentos.com.br'),
    ('302.845.000-38', 3308, '2017-03-07', 'Anthony Yago Mendes', '1987-05-13', 83, 1.92, '(49) 98505-3094', 'aanthonyyagomendes@ceuazul.ind.br'),
    ('798.560.467-77', 2216, '2018-11-06', 'Augusto Carlos Eduardo André', '1991-02-10', 71, 1.75, '(67) 98605-0439', 'augustocarloseduardo@vick1.com.br'),
    ('295.539.995-73', 4633, '2016-10-01', 'Luís Theo Almada', '1982-06-08', 80, 1.75, '(67) 99839-1642', 'luistheoalmada@hawk.com.br'),
    ('922.563.129-41', 7295, '2017-02-08', 'Luís Pedro Henrique Peixoto', '2002-12-07', 72, 1.92, '(69) 99646-9646', 'luispedro-95@bemarius.com.br'),
    ('524.530.266-74', 6418, '2017-04-19', 'Gael Filipe Samuel Alves', '1991-01-05', 97, 1.92, '(67) 98211-8618', 'gaelfili761@cmfcequipamentos.com.br'),
    ('957.939.013-45', 9014, '2018-06-15', 'Marcos Vinicius Silva', '1995-09-05', 87, 1.80, '(79) 98897-0475', 'marcosvinicius@sfranconsultoria.com.br'),
    ('424.691.103-86', 2216, '2018-11-06', 'João Thomas Castro', '1970-01-14', 68, 1.78, '(83) 98430-8323', 'joaothomas_1@doucedoce.com.br'),
    ('101.525.932-41', 6418, '2017-04-19', 'Tomás Henrique Giovanni Almeida', '1975-04-18', 96, 1.75, '(79) 99688-6879', 'tomashenriquegiovanni@eyejoy.com.br'),
    ('586.621.073-89', 1307, '2018-05-22', 'Guilherme Ricardo Pietro Rezende', '1983-01-04', 91, 1.79, '(62) 98552-4271', 'guilhermericardop-86@realbit.com.br'),
    ('000.447.598-43', 4633, '2016-10-01', 'Henry César de Paula', '1999-11-16', 96, 1.84, '(19) 99356-3734', 'henrycesardepaula@br.ibm.com'),
    ('523.855.462-13', 8202, '2018-12-09', 'Ryan Bento Vicente da Mata', '1980-01-05', 98, 1.74, '(47) 98266-6540', 'ryanbentovicentedamata@pronta.com.br'),
    ('978.669.097-41', 8202, '2020-10-25', 'Filipe Theo Dias', '1986-01-16', 80, 1.68, '(82) 99752-9046', 'filipetheodias-91@uzgames.com'),
    ('346.612.176-08', 9014, '2018-06-15', 'Isaac Ricardo Araújo', '2002-08-14', 73, 1.72, '(79) 99983-9070', 'isaacricardoaraujo_@mundivox.com.br'),
    ('311.627.394-44', 3308, '2017-03-07', 'Benjamin Caleb Teixeira', '1991-10-15', 95, 1.77, '(81) 98656-9216', 'benjamincalebteixeira-88@care-br.com'),
    ('014.584.923-62', 4633, '2016-10-01', 'Marcelo Felipe Sebastião Cardoso', '1982-04-11', 74, 1.92, '(91) 99173-4253', 'marcelofelipe@novaface.com.br'),
    ('026.213.375-03', 7295, '2017-02-08', 'Juan Bruno Corte Real', '1980-11-04', 63, 1.85, '(21) 99210-5363', 'juanbrunocortereal-90@homtail.com'),
    ('733.550.819-30', 1307, '2018-05-22', 'Tiago Luís Mendes', '1989-02-06', 92, 1.96, '(65) 99838-0569', 'tiagoluismendes@contabilidadevictoria.com.br'),
    ('234.911.978-56', 7295, '2017-02-08', 'Benício Emanuel Lima', '1988-11-15', 71, 1.82, '(63) 98176-7891', 'benicioemanuellima-73@lojabichopapao.com.br');
	
INSERT INTO JOGO (id, equipe1_id, equipe2_id, data, duracao, equipe1_gols, equipe2_gols)
VALUES
    (259334, 9014, 6418, '2021-08-01', '00:40:00', 4, 2), 
    (806749, 2216, 4633, '2021-08-15', '00:50:00', 3, 2),
    (329505, 7295, 8202, '2021-08-21', '00:50:00', 3, 4), 
    (981609, 9014, 8202, '2021-08-29', '00:40:00', 4, 6); 
	
INSERT INTO JOGADOR_JOGO (jogo_id, jogador_cpf, posicao)
VALUES
    (259334, '957.939.013-45', 'Goleiro'), 
    (259334, '564.892.576-02', 'Fixo'),
    (259334, '442.145.456-72', 'Pivô'), 
    (259334, '362.351.871-90', 'Ala Equerda'), 
    (259334, '583.695.091-18', 'Ala Direita'), 
    (259334, '524.530.266-74', 'Goleiro'), 
    (259334, '100.780.610-91', 'Fixo'), 
    (259334, '344.313.896-95', 'Pivô'), 
    (259334, '363.347.989-95', 'Ala Equerda'), 
    (259334, '224.065.707-38', 'Ala Direita'), 
    (806749, '441.228.640-11', 'Goleiro'), 
    (806749, '406.310.135-55', 'Fixo'), 
    (806749, '891.166.041-80', 'Pivô'), 
    (806749, '798.560.467-77', 'Ala Equerda'), 
    (806749, '408.266.063-18', 'Ala Direita'), 
    (806749, '144.836.894-44', 'Goleiro'), 
    (806749, '295.539.995-73', 'Fixo'), 
    (806749, '159.735.990-43', 'Pivô'), 
    (806749, '014.584.923-62', 'Ala Equerda'), 
    (806749, '000.447.598-43', 'Ala Direita'), 
    (329505, '026.213.375-03', 'Goleiro'), 
    (329505, '526.355.317-06', 'Fixo'), 
    (329505, '986.015.879-76', 'Pivô'), 
    (329505, '922.563.129-41', 'Ala Equerda'), 
    (329505, '234.911.978-56', 'Ala Direita'), 
    (329505, '094.106.485-99', 'Goleiro'), 
    (329505, '002.792.455-64', 'Fixo'), 
    (329505, '274.122.921-02', 'Pivô'),
    (329505, '725.395.595-14', 'Ala Equerda'), 
    (329505, '523.855.462-13', 'Ala Direita'), 
    (981609, '957.939.013-45', 'Goleiro'), 
    (981609, '086.843.545-75', 'Fixo'), 
    (981609, '346.612.176-08', 'Pivô'), 
    (981609, '362.351.871-90', 'Ala Equerda'), 
    (981609, '583.695.091-18', 'Ala Direita'), 
    (981609, '094.106.485-99', 'Goleiro'), 
    (981609, '978.669.097-41', 'Fixo'), 
    (981609, '758.202.467-21', 'Pivô'), 
    (981609, '523.855.462-13', 'Ala Equerda'), 
    (981609, '725.395.595-14', 'Ala Direita'); 
