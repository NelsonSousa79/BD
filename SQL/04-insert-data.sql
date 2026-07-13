USE nextevents;

INSERT INTO Evento (Nome, Data_Inicio, Data_Fim, Custo, Lotacao_Maxima, Descricao)
VALUES
('Braga Tech Summit',   '2026-06-10', '2026-06-12', 25.00, 200, 'Evento tecnológico com workshops e palestras.'),
('Hack Norte 2026',     '2026-07-05', '2026-07-06', 15.00,   4, 'Evento dedicado a hackathons e inovação.'),
('Python Day Braga',    '2026-08-15', '2026-08-15',  0.00, 100, 'Evento gratuito de introdução ao Python.'),
('CiberSec Conference', '2026-09-20', '2026-09-21', 35.00,   5, 'Conferência sobre segurança informática.');

INSERT INTO Espaco (Nome, Lotacao_Fisica)
VALUES
('Auditório Principal',     200),
('Sala Workshop A',          50),
('Laboratório Informática',  80),
('Sala Workshop B',          40),
('Sala de Conferências',     60);

INSERT INTO Participante (Nome, Contacto, Email)
VALUES
('João Silva',     '912345678', 'joao.silva@email.com'),
('Maria Costa',    '913456789', 'maria.costa@email.com'),
('Pedro Sousa',    '914567890', 'pedro.sousa@email.com'),
('Ana Martins',    '915678901', 'ana.martins@email.com'),
('Tiago Ferreira', '916789012', 'tiago.ferreira@email.com'),
('Inês Pereira',   '917890123', 'ines.pereira@email.com'),
('Bruno Carvalho', '918901234', 'bruno.carvalho@email.com'),
('Catarina Lopes', '919012345', 'catarina.lopes@email.com'),
('Diogo Mendes',   '910123456', 'diogo.mendes@email.com'),
('Filipa Rocha',   '911234567', 'filipa.rocha@email.com'),
('Gonçalo Faria',  '921345678', 'goncalo.faria@email.com'),
('Helena Sousa',   '922456789', 'helena.sousa@email.com'),
('Igor Pinto',     '923567890', 'igor.pinto@email.com'),
('Joana Alves',    '924678901', 'joana.alves@email.com'),
('Luís Monteiro',  '925789012', 'luis.monteiro@email.com');

INSERT INTO Orador (Nome, Especialidade, Biografia)
VALUES
('Rui Almeida',   'Inteligência Artificial', 'Orador especializado em inteligência artificial.'),
('Carla Mendes',  'Cibersegurança',          'Oradora especializada em segurança informática.'),
('Sofia Rocha',   'Desenvolvimento Web',     'Oradora especializada em desenvolvimento web.'),
('André Gomes',   'Python e Data Science',   'Orador especializado em Python e ciência de dados.'),
('Marta Fonseca', 'Redes e Sistemas',        'Oradora especializada em infraestruturas de rede.');

INSERT INTO Juri (Nome, Especialidade)
VALUES
('Miguel Torres',  'Engenharia de Software'),
('Helena Lopes',   'Data Science'),
('Ricardo Neves',  'Inteligência Artificial'),
('Beatriz Santos', 'Cibersegurança');

INSERT INTO Atividade (Titulo, Hora_Inicio, Hora_Fim, Descricao, Data, Lotacao_Especifica, Evento_ID_Evento, Espaco_ID_Espaco)
VALUES
('Workshop de Python', 		   '10:00:00', '12:00:00', 'Introdução ao Python.', 			  '2026-06-10', 2, 1, 2),
('Workshop de Cibersegurança', '14:00:00', '16:00:00', 'Fundamentos de segurança.',           '2026-06-11', 35, 1, 4),
('Hackathon IA',               '09:00:00', '18:00:00', 'Desenvolvimento de soluções com IA.', '2026-07-05',  4, 2, 3),
('Hackathon Web',              '09:00:00', '18:00:00', 'Desenvolvimento de aplicações web.',  '2026-07-06',  4, 2, 3),
('Workshop Python Introdução', '10:00:00', '13:00:00', 'Python para iniciantes.',             '2026-08-15', 50, 3, 2),
('Workshop Redes',             '09:00:00', '11:00:00', 'Fundamentos de redes e sistemas.',    '2026-09-20', 30, 4, 5),
('Hackathon CiberSec',         '09:00:00', '18:00:00', 'Desafios de cibersegurança.',         '2026-09-21',  4, 4, 3),
('Sessão Python Data Science', '14:00:00', '16:00:00', 'Introdução à ciência de dados.',      '2026-08-15', 60, 3, 5);

INSERT INTO Workshop (Atividade_ID_Atividade)
VALUES (1), (2), (5), (6), (8);

INSERT INTO Hackathon (Lotacao_Minima_Equipa, Lotacao_Maxima_Equipa, Atividade_ID_Atividade)
VALUES
(2, 4, 3),
(2, 4, 4),
(2, 4, 7);

INSERT INTO Workshop_has_Orador (Workshop_Atividade_ID_Atividade, Orador_ID_Orador)
VALUES
(1, 1), (1, 4),
(2, 2),
(5, 4),
(6, 2), (6, 5),
(8, 1), (8, 4);

INSERT INTO Juri_has_Hackathon (Juri_ID_Juri, Hackathon_Atividade_ID_Atividade)
VALUES
(1, 3), (2, 3),
(2, 4), (1, 4),
(3, 7), (4, 7);


INSERT INTO Inscricao_Evento (Valor_Pago, Data, Hora, Prazo_Pagamento, Estado, Participante_ID_Participante, Evento_ID_Evento)
VALUES
(25.00, '2026-05-01', '10:00:00', NULL,                  'Confirmada',           1,  1),
(25.00, '2026-05-01', '10:05:00', NULL,                  'Confirmada',           2,  1),
(NULL,  '2026-05-02', '09:00:00', NULL,                  'Cancelada',            3,  1),
(25.00, '2026-05-02', '09:10:00', NULL,                  'Confirmada',           4,  1),
(15.00, '2026-06-01', '08:30:00', NULL,                  'Confirmada',           5,  2),
(15.00, '2026-06-01', '08:35:00', NULL,                  'Confirmada',           6,  2),
(15.00, '2026-06-01', '08:40:00', NULL,                  'Confirmada',           7,  2),
(15.00, '2026-06-01', '08:45:00', NULL,                  'Confirmada',           8,  2),
(NULL,  '2026-06-01', '08:50:00', NULL,                  'Em Espera',            9,  2),
( 0.00, '2026-07-01', '09:00:00', NULL,                  'Confirmada',           10, 3),
( 0.00, '2026-07-01', '09:05:00', NULL,                  'Confirmada',           11, 3),
(NULL,  '2026-08-01', '10:20:00', '2026-08-03 23:59:00', 'A Aguardar Pagamento', 12, 4),
(35.00, '2026-08-01', '10:00:00', NULL,                  'Confirmada',           1,  4),
(35.00, '2026-08-01', '10:05:00', NULL,                  'Confirmada',           13, 4),
(35.00, '2026-08-01', '10:10:00', NULL,                  'Confirmada',           14, 4),
(35.00, '2026-08-01', '10:15:00', NULL,                  'Confirmada',           15, 4);

INSERT INTO Equipa (Nome, Nota, Hackathon_Atividade_ID_Atividade)
VALUES
('Code Masters',  18.50, 3),
('Data Warriors', 16.00, 4),
('AI Builders',   19.00, 3),
('Web Wizards',   14.50, 4),
('SecureTeam',    17.00, 7),
('HackForce',     15.50, 7);

INSERT INTO Participante_has_Equipa (Participante_ID_Participante, Equipa_ID_Equipa)
VALUES
(5, 1), (6, 1),       
(5, 2), (6, 2),       
(7, 3), (8, 3),       
(7, 4), (8, 4),       
(1,  5), (13, 5),     
(14, 6), (15, 6);     

INSERT INTO Inscricao_Evento_has_Atividade (Inscricao_Evento_ID_Inscricao, Atividade_ID_Atividade, Data, Hora, Estado)
VALUES
(1, 1, '2026-05-05', '10:00:00', 'Confirmada'),
(2, 1, '2026-05-05', '10:05:00', 'Confirmada'),
(4, 1, '2026-05-05', '10:10:00', 'Em Espera'),
(1, 2, '2026-05-06', '09:00:00', 'Confirmada'),
(2, 2, '2026-05-06', '09:05:00', 'Cancelada'),   

(5, 3, '2026-06-02', '09:00:00', 'Confirmada'),
(6, 3, '2026-06-02', '09:05:00', 'Confirmada'),
(7, 3, '2026-06-02', '09:10:00', 'Confirmada'),
(8, 3, '2026-06-02', '09:15:00', 'Confirmada'),
(5, 4, '2026-06-02', '10:00:00', 'Confirmada'),
(6, 4, '2026-06-02', '10:05:00', 'Confirmada'),
(7, 4, '2026-06-02', '10:10:00', 'Confirmada'),
(8, 4, '2026-06-02', '10:15:00', 'Confirmada'),

(10, 5, '2026-08-01', '09:00:00', 'Confirmada'),
(11, 5, '2026-08-01', '09:05:00', 'Confirmada'),
(10, 8, '2026-08-01', '09:10:00', 'Confirmada'),
(11, 8, '2026-08-01', '09:15:00', 'Confirmada'),

(13, 6, '2026-09-01', '09:00:00', 'Confirmada'),
(14, 6, '2026-09-01', '09:05:00', 'Confirmada'),
(13, 7, '2026-09-01', '10:00:00', 'Confirmada'),
(14, 7, '2026-09-01', '10:05:00', 'Confirmada'),
(15, 7, '2026-09-01', '10:10:00', 'Confirmada'),
(16, 7, '2026-09-01', '10:15:00', 'Confirmada');