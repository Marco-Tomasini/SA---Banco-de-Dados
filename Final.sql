CREATE DATABASE SmartCitiesV4;

USE SmartCitiesV4;
;

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
    status_trem VARCHAR(30),
    quilometragem DECIMAL(10,2) DEFAULT 0,
    tempo_uso DECIMAL(10,2) DEFAULT 0,
    ultima_manutencao DATETIME,
    consumo_kwh DECIMAL(10,2)
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
    id_rota_fk INT,
    ordem INT,
    id_estacao_origem INT,
    id_estacao_destino INT,
    distancia_km DECIMAL(6,2),
    FOREIGN KEY (id_rota_fk) REFERENCES Rota(id_rota),
    FOREIGN KEY (id_estacao_origem) REFERENCES Estacao(id_estacao),
    FOREIGN KEY (id_estacao_destino) REFERENCES Estacao(id_estacao)
);

CREATE TABLE Viagem (
    id_viagem INT AUTO_INCREMENT PRIMARY KEY,
    id_trem_fk INT,
    id_rota_fk INT,
    data_partida DATETIME,
    data_chegada_previsao DATETIME,
    data_chegada DATETIME,
    status_viagem VARCHAR(30),
    FOREIGN KEY (id_trem_fk) REFERENCES Trem(id_trem),
    FOREIGN KEY (id_rota_fk) REFERENCES Rota(id_rota)
);

-- Sensores

CREATE TABLE Sensor (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Trilho', 'Trem'),
    descricao VARCHAR(100)
);

CREATE TABLE Sensor_Trilho (
    id_sensor_trilho INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor_fk INT,
    id_segmento_fk INT,
    tipo_sensor ENUM('Peso', 'Temperatura'),
    FOREIGN KEY (id_sensor_fk) REFERENCES Sensor(id_sensor),
    FOREIGN KEY (id_segmento_fk) REFERENCES Segmento(id_segmento)
);

CREATE TABLE Sensor_Trem (
    id_sensor_trem INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor_fk INT,
    id_trem_fk INT,
    tipo_sensor ENUM('Motor', 'Freio', 'Eletrico'),
    FOREIGN KEY (id_sensor_fk) REFERENCES Sensor(id_sensor),
    FOREIGN KEY (id_trem_fk) REFERENCES Trem(id_trem)
);

CREATE TABLE Leitura_Sensor (
    id_leitura INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor_fk INT,
    data_hora DATETIME,
    valor DECIMAL(10,2),
    unidade VARCHAR(20),
    FOREIGN KEY (id_sensor_fk) REFERENCES Sensor(id_sensor)
);

-- Manutenção

CREATE TABLE Ordem_Manutencao (
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    id_trem_fk INT,
    data_abertura DATETIME,
    data_fechamento DATETIME,
    tipo ENUM('Preventiva', 'Corretiva'),
    descricao TEXT,
    status_manutencao ENUM('Aberta', 'Em andamento', 'Fechada'),
    FOREIGN KEY (id_trem_fk) REFERENCES Trem(id_trem)
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
    id_alerta_fk INT,
    id_usuario_fk INT,
    lido BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_alerta_fk, id_usuario_fk),
    FOREIGN KEY (id_alerta_fk) REFERENCES Alerta(id_alerta),
    FOREIGN KEY (id_usuario_fk) REFERENCES Usuario(id_usuario)
);

-- Relatórios

CREATE TABLE Relatorios (
    id_relatorio INT AUTO_INCREMENT PRIMARY KEY,
    data_relatorio DATE,
    eficiencia_energetica DECIMAL(10,2),
    taxa_pontualidade DECIMAL(5,2),
    causas_atraso TEXT,
    custo_medio_manutencao DECIMAL(10,2)
);