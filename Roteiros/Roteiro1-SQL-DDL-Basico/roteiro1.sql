-- Seguradora de automóveis


-- Questão 1


"""

AUTOMOVEL { 
  placa, 
  renavam,
  modelo,
  cor,
  fabricante,
  ano_fabricacao
};

SEGURADO {
  cpf,
  rg, 
  nome,
  telefone,
  email,
  data_nascimento
};

PERITO {
  cpf,
  rg, 
  nome,
  telefone,
  email,
  data_nascimento 
};

OFICINA {
  cnpj,
  nome,
  telefone,
  email 
};

SEGURO {
  id, 
  placa_automovel,
  cpf_segurado, 
  data_hora_inicio,
  data_hora_fim,
  tipo, 
  valor
};

SINISTRO {
  id,
  id_seguro, 
  data_hora_ocorrido,
  tipo,
  relato_ocorrido
};

PERICIA {
  id,
  id_seguro,
  cpf_perito, 
  cnpj_oficina,
  data_hora_inicio,
  data_hora_fim,  
  laudo
};

REPARO {
  id,
  id_seguro,
  cnpj_oficina,
  data_hora_inicio,
  data_hora_fim,   
  valor
};

"""


-- Questão 2


CREATE TABLE AUTOMOVEL (
  placa CHAR(8),
  renavam CHAR(11),
  modelo VARCHAR(10),
  cor VARCHAR(12),
  fabricante VARCHAR(10),
  ano_fabricacao DATE
);

CREATE TABLE SEGURADO (
  cpf CHAR(14),
  rg CHAR(12), 
  nome VARCHAR(70),
  telefone VARCHAR(18),
  email VARCHAR(50),
  data_nascimento DATE
);

CREATE TABLE PERITO (
  cpf CHAR(14),
  rg CHAR(12), 
  nome VARCHAR(70),
  telefone VARCHAR(18),
  email VARCHAR(50),
  data_nascimento DATE
);

CREATE TABLE OFICINA (
  cnpj CHAR(18),
  nome VARCHAR(70),
  telefone VARCHAR(18),
  email VARCHAR(50) 
);

CREATE TABLE SEGURO (
  id SERIAL,
  placa_automovel CHAR(8),
  cpf_segurado CHAR(14),
  data_hora_inicio TIMESTAMP,
  data_hora_fim TIMESTAMP,
  tipo VARCHAR(100),
  valor NUMERIC
);

CREATE TABLE SINISTRO (
  id SERIAL,
  id_seguro INTEGER, 
  data_hora_ocorrido TIMESTAMP,
  tipo VARCHAR(100),
  relato_ocorrido TEXT
);

CREATE TABLE PERICIA (
  id SERIAL,
  id_seguro INTEGER,
  cpf_perito CHAR(14),
  cnpj_oficina CHAR(14),
  data_hora_inicio TIMESTAMP,
  data_hora_fim TIMESTAMP,
  laudo TEXT
);

CREATE TABLE REPARO (
  id SERIAL,
  id_seguro INTEGER,
  cnpj_oficina CHAR(14),
  data_hora_inicio TIMESTAMP,
  data_hora_fim TIMESTAMP, 
  valor NUMERIC
);


-- Questão 3


ALTER TABLE AUTOMOVEL ADD PRIMARY KEY (placa);
ALTER TABLE SEGURADO ADD PRIMARY KEY (cpf);
ALTER TABLE PERITO ADD PRIMARY KEY (cpf);
ALTER TABLE OFICINA ADD PRIMARY KEY (cnpj);
ALTER TABLE SEGURO ADD PRIMARY KEY (id);
ALTER TABLE SINISTRO ADD PRIMARY KEY (id);
ALTER TABLE PERICIA ADD PRIMARY KEY (id);
ALTER TABLE REPARO ADD PRIMARY KEY (id);


-- Questão 4 


ALTER TABLE SEGURO ADD FOREIGN KEY (placa_automovel) REFERENCES AUTOMOVEL (placa);
ALTER TABLE SEGURO ADD FOREIGN KEY (cpf_segurado) REFERENCES SEGURADO (cpf);

ALTER TABLE SINISTRO ADD FOREIGN KEY (id_seguro) REFERENCES SEGURO (id);

ALTER TABLE PERICIA ADD FOREIGN KEY (id_seguro) REFERENCES SEGURO (id);
ALTER TABLE PERICIA ADD FOREIGN KEY (cpf_perito) REFERENCES PERITO (cpf);
ALTER TABLE PERICIA ADD FOREIGN KEY (cnpj_oficina) REFERENCES OFICINA (cnpj);

ALTER TABLE REPARO ADD FOREIGN KEY (id_seguro) REFERENCES SEGURO (id);  
ALTER TABLE REPARO ADD FOREIGN KEY (cnpj_oficina) REFERENCES OFICINA (cnpj);


-- Questão 5 


"""

AUTOMOVEL { 
  placa NOT NULL, 
  renavam NOT NULL,
  modelo NOT NULL,
  cor NOT NULL,
  fabricante NOT NULL,
  ano_fabricacao NOT NULL
};

SEGURADO {
  cpf NOT NULL,
  rg NOT NULL, 
  nome NOT NULL,
  telefone NOT NULL,
  email,
  data_nascimento NOT NULL
};

PERITO {
  cpf NOT NULL,
  rg NOT NULL, 
  nome NOT NULL,
  telefone NOT NULL,
  email,
  data_nascimento NOT NULL 
};

OFICINA {
  cnpj NOT NULL,
  nome NOT NULL,
  telefone NOT NULL,
  email 
};

SEGURO {
  id NOT NULL, 
  placa_automovel,
  cpf_segurado, 
  data_hora_inicio NOT NULL,
  data_hora_fim NOT NULL,
  tipo NOT NULL, 
  valor NOT NULL
};

SINISTRO {
  id NOT NULL,
  id_seguro, 
  data_hora_ocorrido NOT NULL,
  tipo NOT NULL,
  relato_ocorrido NOT NULL
};

PERICIA {
  id NOT NULL,
  id_seguro,
  cpf_perito, 
  cnpj_oficina,  
  data_hora_inicio NOT NULL,
  data_hora_fim ,
  laudo TEXT
};

REPARO {
  id NOT NULL,
  cnpj_oficina, 
  placa_automovel,
  data_hora_inicio NOT NULL,
  data_hora_fim, 
  valor 
};

"""


-- Questão 6 


DROP TABLE REPARO;
DROP TABLE PERICIA;
DROP TABLE OFICINA;
DROP TABLE SINISTRO;
DROP TABLE SEGURO;
DROP TABLE AUTOMOVEL;
DROP TABLE SEGURADO;
DROP TABLE PERITO;


-- Questão 7


CREATE TABLE AUTOMOVEL (
  placa CHAR(8) PRIMARY KEY,
  renavam CHAR(11) NOT NULL,
  modelo VARCHAR(10) NOT NULL,
  cor VARCHAR(12) NOT NULL,
  fabricante VARCHAR(10) NOT NULL,
  ano_fabricacao DATE NOT NULL
);

CREATE TABLE SEGURADO (
  cpf CHAR(14) PRIMARY KEY,
  rg CHAR(12) NOT NULL, 
  nome VARCHAR(70) NOT NULL,
  telefone VARCHAR(18) NOT NULL,
  email VARCHAR(50),
  data_nascimento DATE NOT NULL
);

CREATE TABLE PERITO (
  cpf CHAR(14) PRIMARY KEY,
  rg CHAR(12) NOT NULL, 
  nome VARCHAR(70) NOT NULL,
  telefone VARCHAR(18) NOT NULL,
  email VARCHAR(50),
  data_nascimento DATE NOT NULL
);

CREATE TABLE OFICINA (
  cnpj CHAR(18) PRIMARY KEY,
  nome VARCHAR(70) NOT NULL,
  telefone VARCHAR(18) NOT NULL,
  email VARCHAR(50) 
);

CREATE TABLE SEGURO (
  id SERIAL PRIMARY KEY,
  placa_automovel CHAR(8) REFERENCES AUTOMOVEL (placa),
  cpf_segurado CHAR(14) REFERENCES SEGURADO (cpf),
  data_hora_inicio TIMESTAMP NOT NULL,
  data_hora_fim TIMESTAMP NOT NULL,
  tipo VARCHAR(100) NOT NULL, 
  valor NUMERIC NOT NULL
);

CREATE TABLE SINISTRO (
  id SERIAL PRIMARY KEY,
  id_seguro INTEGER REFERENCES SEGURO (id), 
  data_hora_ocorrido TIMESTAMP NOT NULL,
  tipo VARCHAR(100) NOT NULL,
  relato_ocorrido TEXT NOT NULL
);

CREATE TABLE PERICIA (
  id SERIAL PRIMARY KEY,
  id_seguro INTEGER REFERENCES SEGURO (id),
  cpf_perito CHAR(14) REFERENCES PERITO (cpf),
  cnpj_oficina CHAR(14) REFERENCES OFICINA (cnpj),
  data_hora_inicio TIMESTAMP NOT NULL,
  data_hora_fim TIMESTAMP,
  laudo TEXT
);

CREATE TABLE REPARO (
  id SERIAL PRIMARY KEY,
  id_seguro INTEGER REFERENCES SEGURO (id),
  cnpj_oficina CHAR(14) REFERENCES OFICINA (cnpj), 
  data_hora_inicio TIMESTAMP NOT NULL,
  data_hora_fim TIMESTAMP,
  valor NUMERIC
);


-- Questão 8


"""

  CRIAR AS TABELAS DA QUESTÃO 7

"""


-- Questão 9


DROP TABLE REPARO;
DROP TABLE PERICIA;
DROP TABLE OFICINA;
DROP TABLE SINISTRO;
DROP TABLE SEGURO;
DROP TABLE AUTOMOVEL;
DROP TABLE SEGURADO;
DROP TABLE PERITO;


-- Questão 10


"""

Nova tabela:

ENDERECO {
  id,
  estado,
  cidade,
  bairro,
  rua,
  numero
}

Novas colunas nas tabelas existentes:

SEGURADO {
  id_endereco
}

PERITO {
  id_endereco
}

OFICINA {
  id_endereco
}

"""


CREATE TABLE ENDERECO (
  id SERIAL PRIMARY KEY,
  estado CHAR(2) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  bairro VARCHAR(70) NOT NULL,
  rua VARCHAR(50) NOT NULL,
  numero NUMERIC NOT NULL
);

CREATE TABLE AUTOMOVEL (
  placa CHAR(8) PRIMARY KEY,
  renavam CHAR(11) NOT NULL,
  modelo VARCHAR(10) NOT NULL,
  cor VARCHAR(12) NOT NULL,
  fabricante VARCHAR(10) NOT NULL,
  ano_fabricacao DATE NOT NULL
);

CREATE TABLE SEGURADO (
  cpf CHAR(14) PRIMARY KEY,
  rg CHAR(12) NOT NULL, 
  nome VARCHAR(70) NOT NULL,
  telefone VARCHAR(18) NOT NULL,
  email VARCHAR(50),
  data_nascimento DATE NOT NULL,
  id_endereco INTEGER REFERENCES ENDERECO (id)
);

CREATE TABLE PERITO (
  cpf CHAR(14) PRIMARY KEY,
  rg CHAR(12) NOT NULL, 
  nome VARCHAR(70) NOT NULL,
  telefone VARCHAR(18) NOT NULL,
  email VARCHAR(50),
  data_nascimento DATE NOT NULL,
  id_endereco INTEGER REFERENCES ENDERECO (id)
);

CREATE TABLE OFICINA (
  cnpj CHAR(18) PRIMARY KEY,
  nome VARCHAR(70) NOT NULL,
  telefone VARCHAR(18) NOT NULL,
  email VARCHAR(50),
  id_endereco INTEGER REFERENCES ENDERECO (id) 
);

CREATE TABLE SEGURO (
  id SERIAL PRIMARY KEY,
  placa_automovel CHAR(8) REFERENCES AUTOMOVEL (placa),
  cpf_segurado CHAR(14) REFERENCES SEGURADO (cpf),
  data_hora_inicio TIMESTAMP NOT NULL,
  data_hora_fim TIMESTAMP NOT NULL,
  tipo VARCHAR(100) NOT NULL, 
  valor NUMERIC NOT NULL
);

CREATE TABLE SINISTRO (
  id SERIAL PRIMARY KEY,
  id_seguro INTEGER REFERENCES SEGURO (id), 
  data_hora_ocorrido TIMESTAMP NOT NULL,
  tipo VARCHAR(100),
  relato_ocorrido TEXT NOT NULL
);

CREATE TABLE PERICIA (
  id SERIAL PRIMARY KEY,
  id_seguro INTEGER REFERENCES SEGURO (id),
  cpf_perito CHAR(14) REFERENCES PERITO (cpf),
  cnpj_oficina CHAR(14) REFERENCES OFICINA (cnpj),
  data_hora_inicio TIMESTAMP NOT NULL,
  data_hora_fim TIMESTAMP,
  laudo TEXT
);

CREATE TABLE REPARO (
  id SERIAL PRIMARY KEY,
  id_seguro INTEGER REFERENCES SEGURO (id),
  cnpj_oficina CHAR(14) REFERENCES OFICINA (cnpj), 
  data_hora_inicio TIMESTAMP NOT NULL,
  data_hora_fim TIMESTAMP,
  valor NUMERIC
);
