-- ===== PACOTE MONITORAMENTO =====
CREATE OR REPLACE PACKAGE pacote_monitoramento AS
    FUNCTION uuid_texto(p_id RAW) RETURN VARCHAR2 DETERMINISTIC;
    FUNCTION consultar_conectividade(
        p_dispositivo_id RAW,
        p_referencia TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
    ) RETURN VARCHAR2;
    PROCEDURE registrar_leitura(
        p_sensor_id RAW,
        p_valor NUMBER,
        p_qualidade VARCHAR2,
        p_registrado_em TIMESTAMP WITH TIME ZONE,
        p_recebido_em TIMESTAMP WITH TIME ZONE,
        p_origem VARCHAR2,
        p_simulado NUMBER,
        p_leitura_id OUT RAW
    );
END pacote_monitoramento;
/

CREATE OR REPLACE PACKAGE BODY pacote_monitoramento AS
    FUNCTION uuid_texto(p_id RAW) RETURN VARCHAR2 DETERMINISTIC IS
        v_hex VARCHAR2(32) := LOWER(RAWTOHEX(p_id));
    BEGIN
        IF p_id IS NULL THEN RETURN NULL; END IF;
        RETURN SUBSTR(v_hex,1,8) || '-' || SUBSTR(v_hex,9,4) || '-' ||
            SUBSTR(v_hex,13,4) || '-' || SUBSTR(v_hex,17,4) || '-' || SUBSTR(v_hex,21,12);
    END uuid_texto;

    FUNCTION consultar_conectividade(
        p_dispositivo_id RAW,
        p_referencia TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
    ) RETURN VARCHAR2 IS
        v_ultima_comunicacao TIMESTAMP WITH TIME ZONE;
    BEGIN
        IF p_referencia IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001,'Informe a data de referencia.');
        END IF;
        SELECT LastSeenAt INTO v_ultima_comunicacao FROM Devices WHERE Id = p_dispositivo_id;
        IF v_ultima_comunicacao IS NULL OR v_ultima_comunicacao > p_referencia THEN
            RETURN 'UNKNOWN';
        ELSIF v_ultima_comunicacao >= p_referencia - INTERVAL '5' MINUTE THEN
            RETURN 'ONLINE';
        ELSIF v_ultima_comunicacao >= p_referencia - INTERVAL '30' MINUTE THEN
            RETURN 'UNSTABLE';
        ELSE
            RETURN 'OFFLINE';
        END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002,'Dispositivo nao encontrado.');
    END consultar_conectividade;

    PROCEDURE registrar_leitura(
        p_sensor_id RAW,
        p_valor NUMBER,
        p_qualidade VARCHAR2,
        p_registrado_em TIMESTAMP WITH TIME ZONE,
        p_recebido_em TIMESTAMP WITH TIME ZONE,
        p_origem VARCHAR2,
        p_simulado NUMBER,
        p_leitura_id OUT RAW
    ) IS
        v_dispositivo_id RAW(16);
    BEGIN
        SELECT DeviceId INTO v_dispositivo_id FROM Sensors WHERE Id = p_sensor_id;
        p_leitura_id := SYS_GUID();
        INSERT INTO Readings(Id,SensorId,Value,Quality,RecordedAt,ReceivedAt,SimulatedData,Origin)
        VALUES(p_leitura_id,p_sensor_id,p_valor,p_qualidade,p_registrado_em,p_recebido_em,p_simulado,p_origem);
        IF p_origem IN('SIMULATED','REAL') THEN
            UPDATE Devices SET LastSeenAt = CASE
                WHEN LastSeenAt IS NULL OR LastSeenAt < p_recebido_em
                THEN p_recebido_em ELSE LastSeenAt END
            WHERE Id = v_dispositivo_id;
        END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003,'Sensor nao encontrado.');
    END registrar_leitura;
END pacote_monitoramento;
/

-- ===== PACOTE ALERTAS =====
CREATE OR REPLACE PACKAGE pacote_alertas AS
    FUNCTION classificar_umidade(p_valor NUMBER,p_qualidade VARCHAR2,p_limite NUMBER) RETURN VARCHAR2;
    PROCEDURE gerar_alerta(p_leitura_id RAW);
END pacote_alertas;
/

CREATE OR REPLACE PACKAGE BODY pacote_alertas AS
    FUNCTION classificar_umidade(p_valor NUMBER,p_qualidade VARCHAR2,p_limite NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF p_limite IS NULL OR p_limite < 0 OR p_limite > 100 THEN
            RAISE_APPLICATION_ERROR(-20004,'Limite de umidade invalido.');
        END IF;
        IF p_qualidade IS NULL OR p_qualidade <> 'VALID' OR p_valor IS NULL OR p_valor < 0 OR p_valor > 100 THEN
            RETURN 'INCONCLUSIVE';
        ELSIF p_valor < p_limite THEN
            RETURN 'LOW';
        ELSE
            RETURN 'ADEQUATE';
        END IF;
    END classificar_umidade;

    PROCEDURE gerar_alerta(p_leitura_id RAW) IS
        v_leitura Readings%ROWTYPE;
        v_dispositivo_id RAW(16);
        v_tipo Sensors.Type%TYPE;
        v_unidade Sensors.Unit%TYPE;
        v_limite NUMBER;
        v_quantidade NUMBER;
        v_alerta_id RAW(16);
        v_titulo VARCHAR2(120);
        v_gravidade VARCHAR2(20);
        v_motivo VARCHAR2(500);
        v_evidencias CLOB;
    BEGIN
        SELECT * INTO v_leitura FROM Readings WHERE Id = p_leitura_id;
        SELECT DeviceId,Type,Unit INTO v_dispositivo_id,v_tipo,v_unidade
        FROM Sensors WHERE Id = v_leitura.SensorId;
        SELECT SoilMoistureThreshold INTO v_limite FROM Devices WHERE Id = v_dispositivo_id FOR UPDATE;
        SELECT COUNT(*) INTO v_quantidade FROM AlertReadings ar
        JOIN Alerts a ON a.Id = ar.AlertId WHERE ar.ReadingId = p_leitura_id AND a.DeviceId = v_dispositivo_id;
        IF v_quantidade > 0 THEN RETURN; END IF;
        IF v_leitura.Quality = 'SENSOR_ERROR' THEN
            v_titulo := 'Falha na medicao do sensor';
            v_gravidade := 'INFO';
            v_motivo := 'Leitura sem valor, identificada como SENSOR_ERROR.';
        ELSIF v_tipo = 'SOIL_MOISTURE'
            AND classificar_umidade(v_leitura.Value,v_leitura.Quality,v_limite) = 'LOW' THEN
            v_titulo := 'Umidade do solo abaixo do limite configurado';
            v_gravidade := 'WARNING';
            v_motivo := 'Leitura valida abaixo do limite de demonstracao do dispositivo.';
        ELSE
            RETURN;
        END IF;
        SELECT JSON_ARRAY(JSON_OBJECT(
            'type' VALUE v_tipo,'value' VALUE v_leitura.Value,'unit' VALUE v_unidade,
            'recordedAt' VALUE TO_CHAR(SYS_EXTRACT_UTC(v_leitura.RecordedAt),'YYYY-MM-DD"T"HH24:MI:SS.FF9"Z"')
            NULL ON NULL RETURNING CLOB) RETURNING CLOB)
        INTO v_evidencias FROM dual;
        v_alerta_id := SYS_GUID();
        INSERT INTO Alerts(Id,DeviceId,Severity,Status,Title,Message,Reason,PushPending,BasedOnJson,CreatedAt)
        VALUES(v_alerta_id,v_dispositivo_id,v_gravidade,'UNREAD',v_titulo,
            'Verifique as condicoes reais e a data da leitura antes de decidir.',
            v_motivo,0,v_evidencias,v_leitura.ReceivedAt);
        INSERT INTO AlertReadings(AlertId,ReadingId) VALUES(v_alerta_id,p_leitura_id);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005,'Leitura ou dispositivo nao encontrado.');
    END gerar_alerta;
END pacote_alertas;
/

-- ===== TRIGGER VALIDACAO =====
CREATE OR REPLACE TRIGGER validar_leitura_sensor
BEFORE INSERT OR UPDATE ON Readings
FOR EACH ROW
BEGIN
    IF :NEW.Quality IS NULL OR :NEW.Quality NOT IN('VALID','OUT_OF_RANGE','SENSOR_ERROR','UNCALIBRATED') THEN
        RAISE_APPLICATION_ERROR(-20006,'Qualidade invalida.');
    END IF;
    IF (:NEW.Quality = 'VALID' AND :NEW.Value IS NULL)
        OR (:NEW.Quality = 'SENSOR_ERROR' AND :NEW.Value IS NOT NULL) THEN
        RAISE_APPLICATION_ERROR(-20007,'Valor incompatível com a qualidade da leitura.');
    END IF;
    IF :NEW.RecordedAt IS NULL OR :NEW.ReceivedAt IS NULL OR :NEW.ReceivedAt < :NEW.RecordedAt THEN
        RAISE_APPLICATION_ERROR(-20008,'Datas da leitura invalidas.');
    END IF;
    IF :NEW.Origin IS NULL OR :NEW.Origin NOT IN('SIMULATED','REAL','ESTIMATED')
        OR (:NEW.Origin = 'SIMULATED' AND :NEW.SimulatedData <> 1)
        OR (:NEW.Origin = 'REAL' AND :NEW.SimulatedData <> 0) THEN
        RAISE_APPLICATION_ERROR(-20009,'Origem incompatível com o indicador de simulacao.');
    END IF;
END;
/

-- ===== TRIGGER PROPRIETARIO DO ALERTA =====
CREATE OR REPLACE TRIGGER definir_proprietario_alerta
BEFORE INSERT OR UPDATE ON Alerts
FOR EACH ROW
BEGIN
    SELECT p.UserId INTO :NEW.OwnerUserId FROM Devices d
    JOIN Fields f ON f.Id = d.FieldId JOIN Properties p ON p.Id = f.PropertyId
    WHERE d.Id = :NEW.DeviceId;
END;
/

-- ===== TRIGGER AUDITORIA =====
CREATE OR REPLACE TRIGGER auditar_alertas
AFTER INSERT OR UPDATE OR DELETE ON Alerts
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_antigos CLOB;
    v_novos CLOB;
BEGIN
    IF INSERTING THEN v_operacao := 'INSERT';
    ELSIF UPDATING THEN v_operacao := 'UPDATE';
    ELSE v_operacao := 'DELETE'; END IF;
    IF UPDATING OR DELETING THEN
        SELECT JSON_OBJECT(
            'id' VALUE pacote_monitoramento.uuid_texto(:OLD.Id),
            'deviceId' VALUE pacote_monitoramento.uuid_texto(:OLD.DeviceId),
            'severity' VALUE :OLD.Severity,'status' VALUE :OLD.Status,
            'title' VALUE :OLD.Title,'message' VALUE :OLD.Message,'reason' VALUE :OLD.Reason,
            'basedOn' VALUE :OLD.BasedOnJson FORMAT JSON,
            'createdAt' VALUE TO_CHAR(SYS_EXTRACT_UTC(:OLD.CreatedAt),'YYYY-MM-DD"T"HH24:MI:SS.FF9"Z"') RETURNING CLOB
        ) INTO v_antigos FROM dual;
    END IF;
    IF INSERTING OR UPDATING THEN
        SELECT JSON_OBJECT(
            'id' VALUE pacote_monitoramento.uuid_texto(:NEW.Id),
            'deviceId' VALUE pacote_monitoramento.uuid_texto(:NEW.DeviceId),
            'severity' VALUE :NEW.Severity,'status' VALUE :NEW.Status,
            'title' VALUE :NEW.Title,'message' VALUE :NEW.Message,'reason' VALUE :NEW.Reason,
            'basedOn' VALUE :NEW.BasedOnJson FORMAT JSON,
            'createdAt' VALUE TO_CHAR(SYS_EXTRACT_UTC(:NEW.CreatedAt),'YYYY-MM-DD"T"HH24:MI:SS.FF9"Z"') RETURNING CLOB
        ) INTO v_novos FROM dual;
    END IF;
    INSERT INTO AlertAudits(Id,AlertId,UserId,Operation,OccurredAt,DatabaseUser,OldValues,NewValues)
    VALUES(SYS_GUID(),COALESCE(:NEW.Id,:OLD.Id),COALESCE(:NEW.OwnerUserId,:OLD.OwnerUserId),v_operacao,
        SYSTIMESTAMP,SYS_CONTEXT('USERENV','SESSION_USER'),v_antigos,v_novos);
END;
/

-- ===== VERIFICACAO DOS OBJETOS =====
DECLARE
    v_erros NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_erros FROM user_errors
    WHERE name IN('PACOTE_MONITORAMENTO','PACOTE_ALERTAS','VALIDAR_LEITURA_SENSOR',
        'DEFINIR_PROPRIETARIO_ALERTA','AUDITAR_ALERTAS');
    IF v_erros > 0 THEN
        RAISE_APPLICATION_ERROR(-20010,'Ha erros de compilacao. Consulte USER_ERRORS.');
    END IF;
END;
/
SELECT name,type,line,position,text FROM user_errors
WHERE name IN('PACOTE_MONITORAMENTO','PACOTE_ALERTAS','VALIDAR_LEITURA_SENSOR',
    'DEFINIR_PROPRIETARIO_ALERTA','AUDITAR_ALERTAS') ORDER BY name,sequence;
