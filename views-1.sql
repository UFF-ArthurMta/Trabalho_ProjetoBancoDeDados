-- 1

CREATE OR REPLACE VIEW trabalho_bd2.vw_patrocinios_canais AS
SELECT p.nro_empresa ,
e.nome AS empresa_nome ,
p.nome_canal ,
p.nro_plataforma ,
p.valor ,
p.data_inicio
FROM trabalho_bd2.Patrocinio p
JOIN trabalho_bd2.Empresa e ON p.nro_empresa = e.nro;

-- 2

CREATE OR REPLACE VIEW trabalho_bd2.vw_membros_inscritos AS
SELECT i.nick_membro ,
COUNT(*) AS qtd_canais ,
SUM(n.valor) AS valor_mensal_total
FROM trabalho_bd2.Inscricao i
JOIN trabalho_bd2.NivelCanal n ON (i. nome_canal = n. nome_canal
AND i. nro_plataforma = n. nro_plataforma
AND i.nivel = n.nivel)
GROUP BY i. nick_membro ;

-- 3

CREATE MATERIALIZED VIEW trabalho_bd2.vw_doacoes_canais AS
SELECT d.nome_canal ,
d.nro_plataforma ,
SUM(d.valor) AS total_doacoes ,
COUNT(*) AS qtd_doacoes
FROM trabalho_bd2.Doacao d
WHERE d.status != 'recusado'
GROUP BY d.nome_canal , d. nro_plataforma ;

-- 4

CREATE OR REPLACE VIEW trabalho_bd2.vw_doacoes_lidas_por_video AS
SELECT d.nome_canal ,
d.nro_plataforma ,
d.titulo_video ,
d.dataH_video ,
SUM(d.valor) FILTER (WHERE d.status = 'lido') AS total_doacoes_lidas
FROM trabalho_bd2.Doacao d
GROUP BY d.nome_canal , d.nro_plataforma , d.titulo_video , d. dataH_video ;

-- 5

CREATE MATERIALIZED VIEW trabalho_bd2.vw_receita_total_canal AS
WITH pat AS (
SELECT nome_canal , nro_plataforma , SUM(valor) AS receita_patrocinio
FROM trabalho_bd2.Patrocinio
GROUP BY nome_canal , nro_plataforma
),
memb AS (
SELECT i.nome_canal , i.nro_plataforma , SUM(n.valor) AS receita_membros
FROM trabalho_bd2.Inscricao i
JOIN trabalho_bd2.NivelCanal n ON i. nome_canal = n. nome_canal
AND i. nro_plataforma = n. nro_plataforma
AND i.nivel = n.nivel
GROUP BY i.nome_canal , i. nro_plataforma
),
doa AS (
SELECT nome_canal , nro_plataforma , SUM(valor) AS receita_doacoes
FROM trabalho_bd2.Doacao
WHERE status != 'recusado'
GROUP BY nome_canal , nro_plataforma
)
SELECT COALESCE(pat.nome_canal , memb.nome_canal , doa. nome_canal ) AS
nome_canal ,
COALESCE(pat.nro_plataforma , memb.nro_plataforma , doa. nro_plataforma
) AS nro_plataforma ,
COALESCE(pat. receita_patrocinio , 0) AS receita_patrocinio ,
COALESCE(memb.receita_membros , 0) AS receita_membros ,
COALESCE(doa.receita_doacoes , 0) AS receita_doacoes ,
COALESCE(pat. receita_patrocinio , 0) +
COALESCE(memb.receita_membros , 0) +
COALESCE(doa.receita_doacoes , 0) AS receita_total
FROM pat
FULL OUTER JOIN memb USING (nome_canal , nro_plataforma )
FULL OUTER JOIN doa USING (nome_canal , nro_plataforma );