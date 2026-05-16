🚗 CarGood — Sistema de Gestão de Vendas de Veículos
Projeto de banco de dados relacional desenvolvido em SQL Server, simulando o back-end de uma concessionária de veículos usados. O sistema contempla cadastro de estoque, clientes, vendedores e vendas, com regras de negócio implementadas via triggers, stored procedures e views analíticas.

📌 Funcionalidades

Cadastro de marcas, modelos e veículos em estoque
Cadastro de clientes e vendedores
Registro de vendas com controle de status do veículo
Bloqueio automático de venda duplicada via trigger
Auditoria de operações em tabela de log
Simulador de financiamento pela Tabela Price (juros compostos)
Views para análise de faturamento mensal e detalhe de vendas
Queries analíticas: ranking de vendedores, ticket médio por marca, carros em encalhe e distribuição por forma de pagamento


🗂️ Estrutura do Banco
Marcas
  └── Modelos
        └── Carros
              └── Vendas ──── Clientes
                         └── Vendedores
                         └── LogVendas (auditoria)
TabelaDescriçãoMarcasFabricantes (Toyota, Honda, Ford…)ModelosModelos por marca (Corolla, Civic, Onix…)CarrosEstoque com status Disponível / VendidoClientesDados dos compradoresVendedoresEquipe de vendasVendasRegistro de cada transaçãoLogVendasAuditoria automática gerada pelo trigger

⚙️ Objetos de Banco
Trigger — trg_VendaCarro_Avancado
Executado automaticamente após cada INSERT em Vendas. Realiza três ações em sequência:

Bloqueia a transação se o carro já estiver com status 'Vendido'
Atualiza o status do carro para 'Vendido'
Registra o evento no LogVendas

Stored Procedure — sp_VenderCarro
Alternativa ao INSERT direto para sistemas que preferem controlar o fluxo via procedure. Valida disponibilidade, registra a venda e atualiza o status.

Nota de design: o trigger e a procedure cobrem a mesma regra de negócio. Em produção, escolha apenas uma das abordagens para evitar duplicidade.

Stored Procedure — sp_SimularFinanciamento
Calcula o plano de pagamento completo (Tabela Price) dado:

Valor do veículo
Valor de entrada
Taxa de juros mensal
Quantidade de parcelas

Retorna uma tabela com parcela, juros, amortização e saldo devedor mês a mês.
Exemplo de uso:
sqlEXEC sp_SimularFinanciamento
    @ValorVeiculo    = 95000,
    @Entrada         = 20000,
    @TaxaJurosMensal = 1.5,
    @QtdParcelas     = 48;
Views
ViewDescriçãovw_VendasDetalhadasJunta venda, cliente, vendedor, marca e modelovw_FaturamentoMensalTotal vendido, quantidade e ticket médio por mês

📊 Queries Analíticas
O script inclui 6 consultas prontas para análise gerencial:

Estoque disponível — carros ordenados por valor
Ranking de vendedores — por volume e faturamento
Top clientes — por número de compras e valor gasto
Faturamento por marca — ticket médio e total
Possíveis encalhes — carros mais antigos ainda disponíveis
Formas de pagamento — distribuição entre à vista, cartão e financiamento


🚀 Como executar
Pré-requisitos

SQL Server 2016 ou superior (ou Azure SQL Database)
SQL Server Management Studio (SSMS) ou Azure Data Studio

Passos
sql-- 1. Abra o arquivo cargood.sql no SSMS
-- 2. Execute o script completo (F5)
-- 3. O banco CarGood será criado automaticamente

O script é idempotente por seção — rode em um banco novo para evitar conflitos.


🗺️ Diagrama ER
Recomenda-se visualizar o modelo no dbdiagram.io usando a estrutura abaixo:
Table Marcas { MarcaID int [pk] / Nome varchar }
Table Modelos { ModeloID int [pk] / Nome varchar / MarcaID int [ref: > Marcas.MarcaID] }
Table Carros { CarroID int [pk] / ModeloID int [ref: > Modelos.ModeloID] / ... / Status varchar }
Table Clientes { ClienteID int [pk] / Nome varchar / CPF varchar / Email varchar }
Table Vendedores { VendedorID int [pk] / Nome varchar }
Table Vendas { VendaID int [pk] / ClienteID int [ref: > Clientes.ClienteID] / CarroID int [ref: > Carros.CarroID] / VendedorID int [ref: > Vendedores.VendedorID] }
Table LogVendas { LogID int [pk] / CarroID int / Acao varchar / DataEvento datetime }

🛠️ Tecnologias

SQL Server — banco relacional principal
T-SQL — linguagem de consulta e programação
Conceitos aplicados: DDL, DML, constraints, índices, triggers, stored procedures, views, tabela temporária, auditoria


📁 Estrutura de arquivos
cargood/
├── cargood.sql       # Script completo (DDL + DML + objetos + queries)
└── README.md         # Documentação do projeto

👤 Autor : Bruno Guida Nascimento

Desenvolvido como projeto de portfólio para demonstração de habilidades em banco de dados relacional com SQL Server.
