-- ===== INSERTS =====

------------------- USERS ----------------------
INSERT INTO Users(Id,Name,Email,PasswordHash,CreatedAt,Role,Active)
VALUES(HEXTORAW('10000000000040008000000000000001'),'Produtor Demonstracao SQL',
    'produtor.sql@terrabyte.test','!SQL_ONLY_LOCKED!',SYSTIMESTAMP,'USER',0);
INSERT INTO Users(Id,Name,Email,PasswordHash,CreatedAt,Role,Active)
VALUES(HEXTORAW('10000000000040008000000000000002'),'Administrador Demonstracao SQL',
    'admin.sql@terrabyte.test','!SQL_ONLY_LOCKED!',SYSTIMESTAMP,'ADMIN',0);

------------------- PROPERTIES ----------------------
INSERT INTO Properties(Id,UserId,Name,City,State,AreaHectares,Description,CreatedAt,UpdatedAt)
VALUES(HEXTORAW('20000000000040008000000000000001'),HEXTORAW('10000000000040008000000000000001'),
    'Sitio Boa Esperanca SQL','Carapicuiba','SP',0.500,'Propriedade ficticia para entrega de banco.',SYSTIMESTAMP,SYSTIMESTAMP);

------------------- FIELDS ----------------------
INSERT INTO Fields(Id,PropertyId,Name,AreaHectares)
VALUES(HEXTORAW('30000000000040008000000000000001'),HEXTORAW('20000000000040008000000000000001'),'Canteiro 01',0.003);
INSERT INTO Fields(Id,PropertyId,Name,AreaHectares)
VALUES(HEXTORAW('30000000000040008000000000000002'),HEXTORAW('20000000000040008000000000000001'),'Canteiro 02',0.0024);

------------------- CROPS ----------------------
INSERT INTO Crops(Id,UserId,Code,Name,ScientificName,Description)
VALUES(HEXTORAW('40000000000040008000000000000001'),HEXTORAW('10000000000040008000000000000001'),
    'ALFACE','Alface','Lactuca sativa','Cultura utilizada na demonstracao.');

------------------- PLANTINGS ----------------------
INSERT INTO Plantings(Id,FieldId,CropId,CropName,PlantedAt,Stage,Variety,Status)
VALUES(HEXTORAW('50000000000040008000000000000001'),HEXTORAW('30000000000040008000000000000001'),
    HEXTORAW('40000000000040008000000000000001'),'Alface',
    TO_TIMESTAMP_TZ('2026-10-20 00:00:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM'),'VEGETATIVE','Crespa','ACTIVE');
INSERT INTO Plantings(Id,FieldId,CropId,CropName,PlantedAt,Stage,Variety,Status)
VALUES(HEXTORAW('50000000000040008000000000000002'),HEXTORAW('30000000000040008000000000000002'),
    HEXTORAW('40000000000040008000000000000001'),'Alface',
    TO_TIMESTAMP_TZ('2026-10-24 00:00:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM'),'VEGETATIVE','Americana','ACTIVE');

------------------- DEVICES ----------------------
INSERT INTO Devices(Id,FieldId,Code,Name,LastSeenAt,Rssi,FirmwareVersion,Transport,SimulatedData,SoilMoistureThreshold)
VALUES(HEXTORAW('60000000000040008000000000000001'),HEXTORAW('30000000000040008000000000000001'),
    'DB-ESP32-001','Estacao do Canteiro 01',NULL,-61,'1.0.0','WIFI',1,30);
INSERT INTO Devices(Id,FieldId,Code,Name,LastSeenAt,Rssi,FirmwareVersion,Transport,SimulatedData,SoilMoistureThreshold)
VALUES(HEXTORAW('60000000000040008000000000000002'),HEXTORAW('30000000000040008000000000000002'),
    'DB-ESP32-002','Estacao do Canteiro 02',NULL,NULL,'1.0.0','WIFI',1,30);

------------------- SENSORS ----------------------
INSERT INTO Sensors(Id,DeviceId,Type,Label,Unit,Code,Calibrated)
VALUES(HEXTORAW('70000000000040008000000000000001'),HEXTORAW('60000000000040008000000000000001'),
    'SOIL_MOISTURE','Umidade do solo','%','DB-SOLO-001',1);
INSERT INTO Sensors(Id,DeviceId,Type,Label,Unit,Code,Calibrated)
VALUES(HEXTORAW('70000000000040008000000000000002'),HEXTORAW('60000000000040008000000000000001'),
    'AIR_TEMPERATURE','Temperatura do ar','°C','DB-AR-001',1);
INSERT INTO Sensors(Id,DeviceId,Type,Label,Unit,Code,Calibrated)
VALUES(HEXTORAW('70000000000040008000000000000003'),HEXTORAW('60000000000040008000000000000001'),
    'AIR_HUMIDITY','Umidade do ar','%','DB-AR-002',1);
INSERT INTO Sensors(Id,DeviceId,Type,Label,Unit,Code,Calibrated)
VALUES(HEXTORAW('70000000000040008000000000000004'),HEXTORAW('60000000000040008000000000000001'),
    'LIGHT_ILLUMINANCE','Iluminancia','lux','DB-LUZ-001',1);
INSERT INTO Sensors(Id,DeviceId,Type,Label,Unit,Code,Calibrated)
VALUES(HEXTORAW('70000000000040008000000000000005'),HEXTORAW('60000000000040008000000000000002'),
    'SOIL_MOISTURE','Umidade do solo indisponivel','%','DB-SOLO-002',0);

------------------- READINGS ----------------------
DECLARE
    v_id RAW(16);
    v_referencia TIMESTAMP WITH TIME ZONE :=
        TO_TIMESTAMP_TZ('2026-11-15 14:04:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM');
BEGIN
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),35.2,'VALID',v_referencia - INTERVAL '3' HOUR,v_referencia - INTERVAL '3' HOUR,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),29.5,'VALID',v_referencia - INTERVAL '2' HOUR,v_referencia - INTERVAL '2' HOUR,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),24.5,'VALID',v_referencia - INTERVAL '1' HOUR,v_referencia - INTERVAL '1' HOUR,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),23.8,'VALID',v_referencia,v_referencia,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000002'),25.1,'VALID',v_referencia - INTERVAL '1' HOUR,v_referencia - INTERVAL '1' HOUR,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000002'),27.3,'VALID',v_referencia,v_referencia,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000003'),65,'VALID',v_referencia - INTERVAL '1' HOUR,v_referencia - INTERVAL '1' HOUR,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000003'),63,'VALID',v_referencia,v_referencia,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000004'),11000,'VALID',v_referencia - INTERVAL '1' HOUR,v_referencia - INTERVAL '1' HOUR,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000004'),12500,'VALID',v_referencia,v_referencia,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000005'),NULL,'SENSOR_ERROR',v_referencia - INTERVAL '2' DAY,v_referencia - INTERVAL '2' DAY,'SIMULATED',1,v_id);
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000005'),NULL,'UNCALIBRATED',v_referencia - INTERVAL '3' DAY,v_referencia - INTERVAL '3' DAY,'SIMULATED',1,v_id);
END;
/

-- ===== BLOCO 1 =====
BEGIN
    FOR registro IN(SELECT r.Id FROM Readings r JOIN Sensors s ON s.Id = r.SensorId
        JOIN Devices d ON d.Id = s.DeviceId WHERE d.Code IN('DB-ESP32-001','DB-ESP32-002')
        ORDER BY r.RecordedAt,r.Id) LOOP
        pacote_alertas.gerar_alerta(registro.Id);
    END LOOP;
END;
/

------------------- DEVICEEVENTS ----------------------
INSERT INTO DeviceEvents(Id,DeviceId,Type,Description,OccurredAt,Origin)
VALUES(SYS_GUID(),HEXTORAW('60000000000040008000000000000002'),'DISCONNECTED',
    'Dispositivo sem comunicacao recente; dados simulados.',
    TO_TIMESTAMP_TZ('2026-11-13 14:05:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM'),'SIMULATED');

------------------- RECOMMENDATIONS ----------------------
DECLARE
    v_id RAW(16) := SYS_GUID();
BEGIN
    FOR registro IN(SELECT Id,BasedOnJson FROM Alerts
        WHERE DeviceId = HEXTORAW('60000000000040008000000000000001') AND Severity = 'WARNING'
        ORDER BY CreatedAt DESC,Id FETCH FIRST 1 ROW ONLY) LOOP
        INSERT INTO Recommendations(Id,DeviceId,Priority,Title,Message,Reason,Disclaimer,
            SimulatedData,ModelName,BasedOnJson,GeneratedAt,AiGenerated)
        VALUES(v_id,HEXTORAW('60000000000040008000000000000001'),'WARNING','Avaliar a necessidade de irrigacao',
            'Confira o solo e o sensor antes de decidir.','Umidade simulada abaixo do limite demonstrativo.',
            'Exemplo manual com dados simulados; nao representa uma chamada real ao modelo.',
            1,'DEMONSTRACAO_MANUAL',registro.BasedOnJson,SYSTIMESTAMP,0);
        INSERT INTO RecommendationReadings(RecommendationId,ReadingId)
        SELECT v_id,ReadingId FROM AlertReadings WHERE AlertId = registro.Id;
    END LOOP;
END;
/

------------------- AIINTERACTIONS ----------------------
INSERT INTO AiInteractions(Id,UserId,PropertyId,DeviceId,Question,Response,Context,ModelName,CreatedAt)
VALUES(SYS_GUID(),HEXTORAW('10000000000040008000000000000001'),HEXTORAW('20000000000040008000000000000001'),
    HEXTORAW('60000000000040008000000000000001'),'Como interpretar a umidade do solo?',
    'Exemplo manual: conferir as condicoes reais.','{"simulatedData":true,"source":"SQL_DEMO"}',
    'DEMONSTRACAO_MANUAL',SYSTIMESTAMP);

------------------- WEATHERHISTORY ----------------------
INSERT INTO WeatherHistory(Id,PropertyId,ObservedAt,TemperatureC,RelativeHumidity,PrecipitationMm,WindSpeedKmh,Origin)
VALUES(SYS_GUID(),HEXTORAW('20000000000040008000000000000001'),
    TO_TIMESTAMP_TZ('2026-11-15 14:00:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM'),27.3,63,0,8.5,'SIMULATED');

-- ===== BLOCO 2 =====
DECLARE
    v_situacao VARCHAR2(20);
BEGIN
    FOR registro IN(SELECT Id,Code FROM Devices WHERE Code IN('DB-ESP32-001','DB-ESP32-002') ORDER BY Code) LOOP
        v_situacao := pacote_monitoramento.consultar_conectividade(registro.Id,
            TO_TIMESTAMP_TZ('2026-11-15 14:05:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM'));
        IF v_situacao = 'OFFLINE' THEN
            DBMS_OUTPUT.PUT_LINE(registro.Code || ': OFFLINE - verificar conexao.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(registro.Code || ': ' || v_situacao);
        END IF;
    END LOOP;
END;
/
COMMIT;

-- ===== TESTES =====
DECLARE
    v_leitura RAW(16);
    v_alerta RAW(16);
    v_alerta_cascata RAW(16);
    v_quantidade NUMBER;
    v_referencia TIMESTAMP WITH TIME ZONE :=
        TO_TIMESTAMP_TZ('2026-11-15 14:05:00 +00:00','YYYY-MM-DD HH24:MI:SS TZH:TZM');
    PROCEDURE conferir(p_condicao BOOLEAN,p_mensagem VARCHAR2) IS
    BEGIN
        IF p_condicao IS NULL OR NOT p_condicao THEN RAISE_APPLICATION_ERROR(-20100,p_mensagem); END IF;
        DBMS_OUTPUT.PUT_LINE('OK: ' || p_mensagem);
    END;
BEGIN
    SAVEPOINT inicio_testes;
    conferir(pacote_monitoramento.consultar_conectividade(HEXTORAW('60000000000040008000000000000001'),v_referencia) = 'ONLINE','Dispositivo online');
    conferir(pacote_monitoramento.consultar_conectividade(HEXTORAW('60000000000040008000000000000002'),v_referencia) = 'OFFLINE','Dispositivo offline');
    UPDATE Devices SET LastSeenAt = v_referencia - INTERVAL '20' MINUTE WHERE Id = HEXTORAW('60000000000040008000000000000001');
    conferir(pacote_monitoramento.consultar_conectividade(HEXTORAW('60000000000040008000000000000001'),v_referencia) = 'UNSTABLE','Dispositivo instavel');
    conferir(pacote_alertas.classificar_umidade(23.8,'VALID',30) = 'LOW','Umidade baixa');
    conferir(pacote_alertas.classificar_umidade(30,'VALID',30) = 'ADEQUATE','Umidade no limite');
    conferir(pacote_alertas.classificar_umidade(NULL,'SENSOR_ERROR',30) = 'INCONCLUSIVE','Falha sem valor inventado');
    pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),20,'VALID',v_referencia,v_referencia,'SIMULATED',1,v_leitura);
    pacote_alertas.gerar_alerta(v_leitura);
    pacote_alertas.gerar_alerta(v_leitura);
    SELECT COUNT(*) INTO v_quantidade FROM AlertReadings WHERE ReadingId = v_leitura;
    conferir(v_quantidade = 1,'Alerta sem duplicacao por leitura');
    SELECT AlertId INTO v_alerta FROM AlertReadings WHERE ReadingId = v_leitura;
    SELECT COUNT(*) INTO v_quantidade FROM AlertAudits WHERE AlertId = v_alerta AND Operation = 'INSERT';
    conferir(v_quantidade = 1,'Auditoria de inclusao');
    UPDATE Alerts SET Status = 'READ' WHERE Id = v_alerta;
    SELECT COUNT(*) INTO v_quantidade FROM AlertAudits WHERE AlertId = v_alerta AND Operation = 'UPDATE'
        AND JSON_VALUE(OldValues,'$.status') = 'UNREAD' AND JSON_VALUE(NewValues,'$.status') = 'READ';
    conferir(v_quantidade = 1,'Auditoria com valores antigos e novos');
    DELETE FROM Alerts WHERE Id = v_alerta;
    SELECT COUNT(*) INTO v_quantidade FROM AlertAudits WHERE AlertId = v_alerta AND Operation = 'DELETE' AND NewValues IS NULL;
    conferir(v_quantidade = 1,'Auditoria preservada na exclusao');
    BEGIN
        pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),NULL,'VALID',v_referencia,v_referencia,'SIMULATED',1,v_leitura);
        RAISE_APPLICATION_ERROR(-20101,'Leitura valida sem valor foi aceita.');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -20007 THEN RAISE; END IF;
        DBMS_OUTPUT.PUT_LINE('OK: leitura valida sem valor rejeitada.');
    END;
    BEGIN
        pacote_monitoramento.registrar_leitura(HEXTORAW('70000000000040008000000000000001'),20,'VALID',v_referencia,v_referencia - INTERVAL '1' MINUTE,'SIMULATED',1,v_leitura);
        RAISE_APPLICATION_ERROR(-20102,'Datas inconsistentes foram aceitas.');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -20008 THEN RAISE; END IF;
        DBMS_OUTPUT.PUT_LINE('OK: datas inconsistentes rejeitadas.');
    END;
    SELECT Id INTO v_alerta_cascata FROM Alerts WHERE DeviceId = HEXTORAW('60000000000040008000000000000002');
    DELETE FROM Devices WHERE Id = HEXTORAW('60000000000040008000000000000002');
    SELECT COUNT(*) INTO v_quantidade FROM AlertAudits WHERE AlertId = v_alerta_cascata AND Operation = 'DELETE';
    conferir(v_quantidade = 1,'Auditoria de exclusao em cascata');
    ROLLBACK TO inicio_testes;
    DBMS_OUTPUT.PUT_LINE('TESTES CONCLUIDOS. Alteracoes de teste revertidas.');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK TO inicio_testes;
    RAISE;
END;
/

-- ===== RELATORIOS =====
------------------- RELATORIO 1 ----------------------
SELECT d.Code AS dispositivo,pacote_monitoramento.uuid_texto(r.Id) AS leitura_id,
    r.Value,s.Unit,r.Quality,
    TO_CHAR(SYS_EXTRACT_UTC(r.RecordedAt),'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS registrado_em
FROM Readings r JOIN Sensors s ON s.Id = r.SensorId JOIN Devices d ON d.Id = s.DeviceId
WHERE d.Code = 'DB-ESP32-001' AND s.Type = 'SOIL_MOISTURE' ORDER BY r.RecordedAt,r.Id;

------------------- RELATORIO 2 ----------------------
SELECT d.Code AS dispositivo,s.Code AS sensor,s.Type,r.Quality
FROM Readings r JOIN Sensors s ON s.Id = r.SensorId JOIN Devices d ON d.Id = s.DeviceId
WHERE r.Quality = 'SENSOR_ERROR' AND r.Value IS NULL ORDER BY d.Code,s.Code;

------------------- RELATORIO 3 ----------------------
SELECT d.Code AS dispositivo,s.Type,COUNT(*) AS quantidade,ROUND(AVG(r.Value),2) AS media,
    MIN(r.Value) AS minimo,MAX(r.Value) AS maximo
FROM Readings r JOIN Sensors s ON s.Id = r.SensorId JOIN Devices d ON d.Id = s.DeviceId
WHERE r.Quality = 'VALID' GROUP BY d.Code,s.Type ORDER BY d.Code,s.Type;

------------------- RELATORIO 4 ----------------------
SELECT pacote_monitoramento.uuid_texto(AlertId) AS alerta,Operation,DatabaseUser,OccurredAt
FROM AlertAudits ORDER BY OccurredAt,Id;
