-- 1. Procedure para inserir Empresa
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_empresa(
    p_nro INT,
    p_nome VARCHAR(255),
    p_nome_fantasia VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Empresa (nro, nome, nome_fantasia)
    VALUES (p_nro, p_nome, p_nome_fantasia);
END;
$$;

-- 2. Procedure para inserir Conversao
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_conversao(
    p_moeda VARCHAR(10),
    p_nome VARCHAR(100),
    p_fator_conver DECIMAL(15,6)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Conversao (moeda, nome, fator_conver)
    VALUES (p_moeda, p_nome, p_fator_conver);
END;
$$;

-- 3. Procedure para inserir Plataforma
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_plataforma(
    p_nro INT,
    p_nome VARCHAR(255),
    p_qtd_users INT,
    p_empresa_fund INT,
    p_empresa_respo INT,
    p_data_fund DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Plataforma (nro, nome, qtd_users, empresa_fund, empresa_respo, data_fund)
    VALUES (p_nro, p_nome, p_qtd_users, p_empresa_fund, p_empresa_respo, p_data_fund);
END;
$$;

-- 4. Procedure para inserir Pais
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_pais(
    p_ddi VARCHAR(10),
    p_nome VARCHAR(100),
    p_moeda VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Pais (DDI, nome, moeda)
    VALUES (p_ddi, p_nome, p_moeda);
END;
$$;


-- 5. Procedure para inserir Usuario
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_usuario(
    p_nick VARCHAR(50),
    p_email VARCHAR(255),
    p_data_nasc DATE,
    p_telefone VARCHAR(20),
    p_end_postal VARCHAR(255),
    p_pais_residencia VARCHAR(5)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Usuario (nick, email, data_nasc, telefone, end_postal, pais_residencia)
    VALUES (p_nick, p_email, p_data_nasc, p_telefone, p_end_postal, p_pais_residencia);
END;
$$;

-- 6. Procedure para inserir PlataformaUsuario
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_plataforma_usuario(
    p_nro_plataforma INT,
    p_nick_usuario VARCHAR(50),
    p_nro_usuario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.PlataformaUsuario (nro_plataforma, nick_usuario, nro_usuario)
    VALUES (p_nro_plataforma, p_nick_usuario, p_nro_usuario);
END;
$$;

-- 7. Procedure para inserir StreamerPais
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_streamer_pais(
    p_nick_streamer VARCHAR(50),
    p_ddi_pais VARCHAR(10),
    p_nro_passaporte VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.StreamerPais (nick_streamer, ddi_pais, nro_passaporte)
    VALUES (p_nick_streamer, p_ddi_pais, p_nro_passaporte);
END;
$$;

-- 8. Procedure para inserir EmpresaPais
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_empresa_pais(
    p_nro_empresa INT,
    p_ddi_pais VARCHAR(5),
    p_id_nacional VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.EmpresaPais (nro_empresa, ddi_pais, id_nacional)
    VALUES (p_nro_empresa, p_ddi_pais, p_id_nacional);
END;
$$;

-- 9. Procedure para inserir Canal
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_canal(
    p_nome VARCHAR(255),
    p_nro_plataforma INT,
    p_tipo trabalho_bd2.tipo_canal,
    p_data DATE,
    p_descricao TEXT,
    p_qtd_visualizacoes INT,
    p_nick_streamer VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Canal (nome, nro_plataforma, tipo, data, descricao, qtd_visualizacoes, nick_streamer)
    VALUES (p_nome, p_nro_plataforma, p_tipo, p_data, p_descricao, p_qtd_visualizacoes, p_nick_streamer);
END;
$$;

-- 10. Procedure para inserir Patrocinio
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_patrocinio(
    p_nro_empresa INT,
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_valor DECIMAL(15,2),
    p_data_inicio DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Patrocinio (nro_empresa, nome_canal, nro_plataforma, valor, data_inicio)
    VALUES (p_nro_empresa, p_nome_canal, p_nro_plataforma, p_valor, p_data_inicio);
END;
$$;

-- 11. Procedure para inserir NivelCanal
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_nivel_canal(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_nivel trabalho_bd2.nivel_membro,
    p_valor DECIMAL(10,2),
    p_gif VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.NivelCanal (nome_canal, nro_plataforma, nivel, valor, gif)
    VALUES (p_nome_canal, p_nro_plataforma, p_nivel, p_valor, p_gif);
END;
$$;

-- 12. Procedure para inserir Inscricao
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_inscricao(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_nick_membro VARCHAR(50),
    p_nivel trabalho_bd2.nivel_membro,
    p_data_inscricao DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Inscricao (nome_canal, nro_plataforma, nick_membro, nivel, data_inscricao)
    VALUES (p_nome_canal, p_nro_plataforma, p_nick_membro, p_nivel, p_data_inscricao);
END;
$$;

-- 13. Procedure para inserir Video
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_video(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo VARCHAR(255),
    p_dataH TIMESTAMP,
    p_tema VARCHAR(100),
    p_duracao INT,
    p_visu_simul INT,
    p_visu_total INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Video (nome_canal, nro_plataforma, titulo, dataH, tema, duracao, visu_simul, visu_total)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo, p_dataH, p_tema, p_duracao, p_visu_simul, p_visu_total);
END;
$$;

-- 14. Procedure para inserir Participa
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_participa(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_streamer VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Participa (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_streamer)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_streamer);
END;
$$;

-- 15. Procedure para inserir Comentario
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_comentario(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_usuario VARCHAR(50),
    p_seq INT,
    p_texto TEXT,
    p_dataH TIMESTAMP,
    p_coment_on INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Comentario (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq, texto, dataH, coment_on)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_usuario, p_seq, p_texto, p_dataH, p_coment_on);
END;
$$;

-- 16. Procedure para inserir Doacao
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_doacao(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_usuario VARCHAR(50),
    p_seq_comentario INT,
    p_seq_pg INT,
    p_valor DECIMAL(15,2),
    p_status trabalho_bd2.status_doacao,
    p_data_doacao TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.Doacao (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_pg, valor, status, data_doacao)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_usuario, p_seq_comentario, p_seq_pg, p_valor, p_status, p_data_doacao);
END;
$$;

-- 17. Procedure para inserir BitCoin
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_bitcoin(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_usuario VARCHAR(50),
    p_seq_comentario INT,
    p_seq_doacao INT,
    p_txid VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.BitCoin (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao, TxID)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_usuario, p_seq_comentario, p_seq_doacao, p_txid);
END;
$$;

-- 18. Procedure para inserir PayPal
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_paypal(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_usuario VARCHAR(50),
    p_seq_comentario INT,
    p_seq_doacao INT,
    p_id_paypal VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.PayPal (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao, IdPayPal)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_usuario, p_seq_comentario, p_seq_doacao, p_id_paypal);
END;
$$;

-- 19. Procedure para inserir CartaoCredito
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_cartao_credito(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_usuario VARCHAR(50),
    p_seq_comentario INT,
    p_seq_doacao INT,
    p_nro VARCHAR(50),
    p_bandeira VARCHAR(50),
    p_datah_transacao TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.CartaoCredito (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao, nro, bandeira, datah_transacao)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_usuario, p_seq_comentario, p_seq_doacao, p_nro, p_bandeira, p_datah_transacao);
END;
$$;

-- 20. Procedure para inserir MecanismoPlat
CREATE OR REPLACE PROCEDURE trabalho_bd2.inserir_mecanismo_plat(
    p_nome_canal VARCHAR(255),
    p_nro_plataforma INT,
    p_titulo_video VARCHAR(255),
    p_dataH_video TIMESTAMP,
    p_nick_usuario VARCHAR(50),
    p_seq_comentario INT,
    p_seq_doacao INT,
    p_seq_plataforma INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trabalho_bd2.MecanismoPlat (nome_canal, nro_plataforma, titulo_video, dataH_video, nick_usuario, seq_comentario, seq_doacao, seq_plataforma)
    VALUES (p_nome_canal, p_nro_plataforma, p_titulo_video, p_dataH_video, p_nick_usuario, p_seq_comentario, p_seq_doacao, p_seq_plataforma);
END;
$$;