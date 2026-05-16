-- ============================================================
--  CarGood - Sistema de Gestão de Vendas de Veículos
--  Banco de Dados: SQL Server
-- ============================================================

CREATE DATABASE CarGood;
GO

USE CarGood;
GO

-- ============================================================
-- TABELAS
-- ============================================================

-- Marcas
CREATE TABLE Marcas (
    MarcaID   INT PRIMARY KEY IDENTITY,
    Nome      VARCHAR(50) NOT NULL UNIQUE
);

-- Modelos
CREATE TABLE Modelos (
    ModeloID  INT PRIMARY KEY IDENTITY,
    Nome      VARCHAR(50) NOT NULL,
    MarcaID   INT NOT NULL,
    FOREIGN KEY (MarcaID) REFERENCES Marcas(MarcaID)
);

-- Carros em estoque
CREATE TABLE Carros (
    CarroID        INT PRIMARY KEY IDENTITY,
    ModeloID       INT NOT NULL,
    AnoFabricacao  INT          CHECK (AnoFabricacao >= 1980),
    KM_Rodados     INT          CHECK (KM_Rodados >= 0),
    Valor          DECIMAL(10,2) CHECK (Valor > 0),
    Cor            VARCHAR(30),
    Combustivel    VARCHAR(20),
    Portas         INT          CHECK (Portas IN (2, 4)),
    Transmissao    VARCHAR(20),
    Status         VARCHAR(20)  DEFAULT 'Disponível',
    FOREIGN KEY (ModeloID) REFERENCES Modelos(ModeloID)
);

-- Clientes
CREATE TABLE Clientes (
    ClienteID  INT PRIMARY KEY IDENTITY,
    Nome       VARCHAR(100) NOT NULL,
    CPF        VARCHAR(14)  UNIQUE,
    Email      VARCHAR(100) UNIQUE,
    Telefone   VARCHAR(20),
    Endereco   VARCHAR(100),
    Cidade     VARCHAR(50),
    Estado     VARCHAR(50)
);

-- Vendedores
CREATE TABLE Vendedores (
    VendedorID  INT PRIMARY KEY IDENTITY,
    Nome        VARCHAR(100) NOT NULL
);

-- Vendas
CREATE TABLE Vendas (
    VendaID        INT PRIMARY KEY IDENTITY,
    ClienteID      INT NOT NULL,
    CarroID        INT NOT NULL,
    VendedorID     INT NOT NULL,
    ValorPago      DECIMAL(10,2),
    DataCompra     DATETIME DEFAULT GETDATE(),
    FormaPagamento VARCHAR(30),
    FOREIGN KEY (ClienteID)  REFERENCES Clientes(ClienteID),
    FOREIGN KEY (CarroID)    REFERENCES Carros(CarroID),
    FOREIGN KEY (VendedorID) REFERENCES Vendedores(VendedorID)
);

-- Log de Auditoria de Vendas
CREATE TABLE LogVendas (
    LogID       INT PRIMARY KEY IDENTITY,
    CarroID     INT,
    DataEvento  DATETIME DEFAULT GETDATE(),
    Acao        VARCHAR(50),
    Detalhes    VARCHAR(255)
);

-- ============================================================
-- ÍNDICES
-- ============================================================

CREATE INDEX IDX_Carro_Status  ON Carros(Status);
CREATE INDEX IDX_Vendas_Data   ON Vendas(DataCompra);

-- ============================================================
-- INSERÇÃO DE DADOS
-- ============================================================

-- Marcas
INSERT INTO Marcas (Nome) VALUES
('Toyota'), ('Honda'), ('Ford'), ('Chevrolet'), ('Volkswagen');

-- Modelos
INSERT INTO Modelos (Nome, MarcaID) VALUES
('Corolla', 1), ('Hilux', 1),   ('Yaris', 1),
('Civic', 2),   ('City', 2),    ('HR-V', 2),
('Ka', 3),      ('Ranger', 3),  ('EcoSport', 3),
('Onix', 4),    ('Tracker', 4), ('S10', 4),
('Gol', 5),     ('Polo', 5),    ('Virtus', 5),
('Jetta', 5),   ('T-Cross', 5),
('Camry', 1),   ('Accord', 2),  ('Fusion', 3);

-- Carros
INSERT INTO Carros (ModeloID, AnoFabricacao, KM_Rodados, Valor, Cor, Combustivel, Portas, Transmissao, Status) VALUES
(1,  2020, 45000,  95000,  'Prata',    'Flex',     4, 'Automática', 'Disponível'),
(2,  2022, 20000, 180000,  'Preto',    'Diesel',   4, 'Automática', 'Disponível'),
(3,  2021, 30000,  75000,  'Branco',   'Flex',     4, 'Manual',     'Disponível'),
(4,  2019, 60000,  85000,  'Cinza',    'Gasolina', 4, 'Automática', 'Disponível'),
(5,  2020, 40000,  70000,  'Vermelho', 'Flex',     4, 'Manual',     'Disponível'),
(6,  2023, 15000, 120000,  'Azul',     'Flex',     4, 'Automática', 'Disponível'),
(7,  2018, 80000,  40000,  'Preto',    'Flex',     4, 'Manual',     'Disponível'),
(8,  2022, 25000, 160000,  'Prata',    'Diesel',   4, 'Automática', 'Disponível'),
(9,  2021, 35000,  90000,  'Branco',   'Flex',     4, 'Manual',     'Disponível'),
(10, 2023, 10000,  85000,  'Cinza',    'Flex',     4, 'Automática', 'Disponível'),
(11, 2022, 20000, 110000,  'Preto',    'Flex',     4, 'Automática', 'Disponível'),
(12, 2020, 50000, 130000,  'Branco',   'Diesel',   4, 'Manual',     'Disponível'),
(13, 2017, 90000,  35000,  'Prata',    'Flex',     4, 'Manual',     'Disponível'),
(14, 2021, 30000,  80000,  'Azul',     'Flex',     4, 'Automática', 'Disponível'),
(15, 2023,  5000,  95000,  'Vermelho', 'Flex',     4, 'Automática', 'Disponível'),
(16, 2022, 15000, 140000,  'Preto',    'Gasolina', 4, 'Automática', 'Disponível'),
(17, 2023,  8000, 125000,  'Cinza',    'Flex',     4, 'Automática', 'Disponível'),
(18, 2021, 25000, 150000,  'Prata',    'Gasolina', 4, 'Automática', 'Disponível'),
(19, 2020, 45000, 135000,  'Branco',   'Gasolina', 4, 'Automática', 'Disponível'),
(20, 2022, 20000, 145000,  'Preto',    'Gasolina', 4, 'Automática', 'Disponível');

-- Clientes
INSERT INTO Clientes (Nome, CPF, Email, Telefone, Endereco, Cidade, Estado) VALUES
('João Silva',       '111.111.111-11', 'joao@email.com',      '11999990001', 'Rua A, 10',  'São Paulo',    'SP'),
('Maria Souza',      '222.222.222-22', 'maria@email.com',     '11999990002', 'Rua B, 20',  'Campinas',     'SP'),
('Carlos Lima',      '333.333.333-33', 'carlos@email.com',    '11999990003', 'Rua C, 30',  'Santos',       'SP'),
('Ana Paula',        '444.444.444-44', 'ana@email.com',       '11999990004', 'Rua D, 40',  'São Paulo',    'SP'),
('Pedro Santos',     '555.555.555-55', 'pedro@email.com',     '11999990005', 'Rua E, 50',  'Osasco',       'SP'),
('Lucas Alves',      '666.666.666-66', 'lucas@email.com',     '11999990006', 'Rua F, 60',  'Guarulhos',    'SP'),
('Fernanda Rocha',   '777.777.777-77', 'fernanda@email.com',  '11999990007', 'Rua G, 70',  'Santo André',  'SP'),
('Bruno Costa',      '888.888.888-88', 'bruno@email.com',     '11999990008', 'Rua H, 80',  'São Bernardo', 'SP'),
('Juliana Martins',  '999.999.999-99', 'juliana@email.com',   '11999990009', 'Rua I, 90',  'Diadema',      'SP'),
('Rafael Mendes',    '101.101.101-10', 'rafael@email.com',    '11999990010', 'Rua J, 100', 'Barueri',      'SP'),
('Camila Freitas',   '202.202.202-20', 'camila@email.com',    '11999990011', 'Rua K, 110', 'São Paulo',    'SP'),
('Ricardo Gomes',    '303.303.303-30', 'ricardo@email.com',   '11999990012', 'Rua L, 120', 'Campinas',     'SP'),
('Patricia Lima',    '404.404.404-40', 'patricia@email.com',  '11999990013', 'Rua M, 130', 'Santos',       'SP'),
('Eduardo Nunes',    '505.505.505-50', 'eduardo@email.com',   '11999990014', 'Rua N, 140', 'Osasco',       'SP'),
('Vanessa Oliveira', '606.606.606-60', 'vanessa@email.com',   '11999990015', 'Rua O, 150', 'Guarulhos',    'SP'),
('Thiago Ribeiro',   '707.707.707-70', 'thiago@email.com',    '11999990016', 'Rua P, 160', 'São Paulo',    'SP'),
('Aline Cardoso',    '808.808.808-80', 'aline@email.com',     '11999990017', 'Rua Q, 170', 'Campinas',     'SP'),
('Gabriel Duarte',   '909.909.909-90', 'gabriel@email.com',   '11999990018', 'Rua R, 180', 'Santos',       'SP'),
('Larissa Teixeira', '123.123.123-12', 'larissa@email.com',   '11999990019', 'Rua S, 190', 'São Paulo',    'SP'),
('Marcos Vinicius',  '321.321.321-21', 'marcos@email.com',    '11999990020', 'Rua T, 200', 'Osasco',       'SP');

-- Vendedores
INSERT INTO Vendedores (Nome) VALUES
('Carlos Mendes'),   ('Fernanda Rocha'),  ('João Silva'),
('Maria Oliveira'),  ('Ricardo Alves'),   ('Juliana Martins'),
('Paulo Henrique'),  ('Ana Beatriz'),     ('Marcos Vinicius'),
('Camila Rocha'),    ('Felipe Santos'),   ('Larissa Costa'),
('Gabriel Mendes'),  ('Patrícia Gomes'),  ('Thiago Ferreira'),
('Vanessa Lima'),    ('Bruno Cardoso'),   ('Carolina Dias'),
('Eduardo Ramos'),   ('Sofia Almeida');

-- Vendas
INSERT INTO Vendas (ClienteID, CarroID, VendedorID, ValorPago, FormaPagamento) VALUES
(1,  1,  1,  95000, 'À vista'),
(2,  2,  2,  180000,'Financiamento'),
(3,  3,  3,  75000, 'Cartão'),
(4,  4,  4,  85000, 'À vista'),
(5,  5,  5,  70000, 'Financiamento'),
(6,  6,  6,  120000,'Cartão'),
(7,  7,  7,  40000, 'À vista'),
(8,  8,  8,  160000,'Financiamento'),
(9,  9,  9,  90000, 'Cartão'),
(10, 10, 10, 85000, 'À vista'),
(11, 11, 11, 110000,'Financiamento'),
(12, 12, 12, 130000,'Cartão'),
(13, 13, 13, 35000, 'À vista'),
(14, 14, 14, 80000, 'Financiamento'),
(15, 15, 15, 95000, 'Cartão'),
(16, 16, 16, 140000,'À vista'),
(17, 17, 17, 125000,'Financiamento'),
(18, 18, 18, 150000,'À vista'),
(19, 19, 19, 135000,'Cartão'),
(20, 20, 20, 145000,'Financiamento');

-- ============================================================
-- TRIGGER — Validação e Auditoria de Venda
-- ============================================================
-- Responsabilidade: bloquear venda de carro já vendido,
-- atualizar o status do carro e registrar no log de auditoria.
-- Nota: a stored procedure sp_VenderCarro também atualiza o
-- status — use uma das duas abordagens; ambas estão aqui para
-- fins didáticos.
-- ============================================================

CREATE TRIGGER trg_VendaCarro_Avancado
ON Vendas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Bloquear venda de carro já vendido
    IF EXISTS (
        SELECT 1
        FROM Carros C
        JOIN inserted I ON I.CarroID = C.CarroID
        WHERE C.Status = 'Vendido'
    )
    BEGIN
        RAISERROR('ERRO: Um ou mais carros já foram vendidos!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- 2. Atualizar status dos carros para 'Vendido'
    UPDATE C
    SET Status = 'Vendido'
    FROM Carros C
    JOIN inserted I ON I.CarroID = C.CarroID;

    -- 3. Registrar auditoria no log
    INSERT INTO LogVendas (CarroID, Acao, Detalhes)
    SELECT
        I.CarroID,
        'VENDA_REALIZADA',
        CONCAT('Venda registrada em ', CONVERT(VARCHAR, GETDATE(), 103))
    FROM inserted I;
END;
GO

-- ============================================================
-- STORED PROCEDURE — Registrar venda com validação
-- ============================================================
-- Alternativa ao INSERT direto em Vendas; útil para sistemas
-- que não utilizam o trigger acima.
-- ============================================================

CREATE PROCEDURE sp_VenderCarro
    @ClienteID     INT,
    @CarroID       INT,
    @VendedorID    INT,
    @Valor         DECIMAL(10,2),
    @FormaPagamento VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM Carros
        WHERE CarroID = @CarroID AND Status = 'Vendido'
    )
    BEGIN
        RAISERROR('ERRO: Carro já foi vendido!', 16, 1);
        RETURN;
    END

    INSERT INTO Vendas (ClienteID, CarroID, VendedorID, ValorPago, FormaPagamento)
    VALUES (@ClienteID, @CarroID, @VendedorID, @Valor, @FormaPagamento);

    UPDATE Carros
    SET Status = 'Vendido'
    WHERE CarroID = @CarroID;
END;
GO

-- ============================================================
-- STORED PROCEDURE — Simulador de Financiamento (Price)
-- ============================================================

CREATE PROCEDURE sp_SimularFinanciamento
    @ValorVeiculo    DECIMAL(10,2),
    @Entrada         DECIMAL(10,2),
    @TaxaJurosMensal DECIMAL(5,2),
    @QtdParcelas     INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Saldo       DECIMAL(10,2)  = @ValorVeiculo - @Entrada;
    DECLARE @Taxa        DECIMAL(10,6)  = @TaxaJurosMensal / 100.0;
    DECLARE @Parcela     DECIMAL(10,2);
    DECLARE @Mes         INT = 1;
    DECLARE @Juros       DECIMAL(10,2);
    DECLARE @Amortizacao DECIMAL(10,2);

    SET @Parcela =
        @Saldo *
        (@Taxa * POWER(1 + @Taxa, @QtdParcelas)) /
        (POWER(1 + @Taxa, @QtdParcelas) - 1);

    CREATE TABLE #Parcelas (
        Parcela       INT,
        ValorParcela  DECIMAL(10,2),
        Juros         DECIMAL(10,2),
        Amortizacao   DECIMAL(10,2),
        SaldoDevedor  DECIMAL(10,2)
    );

    WHILE @Mes <= @QtdParcelas
    BEGIN
        SET @Juros       = @Saldo * @Taxa;
        SET @Amortizacao = @Parcela - @Juros;
        SET @Saldo       = @Saldo - @Amortizacao;

        INSERT INTO #Parcelas VALUES (@Mes, @Parcela, @Juros, @Amortizacao, @Saldo);
        SET @Mes += 1;
    END

    SELECT * FROM #Parcelas;
END;
GO

-- ============================================================
-- VIEWS
-- ============================================================

-- Detalhe completo de cada venda
CREATE VIEW vw_VendasDetalhadas AS
SELECT
    V.VendaID,
    C.Nome          AS Cliente,
    VD.Nome         AS Vendedor,
    MA.Nome         AS Marca,
    M.Nome          AS Modelo,
    CA.AnoFabricacao,
    CA.KM_Rodados,
    V.ValorPago,
    V.FormaPagamento,
    V.DataCompra
FROM Vendas V
JOIN Clientes  C  ON C.ClienteID  = V.ClienteID
JOIN Vendedores VD ON VD.VendedorID = V.VendedorID
JOIN Carros    CA ON CA.CarroID   = V.CarroID
JOIN Modelos   M  ON M.ModeloID   = CA.ModeloID
JOIN Marcas    MA ON MA.MarcaID   = M.MarcaID;
GO

-- Faturamento mensal
CREATE VIEW vw_FaturamentoMensal AS
SELECT
    YEAR(DataCompra)  AS Ano,
    MONTH(DataCompra) AS Mes,
    COUNT(*)          AS TotalVendas,
    SUM(ValorPago)    AS TotalFaturado,
    AVG(ValorPago)    AS TicketMedio
FROM Vendas
GROUP BY YEAR(DataCompra), MONTH(DataCompra);
GO

-- ============================================================
-- QUERIES ANALÍTICAS
-- ============================================================

-- 1. Carros disponíveis em estoque
SELECT
    CA.CarroID,
    MA.Nome  AS Marca,
    M.Nome   AS Modelo,
    CA.AnoFabricacao,
    CA.KM_Rodados,
    CA.Valor,
    CA.Cor,
    CA.Combustivel,
    CA.Transmissao
FROM Carros CA
JOIN Modelos M  ON M.ModeloID = CA.ModeloID
JOIN Marcas  MA ON MA.MarcaID = M.MarcaID
WHERE CA.Status = 'Disponível'
ORDER BY CA.Valor;

-- 2. Ranking de vendedores por volume de vendas
SELECT
    VD.Nome        AS Vendedor,
    COUNT(*)       AS TotalVendas,
    SUM(V.ValorPago) AS Faturamento
FROM Vendas V
JOIN Vendedores VD ON VD.VendedorID = V.VendedorID
GROUP BY VD.Nome
ORDER BY TotalVendas DESC;

-- 3. Top clientes por número de compras
SELECT
    C.Nome,
    COUNT(*)         AS TotalCompras,
    SUM(V.ValorPago) AS TotalGasto
FROM Vendas V
JOIN Clientes C ON C.ClienteID = V.ClienteID
GROUP BY C.Nome
ORDER BY TotalCompras DESC;

-- 4. Ticket médio e faturamento por marca
SELECT
    MA.Nome          AS Marca,
    COUNT(*)         AS Vendas,
    AVG(V.ValorPago) AS TicketMedio,
    SUM(V.ValorPago) AS Faturamento
FROM Vendas V
JOIN Carros  CA ON CA.CarroID  = V.CarroID
JOIN Modelos M  ON M.ModeloID  = CA.ModeloID
JOIN Marcas  MA ON MA.MarcaID  = M.MarcaID
GROUP BY MA.Nome
ORDER BY Faturamento DESC;

-- 5. Carros disponíveis há mais tempo (possível encalhe)
SELECT
    CA.CarroID,
    MA.Nome AS Marca,
    M.Nome  AS Modelo,
    CA.AnoFabricacao,
    CA.Valor
FROM Carros CA
JOIN Modelos M  ON M.ModeloID = CA.ModeloID
JOIN Marcas  MA ON MA.MarcaID = M.MarcaID
WHERE CA.Status = 'Disponível'
ORDER BY CA.AnoFabricacao ASC;

-- 6. Distribuição de vendas por forma de pagamento
SELECT
    FormaPagamento,
    COUNT(*)         AS Quantidade,
    SUM(ValorPago)   AS Total
FROM Vendas
GROUP BY FormaPagamento
ORDER BY Total DESC;
