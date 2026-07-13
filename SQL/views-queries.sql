-- Todos os eventos com as suas atividades e espaços
SELECT * FROM vw_eventos_atividades;

-- Apenas um evento específico
SELECT * FROM vw_eventos_atividades
WHERE nome_evento = 'Braga Tech Summit';

-- Atividades de um determinado espaço
SELECT nome_evento, titulo_atividade, data_atividade, Hora_Inicio, Hora_Fim
FROM vw_eventos_atividades
WHERE nome_espaco = 'Laboratório Informática';

-- Quantas atividades tem cada evento
SELECT nome_evento, COUNT(ID_Atividade) AS total_atividades
FROM vw_eventos_atividades
GROUP BY ID_Evento, nome_evento;