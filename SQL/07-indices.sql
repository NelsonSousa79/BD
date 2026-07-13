USE nextevents;

-- 1. Pesquisas frequentes por estado e evento em Inscricao_Evento
-- Acelera queries que filtram inscrições por estado (ex: 'Confirmada', 'A Aguardar Pagamento')
-- e que agrupam/contam por evento. Cobre as queries 2, 6 e 9
CREATE INDEX idx_inscricao_evento_estado
    ON Inscricao_Evento (Evento_ID_Evento, Estado);


-- 2. Pesquisas por data e evento em Atividade
-- Acelera ordenações e filtros por data dentro de um evento — cobre as queries 3, 7 e a VIEW
CREATE INDEX idx_atividade_evento_data
    ON Atividade (Evento_ID_Evento, Data, Hora_Inicio);


-- 3. Lookup de atividades por espaço
-- Acelera joins entre Atividade e Espaco, útil para relatórios de ocupação de salas — cobre a query 7
CREATE INDEX idx_atividade_espaco
    ON Atividade (Espaco_ID_Espaco);


-- 4. Inscrições a aguardar pagamento com prazo
-- Acelera a query 9 que filtra por estado e ordena pelo prazo de pagamento
CREATE INDEX idx_inscricao_estado_prazo
    ON Inscricao_Evento (Estado, Prazo_Pagamento);


-- 5. Participante por email e contacto (colunas UNIQUE já indexadas, índice composto para pesquisa combinada)
-- Acelera autenticações ou pesquisas que usem email + contacto em simultâneo
CREATE INDEX idx_participante_email_contacto
    ON Participante (Email, Contacto);