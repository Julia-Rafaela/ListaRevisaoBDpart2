
USE master
CREATE DATABASE Exercicio10
GO
USE Exercicio10

CREATE TABLE Medicamento (				
Codigo			INT			NOT NULL,
Nome			VARCHAR(50)	NOT NULL,
Apresentacao  	VARCHAR(50) NOT NULL,
Unidade			VARCHAR(30)	NOT NULL, 	 
Preco_Composto	DECIMAL(7,2)NOT NULL
PRIMARY KEY (Codigo)
)
GO
 
 INSERT INTO Medicamento VALUES 
(1,	 'Acetato de medroxiprogesterona',  	'150 mg/ml',  			    'Ampola',		6.700),
(2,	 'Aciclovir',							'200mg/comp.',  			'Comprimido',  	0.280),
(3,	 '�cido Acetilsalic�lico',  			'500mg/comp.',  			'Comprimido',  	0.035),
(4,	 '�cido Acetilsalic�lico',  			'100mg/comp.',  			'Comprimido',  	0.030),
(5,	 '�cido F�lico',  						'5mg/comp.',				'Comprimido',  	0.054),
(6,	 'Albendazol',							'400mg/comp. mastig�vel',  	'Comprimido',  	0.560),
(7,	 'Alopurinol',  						'100mg/comp.',  			'Comprimido',  	0.080),
(8,	 'Amiodarona',  						'200mg/comp.',  			'Comprimido',  	0.200),
(9,	 'Amitriptilina(Cloridrato)',  			'25mg/comp.',  				'Comprimido',  	0.220),
(10, 'Amoxicilina',  						'500mg/c�ps.',  			'C�psula',  	0.190)

CREATE TABLE Cliente(					
CPF			CHAR(11)		NOT NULL,
Nome		VARCHAR(50)		NOT NULL,	
Rua			VARCHAR(30)		NOT NULL,
Numero		INT				NOT NULL,	
Bairro		VARCHAR(30)		NOT NULL,
Telefone	CHAR(08)		NOT NULL,
PRIMARY KEY (CPF)
)
GO

INSERT INTO Cliente VALUES
('34390898700',	'Maria Z�lia',		'Anhaia',					65,		'Barra Funda',	92103762),
('21345986290',	'Roseli Silva',		'Xv. De Novembro',			987,	'Centro',		82198763),
('86927981825',	'Carlos Campos',	'Volunt�rios da P�tria',	1276,	'Santana',		98172361),
('31098120900',	'Jo�o Perdizes',	'Carlos de Campos',			90,		'Pari',			61982371)

CREATE TABLE Vendas (					
    Nota_Fiscal         INT             NOT NULL,
    CPF_cliente         CHAR(11)        NOT NULL,
    Codigo_Medicamento  INT             NOT NULL,
    Quantidade          INT             NOT NULL,
    Valor_Total         DECIMAL(7,2)    NOT NULL,
    Data_Venda          DATE            NOT NULL
    PRIMARY KEY (CPF_cliente,Codigo_Medicamento)
    FOREIGN KEY (CPF_cliente) REFERENCES Cliente(CPF),
    FOREIGN KEY (Codigo_Medicamento) REFERENCES Medicamento(Codigo)
)
GO

INSERT INTO Vendas VALUES
(31501,	'86927981825',	10,	3,	0.57,	'2020-11-01'),
(31501,	'86927981825',	2,	10,	2.8,	'2020-11-01'),
(31501,	'86927981825',	5,	30,	1.05,	'2020-11-01'),
(31501,	'86927981825',	8,	30,	6.6,	'2020-11-01'),
(31502,	'34390898700',	8,	15,	3,		'2020-11-01'),
(31502,	'34390898700',	2,	10,	2.8,	'2020-11-01'),
(31502,	'34390898700',	9,	10,	2.2,	'2020-11-01'),
(31503,	'31098120900',	1,	20,	134,	'2020-11-02')

--Consultar																					
--Nome, apresenta��o, unidade e valor unit�rio dos rem�dios que ainda n�o foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp.	
SELECT m.Nome,
       m.Preco_Composto,
	   CASE
	   WHEN m.Unidade = 'Comprimido' THEN SUBSTRING(m.Unidade, 1, 4)
	   ELSE m.Unidade
	   END AS unidade
FROM Medicamento m	LEFT JOIN Vendas v
ON m.Codigo =v.Codigo_Medicamento
WHERE v.Nota_Fiscal IS NULL									
--Nome dos clientes que compraram Amiodarona	
SELECT c.Nome
FROM Cliente c, Vendas v, Medicamento m	
WHERE c.CPF = v.CPF_cliente
AND v.Codigo_Medicamento = m.Codigo
AND m.Nome = 'Amiodarona'	
						
--CPF do cliente, endere�o concatenado, nome do medicamento (como nome de rem�dio),  apresenta��o do rem�dio, unidade, pre�o proposto, quantidade vendida e valor total dos rem�dios vendidos a Maria Z�lia											
SELECT c.CPF,
       c.Rua + ' '+ CAST(Numero AS VARCHAR) AS endere�o,
	   m.Nome AS nome_rem�dio,
	   m.Apresentacao,
	   m.Unidade,
	   m.Preco_Composto,
	   v.Quantidade,
	   v.Valor_Total
FROM Cliente c, Medicamento m, Vendas v
WHERE c.CPF = v.CPF_cliente
AND v.Codigo_Medicamento = m.Codigo 
AND C.Nome = 'Maria Z�lia'

--Data de compra, convertida, de Carlos Campos	
SELECT CONVERT(VARCHAR,v.Data_Venda, 101) AS data_venda
FROM Vendas v, Cliente c
WHERE v.CPF_cliente = c.CPF
AND c.Nome = 'Carlos Campos'									
											
--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina	
UPDATE Medicamento
SET Nome = 'Cloridrato de Amitriptilina'
WHERE Nome = 'Amitriptilina(Cloridrato)'	
SELECT * FROM Medicamento		
							


