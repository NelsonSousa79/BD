USE nextevents;

-- FUNÇÃO --------------------------------------------------------

-- Calcula o total de receita confirmada de um evento
DELIMITER $$

CREATE FUNCTION fn_receita_evento(p_id_evento INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_receita DECIMAL(10,2);

    SELECT COALESCE(SUM(Valor_Pago), 0)
    INTO v_receita
    FROM Inscricao_Evento
    WHERE Evento_ID_Evento = p_id_evento
      AND Estado = 'Confirmada';

    RETURN v_receita;
END$$

DELIMITER ;

-- Exemplo:
-- SELECT Nome, fn_receita_evento(ID_Evento) AS receita_total FROM Evento;




-- PROCEDIMENTO --------------------------------------------------

-- Inscreve um participante num evento:
-- - Verifica se já existe inscrição ativa
-- - Verifica se há vagas (lotação máxima)
-- - Define o estado como 'Confirmada' ou 'Em Espera'
-- - Atribui prazo de pagamento se o evento tiver custo
DELIMITER $$

CREATE PROCEDURE sp_inscrever_participante(
    IN  p_participante_id  INT,
    IN  p_evento_id        INT,
    IN  p_valor_pago       DECIMAL(10,2),
    OUT p_resultado        VARCHAR(100)
)
BEGIN
    DECLARE v_lotacao_max     INT;
    DECLARE v_inscritos       INT;
    DECLARE v_custo           DECIMAL(10,2);
    DECLARE v_ja_inscrito     INT;
    DECLARE v_estado          VARCHAR(45);
    DECLARE v_prazo           DATETIME;

    -- Verifica se o participante já tem inscrição ativa no evento
    SELECT COUNT(*) INTO v_ja_inscrito
    FROM Inscricao_Evento
    WHERE Participante_ID_Participante = p_participante_id
      AND Evento_ID_Evento = p_evento_id
      AND Estado NOT IN ('Cancelada');

    IF v_ja_inscrito > 0 THEN
        SET p_resultado = 'ERRO: Participante já tem inscrição ativa neste evento.';
    ELSE
        -- Obtém lotação máxima e custo do evento
        SELECT Lotacao_Maxima, COALESCE(Custo, 0)
        INTO v_lotacao_max, v_custo
        FROM Evento
        WHERE ID_Evento = p_evento_id;

        -- Conta inscrições confirmadas ou em espera
        SELECT COUNT(*) INTO v_inscritos
        FROM Inscricao_Evento
        WHERE Evento_ID_Evento = p_evento_id
          AND Estado IN ('Confirmada', 'A Aguardar Pagamento');

        -- Define estado e prazo conforme vagas e custo
        IF v_inscritos >= v_lotacao_max THEN
            SET v_estado = 'Em Espera';
            SET v_prazo  = NULL;
        ELSEIF v_custo > 0 AND (p_valor_pago IS NULL OR p_valor_pago = 0) THEN
            SET v_estado = 'A Aguardar Pagamento';
            SET v_prazo  = DATE_ADD(NOW(), INTERVAL 48 HOUR);
        ELSE
            SET v_estado = 'Confirmada';
            SET v_prazo  = NULL;
        END IF;

        INSERT INTO Inscricao_Evento (
            Valor_Pago,
            Data,
            Hora,
            Prazo_Pagamento,
            Estado,
            Participante_ID_Participante,
            Evento_ID_Evento
        ) VALUES (
            p_valor_pago,
            CURDATE(),
            CURTIME(),
            v_prazo,
            v_estado,
            p_participante_id,
            p_evento_id
        );

        SET p_resultado = CONCAT('Inscrição criada com estado "', v_estado, '".');
    END IF;
END$$

DELIMITER ;

-- Exemplos:
-- CALL sp_inscrever_participante(3, 1, 25.00, @res); SELECT @res;
-- CALL sp_inscrever_participante(3, 2, NULL,  @res); SELECT @res;




-- TRIGGERS ------------------------------------------------------

-- TRIGGER 1
-- Impede inscrição numa atividade se o participante
-- não estiver inscrito no evento correspondente
DELIMITER $$

CREATE TRIGGER trg_validar_inscricao_atividade
BEFORE INSERT ON Inscricao_Evento_has_Atividade
FOR EACH ROW
BEGIN
    DECLARE v_evento_id        INT;
    DECLARE v_inscricao_valida INT;

    -- Obtém o evento a que a atividade pertence
    SELECT Evento_ID_Evento INTO v_evento_id
    FROM Atividade
    WHERE ID_Atividade = NEW.Atividade_ID_Atividade;

    -- Verifica se a inscrição no evento está ativa
    SELECT COUNT(*) INTO v_inscricao_valida
    FROM Inscricao_Evento
    WHERE ID_Inscricao              = NEW.Inscricao_Evento_ID_Inscricao
      AND Evento_ID_Evento          = v_evento_id
      AND Estado NOT IN ('Cancelada');

    IF v_inscricao_valida = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: O participante não tem inscrição ativa no evento desta atividade.';
    END IF;
END$$

DELIMITER ;


-- TRIGGER 2
-- Ao cancelar uma inscrição num evento, cancela automaticamente
-- todas as reservas de atividades associadas a essa inscrição
DELIMITER $$

CREATE TRIGGER trg_cancelar_atividades_inscricao
AFTER UPDATE ON Inscricao_Evento
FOR EACH ROW
BEGIN
    IF NEW.Estado = 'Cancelada' AND OLD.Estado != 'Cancelada' THEN
        UPDATE Inscricao_Evento_has_Atividade
        SET Estado = 'Cancelada'
        WHERE Inscricao_Evento_ID_Inscricao = NEW.ID_Inscricao
          AND Estado != 'Cancelada';
    END IF;
END$$

DELIMITER ;


-- TRIGGER 3
-- Impede que uma equipa seja inserida num hackathon
-- se o número de membros violar os limites definidos
-- (Lotacao_Minima_Equipa e Lotacao_Maxima_Equipa)
DELIMITER $$

CREATE TRIGGER trg_validar_membros_equipa
BEFORE INSERT ON Participante_has_Equipa
FOR EACH ROW
BEGIN
    DECLARE v_hackathon_id  INT;
    DECLARE v_min_equipa    INT;
    DECLARE v_max_equipa    INT;
    DECLARE v_membros_atuais INT;

    -- Obtém o hackathon da equipa
    SELECT Hackathon_Atividade_ID_Atividade INTO v_hackathon_id
    FROM Equipa
    WHERE ID_Equipa = NEW.Equipa_ID_Equipa;

    -- Obtém os limites de lotação do hackathon
    SELECT Lotacao_Minima_Equipa, Lotacao_Maxima_Equipa
    INTO v_min_equipa, v_max_equipa
    FROM Hackathon
    WHERE Atividade_ID_Atividade = v_hackathon_id;

    -- Conta membros atuais da equipa
    SELECT COUNT(*) INTO v_membros_atuais
    FROM Participante_has_Equipa
    WHERE Equipa_ID_Equipa = NEW.Equipa_ID_Equipa;

    -- Bloqueia se a equipa já atingiu o máximo
    IF v_membros_atuais >= v_max_equipa THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: A equipa já atingiu a lotação máxima permitida para este hackathon.';
    END IF;
END$$

DELIMITER ;