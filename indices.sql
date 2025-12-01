CREATE INDEX nome_canal ON trabalho_bd2.Canal(nome);
CREATE INDEX nome_nro_patrocinio ON trabalho_bd2.Patrocinio(nome_canal, nro_empresa);
CREATE INDEX nome_usuario_inscricao ON trabalho_bd2.Inscricao(nick_membro);
CREATE INDEX ordena_valor_doacao ON trabalho_bd2.Doacao USING BTREE (valor);
CREATE INDEX ordena_valor_patrocinio ON trabalho_bd2.Patrocinio USING BTREE (valor);