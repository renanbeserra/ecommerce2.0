-- Banco de Dados ecommerce

create database ecommerce;
use ecommerce;
-- drop database ecommerce;

-- CRIAÇÃO DAS TABELAS

create table PJ(
idPJ int primary key auto_increment,
razaoSocial varchar(45) not null,
cnpj char(14) not null,
constraint U_cnpj_pj unique (cnpj)
);

create table PF(
idPF int primary key auto_increment,
nome varchar(45) not null,
cpf char(11) not null,
rg varchar(45),
constraint U_cpf_pf unique (cpf)
);

create table Cliente(
idCliente int primary key auto_increment,
telefone varchar(45),
endereco varchar(45),
email varchar(45),
pj_idPJ int,
pf_idPF int,
constraint fk_pj_cliente foreign key (pj_idPJ) references PJ (idPJ),
constraint fk_pf_cliente foreign key (pf_idPF) references PF (idPF) 
);

create table Pedido(
idPedido int primary key auto_increment,
statusPedido ENUM('Andamento', 'Processando', 'Enviado', 'Entregue') default 'Andamento',
descricao varchar(45),
frete float,
Cliente_idCliente int not null,
constraint fk_Cliente_Pedido foreign key (Cliente_idCliente) references Cliente (idCliente)
);

CREATE TABLE CartaoCredito (
    idCartao INT PRIMARY KEY AUTO_INCREMENT,
    numeroCartao VARCHAR(20),
    validade DATE,
    cvv VARCHAR(4),
    titular VARCHAR(100),
    bandeira VARCHAR(20),
    limiteCredito DECIMAL(10,2),
    dataEmissao DATE
);

CREATE TABLE Boleto (
    idBoleto INT PRIMARY KEY AUTO_INCREMENT,
    numeroBoleto VARCHAR(50),
    dataVencimento DATE,
    valorBoleto DECIMAL(10 , 2 ),
    statusBoleto VARCHAR(20),
    dataPagamento DATE
);

CREATE TABLE Pix (
    idPix INT PRIMARY KEY AUTO_INCREMENT,
    dataHoraTransacao TIMESTAMP,
    valor DECIMAL(10 , 2 ),
    tipoTransacao VARCHAR(20),
    chaveOrigem VARCHAR(100),
    chaveDestino VARCHAR(100),
    descricao TEXT,
    status VARCHAR(20),
    taxa DECIMAL(10 , 2 )
);

create table Pagamento(
idPagamento int primary key auto_increment,
formaPagamento ENUM('Cartão de Crédito', 'Boleto', 'Pix') default 'Cartão de Crédito',
cartaoCredito_idCartaoCredito int,
boleto_idBoleto int,
pix_idPix int,
constraint fk_cartaoCredito_idCartaoCredito foreign key (cartaoCredito_idCartaoCredito) references cartaoCredito (idCartaoCredito),
constraint fk_boleto_idBoleto foreign key (boleto_idBoleto) references boleto (idBoleto),
constraint fk_pix_idPix foreign key (pix_idPix) references pix (idPix)
);

create table Pedido_has_Pagamento(
pedido_idPedido int not null,
pagamento_idPagamento int not null,
constraint fk_pedido_idPedido foreign key (pedido_idPedido) references pedido (idPedido),
constraint fk_pagamento_idPagamento foreign key (pagamento_idPagamento) references Pagamento (idPagamento)
);

create table Produto(
idProduto int primary key auto_increment,
categoria varchar(45) not null,
decricao varchar(500),
valor float not null
);

create table Pedido_has_Produto(
Pedido_idPedido int not null,
Produto_idProduto int not null,
quantidade int not null,
statusProduto ENUM('Disponível', 'Sem estoque') default 'Disponível'
);

create table Transportadora(
idTransportadora int primary key auto_increment,
CNPJ char(14) not null,
razoSocial varchar(45),
telefone varchar(45),
endereco varchar(45),
email varchar(45)
);

create table Entrega(
idEntrega int primary key auto_increment,
tipo char(14) not null,
statusEntrega ENUM('Saiu para entrega','Endereço não encontrado','Cliente ausente','Entregue', 'Pendente') default 'Pendente',
codigoRastreio varchar(45),
Transportadora_idTransportadora int not null,
Pedido_idPedido int not null,
constraint fk_pedido_entrega foreign key (pedido_idPedido) references pedido (idPedido),
constraint fk_pedido_Transportadora foreign key (Transportadora_idTransportadora) references Transportadora (idTransportadora)
);

create table Estoque(
idEstoque int primary key auto_increment,
localEstoque varchar(45) not null
);

create table Produto_has_Estoque(
Estoque_idEstoque int not null,
Produto_idProduto int not null,
quantidade int not null,
constraint fk_Produto_idProduto foreign key (Produto_idProduto) references Produto (idProduto),
constraint fk_Estoque_idEstoque foreign key (Estoque_idEstoque) references Estoque (idEstoque)
);

create table Fornecedor(
idFornecedor int primary key auto_increment,
CNPJ char(14) not null,
razoSocial varchar(45),
telefone varchar(45),
endereco varchar(45),
email varchar(45)
);

create table Fornecedor_has_Produto(
Fornecedor_idFornecedor int not null,
Produto_idProduto int not null,
dataFornecimento date,
constraint fk_Produto_idProduto_Fornecedor foreign key (Produto_idProduto) references Produto (idProduto),
constraint fk_Fornecedor_idFornecedor_Produto foreign key (Fornecedor_idFornecedor) references Fornecedor (idFornecedor)
);

create table TerceiroVendedor(
idTerceiroVendedor int primary key auto_increment,
CNPJ_CPF char(14) not null,
razoSocial varchar(45) not null,
telefone varchar(45),
endereco varchar(45),
email varchar(45)
);

create table TerceiroVendedor_has_Produto(
TerceiroVendedor_idTerceiroVendedor int not null,
Produto_idProduto int not null,
quantidade int not null,
constraint fk_Produto_idProduto_TerceiroVendedor foreign key (Produto_idProduto) references Produto (idProduto),
constraint fk_TerceiroVendedor_idTerceiroVendedor_Produto foreign key (TerceiroVendedor_idTerceiroVendedor) references TerceiroVendedor (idTerceiroVendedor)
);

-- Verificando com detalhes as constraints criadas no schema ecommerce
-- use information_schema;
-- select * from referential_constraints where constraint_schema = 'ecommerce';


-- INSERÇÃO DE REGISTROS

INSERT INTO PJ (razaoSocial, cnpj)
VALUES
    ('Tech Company Ltda', '12345678901234'),
    ('Moda Chic SA', '98765432109876'),
    ('Alimentos Sabores SA', '45678912309876'),
    ('Construtora Mega Obras Ltda', '78901234567890'),
    ('Farmácia Sempre Bem', '34567890123456'),
    ('Eletrônicos Top', '23456789012345'),
    ('Livraria Virtual', '67890123456789'),
    ('Academia Fitness', '89012345678901'),
    ('Agência de Viagens', '56789012345678'),
    ('Consultoria Empresarial', '12345678901235')
;

INSERT INTO PF (nome, cpf, rg)
VALUES
    ('João da Silva', '12345678901', '123456789'),
    ('Maria Souza', '98765432109', '987654321'),
    ('Pedro Gomes', '45678912309', '456789123'),
    ('Ana Oliveira', '78901234567', '789012345'),
    ('Carlos Pereira', '34567890123', '345678901'),
    ('Fernanda Santos', '23456789012', '234567890'),
    ('Gustavo Lima', '67890123456', '678901234'),
    ('Helena Costa', '89012345678', '890123456'),
    ('Isabela Alves', '56789012345', '567890123'),
    ('Juliana Rodrigues', '12345678909', '123456781')
;

INSERT INTO Cliente (telefone, endereco, email, pj_idPJ, pf_idPF)
VALUES
    ('(11) 91234-5678', 'Rua A, 123', 'joao@email.com', NULL, 1),
    ('(21) 89012-3456', 'Avenida B, 456', 'empresa@email.com', 2, NULL),
    ('(19) 98765-4321', 'Rua C, 789', 'maria@email.com', NULL, 2),
    ('(27) 87654-3210', 'Avenida D, 1011', 'pedro@email.com', NULL, 3),
    ('(41) 76543-2109', 'Rua E, 1213', 'empresa2@email.com', 3, NULL),
    ('(12) 34567-8901', 'Rua F, 1415', 'ana@email.com', NULL, 4),
    ('(16) 23456-7890', 'Avenida G, 1617', 'empresa3@email.com', 4, NULL),
    ('(13) 12345-6789', 'Rua H, 1819', 'carlos@email.com', NULL, 5),
    ('(17) 01234-5678', 'Avenida I, 2021', 'fernanda@email.com', NULL, 6),
    ('(18) 90123-4567', 'Rua J, 2223', 'empresa4@email.com', 5, NULL);
    
    INSERT INTO Pedido (statusPedido, descricao, frete, Cliente_idCliente)
VALUES
    ('Andamento', 'Pedido de livros', 10.99, 1),
    ('Processando', 'Pedido de eletrônicos', 15.00, 2),
    ('Enviado', 'Pedido de roupas', 8.50, 3),
    ('Entregue', 'Pedido de móveis', 50.00, 4),
    ('Andamento', 'Pedido de alimentos', 5.99, 5),
    ('Processando', 'Pedido de cosméticos', 12.99, 6),
    ('Enviado', 'Pedido de brinquedos', 7.00, 7),
    ('Entregue', 'Pedido de calçados', 9.99, 8),
    ('Andamento', 'Pedido de artigos esportivos', 18.00, 9),
    ('Processando', 'Pedido de ferramentas', 25.00, 10);

INSERT INTO Pedido (statusPedido, descricao, frete, Cliente_idCliente)
VALUES
	('Andamento', 'Pedido de livros', 20.99, 1),
    ('Processando', 'Pedido de eletrônicos', 20.00, 2),
    ('Enviado', 'Pedido de roupas', 15.50, 3),
    ('Entregue', 'Pedido de móveis', 90.00, 4),
    ('Andamento', 'Pedido de alimentos', 16.99, 5),
    ('Processando', 'Pedido de cosméticos', 19.99, 6),
    ('Enviado', 'Pedido de brinquedos', 22.00, 7),
    ('Entregue', 'Pedido de calçados', 29.99, 8),
    ('Andamento', 'Pedido de artigos esportivos', 48.00, 9),
    ('Processando', 'Pedido de ferramentas', 35.00, 10);

INSERT INTO Pedido (statusPedido, descricao, frete, Cliente_idCliente)
VALUES
	('Andamento', 'Pedido de livros', 120.99, 1),
    ('Processando', 'Pedido de eletrônicos', 120.00, 2),
    ('Enviado', 'Pedido de roupas', 115.50, 3),
    ('Entregue', 'Pedido de móveis', 190.00, 4),
    ('Andamento', 'Pedido de alimentos', 116.99, 5),
    ('Processando', 'Pedido de cosméticos', 119.99, 6),
    ('Enviado', 'Pedido de brinquedos', 122.00, 7),
    ('Entregue', 'Pedido de calçados', 129.99, 8),
    ('Andamento', 'Pedido de artigos esportivos', 148.00, 9),
    ('Processando', 'Pedido de ferramentas', 135.00, 10);
    
    INSERT INTO CartaoCredito (numeroCartao, dataValidade, Proprietario, cpf_cnpj, bandeira)
VALUES
    ('1234567890123456', '2025-12', 'João da Silva', '12345678901', 'Visa'),
    ('9876543210987654', '2024-09', 'Maria Souza', '98765432109', 'Mastercard'),
    ('4567891230987654', '2023-11', 'Pedro Gomes', '45678912309', 'Elo'),
    ('7890123456789012', '2026-03', 'Ana Oliveira', '78901234567', 'American Express'),
    ('3456789012345678', '2025-07', 'Carlos Pereira', '34567890123', 'Visa'),
    ('2345678901234567', '2024-12', 'Fernanda Santos', '23456789012', 'Mastercard'),
    ('6789012345678901', '2023-05', 'Gustavo Lima', '67890123456', 'Elo'),
    ('8901234567890123', '2026-02', 'Helena Costa', '89012345678', 'American Express'),
    ('5678901234567890', '2025-01', 'Isabela Alves', '56789012345', 'Visa'),
    ('1234567890123451', '2024-10', 'Juliana Rodrigues', '12345678909', 'Mastercard');
    
    INSERT INTO Boleto (descricao)
VALUES
    ('Boleto referente à compra de um celular'),
    ('Pagamento da mensalidade da academia'),
    ('Boleto da fatura do cartão de crédito'),
    ('Pagamento do IPTU'),
    ('Boleto referente à compra de um livro'),
    ('Pagamento da conta de energia elétrica'),
    ('Boleto da mensalidade escolar'),
    ('Pagamento do seguro do carro'),
    ('Boleto referente à compra de uma passagem aérea'),
    ('Pagamento da conta de água');
    
    INSERT INTO Pix (descricao)
VALUES
    ('Pagamento de uma compra online'),
    ('Transferência para um amigo'),
    ('Pagamento de uma conta'),
    ('Recebimento de um serviço'),
    ('Pagamento de um boleto atrasado'),
    ('Divisão de conta em um restaurante'),
    ('Doação para uma instituição'),
    ('Pagamento de uma assinatura'),
    ('Reembolso de uma compra'),
    ('Pagamento de um aluguel');
    
INSERT INTO Pagamento (formaPagamento, cartaoCredito_idCartaoCredito, boleto_idBoleto, pix_idPix)
VALUES
    ('Cartão de Crédito', 1, NULL, NULL),
    ('Boleto', NULL, 2, NULL),
    ('Pix', NULL, NULL, 3),
    ('Cartão de Crédito', 4, NULL, NULL),
    ('Boleto', NULL, 5, NULL),
    ('Pix', NULL, NULL, 6),
    ('Cartão de Crédito', 7, NULL, NULL),
    ('Boleto', NULL, 8, NULL),
    ('Pix', NULL, NULL, 9),
    ('Cartão de Crédito', 10, NULL, NULL);
    
INSERT INTO Pedido_has_Pagamento (pedido_idPedido, pagamento_idPagamento)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);
    
INSERT INTO Produto (categoria, decricao, valor)
VALUES
    ('Eletrônicos', 'Smartphone', 2500.00),
    ('Eletrônicos', 'Notebook', 4000.00),
    ('Vestuário', 'Camiseta', 39.99),
    ('Vestuário', 'Calça Jeans', 120.00),
    ('Alimentos', 'Arroz', 5.99),
    ('Alimentos', 'Feijão', 8.99),
    ('Móveis', 'Sofá', 1500.00),
    ('Móveis', 'Mesa', 500.00),
    ('Beleza', 'Shampoo', 19.99),
    ('Beleza', 'Perfume', 80.00);
    
INSERT INTO Pedido_has_Produto (Pedido_idPedido, Produto_idProduto, quantidade, statusProduto)
VALUES
    (1, 1, 2, 'Disponível'),
    (1, 2, 1, 'Sem estoque'),
    (2, 3, 3, 'Disponível'),
    (2, 4, 1, 'Disponível'),
    (3, 5, 5, 'Disponível'),
    (4, 6, 2, 'Sem estoque'),
    (5, 7, 1, 'Disponível'),
    (6, 8, 4, 'Disponível'),
    (7, 9, 2, 'Disponível'),
    (8, 10, 3, 'Disponível');

INSERT INTO Pedido_has_Produto (Pedido_idPedido, Produto_idProduto, quantidade, statusProduto)
VALUES
    (11, 3, 4, 'Disponível'),
    (12, 2, 1, 'Sem estoque'),
    (13, 3, 3, 'Disponível'),
    (14, 4, 1, 'Disponível'),
    (15, 5, 5, 'Disponível'),
    (16, 6, 2, 'Sem estoque'),
    (17, 7, 1, 'Disponível'),
    (18, 8, 4, 'Disponível'),
    (19, 9, 2, 'Disponível'),
    (20, 10, 3, 'Disponível');
    
INSERT INTO Transportadora (CNPJ, razoSocial, telefone, endereco, email) VALUES 
('12345678000101', 'Translog Transportes', '(11) 98765-4321', 'Rua das Flores, 123', 'contato@translog.com.br'),
('23456789000112', 'Rápido Entrega', '(21) 91234-5678', 'Av. Paulista, 456', 'suporte@rapidoentrega.com.br'),
('34567890000123', 'Via Veloz', '(31) 92345-6789', 'Rua do Comércio, 789', 'atendimento@viaveloz.com.br'),
('45678901000134', 'Expresso Sul', '(41) 93456-7890', 'Rua das Árvores, 321', 'info@expressosul.com.br'),
('56789012000145', 'NorteTrans', '(51) 94567-8901', 'Av. Central, 654', 'nortetrans@norte.com.br'),
('67890123000156', 'Transportadora Alfa', '(61) 95678-9012', 'Rua das Palmeiras, 987', 'alfa@transportadora.com.br'),
('78901234000167', 'Logística Beta', '(71) 96789-0123', 'Av. dos Expedicionários, 159', 'contato@logisticabeta.com.br'),
('89012345000178', 'Cargas Rápidas', '(81) 97890-1234', 'Rua São João, 753', 'cargas@rapidas.com.br'),
('90123456000189', 'Fretes Brasil', '(91) 98901-2345', 'Av. Rio Branco, 852', 'fretes@brasil.com.br'),
('01234567000190', 'Entregas Expressas', '(85) 99012-3456', 'Rua das Pedras, 147', 'expressas@entregas.com.br');

INSERT INTO Entrega (tipo, statusEntrega, codigoRastreio, Transportadora_idTransportadora, Pedido_idPedido) VALUES 
('Normal', 'Saiu para entrega', 'BR1234567890', 1, 1),
('Expressa', 'Entregue', 'BR0987654321', 2, 2),
('Normal', 'Cliente ausente', 'BR1122334455', 3, 3),
('Expressa', 'Endereço não encontrado', 'BR2233445566', 4, 4),
('Normal', 'Saiu para entrega', 'BR3344556677', 5, 5),
('Prioritária', 'Entregue', 'BR4455667788', 6, 6),
('Normal', 'Pendente', 'BR5566778899', 7, 7),
('Expressa', 'Saiu para entrega', 'BR6677889900', 8, 8),
('Prioritária', 'Cliente ausente', 'BR7788990011', 9, 9),
('Normal', 'Endereço não encontrado', 'BR8899001122', 10, 10);

INSERT INTO Estoque (localEstoque) VALUES 
('Centro de Distribuição - São Paulo'),
('Armazém Regional - Rio de Janeiro'),
('Depósito Norte - Manaus'),
('Centro de Logística - Curitiba'),
('Armazém Nordeste - Recife'),
('Depósito Central - Brasília'),
('Centro de Distribuição - Belo Horizonte'),
('Armazém Sul - Porto Alegre'),
('Depósito Leste - Fortaleza'),
('Centro de Logística - Salvador');

INSERT INTO Produto_has_Estoque (Estoque_idEstoque, Produto_idProduto, quantidade) VALUES 
(1, 1, 150),
(2, 2, 200),
(3, 3, 120),
(4, 4, 180),
(5, 5, 300),
(6, 6, 250),
(7, 7, 400),
(8, 8, 90),
(9, 9, 350),
(10, 10, 100);

INSERT INTO Fornecedor (CNPJ, razoSocial, telefone, endereco, email) VALUES 
('11223344000156', 'Fornecedor ABC', '(11) 91234-5678', 'Rua das Amoras, 100', 'contato@fornecedorabc.com.br'),
('22334455000167', 'Distribuidora XYZ', '(21) 93456-7890', 'Avenida Brasil, 200', 'vendas@distribuidoraxyz.com.br'),
('33445566000178', 'Comercial Delta', '(31) 95678-9012', 'Travessa das Flores, 300', 'delta@comercialdelta.com.br'),
('44556677000189', 'Fornecedor Epsilon', '(41) 97890-1234', 'Rua do Comércio, 400', 'atendimento@epsilonsupply.com.br'),
('55667788000190', 'Grupo Omega', '(51) 99012-3456', 'Alameda Santos, 500', 'suporte@grupoomega.com.br'),
('66778899000101', 'Indústria Lambda', '(61) 91123-4567', 'Avenida Central, 600', 'ind.lambda@industria.com.br'),
('77889900000112', 'Fornecedora Kappa', '(71) 92234-5678', 'Rua da Paz, 700', 'kappa@fornecedora.com.br'),
('88990011000123', 'Importadora Sigma', '(81) 93345-6789', 'Praça da Liberdade, 800', 'contato@importadorasigma.com.br'),
('99001122000134', 'Empresa Theta', '(91) 94456-7890', 'Avenida Independência, 900', 'theta@empresatheta.com.br'),
('10111233000145', 'Comércio Zeta', '(85) 95567-8901', 'Rua dos Trilhos, 1000', 'zeta@comerciozeta.com.br');

INSERT INTO Fornecedor_has_Produto (Fornecedor_idFornecedor, Produto_idProduto, dataFornecimento) VALUES 
(1, 1, '2024-01-15'),
(2, 2, '2024-02-20'),
(3, 3, '2024-03-05'),
(4, 4, '2024-03-18'),
(5, 5, '2024-04-12'),
(6, 6, '2024-05-30'),
(7, 7, '2024-06-10'),
(8, 8, '2024-07-22'),
(9, 9, '2024-08-15'),
(10, 10, '2024-09-05');

INSERT INTO TerceiroVendedor (CNPJ_CPF, razoSocial, telefone, endereco, email) VALUES 
('12345678000101', 'Vendas Rápidas Ltda', '(11) 91234-5678', 'Rua das Palmeiras, 100', 'contato@vendasrapidas.com.br'),
('23456789000112', 'Comércio XYZ', '(21) 92345-6789', 'Avenida Brasil, 200', 'suporte@comercioxyz.com.br'),
('34567890000123', 'Distribuidora Alfa', '(31) 93456-7890', 'Rua do Comércio, 300', 'alfa@distribuidoralf.com.br'),
('45678901000134', 'Mercado Digital', '(41) 94567-8901', 'Avenida Central, 400', 'contato@mercadodigital.com.br'),
('56789012000145', 'Shop Online Beta', '(51) 95678-9012', 'Rua das Flores, 500', 'beta@shoponline.com.br'),
('67890123000156', 'Venda Fácil Ltda', '(61) 96789-0123', 'Avenida Paulista, 600', 'contato@vendafacil.com.br'),
('78901234000167', 'E-commerce Gama', '(71) 97890-1234', 'Rua das Oliveiras, 700', 'gama@ecommerce.com.br'),
('89012345000178', 'Distribuidora Delta', '(81) 98901-2345', 'Praça das Nações, 800', 'delta@distribuidoradelta.com.br'),
('90123456000189', 'Loja Virtual Ômega', '(91) 99012-3456', 'Alameda Santos, 900', 'omega@lojavirtual.com.br'),
('01234567000190', 'Vendas e Cia', '(85) 91123-4567', 'Rua do Porto, 1000', 'contato@vendasecia.com.br');

INSERT INTO TerceiroVendedor_has_Produto (TerceiroVendedor_idTerceiroVendedor, Produto_idProduto, quantidade) VALUES 
(1, 1, 50),
(2, 2, 100),
(3, 3, 75),
(4, 4, 200),
(5, 5, 60),
(6, 6, 150),
(7, 7, 80),
(8, 8, 120),
(9, 9, 90),
(10, 10, 110);


-- CONSULTAS

-- (Recuperações simples com SELECT Statement)
-- Clientes 
select * from cliente;
select * from pedido;

-- (Filtros com WHERE Statement)
-- Todos os cliente PF e PJ 
select * from cliente c, pf, pj where c.pf_idpf = pf.idpf or c.pj_idpj = pj.idpj;

-- (Filtros com WHERE Statement)
-- Clientes que são PF
select nome from cliente c, PF where c.pf_idpf = pf.idpf;

-- (Filtros com WHERE Statement) (Defina ordenações dos dados com ORDER BY)
-- Clientes que são PJ em ordem alfabética ascedente 
select razaosocial from cliente c, PJ where c.pj_idpj = pj.idpj order by pj.razaosocial asc;

-- Crie expressões para gerar atributos derivados
-- Valor total dos produtos vendidos
select pr.decricao, pr.valor, pp.quantidade, (pr.valor * pp.quantidade) as TOTAL from produto pr
inner join pedido_has_produto pp on pp.produto_idproduto = pr.idproduto
inner join pedido pe on pp.pedido_idpedido = pe.idpedido;

-- (Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados)
-- Clientes PF que fizeram pedidos de produtos
select idCliente, pf.nome, pe.statusPedido, pr.decricao, pp.quantidade, pr.valor, pe.frete from cliente c inner 
join pedido pe on c.idCliente = pe.cliente_idCliente 
inner join pf on c.pf_idpf = pf.idpf 
inner join pedido_has_produto pp on idPedido = pp.Pedido_idPedido
inner join produto pr on pr.idProduto = pp.produto_idProduto;

-- (Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados)
-- (Condições de filtros aos grupos – HAVING Statement)
-- Total de frete gastos em pedidos agrupado por clientes PJ
select pj.razaosocial, sum(pe.frete) from pedido pe
inner join cliente c on pe.cliente_idcliente = c.idcliente
inner join pj on c.pj_idpj = pj.idpj
group by pj.razaosocial 
having sum(frete) > 150;

