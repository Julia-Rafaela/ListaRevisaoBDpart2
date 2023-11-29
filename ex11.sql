
CREATE DATABASE Exercicio11
GO
USE Exercicio11


CREATE TABLE Plano_Saude(				
Codigo		INT				NOT NULL,	
Nome		VARCHAR(50)		NOT NULL,
Telefone	CHAR(08)		NOT NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Plano_Saude VALUES
(1234,	'Amil',	'41599856'),
(2345,	'Sul América',	'45698745'),
(3456,	'Unimed',	'48759836'),
(4567,	'Bradesco Saúde',	'47265897'),
(5678,	'Intermédica',	'41415269')

CREATE TABLE Paciente(												
CPF				CHAR(11)		NOT NULL,
Nome			VARCHAR(50)		NOT NULL,
Rua				VARCHAR(50)		NOT NULL,
Numero			INT				NOT NULL,		
Bairro			VARCHAR(40)		NOT NULL,
Telefone		CHAR(08)		NOT NULL,
Plano_Saude		INT				NOT NULL
PRIMARY KEY (CPF)
FOREIGN KEY (Plano_Saude) REFERENCES Plano_Saude(Codigo)
)
GO

INSERT INTO Paciente VALUES
('85987458920',	'Maria Paula',	'R. Voluntários da Pátria',	589,	'Santana',		'98458741',		2345),
('87452136900',	'Ana Julia',	'R. XV de Novembro',		657,	'Centro',		'69857412',		5678),
('23659874100',	'João Carlos',	'R. Sete de Setembro',		12,		'República',	'74859632',	1234),
('63259874100',	'José Lima',	'R. Anhaia',				768,	'Barra Funda',	'96524156',	2345)

CREATE TABLE Medico(						
Codigo				INT			NOT NULL,
Nome				VARCHAR(50)	NOT NULL,
Especialidade		VARCHAR(30)	NOT NULL,
Plano_Saude			INT			NOT NULL
PRIMARY KEY (Codigo)
FOREIGN KEY (Plano_Saude) REFERENCES Plano_Saude(Codigo)
)
GO

INSERT INTO Medico VALUES 
(1,	'Claudio',	'Clínico Geral',			1234),
(2,	'Larissa',	'Ortopedista',				2345),
(3,	'Juliana',	'Otorrinolaringologista',	4567),
(4,	'Sérgio',	'Pediatra',					1234),
(5,	'Julio',	'Clínico Geral',			4567),
(6,	'Samara',	'Cirurgião',				1234)

CREATE TABLE Consultas(						
Medico			INT			    NOT NULL,
Paciente		CHAR(11)	    NOT NULL,
Data_Hora	    DATETIME		NOT NULL,
Diagnostico		VARCHAR(50)  	NOT NULL
PRIMARY KEY (Medico,Paciente,Data_Hora)
FOREIGN KEY (Medico) REFERENCES Medico(Codigo),
FOREIGN KEY (Paciente) REFERENCES Paciente(CPF)
)
GO


INSERT INTO Consultas VALUES 
(1,	'85987458920',	'2021-02-10 10:30:00',	'Gripe'),
(2,	'23659874100',	'2021-02-10 11:00:00',	'Pé Fraturado'),
(4,	'85987458920',	'2021-02-11 14:00:00',	'Pneumonia'),
(1,	'23659874100',	'2021-02-11 15:00:00',	'Asma'),
(3,	'87452136900',	'2021-02-11 16:00:00',	'Sinusite'),
(5,	'63259874100',	'2021-02-11 17:00:00',	'Rinite'),
(4,	'23659874100',	'2021-02-11 18:00:00',	'Asma'),
(5,	'63259874100',	'2021-02-12 10:00:00',	'Rinoplastia')

SELECT * FROM Consultas 

--Consultar Nome e especialidade dos médicos da Amil		
SELECT m.Nome,
       m.Especialidade
FROM Medico m, Plano_Saude p
WHERE m.Plano_Saude = p.Codigo
AND p.Nome = 'Amil'

--Consultar Nome, Endereço concatenado, Telefone e Nome do Plano de Saúde de todos os pacientes										
SELECT pa.Nome,
       pa.Rua + ' '+ CAST(pa.Numero AS VARCHAR) AS endereço,
	   pa.Telefone,
	   p.Nome
FROM Paciente pa, Plano_Saude p
WHERE pa.Plano_Saude = p.Codigo

--Consultar Telefone do Plano de  Saúde de Ana Júlia										
SELECT  p.Telefone
FROM Paciente pa, Plano_Saude p
WHERE pa.Plano_Saude = p.Codigo
AND pa.Nome = 'Ana Julia'

--Consultar Plano de Saúde que não tem pacientes cadastrados										
SELECT  p.Nome
FROM Plano_Saude p LEFT JOIN Paciente pa 
ON pa.Plano_Saude = p.Codigo
WHERE pa.CPF IS NULL

--Consultar Planos de Saúde que não tem médicos cadastrados										
SELECT p.Nome
FROM Plano_Saude p LEFT JOIN Medico m
ON p.Codigo = m.Plano_Saude
WHERE m.Codigo IS NULL

--Consultar Data da consulta, Hora da consulta, nome do médico, nome do paciente e diagnóstico de todas as consultas	
SELECT 
       SUBSTRING(CAST(c.Data_Hora AS VARCHAR), 1,11) AS Data_Consulta,
       SUBSTRING(CAST(c.Data_Hora AS VARCHAR), 13,7) AS Hora_Consulta,
	   m.Nome,
	   p.Nome,
	   c.Diagnostico
FROM Paciente p, Medico m, Consultas c
WHERE p.CPF = c.Paciente
AND m.Codigo = c.Medico

--Consultar Nome do médico, data e hora de consulta e diagnóstico de José Lima	
SELECT m.Nome,
       SUBSTRING(CAST(c.Data_Hora AS VARCHAR), 1,11) AS Data_Consulta,
       SUBSTRING(CAST(c.Data_Hora AS VARCHAR), 13,7) AS Hora_Consulta,
	   c.Diagnostico
FROM Paciente p, Medico	m, Consultas c
WHERE p.CPF = c.Paciente
AND m.Codigo = c.Medico
AND p.Nome = 'José Lima'								

--Consultar Diagnóstico e Quantidade de consultas que aquele diagnóstico foi dado (Coluna deve chamar qtd)										
SELECT Diagnostico,
       COUNT(Diagnostico) AS Qtd
FROM Consultas 
GROUP BY Diagnostico
--Consultar Quantos Planos de Saúde que não tem médicos cadastrados	
SELECT P.Nome							
FROM  Plano_Saude p LEFT JOIN Medico m
ON p.Codigo = m.Plano_Saude		
WHERE m.Codigo IS NULL	
GROUP BY p.Nome		
		
--Alterar o nome de João Carlos para João Carlos da Silva	
UPDATE Paciente
SET Nome = 'João Carlos da Silva'
WHERE Nome = 'João Carlos'

SELECT * FROM Paciente		
--Deletar o plano de Saúde Unimed
DELETE Plano_Saude
WHERE Nome = 'Unimed'

SELECT * FROM Plano_Saude										
--Renomear a coluna Rua da tabela Paciente para Logradouro	
EXEC sp_rename 'Paciente.Rua', 'Logradouro', 'COLUMN'
SELECT * FROM Paciente									
--Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente										
ALTER TABLE Paciente
ADD data_nasc DATE

UPDATE Paciente
SET data_nasc = '1990-04-18' 
WHERE CPF = '23659874100'

UPDATE Paciente
SET data_nasc = '1981-03-25'
WHERE CPF ='63259874100'

UPDATE Paciente
SET data_nasc = '2004-09-04'
WHERE CPF = '85987458920'

UPDATE Paciente
SET data_nasc = '1986-06-18'
WHERE CPF = '87452136900'

SELECT * FROM Paciente	