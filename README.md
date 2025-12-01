# Sistema de Gerenciamento de Plataformas de Streaming

**Universidade Federal Fluminense - Instituto de Computação**  
**Projeto de Banco de Dados - 2025/2**  
**Professor:** Marcos Bedo

**Integrantes:**
- Gabriel Vieira
- Arthur Mota
- Danillo Cyrilo
- Pedro Piaes
- Matheus Andrade

---

## Descrição

Banco de dados relacional para gerenciamento de plataformas de streaming (tipo Twitch/YouTube), incluindo usuários, canais, vídeos, patrocínios, sistema de membros, doações e conversão de moedas internacionais

## Estrutura do Banco

### Principais Entidades

- **Empresa**: Empresas fundadoras e patrocinadoras
- **Plataforma**: Plataformas de streaming (100 registros)
- **Usuário**: Usuários e streamers (300 registros)
- **Canal**: Canais de streaming (tipos: público, privado, misto)
- **Vídeo**: Conteúdo transmitido
- **Patrocínio**: Acordos comerciais entre empresas e canais
- **Inscrição**: Sistema de membros em 5 níveis
- **Doação**: Múltiplos métodos de pagamento
- **País/Conversão**: Sistema internacional de moedas

### Tipos Enumerados

```sql
tipo_canal: 'privado', 'público', 'misto'
status_doacao: 'recusado', 'recebido', 'lido'
nivel_membro: '1', '2', '3', '4', '5'
```

## Arquivos

- **ddl-2.sql**: Estrutura completa do banco (schemas, tipos, tabelas)
- **tuplas-1.sql**: Dados de teste (empresas, países, plataformas, usuários, canais)
- **procedures.sql**: 20 stored procedures para inserção de dados
- **triggers-1.sql**: 5 triggers para automação:
  - Atualização de quantidade de usuários
  - Contagem de visualizações
  - Gestão de status de doações
  - Auditoria de mudanças
  - Conversão automática de canais privados
- **views-1.sql**: 5 views (3 materializadas) para relatórios:
  - Patrocínios de canais
  - Membros inscritos
  - Doações por canal
  - Doações lidas por vídeo
  - Receita total (patrocínios + membros + doações)
- **indices.sql**: 5 índices para otimização de consultas

## Como Usar

### 1. Criar a estrutura
```bash
psql -U seu_usuario -d seu_banco -f ddl-2.sql
```

### 2. Inserir dados
```bash
psql -U seu_usuario -d seu_banco -f tuplas-1.sql
```

### 3. Criar procedures
```bash
psql -U seu_usuario -d seu_banco -f procedures.sql
```

### 4. Criar triggers
```bash
psql -U seu_usuario -d seu_banco -f triggers-1.sql
```

### 5. Criar views
```bash
psql -U seu_usuario -d seu_banco -f views-1.sql
```

### 6. Criar índices
```bash
psql -U seu_usuario -d seu_banco -f indices.sql
```

## Funcionalidades Principais

### Procedures
- Inserção simplificada em todas as tabelas
- Validação automática de chaves estrangeiras
- Uso: `CALL trabalho_bd2.inserir_empresa(1, 'Nome', 'Fantasia');`

### Triggers
- Contadores automáticos (usuários, visualizações)
- Mudança de status automática
- Auditoria de alterações
- Regras de negócio (canais privados)

### Views
- Relatórios de patrocínio
- Análise de receitas
- Métricas de doações
- Agregação de dados financeiros

### Índices
- Otimização de buscas por nome
- Ordenação por valores
- Consultas em tabelas de relacionamento

## Schema

Todos os objetos estão no schema `trabalho_bd2`.

## Observações

- Sistema suporta múltiplos países e moedas
- Conversão automática de valores
- Rastreamento completo de transações financeiras
- Auditoria de mudanças críticas
- Constraints de integridade referencial em cascata
