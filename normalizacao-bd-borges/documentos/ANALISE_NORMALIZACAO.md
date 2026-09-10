# Normalização de Base de Dados — Sistema de Gestão de Funcionários
## Análise Completa: 1FN, 2FN, 3FN e 4FN

**Universidade Licungo | Curso de Licenciatura em Informática**

---

## 1. Contexto e Dados de Partida

A tabela original (0FN) contém dados de 16 funcionários de uma empresa moçambicana, armazenados numa única folha de cálculo. Inclui informação pessoal, morada, dados profissionais, filhos (até 3) e contactos telefónicos (até 3), armazenados em colunas repetidas.

### Campos da Tabela Original (0FN)

| Categoria | Campos |
|-----------|--------|
| **Dados Pessoais** | Nome, Data Nasc., NUIT, BI, Email |
| **Morada** | Endereço, Cidade, Província, País |
| **Dados Profissionais** | Cargo, Cód. Cargo, Função, Cód. Função, Posto de Trabalho, Data Admissão |
| **Filhos** | Filho 1, Filho 2, Filho 3 |
| **Contactos** | Celular 1, Celular 2, Celular 3 |

---

## 2. Identificação dos Problemas na Tabela Original (0FN)

### 2.1. Dados Não Atómicos

A coluna **Endereço** não é atómica:
- **Valor original:** "Av. Julius Nyerere, n.º 245, Sommerschield" / "Rua da Resistência, n.º 8, Polana Caniço8"
- **Problema:** Combina rua/avenida, número e bairro numa única célula
- **Justificação:** Viola a definição de atomicidade de 1FN; deve ser decomposta em rua e bairro

### 2.2. Grupos Repetitivos

#### **Filhos (Colunas Repetidas)**
- **Campos:** Filho 1, Filho 2, Filho 3
- **Problema:** Armazena múltiplos valores de um mesmo atributo em colunas separadas
- **Exemplos:**
  - Fernando José Macuácua: [José Macuácua, Beatriz Macuácua, Adriano Macuácua]
  - Hélder António Cuamba: [António Cuamba Jr, Filomena Cuamba, vazio]
- **Violação:** Viola 1FN; não permite fácil adição/remoção de filhos

#### **Contactos Telefónicos (Colunas Repetidas)**
- **Campos:** Celular 1, Celular 2, Celular 3
- **Problema:** Armazena múltiplos números em colunas separadas
- **Exemplos:**
  - Amélia Fernanda Cossa: [841234567, 821234567, vazio]
  - Fernando José Macuácua: [823456789, 843456789, 863456789]
- **Violação:** Viola 1FN; cria anomalias de inserção/remoção/atualização

### 2.3. Dependências Parciais

Uma dependência parcial existe quando um atributo não-chave depende apenas de parte da chave primária composta.

**Análise da Chave Primária Composta Proposta: (NUIT, Data Admissão)**
- **Problema identificado:** Cargo e Função dependem de Cód. Cargo e Cód. Função, não do funcionário específico
- **Exemplos:**
  - Amélia Fernanda Cossa: Cargo "Técnico de Informática" (C01) → Função "Tecnologias de Informação" (F01)
  - Ivete Sara Chirindza: Cargo "Técnico de Informática" (C01) → Função "Tecnologias de Informação" (F01)
  - Os mesmos cargos/funções repetem-se para vários funcionários

### 2.4. Dependências Transitivas

Uma dependência transitiva existe quando um atributo não-chave depende de outro atributo não-chave.

**Dependências Identificadas:**
1. **Cargo → Cód. Cargo → Função → Cód. Função**
   - Cargo "Contabilista" → sempre C02
   - C02 → sempre "Finanças"
   - Cód. Função F02

2. **Cidade → Província**
   - "Maputo" (cidade) → sempre "Maputo Cidade" (província)
   - "Beira" (cidade) → sempre "Sofala" (província)
   - "Nampula" (cidade) → sempre "Nampula" (província)
   - Violação de 3FN: Cidade não-chave determina Província não-chave

### 2.5. Dependências Multivaloradas Independentes

Uma dependência multivalorada ocorre quando dois atributos multivalorados são independentes um do outro.

**Análise:**
- **Filhos e Contactos Telefónicos são independentes:**
  - Um funcionário pode ter 1, 2 ou 3 filhos
  - Um funcionário pode ter 1, 2 ou 3 contactos telefónicos
  - Não existe relação entre número de filhos e número de contactos
  - Violação de 4FN: Armazenar filhos e contactos na mesma tabela viola 4FN

---

## 3. Primeira Forma Normal (1FN)

### Objetivo
Eliminar grupos repetitivos e garantir que todos os atributos são atómicos.

### Problemas Tratados
1. ✓ Decomposição de Endereço em Rua e Bairro
2. ✓ Eliminação de colunas repetidas de Filhos
3. ✓ Eliminação de colunas repetidas de Contactos Telefónicos

### Tabelas Resultantes da 1FN

#### **FUNCIONÁRIO_1FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| NUIT | Char(9) | Chave Primária |
| Nome | Varchar(100) | Nome completo |
| Data_Nasc | Date | Data de nascimento |
| BI | Varchar(25) | Bilhete de Identidade |
| Email | Varchar(100) | Endereço de email |
| Rua_Avenida | Varchar(150) | Rua ou Avenida (atómico) |
| Bairro | Varchar(50) | Bairro (atómico) |
| Cidade | Varchar(50) | Cidade |
| Provincia | Varchar(50) | Província |
| Pais | Varchar(50) | País |
| Cargo | Varchar(80) | Designação do cargo |
| Cod_Cargo | Char(3) | Código do cargo |
| Funcao | Varchar(80) | Designação da função |
| Cod_Funcao | Char(3) | Código da função |
| Posto_Trabalho | Varchar(50) | Posto de trabalho (delegação) |
| Data_Admissao | Date | Data de admissão |

#### **FILHO_1FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| ID_Filho | Int | Chave Primária |
| NUIT_Funcionario | Char(9) | Chave Estrangeira para FUNCIONÁRIO_1FN |
| Nome_Filho | Varchar(100) | Nome do filho |

#### **CONTACTO_TELEFONICO_1FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| ID_Contacto | Int | Chave Primária |
| NUIT_Funcionario | Char(9) | Chave Estrangeira para FUNCIONÁRIO_1FN |
| Numero_Celular | Varchar(20) | Número de contacto (atómico) |

### Características da 1FN
✓ Todos os atributos são atómicos
✓ Sem colunas repetidas
✓ Cada célula contém um único valor
✓ Grupos repetitivos eliminados

### Problemas Ainda Presentes
⚠ **Dependências Parciais:** Cargo, Cód. Cargo, Função, Cód. Função dependem de Cód. Cargo e Cód. Função
⚠ **Dependências Transitivas:** Cidade determina Província; Cargo determina Função
⚠ **Dependências Multivaloradas:** Filhos e Contactos independentes

---

## 4. Segunda Forma Normal (2FN)

### Objetivo
Eliminar dependências parciais em relação à chave primária.

### Análise de Dependências Parciais

A chave primária em 1FN é **NUIT** (Chave Simples), portanto não existem dependências parciais (estas ocorrem apenas com chaves compostas).

No entanto, identificamos **redundância:**
- **Cargo, Cód. Cargo, Função, Cód. Função** repetem-se para múltiplos funcionários
- Estes atributos pertencem à entidade "Cargo" e não à entidade "Funcionário"

**Decisão de Normalização:** Embora tecnicamente 1FN não viole dependências parciais (chave é simples), aplicamos 2FN de forma funcional separando a tabela de Cargos.

### Tabelas Resultantes da 2FN

#### **CARGO_2FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| Cod_Cargo | Char(3) | Chave Primária |
| Nome_Cargo | Varchar(80) | Nome do cargo |
| Cod_Funcao | Char(3) | Chave Estrangeira para FUNÇÃO_2FN |

#### **FUNCAO_2FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| Cod_Funcao | Char(3) | Chave Primária |
| Nome_Funcao | Varchar(80) | Nome da função |

#### **FUNCIONÁRIO_2FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| NUIT | Char(9) | Chave Primária |
| Nome | Varchar(100) | Nome completo |
| Data_Nasc | Date | Data de nascimento |
| BI | Varchar(25) | Bilhete de Identidade |
| Email | Varchar(100) | Email |
| Rua_Avenida | Varchar(150) | Rua/Avenida |
| Bairro | Varchar(50) | Bairro |
| Cidade | Varchar(50) | Cidade |
| Provincia | Varchar(50) | Província |
| Pais | Varchar(50) | País |
| Cod_Cargo | Char(3) | Chave Estrangeira para CARGO_2FN |
| Posto_Trabalho | Varchar(50) | Posto de trabalho |
| Data_Admissao | Date | Data de admissão |

#### **FILHO_2FN**
(Sem alterações da 1FN)

#### **CONTACTO_TELEFONICO_2FN**
(Sem alterações da 1FN)

### Características da 2FN
✓ Todos os atributos da 1FN mantidos
✓ Redundância de Cargo e Função eliminada
✓ Relacionamentos com chaves estrangeiras
✓ Sem dependências parciais

### Problemas Ainda Presentes
⚠ **Dependências Transitivas:** Cidade → Província (ambas não-chave)
⚠ **Dependências Multivaloradas:** Filhos e Contactos independentes

---

## 5. Terceira Forma Normal (3FN)

### Objetivo
Eliminar dependências transitivas (atributos não-chave dependem de outros atributos não-chave).

### Dependência Transitiva Identificada

**Cadeia de Dependência:** Funcionário → Cidade → Província

Análise dos dados reais:
| Cidade | Província Observada | Constância |
|--------|-------------------|-----------|
| Maputo | Maputo Cidade | 100% |
| Matola | Maputo Província | 100% |
| Chókwè | Gaza | 100% |
| Maxixe | Inhambane | 100% |
| Beira | Sofala | 100% |
| Nampula | Nampula | 100% |
| Chimoio | Manica | 100% |
| Tete | Tete | 100% |
| Quelimane | Zambézia | 100% |
| Pemba | Cabo Delgado | 100% |

**Violação Identificada:** Cidade (atributo não-chave) determina Província (atributo não-chave)

**Anomalias Causadas:**
- **Inserção:** Impossível inserir uma cidade sem conhecer a sua província
- **Atualização:** Se a província de uma cidade muda, todos os registos de funcionários dessa cidade devem ser atualizados
- **Remoção:** Se remover o último funcionário de uma cidade, perde-se a informação da associação Cidade-Província

### Tabelas Resultantes da 3FN

#### **LOCALIZACAO_3FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| Cod_Cidade | Int | Chave Primária |
| Nome_Cidade | Varchar(50) | Nome da cidade |
| Cod_Provincia | Int | Chave Estrangeira para PROVINCIA_3FN |

#### **PROVINCIA_3FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| Cod_Provincia | Int | Chave Primária |
| Nome_Provincia | Varchar(50) | Nome da província |
| Pais | Varchar(50) | País |

#### **FUNCIONÁRIO_3FN**

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| NUIT | Char(9) | Chave Primária |
| Nome | Varchar(100) | Nome completo |
| Data_Nasc | Date | Data de nascimento |
| BI | Varchar(25) | Bilhete de Identidade |
| Email | Varchar(100) | Email |
| Rua_Avenida | Varchar(150) | Rua/Avenida |
| Bairro | Varchar(50) | Bairro |
| Cod_Cidade | Int | Chave Estrangeira para LOCALIZACAO_3FN |
| Cod_Cargo | Char(3) | Chave Estrangeira para CARGO_3FN |
| Posto_Trabalho | Varchar(50) | Posto de trabalho |
| Data_Admissao | Date | Data de admissão |

#### Tabelas Sem Alteração
- **CARGO_3FN** (idêntica a 2FN)
- **FUNCAO_3FN** (idêntica a 2FN)
- **FILHO_3FN** (idêntica a 1FN/2FN)
- **CONTACTO_TELEFONICO_3FN** (idêntica a 1FN/2FN)

### Características da 3FN
✓ Todas as características de 1FN e 2FN mantidas
✓ Dependências Transitivas eliminadas
✓ Novo relacionamento 1:N entre PROVINCIA e LOCALIZACAO
✓ Novo relacionamento 1:N entre LOCALIZACAO e FUNCIONARIO
✓ Anomalias de Cidade-Província resolvidas

### Problemas Ainda Presentes
⚠ **Dependências Multivaloradas:** Filhos e Contactos são atributos multivalorados independentes armazenados separadamente (ainda assim, a 3FN não as elimina formalmente)

---

## 6. Quarta Forma Normal (4FN)

### Objetivo
Eliminar dependências multivaloradas independentes.

### Análise de Dependências Multivaloradas

Uma dependência multivalorada ocorre quando:
- Um funcionário pode ter múltiplos filhos
- Um funcionário pode ter múltiplos contactos telefónicos
- **Estas duas características são independentes entre si**

**Problema Identificado:**
Se armazenássemos Filhos e Contactos na mesma tabela, teríamos que criar um produto cartesiano:
- Fernando Macuácua com 3 filhos e 3 contactos → 9 registos necessários (3 × 3)

**Solução de 4FN:**
Manter **Filhos e Contactos em tabelas separadas** (já feito desde 1FN)

A estrutura já criada em 1FN está em conformidade com 4FN porque:
- **FILHO_4FN** e **CONTACTO_TELEFONICO_4FN** são tabelas separadas
- Cada uma tem a sua própria relação N:1 com FUNCIONÁRIO_4FN
- Não há produto cartesiano desnecessário

### Tabelas Resultantes da 4FN

#### **FUNCIONÁRIO_4FN** (Schema Final)

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| NUIT | Char(9) | PK |
| Nome | Varchar(100) | NOT NULL |
| Data_Nasc | Date | |
| BI | Varchar(25) | UNIQUE |
| Email | Varchar(100) | |
| Rua_Avenida | Varchar(150) | |
| Bairro | Varchar(50) | |
| Cod_Cidade | Int | FK → LOCALIZACAO |
| Cod_Cargo | Char(3) | FK → CARGO |
| Posto_Trabalho | Varchar(50) | |
| Data_Admissao | Date | |

#### **PROVINCIA_4FN**

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| Cod_Provincia | Int | PK |
| Nome_Provincia | Varchar(50) | NOT NULL |
| Pais | Varchar(50) | NOT NULL |

#### **LOCALIZACAO_4FN**

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| Cod_Cidade | Int | PK |
| Nome_Cidade | Varchar(50) | NOT NULL |
| Cod_Provincia | Int | FK → PROVINCIA |

#### **CARGO_4FN**

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| Cod_Cargo | Char(3) | PK |
| Nome_Cargo | Varchar(80) | NOT NULL |
| Cod_Funcao | Char(3) | FK → FUNCAO |

#### **FUNCAO_4FN**

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| Cod_Funcao | Char(3) | PK |
| Nome_Funcao | Varchar(80) | NOT NULL |

#### **FILHO_4FN**

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| ID_Filho | Int | PK (AUTO_INCREMENT) |
| NUIT_Funcionario | Char(9) | FK → FUNCIONÁRIO |
| Nome_Filho | Varchar(100) | NOT NULL |

#### **CONTACTO_TELEFONICO_4FN**

| Coluna | Tipo | Restrição |
|--------|------|-----------|
| ID_Contacto | Int | PK (AUTO_INCREMENT) |
| NUIT_Funcionario | Char(9) | FK → FUNCIONÁRIO |
| Numero_Celular | Varchar(20) | NOT NULL |

### Características da 4FN
✓ Todas as características de 3FN mantidas
✓ Dependências multivaloradas eliminadas (Filhos e Contactos em tabelas separadas)
✓ Sem produto cartesiano desnecessário
✓ Integridade referencial garantida

---

## 7. Resumo da Evolução

### Tabelas em Cada Fase

**0FN (Original):** 1 tabela não normalizada

**1FN:** 3 tabelas (eliminação de grupos repetitivos)
- FUNCIONÁRIO_1FN
- FILHO_1FN
- CONTACTO_TELEFONICO_1FN

**2FN:** 5 tabelas (eliminação de redundância Cargo/Função)
- FUNCIONÁRIO_2FN
- CARGO_2FN
- FUNCAO_2FN
- FILHO_2FN
- CONTACTO_TELEFONICO_2FN

**3FN:** 7 tabelas (eliminação de dependências transitivas Cidade-Província)
- FUNCIONÁRIO_3FN
- CARGO_3FN
- FUNCAO_3FN
- LOCALIZACAO_3FN
- PROVINCIA_3FN
- FILHO_3FN
- CONTACTO_TELEFONICO_3FN

**4FN:** 7 tabelas (eliminação de dependências multivaloradas)
- FUNCIONÁRIO_4FN
- CARGO_4FN
- FUNCAO_4FN
- PROVINCIA_4FN
- LOCALIZACAO_4FN
- FILHO_4FN
- CONTACTO_TELEFONICO_4FN

### Problemas Resolvidos

| Problema | Forma Normal | Solução |
|----------|-------------|---------|
| Dados não atómicos (Endereço) | 1FN | Decompor em Rua e Bairro |
| Grupos repetitivos (Filhos) | 1FN | Tabela FILHO separada |
| Grupos repetitivos (Contactos) | 1FN | Tabela CONTACTO_TELEFONICO separada |
| Redundância Cargo-Função | 2FN | Tabelas CARGO e FUNCAO separadas |
| Dependência Transitiva Cidade-Província | 3FN | Tabelas LOCALIZACAO e PROVINCIA separadas |
| Multivaloradas independentes | 4FN | Confirmada separação já em 1FN |

---

## 8. Qualidades do Esquema Final

✓ **Atomicidade:** Todos os atributos são atómicos
✓ **Sem Redundância:** Informações repetidas eliminadas
✓ **Sem Anomalias:** Inserção, atualização e remoção seguras
✓ **Integridade Referencial:** Relacionamentos bem definidos
✓ **Escalabilidade:** Fácil adicionar novos funcionários, filhos, contactos
✓ **Manutenibilidade:** Estrutura clara e lógica

---

## 9. Próximos Passos

O esquema final em 4FN é utilizado para:
1. Diagrama Modelo Entidade-Relacionamento (MER)
2. Scripts SQL (CREATE TABLE)
3. Queries de demonstração com JOIN
