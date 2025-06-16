CREATE DATABASE SmartCitiesV2;

USE SmartCitiesV2;

CREATE TABLE Estacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Trem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identificador VARCHAR(50) NOT NULL
);

CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    perfil VARCHAR(30) NOT NULL
);

CREATE TABLE Rota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Viagem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_trem INT,
    id_rota INT,
    data_partida DATETIME,
    data_chegada DATETIME,
    FOREIGN KEY (id_trem) REFERENCES Trem(id),
    FOREIGN KEY (id_rota) REFERENCES Rota(id)
);

CREATE TABLE Sensor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(30)
);

CREATE TABLE Leitura_Sensor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT,
    data_hora DATETIME,
    valor DECIMAL(10,2),
    FOREIGN KEY (id_sensor) REFERENCES Sensor(id)
);

CREATE TABLE Ordem_Manutencao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_trem INT,
    data_abertura DATETIME,
    status VARCHAR(30),
    FOREIGN KEY (id_trem) REFERENCES Trem(id)
);

CREATE TABLE Alerta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(30),
    mensagem TEXT,
    data_hora DATETIME
);
