-- Atualizar quantidade de Usuários na Plataforma

CREATE OR REPLACE FUNCTION trabalho_bd2.atualizar_qtd_users()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE trabalho_bd2.Plataforma
        SET qtd_users = qtd_users + 1
        WHERE nro = NEW. nro_plataforma ;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE trabalho_bd2.Plataforma
        SET qtd_users = qtd_users - 1
        WHERE nro = OLD. nro_plataforma ;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_qtd_users
AFTER INSERT OR DELETE ON trabalho_bd2.PlataformaUsuario
FOR EACH ROW EXECUTE FUNCTION trabalho_bd2.atualizar_qtd_users();

-- Atualizar visualizações do Canal na Plataforma

CREATE OR REPLACE FUNCTION trabalho_bd2.atualizar_visualizacoes_canal()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE trabalho_bd2.Canal
        SET qtd_visualizacoes = qtd_visualizacoes + NEW.visu_total
        WHERE nome = NEW.nome_canal AND nro_plataforma = NEW.nro_plataforma;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE trabalho_bd2.Canal
        SET qtd_visualizacoes = qtd_visualizacoes - OLD.visu_total + NEW.visu_total
        WHERE nome = NEW.nome_canal AND nro_plataforma = NEW.nro_plataforma;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_visualizacoes_canal
AFTER INSERT OR UPDATE OR DELETE ON trabalho_bd2.Video
FOR EACH ROW EXECUTE FUNCTION trabalho_bd2.atualizar_visualizacoes_canal();

-- Atualizar Status de Doação ao Remover Comentário

CREATE OR REPLACE FUNCTION trabalho_bd2.atualizar_status_doacao_comentario ()
RETURNS TRIGGER AS $$
BEGIN
UPDATE trabalho_bd2.Doacao
SET status = 'recusado'
WHERE nome_canal = OLD.nome_canal
AND nro_plataforma = OLD.nro_plataforma
AND titulo_video = OLD.titulo_video
AND dataH_video = OLD.dataH_video
AND nick_usuario = OLD.nick_usuario
AND seq_comentario = OLD.seq;

RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_status_doacao_comentario
AFTER DELETE ON trabalho_bd2.Comentario
FOR EACH ROW EXECUTE FUNCTION trabalho_bd2.atualizar_status_doacao_comentario ();

-- Auditoria de Mudança de Nick

CREATE OR REPLACE FUNCTION trabalho_bd2.auditar_mudanca_nick ()
RETURNS TRIGGER AS $$
BEGIN
IF OLD.nick != NEW.nick THEN
-- Assume tabela de log criada para este fim
INSERT INTO trabalho_bd2.Log_Historico_Nick (nick_antigo , nick_novo
, data_alteracao )
VALUES (OLD.nick , NEW.nick , CURRENT_TIMESTAMP);
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditar_nick
BEFORE UPDATE ON trabalho_bd2.Usuario
FOR EACH ROW EXECUTE FUNCTION trabalho_bd2.auditar_mudanca_nick ();

-- Remove Inscrições de Canais que se tornaram "Privados"

CREATE OR REPLACE FUNCTION trabalho_bd2.gerir_canal_privado()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo = 'privado' AND OLD.tipo != 'privado' THEN
        DELETE FROM trabalho_bd2.Inscricao
        WHERE nome_canal = NEW.nome AND nro_plataforma = NEW.nro_plataforma;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_gerir_privado
AFTER UPDATE ON trabalho_bd2.Canal
FOR EACH ROW EXECUTE FUNCTION trabalho_bd2.gerir_canal_privado(); 
