CREATE DATABASE SmartCitiesV2;

USE SmartCitiesV2;

-- Tabelas principais

CREATE TABLE Estacao (
    id_estacao INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(255) NOT NULL
);

CREATE TABLE Trem (
    id_trem INT AUTO_INCREMENT PRIMARY KEY,
    identificador VARCHAR(50) NOT NULL,
    modelo VARCHAR(50),
    capacidade_passageiros INT,
    capacidade_carga_kg INT,
    status_trem VARCHAR(30)
);

CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    senha VARCHAR(100),
    perfil ENUM('Controlador', 'Engenheiro', 'Planejador', 'Maquinista', 'Gerente') NOT NULL
);

CREATE TABLE Rota (
    id_rota INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE Segmento (
    id_segmento INT AUTO_INCREMENT PRIMARY KEY,
    id_rota INT,
    ordem INT,
    id_estacao_origem INT,
    id_estacao_destino INT,
    distancia_km DECIMAL(6,2),
    FOREIGN KEY (id_rota) REFERENCES Rota(id_rota),
    FOREIGN KEY (id_estacao_origem) REFERENCES Estacao(id_estacao),
    FOREIGN KEY (id_estacao_destino) REFERENCES Estacao(id_estacao)
);

CREATE TABLE Viagem (
    id_viagem INT AUTO_INCREMENT PRIMARY KEY,
    id_trem INT,
    id_rota INT,
    data_partida DATETIME,
    data_chegada_prevista DATETIME,
    data_chegada_real DATETIME,
    status_viagem VARCHAR(30),
    FOREIGN KEY (id_trem) REFERENCES Trem(id_trem),
    FOREIGN KEY (id_rota) REFERENCES Rota(id_rota)
);

-- Telemetria e sensores

CREATE TABLE Sensor (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Trilho', 'Trem'),
    descricao VARCHAR(100)
);

CREATE TABLE Sensor_Trilho (
    id_sensor INT PRIMARY KEY,
    id_segmento INT,
    tipo_sensor ENUM('Peso', 'Temperatura'),
    FOREIGN KEY (id_sensor) REFERENCES Sensor(id_sensor),
    FOREIGN KEY (id_segmento) REFERENCES Segmento(id_segmento)
);

CREATE TABLE Sensor_Trem (
    id_sensor INT PRIMARY KEY,
    id_trem INT,
    tipo_sensor ENUM('Motor', 'Freio', 'Eletrico'),
    FOREIGN KEY (id_sensor) REFERENCES Sensor(id_sensor),
    FOREIGN KEY (id_trem) REFERENCES Trem(id_trem)
);

CREATE TABLE Leitura_Sensor (
    id_leitura INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT,
    data_hora DATETIME,
    valor DECIMAL(10,2),
    unidade VARCHAR(20),
    FOREIGN KEY (id_sensor) REFERENCES Sensor(id_sensor)
);

-- Manutenção

CREATE TABLE Ordem_Manutencao (
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    id_trem INT,
    data_abertura DATETIME,
    data_fechamento DATETIME,
    tipo ENUM('Preventiva', 'Corretiva'),
    descricao TEXT,
    status_manutencao ENUM('Aberta', 'Em andamento', 'Fechada'),
    FOREIGN KEY (id_trem) REFERENCES Trem(id_trem)
);

CREATE TABLE Inspecao (
    id_inspecao INT AUTO_INCREMENT PRIMARY KEY,
    id_trem INT,
    data_inspecao DATETIME,
    tipo ENUM('Quilometragem', 'Tempo de uso'),
    resultado VARCHAR(100),
    observacoes TEXT,
    FOREIGN KEY (id_trem) REFERENCES Trem(id_trem)
);

-- Alertas

CREATE TABLE Alerta (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Atraso', 'Falha Técnica', 'Segurança'),
    mensagem TEXT,
    data_hora DATETIME,
    criticidade ENUM('Baixa', 'Média', 'Alta'),
    id_viagem INT,
    FOREIGN KEY (id_viagem) REFERENCES Viagem(id_viagem)
);

CREATE TABLE Alerta_Usuario (
    id_alerta INT,
    id_usuario INT,
    lido BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_alerta, id_usuario),
    FOREIGN KEY (id_alerta) REFERENCES Alerta(id_alerta),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Eficiência e relatórios

CREATE TABLE Consumo_Energia (
    id_consumo INT AUTO_INCREMENT PRIMARY KEY,
    id_trem INT,
    id_viagem INT,
    kwh DECIMAL(10,2),
    data_registro DATETIME,
    FOREIGN KEY (id_trem) REFERENCES Trem(id_trem),
    FOREIGN KEY (id_viagem) REFERENCES Viagem(id_viagem)
);

CREATE TABLE Relatorios (
    id_relatorio INT AUTO_INCREMENT PRIMARY KEY,
    mes INT,
    ano INT,
    eficiencia_energetica DECIMAL(10,2),
    taxa_pontualidade DECIMAL(5,2),
    causas_atraso TEXT,
    custo_medio_manutencao DECIMAL(10,2)
);

