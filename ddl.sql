CREATE SCHEMA trabalho_bd2

CREATE TYPE trabalho_bd2.tipo_canal AS ENUM ('privado', 'público', 'misto');
CREATE TYPE trabalho_bd2.status_doacao AS ENUM ('recusado', 'recebido', 'lido');
CREATE TYPE trabalho_bd2.nivel_membro AS ENUM ('1', '2', '3', '4', '5');

-- Tabela Empresa
CREATE TABLE trabalho_bd2.Empresa (
    nro INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) UNIQUE NOT NULL
);

-- Tabela Conversao
CREATE TABLE trabalho_bd2.Conversao (
    moeda VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    fator_conver DECIMAL(15,6) NOT NULL
);

-- Tabela Plataforma
CREATE TABLE trabalho_bd2.Plataforma (
    nro INT PRIMARY KEY,
    nome VARCHAR(255) UNIQUE NOT NULL,
    qtd_users INT DEFAULT 0,
    empresa_fund INT NOT NULL,
    empresa_respo INT NOT NULL,
    data_fund DATE NOT NULL,
    FOREIGN KEY (empresa_fund) REFERENCES trabalho_bd2.Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (empresa_respo) REFERENCES trabalho_bd2.Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela Pais
CREATE TABLE trabalho_bd2.Pais (
    DDI VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    moeda VARCHAR(10) NOT NULL,
    FOREIGN KEY (moeda) REFERENCES trabalho_bd2.Conversao(moeda) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela Usuario
CREATE TABLE trabalho_bd2.Usuario (
    nick VARCHAR(50) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    data_nasc DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    end_postal VARCHAR(255) NOT NULL,
    pais_residencia VARCHAR(10) NOT NULL,
    FOREIGN KEY (pais_residencia) REFERENCES trabalho_bd2.Pais(DDI) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela PlataformaUsuario
CREATE TABLE trabalho_bd2.PlataformaUsuario (
    nro_plataforma INT,
    nick_usuario VARCHAR(50),
    nro_usuario INT NOT NULL,
    PRIMARY KEY (nro_plataforma, nick_usuario),
    FOREIGN KEY (nro_plataforma) REFERENCES trabalho_bd2.Plataforma(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nick_usuario) REFERENCES trabalho_bd2.Usuario(nick) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (nro_plataforma, nro_usuario)
);

-- Tabela StreamerPais
CREATE TABLE trabalho_bd2.StreamerPais (
    nick_streamer VARCHAR(50),
    ddi_pais VARCHAR(10), 
    nro_passaporte VARCHAR(50) NOT NULL,
    PRIMARY KEY (nick_streamer, ddi_pais),
    FOREIGN KEY (nick_streamer) REFERENCES trabalho_bd2.Usuario(nick) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ddi_pais) REFERENCES trabalho_bd2.Pais(DDI) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (ddi_pais, nro_passaporte)
);

-- Tabela EmpresaPais
CREATE TABLE trabalho_bd2.EmpresaPais (
    nro_empresa INT,
    ddi_pais VARCHAR(5),
    id_nacional VARCHAR(50) NOT NULL,
    PRIMARY KEY (nro_empresa, ddi_pais),
    FOREIGN KEY (nro_empresa) REFERENCES trabalho_bd2.Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ddi_pais) REFERENCES trabalho_bd2.Pais(DDI) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (ddi_pais, id_nacional)
);

-- Tabela Canal
CREATE TABLE trabalho_bd2.Canal (
    nome VARCHAR(255),
    nro_plataforma INT,
    tipo trabalho_bd2.tipo_canal NOT NULL,
    data DATE NOT NULL,
    descricao TEXT,
    qtd_visualizacoes INT DEFAULT 0,
    nick_streamer VARCHAR(50) NOT NULL,
    PRIMARY KEY (nome, nro_plataforma),
    FOREIGN KEY (nro_plataforma) REFERENCES trabalho_bd2.Plataforma(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nick_streamer) REFERENCES trabalho_bd2.Usuario(nick) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (nro_plataforma, nick_streamer)
);

-- Tabela Patrocinio
CREATE TABLE trabalho_bd2.Patrocinio (
    nro_empresa INT,
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    valor DECIMAL(15,2) NOT NULL,
    data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (nro_empresa, nome_canal, nro_plataforma),
    FOREIGN KEY (nro_empresa) REFERENCES trabalho_bd2.Empresa(nro) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nome_canal, nro_plataforma) REFERENCES trabalho_bd2.Canal(nome, nro_plataforma) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela NivelCanal
CREATE TABLE trabalho_bd2.NivelCanal (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    nivel trabalho_bd2.nivel_membro NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    gif VARCHAR(255) NOT NULL,
    PRIMARY KEY (nome_canal, nro_plataforma, nivel),
    FOREIGN KEY (nome_canal, nro_plataforma) REFERENCES trabalho_bd2.Canal(nome, nro_plataforma) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela Inscricao
CREATE TABLE trabalho_bd2.Inscricao (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    nick_membro VARCHAR(50),
    nivel trabalho_bd2.nivel_membro NOT NULL,
    data_inscricao DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (nome_canal, nro_plataforma, nick_membro),
    FOREIGN KEY (nick_membro) REFERENCES trabalho_bd2.Usuario(nick) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nome_canal, nro_plataforma, nivel) REFERENCES trabalho_bd2.NivelCanal(nome_canal, nro_plataforma, nivel) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela Video
CREATE TABLE trabalho_bd2.Video (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo VARCHAR(255),
    dataH TIMESTAMP NOT NULL,
    tema VARCHAR(100) NOT NULL,
    duracao INT NOT NULL,
    visu_simul INT DEFAULT 0,
    visu_total INT DEFAULT 0,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo, dataH),
    FOREIGN KEY (nome_canal, nro_plataforma) REFERENCES trabalho_bd2.Canal(nome, nro_plataforma) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela Participa
CREATE TABLE trabalho_bd2.Participa (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_streamer VARCHAR(50),
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_streamer),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video) REFERENCES trabalho_bd2.Video(nome_canal, nro_plataforma, titulo, dataH) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nick_streamer) REFERENCES trabalho_bd2.Usuario(nick) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela Comentario
CREATE TABLE trabalho_bd2.Comentario (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_usuario VARCHAR(50),
    seq INT,
    texto TEXT NOT NULL,
    dataH TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    coment_on INT,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video) REFERENCES trabalho_bd2.Video(nome_canal, nro_plataforma, titulo, dataH) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nick_usuario) REFERENCES trabalho_bd2.Usuario(nick) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq)
);

-- Tabela Doacao
CREATE TABLE trabalho_bd2.Doacao (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_usuario VARCHAR(50),
    seq_comentario INT,
    seq_pg INT,
    valor DECIMAL(15,2) NOT NULL,
    status trabalho_bd2.status_doacao NOT NULL,
    data_doacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_pg),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario) REFERENCES trabalho_bd2.Comentario(nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela BitCoin
CREATE TABLE trabalho_bd2.BitCoin (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_usuario VARCHAR(50),
    seq_comentario INT,
    seq_doacao INT,
    TxID VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES trabalho_bd2.Doacao(nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_pg) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela PayPal
CREATE TABLE trabalho_bd2.PayPal (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_usuario VARCHAR(50),
    seq_comentario INT,
    seq_doacao INT,
    IdPayPal VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES trabalho_bd2.Doacao(nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_pg) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela CartaoCredito
CREATE TABLE trabalho_bd2.CartaoCredito (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_usuario VARCHAR(50),
    seq_comentario INT,
    seq_doacao INT,
    nro VARCHAR(50) NOT NULL,
    bandeira VARCHAR(50) NOT NULL,
    datah_transacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES trabalho_bd2.Doacao(nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_pg) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabela MecanismoPlat
CREATE TABLE trabalho_bd2.MecanismoPlat (
    nome_canal VARCHAR(255),
    nro_plataforma INT,
    titulo_video VARCHAR(255),
    dataH_video TIMESTAMP,
    nick_usuario VARCHAR(50),
    seq_comentario INT,
    seq_doacao INT,
    seq_plataforma INT NOT NULL,
    PRIMARY KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao),
    FOREIGN KEY (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES trabalho_bd2.Doacao(nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_pg) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (nro_plataforma, seq_plataforma)
);