USE nextevents;

CREATE TABLE Evento (
    ID_Evento INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Data_Inicio DATE NOT NULL,
    Data_Fim DATE NOT NULL,
    Custo DECIMAL(10,2) UNSIGNED,
    Lotacao_Maxima INT UNSIGNED NOT NULL,
    Descricao VARCHAR(150) NOT NULL,

    PRIMARY KEY (ID_Evento),
    
    CONSTRAINT chk_evento_datas 
		CHECK (Data_Fim >= Data_Inicio)
);

CREATE TABLE Espaco (
    ID_Espaco INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Lotacao_Fisica INT UNSIGNED NOT NULL,

    PRIMARY KEY (ID_Espaco)
);

CREATE TABLE Participante (
    ID_Participante INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Contacto VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,

    PRIMARY KEY (ID_Participante),
    UNIQUE (Contacto),
    UNIQUE (Email)
);

CREATE TABLE Orador (
    ID_Orador INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Especialidade VARCHAR(45) NOT NULL,
    Biografia VARCHAR(150) NOT NULL,

    PRIMARY KEY (ID_Orador)
);

CREATE TABLE Juri (
    ID_Juri INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Especialidade VARCHAR(45) NOT NULL,

    PRIMARY KEY (ID_Juri)
);

CREATE TABLE Atividade (
    ID_Atividade INT NOT NULL AUTO_INCREMENT,
    Titulo VARCHAR(45) NOT NULL,
    Hora_Inicio TIME NOT NULL,
    Hora_Fim TIME NOT NULL,
    Descricao VARCHAR(150) NOT NULL,
    Data DATE NOT NULL,
    Lotacao_Especifica INT UNSIGNED NOT NULL,
    Evento_ID_Evento INT NOT NULL,
    Espaco_ID_Espaco INT NOT NULL,

    PRIMARY KEY (ID_Atividade),

    CONSTRAINT fk_Atividade_Evento1
        FOREIGN KEY (Evento_ID_Evento)
        REFERENCES Evento(ID_Evento),

    CONSTRAINT fk_Atividade_Espaco1
        FOREIGN KEY (Espaco_ID_Espaco)
        REFERENCES Espaco(ID_Espaco),
        
	CONSTRAINT chk_atividade_horas
		CHECK (Hora_Fim > Hora_Inicio)
);

CREATE TABLE Workshop (
    Atividade_ID_Atividade INT NOT NULL,

    PRIMARY KEY (Atividade_ID_Atividade),

    CONSTRAINT fk_Workshop_Atividade1
        FOREIGN KEY (Atividade_ID_Atividade)
        REFERENCES Atividade(ID_Atividade)
);

CREATE TABLE Hackathon (
    Lotacao_Minima_Equipa INT NOT NULL,
    Lotacao_Maxima_Equipa INT NOT NULL,
    Atividade_ID_Atividade INT NOT NULL,

    PRIMARY KEY (Atividade_ID_Atividade),

    CONSTRAINT fk_Hackathon_Atividade1
        FOREIGN KEY (Atividade_ID_Atividade)
        REFERENCES Atividade(ID_Atividade),
	
    CONSTRAINT chk_hackathon_lotacao 
		CHECK (Lotacao_Maxima_Equipa >= Lotacao_Minima_Equipa)
);

CREATE TABLE Inscricao_Evento (
    ID_Inscricao INT NOT NULL AUTO_INCREMENT,
    Valor_Pago DECIMAL(10,2),
    Data DATE NOT NULL,
    Hora TIME NOT NULL,
    Prazo_Pagamento DATETIME,
    Estado VARCHAR(45) NOT NULL,
    Participante_ID_Participante INT NOT NULL,
    Evento_ID_Evento INT NOT NULL,

    PRIMARY KEY (ID_Inscricao),

    CONSTRAINT fk_Inscricao_Evento_Participante1
        FOREIGN KEY (Participante_ID_Participante)
        REFERENCES Participante(ID_Participante),

    CONSTRAINT fk_Inscricao_Evento_Evento1
        FOREIGN KEY (Evento_ID_Evento)
        REFERENCES Evento(ID_Evento),
        
	CONSTRAINT chk_inscricao_estado 
		CHECK (Estado IN ('Confirmada', 'Em Espera', 'Cancelada', 'A Aguardar Pagamento'))

);

CREATE TABLE Equipa (
    ID_Equipa INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Nota DECIMAL(5,2) NOT NULL,
    Hackathon_Atividade_ID_Atividade INT NOT NULL,

    PRIMARY KEY (ID_Equipa),

    CONSTRAINT fk_Equipa_Hackathon1
        FOREIGN KEY (Hackathon_Atividade_ID_Atividade)
        REFERENCES Hackathon(Atividade_ID_Atividade)
);


CREATE TABLE Workshop_has_Orador (
    Workshop_Atividade_ID_Atividade INT NOT NULL,
    Orador_ID_Orador INT NOT NULL,

    PRIMARY KEY (Workshop_Atividade_ID_Atividade, Orador_ID_Orador),

    CONSTRAINT fk_Workshop_has_Orador_Workshop
        FOREIGN KEY (Workshop_Atividade_ID_Atividade)
        REFERENCES Workshop(Atividade_ID_Atividade),

    CONSTRAINT fk_Workshop_has_Orador_Orador
        FOREIGN KEY (Orador_ID_Orador)
        REFERENCES Orador(ID_Orador)
);


CREATE TABLE Juri_has_Hackathon (
    Juri_ID_Juri INT NOT NULL,
    Hackathon_Atividade_ID_Atividade INT NOT NULL,

    PRIMARY KEY (Juri_ID_Juri, Hackathon_Atividade_ID_Atividade),

    CONSTRAINT fk_Juri_has_Hackathon_Juri
        FOREIGN KEY (Juri_ID_Juri)
        REFERENCES Juri(ID_Juri),

    CONSTRAINT fk_Juri_has_Hackathon_Hackathon
        FOREIGN KEY (Hackathon_Atividade_ID_Atividade)
        REFERENCES Hackathon(Atividade_ID_Atividade)
);

CREATE TABLE Participante_has_Equipa (
    Participante_ID_Participante INT NOT NULL,
    Equipa_ID_Equipa INT NOT NULL,

    PRIMARY KEY (Participante_ID_Participante, Equipa_ID_Equipa),

    CONSTRAINT fk_Participante_has_Equipa_Participante
        FOREIGN KEY (Participante_ID_Participante)
        REFERENCES Participante(ID_Participante),

    CONSTRAINT fk_Participante_has_Equipa_Equipa
        FOREIGN KEY (Equipa_ID_Equipa)
        REFERENCES Equipa(ID_Equipa)
);


CREATE TABLE Inscricao_Evento_has_Atividade (
    Inscricao_Evento_ID_Inscricao INT NOT NULL,
    Atividade_ID_Atividade INT NOT NULL,
    Data DATE NOT NULL,
    Hora TIME NOT NULL,
    Estado VARCHAR(45) NOT NULL,

    PRIMARY KEY (Inscricao_Evento_ID_Inscricao, Atividade_ID_Atividade),

    CONSTRAINT fk_InscEv_has_Atividade_Inscricao
        FOREIGN KEY (Inscricao_Evento_ID_Inscricao)
        REFERENCES Inscricao_Evento(ID_Inscricao),

    CONSTRAINT fk_InscEv_has_Atividade_Atividade
        FOREIGN KEY (Atividade_ID_Atividade)
        REFERENCES Atividade(ID_Atividade),
	
    CONSTRAINT chk_reserva_estado 
		CHECK (Estado IN ('Confirmada', 'Em Espera', 'Cancelada'))
);

