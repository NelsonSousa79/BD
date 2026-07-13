USE nextevents;

CREATE OR REPLACE VIEW vw_eventos_atividades AS
SELECT
    e.ID_Evento,
    e.Nome            AS nome_evento,
    e.Data_Inicio,
    e.Data_Fim,
    e.Custo,
    e.Lotacao_Maxima,
    a.ID_Atividade,
    a.Titulo          AS titulo_atividade,
    a.Data            AS data_atividade,
    a.Hora_Inicio,
    a.Hora_Fim,
    a.Descricao       AS descricao_atividade,
    a.Lotacao_Especifica,
    es.ID_Espaco,
    es.Nome           AS nome_espaco,
    es.Lotacao_Fisica
FROM Evento e
JOIN Atividade a  ON a.Evento_ID_Evento  = e.ID_Evento
JOIN Espaco    es ON a.Espaco_ID_Espaco  = es.ID_Espaco
ORDER BY e.Data_Inicio, a.Data, a.Hora_Inicio;