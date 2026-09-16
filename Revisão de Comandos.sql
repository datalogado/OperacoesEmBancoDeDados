/* ==== CREATE TABLE ==== */
CREATE TYPE tipo_pagamento AS ENUM('pix', 'dinheiro', 'débito', 'crédito');

CREATE TABLE rosquinhas(
	id_rosquinha SERIAL PRIMARY KEY,
	nome_rosquinha VARCHAR(50) NOT NULL,
	descricao_rosquinha VARCHAR(100),
	preco_rosquinha DECIMAL(12,2) NOT NULL
);

CREATE TABLE cliente(
	id_cliente SERIAL PRIMARY KEY,
	nome_cliente VARCHAR(50) NOT NULL,
	email_cliente VARCHAR(50) UNIQUE NOT NULL,
	senha_cliente VARCHAR(12) NOT NULL,
	data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedido(
	id_pedido SERIAL PRIMARY KEY,
	id_cliente INT NOT NULL, 
	FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
	resumo_pedido VARCHAR(100) NOT NULL,
	data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	valor_pago DECIMAL(12,2) NOT NULL,
	tipo_pagamento tipo_pagamento
);

/* ==== ALTER TABLE ==== */

ALTER TABLE pedido
RENAME TO pedidos;

ALTER TABLE rosquinhas
ADD COLUMN estoque INT,
RENAME COLUMN estoque TO quantidade
ALTER COLUMN descricao_rosquinha TYPE VARCHAR(200),
DROP COLUMN quantidade;

ALTER TABLE rosquinhas
ALTER COLUMN preco_rosquinha TYPE DECIMAL(12, 2);

ALTER TABLE pedido
ALTER COLUMN valor_pago TYPE DECIMAL(12, 2);

/* ==== DROP TABLE ==== */

DROP TABLE rosquinhas;
DROP TABLE pedidos;
DROP TABLE cliente;

/* ==== INSERT INTO ==== */

INSERT INTO rosquinhas (nome_rosquinha, descricao_rosquinha, preco_rosquinha) VALUES 
('Rosquinha de Chocolate', 'Massa de trigo com cobertura de chocolate e confete de chocolate.', '9.99'),
('Rosquinha do Amor', 'Massa de trigo com cobertura de brigadeiro branco e calda de açúcar.', '29.99'),
('Rosquinha Tropical', 'Massa de chocolate com cobertura de geleia de maracujá e rodelas de abacaxi', '19.99');

INSERT INTO cliente(nome_cliente, email_cliente, senha_cliente) VALUES 
('Edilane Moraes', 'Edilane@gmail.com', '1234'),
('Hugo Huxley', 'Hugo@gmail.com', '1234'),
('Marcelo Eduardo', 'Eduzim@gmail.com', '1234');

INSERT INTO pedido(id_cliente, resumo_pedido, valor_pago, tipo_pagamento) VALUES
('1', 'Uma rosquinha do amor + uma rosquinha tropical', '49.98', 'pix'),
('2', 'Uma rosquinha do amor', '29.99', 'pix'),
('2', 'Uma rosquinha de chocolate', '9.99', 'dinheiro'),
('1', 'Dez rosquinhas tropicais', '199.90', 'crédito'),
('1', 'Duas rosquinhas de chocolate', '19.98', 'dinheiro'),
('1', 'Uma rosquinha de chocolate', '9.99', 'pix');

/* ==== UPDATE SET ==== */

UPDATE pedido SET id_cliente = 2 WHERE id_pedido = 2;

/* ==== DELETE FROM WHERE ==== */

DELETE FROM rosquinhas WHERE id_rosquinha = 1;

/* ==== TRUNCATE TABLE ==== */

TRUNCATE TABLE pedido;

/* ==== SELECT FROM WHERE ORDER BY DESC/ASC ==== */

SELECT * FROM pedido WHERE tipo_pagamento = 'pix' ORDER BY valor_pago DESC;
SELECT * FROM pedido WHERE tipo_pagamento = 'pix' ORDER BY valor_pago ASC;

/* ==== FUNÇÕES DE AGREGAÇÃO ==== */

SELECT COUNT(id_pedido) FROM pedido;
SELECT COUNT(*) FROM pedido;
SELECT COUNT(DISTINCT resumo_pedido) FROM pedido;
SELECT SUM(valor_pago) FROM pedido;
SELECT AVG(valor_pago) FROM pedido;
SELECT MIN(valor_pago) FROM pedido;
SELECT MAX(valor_pago) FROM pedido;

/* ==== SELECT COUNT FROM GROUP BY ==== */

SELECT
	tipo_pagamento,
	COUNT(*) AS "quantidade"
	FROM pedido
	GROUP BY tipo_pagamento;

/* ==== GROUP BY SUM COUNT DISTINCT HAVING ORDER BY ==== */

SELECT 
	tipo_pagamento,
	SUM(valor_pago) AS "total_recebido",
	COUNT(*) AS "quantidade_pagamentos",
	COUNT(DISTINCT id_cliente) AS "quantidade_cliente"
	FROM pedido
	GROUP BY tipo_pagamento
	HAVING COUNT(DISTINCT id_cliente) > 1
	ORDER BY total_recebido ASC;

/* ==== INNER JOIN ==== */

SELECT 
	pedido.*,
	cliente.nome_cliente,
	cliente.email_cliente
FROM pedido
INNER JOIN cliente
ON pedido.id_cliente = cliente.id_cliente;

/* ==== RIGHT JOIN ==== */

SELECT * FROM pedido
RIGHT JOIN cliente ON cliente.id_cliente = pedido.id_cliente;

/* ==== LEFT JOIN ==== */

SELECT * FROM cliente
LEFT JOIN pedido ON cliente.id_cliente = pedido.id_cliente;

/* ==== FULL JOIN ==== */

SELECT * FROM pedido
RIGHT JOIN cliente ON cliente.id_cliente = pedido.id_cliente
UNION
SELECT * FROM pedido
LEFT JOIN cliente ON cliente.id_cliente = pedido.id_cliente



	

