USE master
--DROP DATABASE Exercicio7
CREATE DATABASE Exercicio7
GO
USE Exercicio7


CREATE TABLE Cliente(								
RG			CHAR(9)		NOT NULL,
CPF			CHAR(11)	NOT NULL,
Nome		VARCHAR(50) NOT NULL,
Logradouro	VARCHAR(30)	NOT NULL,
Numero		INT			NOT NULL
PRIMARY KEY (RG)
)
GO

INSERT INTO Cliente	VALUES
('29531844',	'34519878040',	'Luiz André',	'R. Astorga',		500),
('13514996x',	'84984285630',	'Maria Luiza',	'R. Piauí',			174),
('121985541',	'23354997310',	'Ana Barbara',	'Av. Jaceguai',		1141),
('23987746x',	'43587669920',	'Marcos Alberto',	'R. Quinze',	22)

CREATE TABLE Fornecedor(																		
Codigo			INT				NOT NULL,	
Nome			VARCHAR(50)		NOT NULL,
Logradouro		VARCHAR(30)		NOT NULL,
Numero			INT			    NULL,	
Pais			CHAR(04)		NOT NULL,
Area			INT				NOT NULL,
Telefone		CHAR(10)		NULL,
CNPJ			CHAR(14)		NULL,
Cidade			VARCHAR(30)		NULL,
Transporte		VARCHAR(15)		NULL,
Moeda			CHAR(5)			NOT NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Fornecedor VALUES
(1,	'Clone',		'Av. Nações Unidas, 12000',	12000,	'BR',	55,	'1141487000',		NULL,			  'São Paulo',   NULL,	    'R$'),
(2,	'Logitech',		'28th Street, 100',			100,	'USA',	1,	'2127695100',		NULL,			  NULL,		    'Avião',	'US$'),
(3,	'LG',			'Rod. Castello Branco',		NULL,	'BR',	55,	'800664400',		'4159978100001',  'Sorocaba',	 NULL,	     'R$'),
(4,	'PcChips',		'Ponte da Amizade',			NULL,	'PY',	595, NULL,				NULL,			  NULL,	        'Navio',	'US$')

CREATE TABLE Mercadoria(								
Codigo				INT			 NOT NULL,
Descricao			VARCHAR(50)  NOT NULL,
Preco				DECIMAL(7,2) NOT NULL,
Qtd					INT			 NOT NULL,
Cod_Fornecedor		INT			 NOT NULL
PRIMARY KEY (Codigo)
FOREIGN KEY (Cod_Fornecedor) REFERENCES Fornecedor(Codigo)
)
GO

INSERT INTO Mercadoria VALUES
(10,	'Mouse',		24,		30,	1),
(11,	'Teclado',		50,		20,	1),
(12,	'Cx. De Som',	30,		8,	2),
(13,	'Monitor 17',	350,	4,	3),
(14,	'Notebook',		1500,	7,	4)

CREATE TABLE Pedido(						
Nota_Fiscal			INT				NOT NULL,	
Valor				DECIMAL(7,2)	NOT NULL,
Data_Compra			DATE			NOT NULL,
RG_Cliente			CHAR(9)			NOT NULL
PRIMARY KEY	(Nota_Fiscal)
FOREIGN KEY (RG_Cliente) REFERENCES Cliente(RG)
)
GO



INSERT INTO Pedido	VALUES
(1001,	754,		'2018-04-01',	'121985541'),
(1002,	350,		'2018-04-02',	'121985541'),
(1003,	30,		'2018-04-02',	'29531844'),
(1004,	1500,	'2018-04-03',	'13514996x')

SELECT * FROM Pedido

--Pede-se: (Quando o endereço concatenado não tiver número, colocar só o logradouro e o país, quando tiver colocar, também o número)
SELECT CONCAT(Logradouro,
        CASE
            WHEN Numero IS NOT NULL AND Numero <> '' THEN ', ' + CAST(Numero AS VARCHAR)
            ELSE ''
        END,
        ', ' + Pais
    ) AS Endereco_Completo
	FROM Fornecedor
--Nota: (CPF deve vir sempre mascarado no formato XXX.XXX.XXX-XX e RG Sempre com um traçao antes do último dígito (Algo como XXXXXXXX-X), mas alguns tem 8 e outros 9 dígitos)															
SELECT
    CONCAT(SUBSTRING(CPF, 1, 3), '.', SUBSTRING(CPF, 4, 3), '.', SUBSTRING(CPF, 7, 3), '-', SUBSTRING(CPF, 10, 2)) AS CPF_Formatado,
    CONCAT(SUBSTRING(RG, 1, LEN(RG) - 1), '-', RIGHT(RG, 1)) AS RG_Formatado,
    Nome,
    Logradouro,
    Numero
FROM Cliente;
--FK: Cliente em Pedido - Fornecedor em Mercadoria															
--Consultar 10% de desconto no pedido 1003	
SELECT Valor,
       Valor * 0.9 AS Valor_com_Desconto
FROM Pedido
WHERE Nota_Fiscal = 1003
														
--Consultar 5% de desconto em pedidos com valor maior de R$700,00	
SELECT Valor,
       Valor * 0.95 AS Valor_com_Desconto
FROM Pedido
WHERE Valor > 700.00														
--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10	
UPDATE Mercadoria
SET Preco = Preco *1.20
WHERE Qtd < 10

SELECT Preco
FROM Mercadoria
WHERE Qtd < 10
										
--Data e valor dos pedidos do Luiz		
SELECT p.Data_Compra,
       p.Valor
FROM Pedido p, Cliente c
WHERE p.RG_Cliente = c.RG
AND c.Nome LIKE 'Luiz%'													
--CPF, Nome e endereço concatenado do cliente de nota 1004	
SELECT c.CPF,
       c.Logradouro +' '+ CAST(Numero AS VARCHAR) AS Endereço
FROM Cliente c, Pedido p
WHERE c.RG = p.RG_Cliente
AND p.Nota_Fiscal = 1004														
--País e meio de transporte da Cx. De som			
SELECT f.Pais,
       f.Transporte
FROM Fornecedor f, Mercadoria m
WHERE f.Codigo = m.Cod_Fornecedor
AND m.Descricao = 'Cx. de Som'												
--Nome e Quantidade em estoque dos produtos fornecidos pela Clone	
SELECT m.Descricao,
       m.Qtd
FROM Mercadoria m, Fornecedor f
WHERE m.Cod_Fornecedor = f.Codigo
AND f.Nome = 'Clone'														
--Endereço concatenado e telefone dos fornecedores do monitor. (Telefone brasileiro (XX)XXXX-XXXX ou XXXX-XXXXXX (Se for 0800), Telefone Americano (XXX)XXX-XXXX)	
SELECT
    F.Logradouro + ' ' + ' '+ F.Cidade+ ' '+ F.Pais AS Endereço,
   CASE 
        WHEN F.Telefone LIKE '0800%' THEN F.Telefone
        ELSE 
            CASE 
                WHEN F.Area = 55 THEN '(' + SUBSTRING(F.Telefone, 1, 2) + ')' + SUBSTRING(F.Telefone, 3, 4) + '-' + SUBSTRING(F.Telefone, 7, 4)
                WHEN F.Area = 1 THEN '(' + SUBSTRING(F.Telefone, 1, 3) + ')' + SUBSTRING(F.Telefone, 4, 3) + '-' + SUBSTRING(F.Telefone, 7, 4)
                ELSE F.Telefone
            END
    END AS TelefoneFormatado
FROM Fornecedor F, Mercadoria m
WHERE F.Codigo = m.Cod_Fornecedor
AND m.Descricao LIKE 'Monitor%'														
--Tipo de moeda que se compra o notebook				
SELECT f.Moeda
FROM Fornecedor f, Mercadoria m 
WHERE f.Codigo = m.Cod_Fornecedor
AND m.Descricao = 'Notebook'
--Considerando que hoje é 03/02/2019, há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses e pedido recente para os outros	
ALTER TABLE Pedido
ADD Status_Pedido VARCHAR (15)

ALTER TABLE Pedido
ADD Qtd_Dias INT

UPDATE Pedido
SET  Qtd_Dias = DATEDIFF(DAY, Data_Compra, '2019-02-03') 

UPDATE Pedido
SET Status_Pedido =
       CASE
	   WHEN DATEDIFF(MONTH, Data_Compra, '2019-02-03') > 6 THEN 'Pedido Atigo'
	   ELSE 'Pedido Recente'	
	   END									
SELECT * FROM Pedido			
--Nome e Quantos pedidos foram feitos por cada cliente			
SELECT c.Nome,
       COUNT(p.Nota_Fiscal) AS Qtd_De_Pedido
FROM Cliente c, Pedido p
WHERE c.RG = p.RG_Cliente
GROUP BY c.Nome												
--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT c.RG,
       c.CPF,
	   c.Nome,
	   c.Logradouro+ ' ' + CAST(Numero AS VARCHAR)
FROM Cliente c LEFT JOIN Pedido p
ON c.RG = p.RG_Cliente
WHERE p.Nota_Fiscal IS NULL
															
