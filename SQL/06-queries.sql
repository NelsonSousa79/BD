USE nextevents;

-- 1. Listar todos os participantes inscritos num evento específico com o estado da inscrição
SELECT 
    p.Nome AS participante,
    p.Email,
    p.Contacto,
    ie.Estado,
    ie.Data AS data_inscricao,
    ie.Valor_Pago
FROM Participante p
JOIN Inscricao_Evento ie ON ie.Participante_ID_Participante = p.ID_Participante
JOIN Evento e ON e.ID_Evento = ie.Evento_ID_Evento
WHERE e.Nome = 'Braga Tech Summit'
ORDER BY ie.Data, ie.Hora;


-- 2. Número de inscrições confirmadas por evento, com percentagem de lotação ocupada
SELECT 
    e.Nome AS evento,
    e.Lotacao_Maxima,
    COUNT(ie.ID_Inscricao) AS inscricoes_confirmadas,
    ROUND(COUNT(ie.ID_Inscricao) * 100.0 / e.Lotacao_Maxima, 1) AS pct_ocupacao
FROM Evento e
LEFT JOIN Inscricao_Evento ie 
    ON ie.Evento_ID_Evento = e.ID_Evento 
    AND ie.Estado = 'Confirmada'
GROUP BY e.ID_Evento, e.Nome, e.Lotacao_Maxima
ORDER BY pct_ocupacao DESC;


-- 3. Workshops com os seus oradores e respetivos eventos
SELECT 
    e.Nome          AS evento,
    a.Titulo        AS workshop,
    a.Data,
    a.Hora_Inicio,
    a.Hora_Fim,
    o.Nome          AS orador,
    o.Especialidade
FROM Workshop w
JOIN Atividade a        ON a.ID_Atividade    = w.Atividade_ID_Atividade
JOIN Evento e           ON e.ID_Evento       = a.Evento_ID_Evento
JOIN Workshop_has_Orador wo ON wo.Workshop_Atividade_ID_Atividade = w.Atividade_ID_Atividade
JOIN Orador o           ON o.ID_Orador       = wo.Orador_ID_Orador
ORDER BY a.Data, a.Hora_Inicio;


-- 4. Equipas de cada hackathon ordenadas pela nota (ranking)
SELECT 
    e.Nome          AS evento,
    a.Titulo        AS hackathon,
    eq.Nome         AS equipa,
    eq.Nota,
    RANK() OVER (PARTITION BY h.Atividade_ID_Atividade ORDER BY eq.Nota DESC) AS posicao
FROM Hackathon h
JOIN Atividade a  ON a.ID_Atividade = h.Atividade_ID_Atividade
JOIN Evento e     ON e.ID_Evento    = a.Evento_ID_Evento
JOIN Equipa eq    ON eq.Hackathon_Atividade_ID_Atividade = h.Atividade_ID_Atividade
ORDER BY a.Data, posicao;


-- 5. Participantes inscritos em mais do que uma atividade, com o total de atividades
SELECT 
    p.Nome              AS participante,
    p.Email,
    COUNT(iea.Atividade_ID_Atividade) AS total_atividades
FROM Participante p
JOIN Inscricao_Evento ie  ON ie.Participante_ID_Participante = p.ID_Participante
JOIN Inscricao_Evento_has_Atividade iea ON iea.Inscricao_Evento_ID_Inscricao = ie.ID_Inscricao
WHERE iea.Estado != 'Cancelada'
GROUP BY p.ID_Participante, p.Nome, p.Email
HAVING COUNT(iea.Atividade_ID_Atividade) > 1
ORDER BY total_atividades DESC;


-- 6. Receita total arrecadada por evento (apenas inscrições confirmadas)
SELECT 
    e.Nome       AS evento,
    e.Custo      AS custo_unitario,
    COUNT(ie.ID_Inscricao)      AS total_confirmadas,
    SUM(ie.Valor_Pago)          AS receita_total,
    AVG(ie.Valor_Pago)          AS valor_medio_pago
FROM Evento e
JOIN Inscricao_Evento ie ON ie.Evento_ID_Evento = e.ID_Evento
WHERE ie.Estado = 'Confirmada'
GROUP BY e.ID_Evento, e.Nome, e.Custo
ORDER BY receita_total DESC;


-- 7. Espaços com atividades agendadas, mostrando taxa de ocupação específica
SELECT 
    es.Nome             AS espaco,
    es.Lotacao_Fisica,
    a.Titulo            AS atividade,
    a.Data,
    a.Hora_Inicio,
    a.Hora_Fim,
    a.Lotacao_Especifica,
    ROUND(a.Lotacao_Especifica * 100.0 / es.Lotacao_Fisica, 1) AS pct_uso_espaco
FROM Espaco es
JOIN Atividade a ON a.Espaco_ID_Espaco = es.ID_Espaco
ORDER BY a.Data, a.Hora_Inicio;


-- 8. Júris e os hackathons em que participam, com média das notas das equipas avaliadas
SELECT 
    j.Nome          AS juri,
    j.Especialidade,
    a.Titulo        AS hackathon,
    e.Nome          AS evento,
    COUNT(eq.ID_Equipa)     AS nr_equipas,
    ROUND(AVG(eq.Nota), 2)  AS media_notas
FROM Juri j
JOIN Juri_has_Hackathon jh ON jh.Juri_ID_Juri           = j.ID_Juri
JOIN Hackathon h           ON h.Atividade_ID_Atividade   = jh.Hackathon_Atividade_ID_Atividade
JOIN Atividade a           ON a.ID_Atividade             = h.Atividade_ID_Atividade
JOIN Evento e              ON e.ID_Evento                = a.Evento_ID_Evento
JOIN Equipa eq             ON eq.Hackathon_Atividade_ID_Atividade = h.Atividade_ID_Atividade
GROUP BY j.ID_Juri, j.Nome, j.Especialidade, h.Atividade_ID_Atividade, a.Titulo, e.Nome
ORDER BY hackathon, media_notas DESC;


-- 9. Inscrições a aguardar pagamento com prazo ainda não expirado
SELECT 
    p.Nome              AS participante,
    p.Email,
    e.Nome              AS evento,
    ie.Data             AS data_inscricao,
    ie.Prazo_Pagamento,
    TIMESTAMPDIFF(HOUR, NOW(), ie.Prazo_Pagamento) AS horas_restantes
FROM Inscricao_Evento ie
JOIN Participante p ON p.ID_Participante = ie.Participante_ID_Participante
JOIN Evento e       ON e.ID_Evento       = ie.Evento_ID_Evento
WHERE ie.Estado = 'A Aguardar Pagamento'
  AND ie.Prazo_Pagamento > NOW()
ORDER BY ie.Prazo_Pagamento ASC;


-- 10. Participantes e todas as equipas em que participam, com o hackathon correspondente
SELECT 
    p.Nome          AS participante,
    eq.Nome         AS equipa,
    eq.Nota,
    a.Titulo        AS hackathon,
    ev.Nome         AS evento,
    RANK() OVER (PARTITION BY h.Atividade_ID_Atividade ORDER BY eq.Nota DESC) AS posicao_equipa
FROM Participante p
JOIN Participante_has_Equipa pe ON pe.Participante_ID_Participante = p.ID_Participante
JOIN Equipa eq  ON eq.ID_Equipa                       = pe.Equipa_ID_Equipa
JOIN Hackathon h ON h.Atividade_ID_Atividade          = eq.Hackathon_Atividade_ID_Atividade
JOIN Atividade a ON a.ID_Atividade                    = h.Atividade_ID_Atividade
JOIN Evento ev   ON ev.ID_Evento                      = a.Evento_ID_Evento
ORDER BY hackathon, posicao_equipa, p.Nome;