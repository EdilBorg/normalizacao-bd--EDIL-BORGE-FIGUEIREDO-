# Normalização de Base de Dados — Sistema de Gestão de Funcionários

---

## 📋 Descrição do Projeto

Este projeto apresenta a normalização completa de uma base de dados de funcionários, partindo de uma tabela não normalizada (0FN) até à 4ª Forma Normal (4FN).

A base de dados original continha:
- **16 registos de funcionários**
- **Dados pessoais, morada e profissionais**
- **Filhos em colunas repetidas** (Filho 1, Filho 2, Filho 3)
- **Contactos telefónicos em colunas repetidas** (Celular 1, Celular 2, Celular 3)
- **Redundância de cargos, funções e localizações**

Após normalização até 4FN, a estrutura foi reorganizada em **7 tabelas bem definidas** com relacionamentos adequados e sem anomalias de inserção, atualização ou remoção.

---

## 📁 Estrutura do Projeto

```
normalizacao-bd-borges/
│
├── documentos/
│   └── ANALISE_NORMALIZACAO.md
│       └─ Análise completa das 4 formas normais (1FN, 2FN, 3FN, 4FN)
│       └─ Identificação de problemas na tabela original
│       └─ Evolução passo-a-passo de cada forma normal
│       └─ Tabelas resultantes de cada fase
│
├── diagramas/
│   ├── Diagrama.png
│ 
│
├── sql/
│   └── schema_normalizacao.sql
│       ├─ Criação de 7 tabelas normalizadas (DDL)
│       ├─ Definição de chaves primárias e estrangeiras
│       ├─ Inserção de 16 funcionários e dados relacionados
│       └─ 6 queries de demonstração com JOIN
│
└── README.md (este ficheiro)
    └─ Guia do projeto e como consultar os artefatos
```

---

## 📚 Artefatos Principais

### 1. **Documento de Análise** (`documentos/ANALISE_NORMALIZACAO.md`)

Documento completo que apresenta:

#### **Seção 1-2: Contexto e Dados de Partida**
- Descrição dos campos originais
- Categorização de informação

#### **Seção 3: Identificação dos Problemas (0FN)**
- **Dados não atómicos:** Endereço decomposto
- **Grupos repetitivos:** Filhos e contactos em colunas
- **Dependências parciais:** Cargo/Função redundante
- **Dependências transitivas:** Cidade → Província
- **Dependências multivaloradas:** Filhos e contactos independentes

#### **Seções 4-8: Normalização Progressiva**
- **1FN:** Eliminação de grupos repetitivos e atomicidade
- **2FN:** Eliminação de redundância Cargo/Função
- **3FN:** Eliminação de dependência Cidade → Província
- **4FN:** Confirmação de separação de dependências multivaloradas

Cada seção inclui:
- ✓ Objetivos e problemas tratados
- ✓ Tabelas resultantes com tipos de dados
- ✓ Características alcançadas
- ✓ Problemas ainda presentes


### 2. **Script SQL** (`sql/schema_normalizacao.sql`)

Script SQL completo com:

#### **Criação de Tabelas (DDL)**
```sql
CREATE TABLE PROVINCIA (...)
CREATE TABLE LOCALIZACAO (...)
CREATE TABLE FUNCAO (...)
CREATE TABLE CARGO (...)
CREATE TABLE FUNCIONARIO (...)
CREATE TABLE FILHO (...)
CREATE TABLE CONTACTO_TELEFONICO (...)
```

#### **Inserção de Dados**
- 16 funcionários com dados reais
- Províncias, localizações, cargos e funções
- Filhos (19 registos)
- Contactos telefónicos (24 registos)

#### **Queries de Demonstração**
1. **Query 1:** Funcionários com Informação Completa (Cargo, Função, Localização)
2. **Query 2:** Funcionários com Seus Filhos (Reconstituição de colunas repetidas)
3. **Query 3:** Funcionários com Seus Contactos Telefónicos (Reconstituição de colunas repetidas)
4. **Query 4 (Bonus):** Informação Completa Integrada (Tudo junto)
5. **Query 5 (Bonus):** Distribuição por Cargo e Função
6. **Query 6 (Bonus):** Distribuição por Localização

---

## 🔑 Tabelas Normalizadas (4FN)

### 1. **PROVINCIA**
- **Chave Primária:** `Cod_Provincia`
- **Campos:** Nome_Provincia, Pais
- **Relacionamento:** 1:N com LOCALIZACAO

### 2. **LOCALIZACAO**
- **Chave Primária:** `Cod_Cidade`
- **Chave Estrangeira:** `Cod_Provincia`
- **Campos:** Nome_Cidade
- **Relacionamento:** 1:N com FUNCIONARIO

### 3. **FUNCAO**
- **Chave Primária:** `Cod_Funcao`
- **Campos:** Nome_Funcao
- **Relacionamento:** 1:N com CARGO

### 4. **CARGO**
- **Chave Primária:** `Cod_Cargo`
- **Chave Estrangeira:** `Cod_Funcao`
- **Campos:** Nome_Cargo
- **Relacionamento:** 1:N com FUNCIONARIO

### 5. **FUNCIONARIO** (Tabela Principal)
- **Chave Primária:** `NUIT`
- **Chaves Estrangeiras:** `Cod_Cidade`, `Cod_Cargo`
- **Campos:** Nome, Data_Nasc, BI, Email, Rua_Avenida, Bairro, Posto_Trabalho, Data_Admissao
- **Relacionamento:** 1:N com FILHO, 1:N com CONTACTO_TELEFONICO

### 6. **FILHO**
- **Chave Primária:** `ID_Filho` (Auto-incremento)
- **Chave Estrangeira:** `NUIT_Funcionario`
- **Campos:** Nome_Filho
- **Cardinalidade:** N:1 com FUNCIONARIO

### 7. **CONTACTO_TELEFONICO**
- **Chave Primária:** `ID_Contacto` (Auto-incremento)
- **Chave Estrangeira:** `NUIT_Funcionario`
- **Campos:** Numero_Celular
- **Cardinalidade:** N:1 com FUNCIONARIO

---

## 🔗 Relacionamentos e Cardinalidades

| Relacionamento | Tipo | Descrição |
|---|---|---|
| PROVINCIA → LOCALIZACAO | 1:N | Uma província contém múltiplas cidades |
| LOCALIZACAO → FUNCIONARIO | 1:N | Uma cidade tem múltiplos funcionários |
| FUNCAO → CARGO | 1:N | Uma função agrupa múltiplos cargos |
| CARGO → FUNCIONARIO | 1:N | Um cargo é desempenhado por múltiplos funcionários |
| FUNCIONARIO → FILHO | 1:N | Um funcionário pode ter múltiplos filhos |
| FUNCIONARIO → CONTACTO_TELEFONICO | 1:N | Um funcionário pode ter múltiplos contactos |

---

## ⚙️ Como Usar Este Projeto

### 1. **Entender a Normalização**
1. Leia `documentos/ANALISE_NORMALIZACAO.md`
2. Siga a evolução de 1FN → 2FN → 3FN → 4FN
3. Compreenda o tratamento de cada problema

### 2. **Visualizar o Diagrama MER**
**Opção A (Recomendado):**
1. Copie o conteúdo de `diagramas/MER_DBDiagram.txt`
2. Aceda a https://dbdiagram.io/d
3. Cole o conteúdo
4. O diagrama renderiza automaticamente

**Opção B:**
1. Abra `diagramas/MER_ASCII.txt` num editor de texto
2. Visualize o diagrama em ASCII art

### 3. **Executar o Script SQL**
1. Copie o conteúdo de `sql/schema_normalizacao.sql`
2. Conecte-se a uma base de dados MySQL/MariaDB
3. Execute o script completo
4. Execute as queries de demonstração para validar

**Exemplo em MySQL:**
```bash
mysql -u seu_usuario -p seu_banco < sql/schema_normalizacao.sql
```

### 4. **Validar a Reconstrução de Dados**
Execute as queries de demonstração:
- **Query 1:** Valida que informação de Cargo/Função/Localização é recuperada
- **Query 2:** Valida que filhos (colunas repetidas) são recuperados
- **Query 3:** Valida que contactos (colunas repetidas) são recuperados
- **Query 4:** Valida que TODA a informação original é recuperada

---

## ✅ Qualidades Alcançadas

✓ **1FN Atingida:**
- Todos os atributos são atómicos
- Sem colunas repetidas

✓ **2FN Atingida:**
- Sem dependências parciais
- Redundância de Cargo/Função eliminada

✓ **3FN Atingida:**
- Sem dependências transitivas
- Relacionamento Cidade-Província separado

✓ **4FN Atingida:**
- Dependências multivaloradas eliminadas
- Filhos e Contactos em tabelas separadas

✓ **Sem Anomalias:**
- Inserção: Podem adicionar-se filhos/contactos sem replicar dados funcionário
- Atualização: Alterar cargo apenas uma vez na tabela CARGO
- Remoção: Remover um funcionário remove filhos/contactos automaticamente

✓ **Integridade Referencial:**
- Todas as chaves estrangeiras definidas
- Constraints apropriadas (ON DELETE CASCADE, ON DELETE RESTRICT)

---

## 📊 Estatísticas dos Dados

- **Funcionários:** 16
- **Filhos:** 19
- **Contactos Telefónicos:** 24
- **Províncias:** 10
- **Cidades/Localizações:** 10
- **Cargos:** 8
- **Funções:** 8

---

## 🎓 Aprendizados Principais

1. **Atomicidade (1FN):** Decomposição de Endereço, eliminação de colunas repetidas
2. **Dependências Parciais (2FN):** Separação de entidades redundantes
3. **Dependências Transitivas (3FN):** Eliminação de cadeias de dependência
4. **Dependências Multivaloradas (4FN):** Confirmação de separação adequada

---

## 📝 Notas de Implementação

- **SGBD:** MySQL 5.7+ ou MariaDB 10.0+
- **Encoding:** UTF-8 (suporta caracteres português)
- **Auto-incremento:** Usado para ID_Filho e ID_Contacto
- **Integridade:** Cascata em FILHO e CONTACTO_TELEFONICO, Restrição em CARGO e LOCALIZACAO

---

## 👤 Informação do Projeto

- **Instituição:** Universidade Licungo
- **Curso:** Licenciatura em Informática
- **Disciplina:** Bases de Dados
- **Trabalho:** Normalização de Base de Dados II
- **Data:** 2024

---

## 📞 Resumo Rápido

| Pergunta | Resposta |
|----------|----------|
| Quantas tabelas? | 7 (PROVINCIA, LOCALIZACAO, FUNCAO, CARGO, FUNCIONARIO, FILHO, CONTACTO_TELEFONICO) |
| Qual é a chave primária de FUNCIONARIO? | NUIT |
| Qual é a forma normal alcançada? | 4FN (Quarta Forma Normal) |
| Como se recuperam os filhos originais? | Query 2: LEFT JOIN com FILHO |
| Como se recuperam os contactos originais? | Query 3: LEFT JOIN com CONTACTO_TELEFONICO |
| Há redundância? | Não (eliminada entre 1FN e 3FN) |
| Como adicionar um novo filho? | INSERT em FILHO com NUIT_Funcionario |
| Como adicionar um novo contacto? | INSERT em CONTACTO_TELEFONICO com NUIT_Funcionario |

---

**FIM DO README**
