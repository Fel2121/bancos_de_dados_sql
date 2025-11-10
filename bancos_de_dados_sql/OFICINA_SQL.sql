-- OFICINA (Workshop) - Schema and Seed Data (MySQL 8+)
CREATE DATABASE IF NOT EXISTS oficina_db
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_unicode_ci;
USE oficina_db;

-- TABLE Cliente (owner of vehicles)
CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(100),
  cpf VARCHAR(14) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Veiculo (vehicle)
CREATE TABLE IF NOT EXISTS veiculo (
  id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  placa VARCHAR(10) NOT NULL UNIQUE,
  marca VARCHAR(50),
  modelo VARCHAR(50),
  ano YEAR,
  quilometragem INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Mecanico
CREATE TABLE IF NOT EXISTS mecanico (
  id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(20),
  especialidade VARCHAR(80),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Pecas (parts)
CREATE TABLE IF NOT EXISTS peca (
  id_peca INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  custo DECIMAL(10,2) NOT NULL CHECK (custo >= 0),
  preco_venda DECIMAL(10,2) NOT NULL CHECK (preco_venda >= 0),
  estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0),
  id_fornecedor INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX (id_fornecedor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Fornecedor
CREATE TABLE IF NOT EXISTS fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(20),
  contato VARCHAR(100),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Servico (type of service offered)
CREATE TABLE IF NOT EXISTS servico (
  id_servico INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(200) NOT NULL,
  duracao_estimada_minutes INT NOT NULL,
  preco_base DECIMAL(10,2) NOT NULL CHECK (preco_base >= 0),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Ordem de Servico (work order)
CREATE TABLE IF NOT EXISTS ordem_servico (
  id_ordem INT AUTO_INCREMENT PRIMARY KEY,
  id_veiculo INT NOT NULL,
  id_mecanico INT,
  data_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_saida DATETIME,
  status ENUM('Aberta','Em Progresso','Concluída','Cancelada') DEFAULT 'Aberta',
  observacoes TEXT,
  desconto DECIMAL(10,2) DEFAULT 0 CHECK (desconto >= 0),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico)
    ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX (id_veiculo),
  INDEX (id_mecanico)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Item de Servico (services and parts used in an order)
CREATE TABLE IF NOT EXISTS item_servico (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_ordem INT NOT NULL,
  id_servico INT,
  id_peca INT,
  quantidade INT DEFAULT 1 CHECK (quantidade > 0),
  preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
  tipo ENUM('Mão de Obra','Peça') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_ordem) REFERENCES ordem_servico(id_ordem)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
    ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
    ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX (id_ordem),
  INDEX (id_servico),
  INDEX (id_peca)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLE Pagamento
CREATE TABLE IF NOT EXISTS pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_ordem INT NOT NULL,
  tipo_pagamento ENUM('Dinheiro','Cartão','Pix','Boleto') NOT NULL,
  valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
  data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_ordem) REFERENCES ordem_servico(id_ordem)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX (id_ordem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed: fornecedores
INSERT INTO fornecedor (nome, telefone, contato) VALUES
('AutoPeças Centro', '41999990001', 'vendas@autopecas.com'),
('Peças Rápidas', '41999990002', 'comercial@pecasrapidas.com');

-- Seed: peças
INSERT INTO peca (nome, custo, preco_venda, estoque, id_fornecedor) VALUES
('Filtro de Óleo', 10.00, 20.00, 50, 1),
('Filtro de Ar', 8.00, 18.00, 30, 1),
('Pastilha de Freio', 40.00, 80.00, 20, 2),
('Óleo 5W30 (4L)', 60.00, 120.00, 15, 1);

-- Seed: clientes e veículos
INSERT INTO cliente (nome, telefone, email, cpf) VALUES
('Carlos Alberto', '41999990010', 'carlos@exemplo.com', '111.111.111-11'),
('Mariana Souza', '41999990011', 'mariana@exemplo.com', '222.222.222-22'),
('João Pereira', '41999990012', 'joao@exemplo.com', '333.333.333-33');

INSERT INTO veiculo (id_cliente, placa, marca, modelo, ano, quilometragem) VALUES
(1, 'ABC1D23', 'Fiat', 'Uno', 2010, 120000),
(2, 'XYZ9Z88', 'Honda', 'Civic', 2018, 45000),
(1, 'JKL4M56', 'Volkswagen', 'Gol', 2015, 80000);

-- Seed: mecanicos
INSERT INTO mecanico (nome, telefone, especialidade) VALUES
('Rafael Mendes', '41988880001', 'Motor e Injeção'),
('Paulo Santos', '41988880002', 'Freios e Suspensão');

-- Seed: servicos
INSERT INTO servico (descricao, duracao_estimada_minutes, preco_base) VALUES
('Troca de óleo + filtro', 60, 120.00),
('Revisão completa', 180, 450.00),
('Alinhamento e balanceamento', 45, 80.00),
('Troca de pastilhas de freio', 90, 200.00);

-- Seed: ordens e itens (exemplos)
INSERT INTO ordem_servico (id_veiculo, id_mecanico, data_entrada, status, observacoes, desconto) VALUES
(1, 1, '2025-10-10 08:30:00', 'Concluída', 'Cliente pediu troca rápida', 0),
(2, 2, '2025-10-11 09:00:00', 'Concluída', 'Revisão antes de viagem', 20.00),
(3, NULL, '2025-10-12 10:00:00', 'Aberta', 'Aguardando aprovação do orçamento', 0);

-- Itens para ordem 1 (Troca de óleo + peças)
INSERT INTO item_servico (id_ordem, id_servico, id_peca, quantidade, preco_unitario, tipo) VALUES
(1, 1, 1, 1, 120.00, 'Mão de Obra'),
(1, NULL, 4, 1, 120.00, 'Peça');

-- Itens para ordem 2
INSERT INTO item_servico (id_ordem, id_servico, id_peca, quantidade, preco_unitario, tipo) VALUES
(2, 2, NULL, 1, 450.00, 'Mão de Obra'),
(2, NULL, 3, 4, 80.00, 'Peça');

-- Pagamentos
INSERT INTO pagamento (id_ordem, tipo_pagamento, valor) VALUES
(1, 'Dinheiro', 240.00),
(2, 'Cartão', 770.00);

-- Example update to reduce stock after using parts (would normally be done by application logic)
UPDATE peca SET estoque = estoque - 1 WHERE id_peca = 1;
UPDATE peca SET estoque = estoque - 4 WHERE id_peca = 3;

-- ---------- Queries requested in the challenge ----------

-- 1) Recuperação simples: listar clientes
-- Pergunta: Quais são os clientes cadastrados?
SELECT id_cliente, nome, telefone, email FROM cliente;

-- 2) Filtros com WHERE: veículos com quilometragem acima de 80.000
-- Pergunta: Quais veículos possuem mais de 80.000 km?
SELECT id_veiculo, placa, marca, modelo, quilometragem FROM veiculo WHERE quilometragem > 80000 ORDER BY quilometragem DESC;

-- 3) Atributos derivados: valor total de uma ordem (soma de itens - desconto)
-- Pergunta: Qual o total (estimado) cobrado em cada ordem de serviço?
SELECT o.id_ordem,
       o.data_entrada,
       COALESCE(ROUND(SUM(i.quantidade * i.preco_unitario),2),0) AS subtotal,
       COALESCE(ROUND(SUM(i.quantidade * i.preco_unitario) - o.desconto,2),0) AS total_com_desconto
FROM ordem_servico o
LEFT JOIN item_servico i ON o.id_ordem = i.id_ordem
GROUP BY o.id_ordem, o.data_entrada, o.desconto
ORDER BY o.data_entrada;

-- 4) Ordenação: ordens mais recentes primeiro
-- Pergunta: Quais são as ordens mais recentes?
SELECT id_ordem, id_veiculo, id_mecanico, data_entrada, status FROM ordem_servico ORDER BY data_entrada DESC;

-- 5) HAVING: mecânicos com mais de 1 ordem concluída
-- Pergunta: Quais mecânicos tiveram mais de 1 ordem concluída?
SELECT m.id_mecanico, m.nome, COUNT(o.id_ordem) AS ordens_concluidas
FROM mecanico m
JOIN ordem_servico o ON m.id_mecanico = o.id_mecanico
WHERE o.status = 'Concluída'
GROUP BY m.id_mecanico, m.nome
HAVING COUNT(o.id_ordem) > 1;

-- 6) Junções múltiplas: detalhes de ordens com cliente, veículo, mecânico e total
-- Pergunta: Mostre as ordens com dados completos e o total calculado
SELECT o.id_ordem,
       c.nome AS cliente,
       v.placa,
       CONCAT(v.marca, ' ', v.modelo) AS veiculo,
       m.nome AS mecanico,
       o.status,
       COALESCE(ROUND(SUM(i.quantidade * i.preco_unitario) - o.desconto,2),0) AS total
FROM ordem_servico o
JOIN veiculo v ON o.id_veiculo = v.id_veiculo
JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN mecanico m ON o.id_mecanico = m.id_mecanico
LEFT JOIN item_servico i ON o.id_ordem = i.id_ordem
GROUP BY o.id_ordem, c.nome, v.placa, v.marca, v.modelo, m.nome, o.status, o.desconto
ORDER BY o.data_entrada DESC;

-- 7) Query combinando WHERE, JOIN e ORDER BY: peças abaixo do estoque mínimo
-- Pergunta: Quais peças estão com estoque abaixo de 10 unidades?
SELECT id_peca, nome, estoque FROM peca WHERE estoque < 10 ORDER BY estoque ASC;

-- 8) Query mais complexa: média de gasto por cliente (considerando ordens pagas)
-- Pergunta: Qual é o gasto médio por cliente (somente ordens com pagamento registrado)?
SELECT c.id_cliente, c.nome, ROUND(AVG(pag.valor),2) AS gasto_medio
FROM cliente c
JOIN veiculo v ON c.id_cliente = v.id_cliente
JOIN ordem_servico o ON v.id_veiculo = o.id_veiculo
JOIN pagamento pag ON o.id_ordem = pag.id_ordem
GROUP BY c.id_cliente, c.nome
ORDER BY gasto_medio DESC;

-- 9) Top serviços mais solicitados (contagem)
-- Pergunta: Quais serviços são mais solicitados?
SELECT s.id_servico, s.descricao, COUNT(i.id_item) AS vezes_solicitado
FROM servico s
JOIN item_servico i ON s.id_servico = i.id_servico
GROUP BY s.id_servico, s.descricao
ORDER BY vezes_solicitado DESC;

-- 10) Ordem com maior valor
-- Pergunta: Qual foi a ordem com maior total (após desconto)?
SELECT o.id_ordem, COALESCE(ROUND(SUM(i.quantidade * i.preco_unitario) - o.desconto,2),0) AS total
FROM ordem_servico o
LEFT JOIN item_servico i ON o.id_ordem = i.id_ordem
GROUP BY o.id_ordem, o.desconto
ORDER BY total DESC
LIMIT 1;
