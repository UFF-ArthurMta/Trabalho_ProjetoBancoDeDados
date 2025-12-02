-- 1. Canais patrocinados e valores por empresa (com filtro opcional)

CREATE OR REPLACE FUNCTION trabalho_bd2.listar_patrocinios(empresa_filter INT DEFAULT NULL)
RETURNS TABLE (
nome_empresa VARCHAR(255),
nome_canal VARCHAR(255),
nome_plataforma VARCHAR(255),
valor_patrocinio DECIMAL(15,2)
) AS $$
BEGIN
RETURN QUERY
SELECT e.nome, pat.nome_canal, pl.nome, pat.valor
FROM trabalho_bd2.Patrocinio pat
JOIN trabalho_bd2.Empresa e ON pat.nro_empresa = e.nro
JOIN trabalho_bd2.Plataforma pl ON pat.nro_plataforma = pl.nro
WHERE (empresa_filter IS NULL OR pat.nro_empresa = empresa_filter)
ORDER BY e.nome, pat.valor DESC;
END;
$$ LANGUAGE plpgsql;

-- 2. Quantidade de canais e valor mensal por usuário (com filtro opcional)

CREATE OR REPLACE FUNCTION trabalho_bd2.membros_inscricoes(usuario_filter VARCHAR(50)
DEFAULT NULL)
RETURNS TABLE (
nick_usuario VARCHAR(50),
qtd_canais BIGINT,
valor_mensal_total DECIMAL(10,2)
) AS $$
BEGIN
RETURN QUERY
SELECT i.nick_membro,
COUNT(*) as qtd_canais,
SUM(nc.valor) as valor_mensal_total
FROM trabalho_bd2.Inscricao i
JOIN trabalho_bd2.NivelCanal nc ON i.nome_canal = nc.nome_canal
AND i.nro_plataforma = nc.nro_plataforma
AND i.nivel = nc.nivel
WHERE (usuario_filter IS NULL OR i.nick_membro = usuario_filter)
GROUP BY i.nick_membro
ORDER BY valor_mensal_total DESC;
END;
$$ LANGUAGE plpgsql;

-- 3. Canais que receberam doações e soma dos valores (com filtro opcional)

CREATE OR REPLACE FUNCTION trabalho_bd2.doacoes_por_canal(canal_filter VARCHAR(255) DEFAULT
NULL)
RETURNS TABLE (
nome_canal VARCHAR(255),
nome_plataforma VARCHAR(255),
total_doacoes DECIMAL(15,2)
) AS $$
BEGIN
RETURN QUERY
SELECT c.nome, pl.nome, SUM(d.valor) as total_doacoes
FROM trabalho_bd2.Doacao d
JOIN trabalho_bd2.Canal c ON d.nome_canal = c.nome AND d.nro_plataforma = c.nro_plataforma
JOIN trabalho_bd2.Plataforma pl ON c.nro_plataforma = pl.nro
WHERE (canal_filter IS NULL OR c.nome = canal_filter)
GROUP BY c.nome, pl.nome
ORDER BY total_doacoes DESC;
END;
$$ LANGUAGE plpgsql;

-- 4. Soma das doações de comentários lidos por vídeo (com filtro opcional)

CREATE OR REPLACE FUNCTION trabalho_bd2.doacoes_lidas_por_video(
video_titulo_filter VARCHAR(255) DEFAULT NULL,
video_data_filter TIMESTAMP DEFAULT NULL
) RETURNS TABLE (
titulo_video VARCHAR(255),
dataH_video TIMESTAMP,
total_doacoes_lidas DECIMAL(15,2)
) AS $$
BEGIN
RETURN QUERY
SELECT v.titulo, v.dataH, COALESCE(SUM(d.valor), 0.00) as total_doacoes_lidas
FROM trabalho_bd2.Video v
LEFT JOIN trabalho_bd2.Doacao d ON d.nome_canal = v.nome_canal
AND d.nro_plataforma = v.nro_plataforma
AND d.titulo_video = v.titulo
AND d.dataH_video = v.dataH
AND d.status = 'lido'
WHERE (video_titulo_filter IS NULL OR v.titulo = video_titulo_filter) AND (video_data_filter IS NULL OR v.dataH = video_data_filter)
GROUP BY v.titulo, v.dataH
ORDER BY total_doacoes_lidas DESC;
END;
$$ LANGUAGE plpgsql;

-- 5. Top K canais que mais recebem patrocínio

CREATE OR REPLACE FUNCTION trabalho_bd2.top_canais_patrocinio(k INT)
RETURNS TABLE (
nome_canal VARCHAR(255),
nome_plataforma VARCHAR(255),
total_patrocinio DECIMAL(15,2)
) AS $$
BEGIN
RETURN QUERY
SELECT c.nome, pl.nome, COALESCE(SUM(pat.valor), 0.00) as total_patrocinio
FROM trabalho_bd2.Canal c
JOIN trabalho_bd2.Plataforma pl ON c.nro_plataforma = pl.nro
LEFT JOIN trabalho_bd2.Patrocinio pat ON c.nome = pat.nome_canal AND c.nro_plataforma =
pat.nro_plataforma
GROUP BY c.nome, pl.nome
ORDER BY total_patrocinio DESC
LIMIT k;
END;
$$ LANGUAGE plpgsql;

-- 6. Top K canais que mais recebem aportes de membros

CREATE OR REPLACE FUNCTION trabalho_bd2.top_canais_membros(k INT)
RETURNS TABLE (
nome_canal VARCHAR(255),
nome_plataforma VARCHAR(255),
total_membros DECIMAL(10,2)
) AS $$
BEGIN
RETURN QUERY
SELECT c.nome, pl.nome, COALESCE(SUM(nc.valor), 0.00) as total_membros
FROM trabalho_bd2.Canal c
JOIN trabalho_bd2.Plataforma pl ON c.nro_plataforma = pl.nro
LEFT JOIN trabalho_bd2.Inscricao i ON c.nome = i.nome_canal AND c.nro_plataforma =
i.nro_plataforma
LEFT JOIN trabalho_bd2.NivelCanal nc ON i.nome_canal = nc.nome_canal
AND i.nro_plataforma = nc.nro_plataforma
AND i.nivel = nc.nivel
GROUP BY c.nome, pl.nome
ORDER BY total_membros DESC
LIMIT k;
END;
$$ LANGUAGE plpgsql;

-- 7. Top K canais que mais receberam doações considerando todos os vídeos

CREATE OR REPLACE FUNCTION trabalho_bd2.top_canais_doacoes(k INT)
RETURNS TABLE (
nome_canal VARCHAR(255),
nome_plataforma VARCHAR(255),
total_doacoes DECIMAL(15,2)
) AS $$
BEGIN
RETURN QUERY
SELECT c.nome, pl.nome, COALESCE(SUM(d.valor), 0.00) as total_doacoes
FROM trabalho_bd2.Canal c
JOIN trabalho_bd2.Plataforma pl ON c.nro_plataforma = pl.nro
LEFT JOIN trabalho_bd2.Doacao d ON c.nome = d.nome_canal AND c.nro_plataforma =
d.nro_plataforma
GROUP BY c.nome, pl.nome
ORDER BY total_doacoes DESC
LIMIT k;
END;
$$ LANGUAGE plpgsql;

-- 8. Top K canais que mais faturam considerando as três fontes de receita

CREATE OR REPLACE FUNCTION trabalho_bd2.top_canais_faturamento(k INT)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    nome_plataforma VARCHAR(255),
    total_patrocinio DECIMAL(15,2),
    total_membros DECIMAL(10,2),
    total_doacoes DECIMAL(15,2),
    faturamento_total DECIMAL(15,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.nome::VARCHAR(255) AS canal_nome,
        pl.nome::VARCHAR(255) AS plataforma_nome,
        COALESCE(pat.total_patrocinio, 0.00)::DECIMAL(15,2) AS patrocinio_total,
        COALESCE(mem.total_membros, 0.00)::DECIMAL(10,2) AS membros_total,
        COALESCE(doa.total_doacoes, 0.00)::DECIMAL(15,2) AS doacoes_total,
        (COALESCE(pat.total_patrocinio, 0.00) +
         COALESCE(mem.total_membros, 0.00) +
         COALESCE(doa.total_doacoes, 0.00))::DECIMAL(15,2) AS fat_total
    FROM trabalho_bd2.Canal c
    JOIN trabalho_bd2.Plataforma pl ON c.nro_plataforma = pl.nro
    LEFT JOIN (
        SELECT pat_inner.nome_canal, pat_inner.nro_plataforma, SUM(pat_inner.valor) as total_patrocinio
        FROM trabalho_bd2.Patrocinio pat_inner
        GROUP BY pat_inner.nome_canal, pat_inner.nro_plataforma
    ) pat ON c.nome = pat.nome_canal AND c.nro_plataforma = pat.nro_plataforma
    LEFT JOIN (
        SELECT i.nome_canal, i.nro_plataforma, SUM(nc.valor) as total_membros
        FROM trabalho_bd2.Inscricao i
        JOIN trabalho_bd2.NivelCanal nc ON i.nome_canal = nc.nome_canal
            AND i.nro_plataforma = nc.nro_plataforma
            AND i.nivel = nc.nivel
        GROUP BY i.nome_canal, i.nro_plataforma
    ) mem ON c.nome = mem.nome_canal AND c.nro_plataforma = mem.nro_plataforma
    LEFT JOIN (
        SELECT doa_inner.nome_canal, doa_inner.nro_plataforma, SUM(doa_inner.valor) as total_doacoes
        FROM trabalho_bd2.Doacao doa_inner
        GROUP BY doa_inner.nome_canal, doa_inner.nro_plataforma
    ) doa ON c.nome = doa.nome_canal AND c.nro_plataforma = doa.nro_plataforma
    ORDER BY fat_total DESC
    LIMIT top_canais_faturamento.k;
END;
$$ LANGUAGE plpgsql;