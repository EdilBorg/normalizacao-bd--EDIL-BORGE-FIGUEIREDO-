CREATE TABLE PROVINCIA (
    Cod_Provincia INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Provincia VARCHAR(50) NOT NULL UNIQUE,
    Pais VARCHAR(50) NOT NULL DEFAULT 'Moçambique'
);

-- Tabela: LOCALIZACAO
-- Descrição: Armazena informação de cidades/localizações e sua relação com províncias
-- Chave Primária: Cod_Cidade
-- Chave Estrangeira: Cod_Provincia → PROVINCIA.Cod_Provincia
CREATE TABLE LOCALIZACAO (
    Cod_Cidade INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Cidade VARCHAR(50) NOT NULL,
    Cod_Provincia INT NOT NULL,
    UNIQUE KEY unique_cidade_provincia (Nome_Cidade, Cod_Provincia),
    CONSTRAINT fk_localizacao_provincia FOREIGN KEY (Cod_Provincia) 
        REFERENCES PROVINCIA(Cod_Provincia) ON DELETE RESTRICT
);

-- Tabela: FUNCAO
-- Descrição: Armazena informação de funções (Tecnologias de Informação, Finanças, etc.)
-- Chave Primária: Cod_Funcao
CREATE TABLE FUNCAO (
    Cod_Funcao CHAR(3) PRIMARY KEY,
    Nome_Funcao VARCHAR(80) NOT NULL UNIQUE
);

-- Tabela: CARGO
-- Descrição: Armazena informação de cargos e sua relação com funções
-- Chave Primária: Cod_Cargo
-- Chave Estrangeira: Cod_Funcao → FUNCAO.Cod_Funcao
-- Relacionamento: 1:N (Uma função pode ter múltiplos cargos)
CREATE TABLE CARGO (
    Cod_Cargo CHAR(3) PRIMARY KEY,
    Nome_Cargo VARCHAR(80) NOT NULL UNIQUE,
    Cod_Funcao CHAR(3) NOT NULL,
    CONSTRAINT fk_cargo_funcao FOREIGN KEY (Cod_Funcao) 
        REFERENCES FUNCAO(Cod_Funcao) ON DELETE RESTRICT
);

-- Tabela: FUNCIONARIO
-- Descrição: Tabela principal de funcionários normalizada até 4FN
-- Chave Primária: NUIT (Número Único de Identificação Tributária)
-- Chaves Estrangeiras: Cod_Cidade, Cod_Cargo
-- Relacionamentos: N:1 com LOCALIZACAO e CARGO
CREATE TABLE FUNCIONARIO (
    NUIT CHAR(9) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Data_Nasc DATE,
    BI VARCHAR(25) UNIQUE,
    Email VARCHAR(100),
    Rua_Avenida VARCHAR(150),
    Bairro VARCHAR(50),
    Cod_Cidade INT NOT NULL,
    Cod_Cargo CHAR(3) NOT NULL,
    Posto_Trabalho VARCHAR(50),
    Data_Admissao DATE NOT NULL,
    CONSTRAINT fk_funcionario_localizacao FOREIGN KEY (Cod_Cidade) 
        REFERENCES LOCALIZACAO(Cod_Cidade) ON DELETE RESTRICT,
    CONSTRAINT fk_funcionario_cargo FOREIGN KEY (Cod_Cargo) 
        REFERENCES CARGO(Cod_Cargo) ON DELETE RESTRICT
);

-- Tabela: FILHO
-- Descrição: Armazena informação de filhos dos funcionários
-- Chave Primária: ID_Filho (Auto-incremento)
-- Chave Estrangeira: NUIT_Funcionario → FUNCIONARIO.NUIT
-- Relacionamento: N:1 (Múltiplos filhos para um funcionário)
-- Nota: Elimina a colunas repetidas "Filho 1, Filho 2, Filho 3" da tabela original
CREATE TABLE FILHO (
    ID_Filho INT PRIMARY KEY AUTO_INCREMENT,
    NUIT_Funcionario CHAR(9) NOT NULL,
    Nome_Filho VARCHAR(100) NOT NULL,
    CONSTRAINT fk_filho_funcionario FOREIGN KEY (NUIT_Funcionario) 
        REFERENCES FUNCIONARIO(NUIT) ON DELETE CASCADE
);

-- Tabela: CONTACTO_TELEFONICO
-- Descrição: Armazena informação de contactos telefónicos dos funcionários
-- Chave Primária: ID_Contacto (Auto-incremento)
-- Chave Estrangeira: NUIT_Funcionario → FUNCIONARIO.NUIT
-- Relacionamento: N:1 (Múltiplos contactos para um funcionário)
-- Nota: Elimina as colunas repetidas "Celular 1, Celular 2, Celular 3" da tabela original
CREATE TABLE CONTACTO_TELEFONICO (
    ID_Contacto INT PRIMARY KEY AUTO_INCREMENT,
    NUIT_Funcionario CHAR(9) NOT NULL,
    Numero_Celular VARCHAR(20) NOT NULL,
    CONSTRAINT fk_contacto_funcionario FOREIGN KEY (NUIT_Funcionario) 
        REFERENCES FUNCIONARIO(NUIT) ON DELETE CASCADE
);

-- ────────────────────────────────────────────────────────────────────────────────
-- INSERÇÃO DE DADOS
-- ────────────────────────────────────────────────────────────────────────────────

-- Inserir Províncias (única tabela que não havia no Excel original)
INSERT INTO PROVINCIA (Nome_Provincia, Pais) VALUES
('Maputo Cidade', 'Moçambique'),
('Maputo Província', 'Moçambique'),
('Gaza', 'Moçambique'),
('Inhambane', 'Moçambique'),
('Sofala', 'Moçambique'),
('Nampula', 'Moçambique'),
('Manica', 'Moçambique'),
('Tete', 'Moçambique'),
('Zambézia', 'Moçambique'),
('Cabo Delgado', 'Moçambique');

-- Inserir Localizações (Cidades)
-- Dados extraídos da coluna 'Cidade' e 'Província' da tabela original
INSERT INTO LOCALIZACAO (Nome_Cidade, Cod_Provincia) VALUES
('Maputo', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Maputo Cidade')),
('Matola', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Maputo Província')),
('Chókwè', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Gaza')),
('Maxixe', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Inhambane')),
('Beira', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Sofala')),
('Nampula', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Nampula')),
('Chimoio', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Manica')),
('Tete', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Tete')),
('Quelimane', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Zambézia')),
('Pemba', (SELECT Cod_Provincia FROM PROVINCIA WHERE Nome_Provincia = 'Cabo Delgado'));

-- Inserir Funções
-- Dados extraídos da coluna 'Função' e 'Cód. Função' da tabela original
INSERT INTO FUNCAO (Cod_Funcao, Nome_Funcao) VALUES
('F01', 'Tecnologias de Informação'),
('F02', 'Finanças'),
('F03', 'Engenharia'),
('F04', 'Saúde'),
('F05', 'Educação'),
('F06', 'Logística'),
('F07', 'Recursos Humanos'),
('F08', 'Administração');

-- Inserir Cargos
-- Dados extraídos da coluna 'Cargo', 'Cód. Cargo', 'Função' e 'Cód. Função' da tabela original
INSERT INTO CARGO (Cod_Cargo, Nome_Cargo, Cod_Funcao) VALUES
('C01', 'Técnico de Informática', 'F01'),
('C02', 'Contabilista', 'F02'),
('C03', 'Engenheiro Civil', 'F03'),
('C04', 'Enfermeiro', 'F04'),
('C05', 'Professor', 'F05'),
('C06', 'Motorista', 'F06'),
('C07', 'Gestor de Recursos Humanos', 'F07'),
('C08', 'Assistente Administrativo', 'F08');

-- Inserir Funcionários
-- Dados extraídos da tabela original, sem redundância de cargo/função/cidade/província
INSERT INTO FUNCIONARIO (NUIT, Nome, Data_Nasc, BI, Email, Rua_Avenida, Bairro, Cod_Cidade, Cod_Cargo, Posto_Trabalho, Data_Admissao) VALUES
('100234567', 'Amélia Fernanda Cossa', '1985-03-12', '110100123456A', 'amelia.cossa@empresa.co.mz', 'Av. Julius Nyerere, n.º 245', 'Sommerschield', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Maputo'), 'C01', 'Sede Maputo', '2015-02-05'),
('100345678', 'Bernardo Alfredo Machava', '1979-07-22', '110100234567B', 'bernard.machava@empresa.co.mz', 'Rua da Resistência, n.º 8', 'Polana Caniço', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Maputo'), 'C02', 'Sede Maputo', '2010-09-14'),
('100456789', 'Celina Armando Sitoe', '1990-11-03', '110200345678C', 'celina.sitoe@empresa.co.mz', 'Av. Samora Machel, n.º 12', 'Fomento', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Matola'), 'C08', 'Delegação Matola', '2018-06-01'),
('100567890', 'Domingos Paulo Nhantumbo', '1982-01-30', '110300456789D', 'domingos.nhantumbo@empresa.co.mz', 'Rua 3, n.º 56', 'Chókwè-Sede', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Chókwè'), 'C06', 'Delegação Gaza', '2012-03-10'),
('100678901', 'Eugénia Marta Muchanga', '1988-05-18', '110400567890E', 'eugenia.muchanga@empresa.co.mz', 'Av. Eduardo Mondlane, n.º 301', 'Maxixe-Sede', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Maxixe'), 'C04', 'Delegação Inhambane', '2016-08-20'),
('100789012', 'Fernando José Macuácua', '1975-09-25', '110500678901F', 'fernando.macuacua@empresa.co.mz', 'Av. Poder Popular, n.º 77', 'Macuti', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Beira'), 'C03', 'Delegação Beira', '2008-01-15'),
('100890123', 'Graça Isabel Zunguze', '1992-12-07', '110600789012G', 'graca.zunguze@empresa.co.mz', 'Rua da Frescura, n.º 19', 'Ponta Gêa', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Beira'), 'C05', 'Delegação Beira', '2019-02-02'),
('100901234', 'Hélder António Cuamba', '1980-04-14', '110700890123H', 'helder.cuamba@empresa.co.mz', 'Av. 25 de Setembro, n.º 150', 'Alto Maé', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Maputo'), 'C07', 'Sede Maputo', '2011-11-11'),
('101012345', 'Ivete Sara Chirindza', '1995-06-29', '110800901234I', 'ivete.chirindza@empresa.co.mz', 'Rua do Bagamoyo, n.º 5', 'Muhipiti', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Nampula'), 'C01', 'Delegação Nampula', '2020-07-03'),
('101123456', 'João Baptista Nhaca', '1978-08-09', '110900012345J', 'joao.nhaca@empresa.co.mz', 'Av. Josina Machel, n.º 200', 'Namahera', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Nampula'), 'C02', 'Delegação Nampula', '2009-05-25'),
('101234567', 'Lúcia Ermelinda Bila', '1991-02-16', '111000123456K', 'lucia.bila@empresa.co.mz', 'Rua da Base, n.º 33', 'Chaimite', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Beira'), 'C08', 'Delegação Beira', '2017-09-19'),
('101345678', 'Marcelino Inácio Tembe', '1983-10-21', '111100234567L', 'marcelino.tembe@empresa.co.mz', 'Av. Kwame Nkrumah, n.º 410', 'Coop', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Maputo'), 'C03', 'Sede Maputo', '2013-04-08'),
('101456789', 'Noémia Alzira Massingue', '1987-03-04', '111200345678M', 'noemia.massingue@empresa.co.mz', 'Rua de Chimoio, n.º 67', 'Chingussura', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Chimoio'), 'C04', 'Delegação Manica', '2014-12-12'),
('101567890', 'Osvaldo Simião Ubisse', '1976-07-27', '111300456789N', 'osvaldo.ubisse@empresa.co.mz', 'Av. 7 de Setembro, n.º 90', 'Matundo', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Tete'), 'C06', 'Delegação Tete', '2006-10-30'),
('101678901', 'Paulina Fátima Uache', '1993-01-15', '111400567890O', 'paulina.uache@empresa.co.mz', 'Rua da Missão, n.º 24', 'Chalaua', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Quelimane'), 'C05', 'Delegação Zambézia', '2021-09-09'),
('101789012', 'Ricardo Manuel Come', '1981-06-02', '111500678901P', 'ricardo.come@empresa.co.mz', 'Av. Franqueza, n.º 18', 'Chuwaula', (SELECT Cod_Cidade FROM LOCALIZACAO WHERE Nome_Cidade = 'Pemba'), 'C07', 'Delegação Cabo Delgado', '2010-07-17');

-- Inserir Filhos
-- Dados extraídos das colunas "Filho 1, Filho 2, Filho 3" da tabela original
INSERT INTO FILHO (NUIT_Funcionario, Nome_Filho) VALUES
-- Amélia Fernanda Cossa
('100234567', 'Cátia Cossa'),
-- Bernardo Alfredo Machava
('100345678', 'Nelson Machava'),
('100345678', 'Ivete Machava'),
('100345678', 'Suzana Machava'),
-- Domingos Paulo Nhantumbo
('100567890', 'Paulo Nhantumbo Jr'),
('100567890', 'Alzira Nhantumbo'),
-- Eugénia Marta Muchanga
('100678901', 'Marta Muchanga'),
-- Fernando José Macuácua
('100789012', 'José Macuácua'),
('100789012', 'Beatriz Macuácua'),
('100789012', 'Adriano Macuácua'),
-- Hélder António Cuamba
('100901234', 'António Cuamba Jr'),
('100901234', 'Filomena Cuamba'),
-- Ivete Sara Chirindza (sem filhos)
-- João Baptista Nhaca
('101123456', 'Baptista Nhaca Jr'),
-- Lúcia Ermelinda Bila
('101234567', 'Ermelinda Bila'),
-- Marcelino Inácio Tembe
('101345678', 'Inácio Tembe Jr'),
('101345678', 'Rosa Tembe'),
-- Osvaldo Simião Ubisse
('101567890', 'Simião Ubisse Jr'),
('101567890', 'Alcinda Ubisse'),
('101567890', 'Custódio Ubisse'),
-- Ricardo Manuel Come
('101789012', 'Manuel Come Jr');

-- Inserir Contactos Telefónicos
-- Dados extraídos das colunas "Celular 1, Celular 2, Celular 3" da tabela original
INSERT INTO CONTACTO_TELEFONICO (NUIT_Funcionario, Numero_Celular) VALUES
-- Amélia Fernanda Cossa
('100234567', '841234567'),
('100234567', '821234567'),
-- Bernardo Alfredo Machava
('100345678', '845678901'),
-- Celina Armando Sitoe
('100456789', '861122334'),
-- Domingos Paulo Nhantumbo
('100567890', '847890123'),
('100567890', '878901234'),
-- Eugénia Marta Muchanga
('100678901', '849012345'),
-- Fernando José Macuácua
('100789012', '823456789'),
('100789012', '843456789'),
('100789012', '863456789'),
-- Graça Isabel Zunguze
('100890123', '844567890'),
('100890123', '824567890'),
-- Hélder António Cuamba
('100901234', '825678901'),
-- Ivete Sara Chirindza
('101012345', '846789012'),
-- João Baptista Nhaca
('101123456', '827890123'),
('101123456', '847890124'),
-- Lúcia Ermelinda Bila
('101234567', '848901234'),
-- Marcelino Inácio Tembe
('101345678', '829012345'),
('101345678', '849012346'),
('101345678', '869012347'),
-- Noémia Alzira Massingue
('101456789', '841122334'),
-- Osvaldo Simião Ubisse
('101567890', '822233445'),
('101567890', '842233445'),
-- Paulina Fátima Uache
('101678901', '843344556'),
-- Ricardo Manuel Come
('101789012', '824455667'),
('101789012', '844455667');

-- ════════════════════════════════════════════════════════════════════════════════
-- QUERIES DE DEMONSTRAÇÃO (PELO MENOS 3 COM JOIN)
-- ════════════════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────────────────
-- QUERY 1: Funcionários com Informação Completa (Cargo, Função, Localização)
-- ────────────────────────────────────────────────────────────────────────────────
-- Objetivo: Reconstituir a informação original: funcionário com cargo, função,
-- localização e província.
-- Esta query demonstra como recuperar da tabela normalizada a informação que
-- estava armazenada redundantemente na tabela original.

SELECT 
    f.NUIT,
    f.Nome,
    f.Email,
    c.Cod_Cargo,
    c.Nome_Cargo,
    func.Cod_Funcao,
    func.Nome_Funcao,
    l.Nome_Cidade,
    p.Nome_Provincia,
    f.Posto_Trabalho,
    f.Data_Admissao
FROM FUNCIONARIO f
JOIN CARGO c ON f.Cod_Cargo = c.Cod_Cargo
JOIN FUNCAO func ON c.Cod_Funcao = func.Cod_Funcao
JOIN LOCALIZACAO l ON f.Cod_Cidade = l.Cod_Cidade
JOIN PROVINCIA p ON l.Cod_Provincia = p.Cod_Provincia
ORDER BY f.Nome;

-- ────────────────────────────────────────────────────────────────────────────────
-- QUERY 2: Funcionários com Seus Filhos
-- ────────────────────────────────────────────────────────────────────────────────
-- Objetivo: Reconstituir a informação de filhos que estava em colunas repetidas
-- (Filho 1, Filho 2, Filho 3) na tabela original.
-- Esta query demonstra como recuperar a relação 1:N entre funcionários e filhos.

SELECT 
    f.NUIT,
    f.Nome AS Nome_Funcionario,
    COUNT(fi.ID_Filho) AS Numero_Filhos,
    GROUP_CONCAT(fi.Nome_Filho ORDER BY fi.Nome_Filho SEPARATOR ', ') AS Filhos
FROM FUNCIONARIO f
LEFT JOIN FILHO fi ON f.NUIT = fi.NUIT_Funcionario
GROUP BY f.NUIT, f.Nome
ORDER BY f.Nome;

-- ────────────────────────────────────────────────────────────────────────────────
-- QUERY 3: Funcionários com Seus Contactos Telefónicos
-- ────────────────────────────────────────────────────────────────────────────────
-- Objetivo: Reconstituir a informação de contactos que estava em colunas repetidas
-- (Celular 1, Celular 2, Celular 3) na tabela original.
-- Esta query demonstra como recuperar a relação 1:N entre funcionários e contactos.

SELECT 
    f.NUIT,
    f.Nome AS Nome_Funcionario,
    COUNT(ct.ID_Contacto) AS Numero_Contactos,
    GROUP_CONCAT(ct.Numero_Celular ORDER BY ct.Numero_Celular SEPARATOR ', ') AS Contactos_Telefonicos
FROM FUNCIONARIO f
LEFT JOIN CONTACTO_TELEFONICO ct ON f.NUIT = ct.NUIT_Funcionario
GROUP BY f.NUIT, f.Nome
ORDER BY f.Nome;

-- ────────────────────────────────────────────────────────────────────────────────
-- QUERY 4 (Bonus): Funcionários com Informação Completa, Incluindo Filhos e Contactos
-- ────────────────────────────────────────────────────────────────────────────────
-- Objetivo: Demonstração máxima de como reconstituir COMPLETAMENTE a informação
-- original a partir do esquema normalizado.
-- Esta query combina as três anteriores para mostrar que toda a informação original
-- pode ser recuperada através de JOINs.

SELECT 
    f.NUIT,
    f.Nome,
    f.Data_Nasc,
    f.BI,
    f.Email,
    CONCAT(f.Rua_Avenida, ', ', f.Bairro) AS Endereco,
    l.Nome_Cidade,
    p.Nome_Provincia,
    c.Nome_Cargo,
    c.Cod_Cargo,
    func.Nome_Funcao,
    func.Cod_Funcao,
    f.Posto_Trabalho,
    f.Data_Admissao,
    COUNT(DISTINCT fi.ID_Filho) AS Total_Filhos,
    GROUP_CONCAT(DISTINCT fi.Nome_Filho ORDER BY fi.Nome_Filho SEPARATOR '; ') AS Filhos,
    COUNT(DISTINCT ct.ID_Contacto) AS Total_Contactos,
    GROUP_CONCAT(DISTINCT ct.Numero_Celular ORDER BY ct.Numero_Celular SEPARATOR '; ') AS Contactos
FROM FUNCIONARIO f
JOIN CARGO c ON f.Cod_Cargo = c.Cod_Cargo
JOIN FUNCAO func ON c.Cod_Funcao = func.Cod_Funcao
JOIN LOCALIZACAO l ON f.Cod_Cidade = l.Cod_Cidade
JOIN PROVINCIA p ON l.Cod_Provincia = p.Cod_Provincia
LEFT JOIN FILHO fi ON f.NUIT = fi.NUIT_Funcionario
LEFT JOIN CONTACTO_TELEFONICO ct ON f.NUIT = ct.NUIT_Funcionario
GROUP BY f.NUIT, f.Nome, f.Data_Nasc, f.BI, f.Email, f.Rua_Avenida, f.Bairro, 
         l.Nome_Cidade, p.Nome_Provincia, c.Nome_Cargo, c.Cod_Cargo, func.Nome_Funcao, 
         func.Cod_Funcao, f.Posto_Trabalho, f.Data_Admissao
ORDER BY f.Nome;

-- ────────────────────────────────────────────────────────────────────────────────
-- QUERY 5 (Bonus): Distribuição de Funcionários por Cargo e Função
-- ────────────────────────────────────────────────────────────────────────────────
-- Objetivo: Demonstrar análise de dados através da estrutura normalizada.

SELECT 
    func.Nome_Funcao,
    c.Nome_Cargo,
    COUNT(f.NUIT) AS Numero_Funcionarios,
    GROUP_CONCAT(f.Nome ORDER BY f.Nome SEPARATOR ', ') AS Nomes_Funcionarios
FROM FUNCAO func
LEFT JOIN CARGO c ON func.Cod_Funcao = c.Cod_Funcao
LEFT JOIN FUNCIONARIO f ON c.Cod_Cargo = f.Cod_Cargo
GROUP BY func.Cod_Funcao, func.Nome_Funcao, c.Cod_Cargo, c.Nome_Cargo
ORDER BY func.Nome_Funcao, c.Nome_Cargo;

-- ────────────────────────────────────────────────────────────────────────────────
-- QUERY 6 (Bonus): Funcionários por Localização e Província
-- ────────────────────────────────────────────────────────────────────────────────
-- Objetivo: Demonstrar análise de dados por localização.

SELECT 
    p.Nome_Provincia,
    l.Nome_Cidade,
    COUNT(f.NUIT) AS Numero_Funcionarios,
    GROUP_CONCAT(f.Nome ORDER BY f.Nome SEPARATOR ', ') AS Funcionarios
FROM PROVINCIA p
LEFT JOIN LOCALIZACAO l ON p.Cod_Provincia = l.Cod_Provincia
LEFT JOIN FUNCIONARIO f ON l.Cod_Cidade = f.Cod_Cidade
GROUP BY p.Cod_Provincia, p.Nome_Provincia, l.Cod_Cidade, l.Nome_Cidade
ORDER BY p.Nome_Provincia, l.Nome_Cidade;

-- ════════════════════════════════════════════════════════════════════════════════
-- FIM DO SCRIPT SQL
-- ════════════════════════════════════════════════════════════════════════════════
