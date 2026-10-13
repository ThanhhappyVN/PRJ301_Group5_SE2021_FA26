USE master;
GO

IF DB_ID('PRJ301_PUMP') IS NOT NULL
BEGIN
    ALTER DATABASE PRJ301_PUMP SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PRJ301_PUMP;
END
GO

CREATE DATABASE PRJ301_PUMP;
GO

USE PRJ301_PUMP;
GO
CREATE TABLE Users (user_id INT IDENTITY PRIMARY KEY, username NVARCHAR(50) UNIQUE NOT NULL,
  password_hash CHAR(60) NOT NULL, full_name NVARCHAR(80), status NVARCHAR(20) DEFAULT 'ACTIVE',
  created_at DATETIME2 DEFAULT SYSUTCDATETIME());
CREATE TABLE Roles (role_id INT IDENTITY PRIMARY KEY, role_name NVARCHAR(30) UNIQUE NOT NULL);
CREATE TABLE UserRole (user_id INT REFERENCES Users, role_id INT REFERENCES Roles, PRIMARY KEY (user_id, role_id));
CREATE TABLE Permissions (perm_id INT IDENTITY PRIMARY KEY, resource NVARCHAR(40), action NVARCHAR(10),
  UNIQUE (resource, action));
CREATE TABLE RolePerm (role_id INT REFERENCES Roles, perm_id INT REFERENCES Permissions, PRIMARY KEY (role_id, perm_id));
CREATE TABLE Device (device_id INT IDENTITY PRIMARY KEY, device_code NVARCHAR(30) UNIQUE, location NVARCHAR(80),
  firmware NVARCHAR(20), status NVARCHAR(20) DEFAULT 'ACTIVE', control_owner INT NULL REFERENCES Users,
  last_seen DATETIME2 NULL, api_key_hash CHAR(64) NOT NULL);
CREATE TABLE SensorType (sensor_type_id INT IDENTITY PRIMARY KEY, name NVARCHAR(40), unit NVARCHAR(20),
  min_valid FLOAT, max_valid FLOAT);
CREATE TABLE Calibration (calib_id INT IDENTITY PRIMARY KEY, device_id INT REFERENCES Device,
  sensor_type_id INT REFERENCES SensorType, offset_val FLOAT, scale_val FLOAT, version INT,
  valid_until DATE, created_by INT REFERENCES Users);
CREATE TABLE OperatingProfile (profile_id INT IDENTITY PRIMARY KEY, device_id INT REFERENCES Device,
  params_json NVARCHAR(MAX), updated_by INT REFERENCES Users, updated_at DATETIME2 DEFAULT SYSUTCDATETIME());
CREATE TABLE Alert (alert_id INT IDENTITY PRIMARY KEY, device_id INT REFERENCES Device, session_id BIGINT,
  source NVARCHAR(10), label NVARCHAR(40), risk_score FLOAT NULL, status NVARCHAR(20) DEFAULT 'OPEN',
  created_at DATETIME2 DEFAULT SYSUTCDATETIME());
CREATE TABLE AlertEvidence (evidence_id INT IDENTITY PRIMARY KEY, alert_id INT REFERENCES Alert,
  item NVARCHAR(60), value_text NVARCHAR(200));
CREATE TABLE MaintenanceTicket (ticket_id INT IDENTITY PRIMARY KEY, alert_id INT NULL REFERENCES Alert,
  device_id INT REFERENCES Device, assigned_to INT REFERENCES Users, note NVARCHAR(400),
  status NVARCHAR(20) DEFAULT 'OPEN', opened_at DATETIME2 DEFAULT SYSUTCDATETIME(), closed_at DATETIME2 NULL);
CREATE TABLE AuditLog (audit_id BIGINT IDENTITY PRIMARY KEY, actor_user_id INT, action NVARCHAR(50),
  object_type NVARCHAR(50), object_id BIGINT, diff_json NVARCHAR(MAX),
  ts DATETIME2(7) DEFAULT SYSUTCDATETIME(), row_hash CHAR(64) NULL);
CREATE TABLE HashChain (anchor_id BIGINT IDENTITY PRIMARY KEY, audit_id BIGINT REFERENCES AuditLog,
  prev_hash CHAR(64), chain_hash CHAR(64));
CREATE TABLE PumpRun (
  session_id BIGINT IDENTITY PRIMARY KEY,
  device_id INT NOT NULL REFERENCES Device,
  device_seq INT NOT NULL,                    -- sequence number on the device, prevents duplicates
  measured_at DATETIME2 NOT NULL,             -- time measured on the device
  ingested_at DATETIME2 DEFAULT SYSUTCDATETIME(),   -- time received by the server
  vib1_rms FLOAT,
  current_a FLOAT,
  pressure_bar FLOAT,
  fluid_temp_c FLOAT,
  flow_lpm FLOAT,
  UNIQUE (device_id, device_seq));
CREATE TABLE PumpRunLabel (
  session_id BIGINT PRIMARY KEY REFERENCES PumpRun,
  label NVARCHAR(40) NOT NULL,                -- one of: NORMAL, PARTIAL_VALVE_CLOSURE, IMBALANCE, LEAK, CAVITATION, SENSOR_FAULT
  labeled_by INT REFERENCES Users,
  labeled_at DATETIME2 DEFAULT SYSUTCDATETIME());
CREATE TABLE PumpRunReading (
  reading_id BIGINT IDENTITY PRIMARY KEY,
  session_id BIGINT REFERENCES PumpRun,
  sensor_type_id INT REFERENCES SensorType,
  measured_at DATETIME2, value FLOAT);
CREATE TABLE Valve (
  valve_id INT IDENTITY PRIMARY KEY,
  valve_code NVARCHAR(20),
  pump_id INT,
  position NVARCHAR(20),
  status NVARCHAR(20),
  created_at DATETIME2 DEFAULT SYSUTCDATETIME());
CREATE TABLE PumpSystem (
    system_id INT IDENTITY PRIMARY KEY,
    system_code NVARCHAR(30) UNIQUE NOT NULL,
    system_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(100),
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSUTCDATETIME()
);

CREATE TABLE Pump (
    pump_id INT IDENTITY PRIMARY KEY,
    pump_code NVARCHAR(30) UNIQUE NOT NULL,
    system_id INT NOT NULL REFERENCES PumpSystem(system_id),
    pump_name NVARCHAR(100) NOT NULL,
    model NVARCHAR(80),
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSUTCDATETIME()
);

CREATE TABLE TestScenario (
    scenario_id INT IDENTITY PRIMARY KEY,
    scenario_code NVARCHAR(30) UNIQUE NOT NULL,
    scenario_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    expected_label NVARCHAR(40),
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO
ALTER TABLE Valve
ADD CONSTRAINT FK_Valve_Pump
FOREIGN KEY (pump_id) REFERENCES Pump(pump_id);
GO
-- sessions are append-only: block every update and delete
CREATE TRIGGER trg_PumpRun_AppendOnly ON PumpRun INSTEAD OF UPDATE, DELETE AS
BEGIN
  RAISERROR(N'Session records are append-only', 16, 1);
END;
GO
-- feature view consumed by the machine learning step
CREATE VIEW v_PumpRun_Features AS
SELECT s.session_id, s.device_id, s.vib1_rms, s.current_a, s.pressure_bar, s.fluid_temp_c, s.flow_lpm, l.label
FROM PumpRun s JOIN PumpRunLabel l ON l.session_id = s.session_id;
GO
INSERT INTO Roles (role_name) VALUES (N'ADMIN'), (N'OPERATOR'), (N'TECHNICIAN'), (N'AUDITOR'), (N'END_USER');
-- every resource gets a READ and a WRITE permission
INSERT INTO Permissions (resource, action)
SELECT r.res, a.act
FROM (VALUES (N'USER'), (N'ROLE'), (N'DEVICE'), (N'SENSOR_TYPE'), (N'CALIBRATION'), (N'PROFILE'),
             (N'PUMPRUN'), (N'VALVE'), (N'ALERT'), (N'MAINTENANCE'), (N'AUDIT')) r(res)
CROSS JOIN (VALUES (N'READ'), (N'WRITE')) a(act);
-- example: auditors are read-only
INSERT INTO RolePerm (role_id, perm_id)
SELECT (SELECT role_id FROM Roles WHERE role_name = N'AUDITOR'), perm_id
FROM Permissions WHERE action = N'READ';
-- ADMIN
INSERT INTO Users (username, password_hash, full_name, status)
VALUES ('admin01', '123456', 'Administrator', 'ACTIVE');

DECLARE @AdminId INT = SCOPE_IDENTITY();

INSERT INTO UserRole (user_id, role_id)
SELECT @AdminId, role_id
FROM Roles
WHERE role_name = 'ADMIN';


-- AUDITOR
INSERT INTO Users (username, password_hash, full_name, status)
VALUES ('auditor01', '123456', 'Auditor One', 'ACTIVE');

DECLARE @AuditorId INT = SCOPE_IDENTITY();

INSERT INTO UserRole (user_id, role_id)
SELECT @AuditorId, role_id
FROM Roles
WHERE role_name = 'AUDITOR';


-- OPERATOR
INSERT INTO Users (username, password_hash, full_name, status)
VALUES ('operator01', '123456', 'Operator One', 'ACTIVE');

DECLARE @OperatorId INT = SCOPE_IDENTITY();

INSERT INTO UserRole (user_id, role_id)
SELECT @OperatorId, role_id
FROM Roles
WHERE role_name = 'OPERATOR';


-- TECHNICIAN
INSERT INTO Users (username, password_hash, full_name, status)
VALUES ('tech01', '123456', 'Technician One', 'ACTIVE');

DECLARE @TechId INT = SCOPE_IDENTITY();

INSERT INTO UserRole (user_id, role_id)
SELECT @TechId, role_id
FROM Roles
WHERE role_name = 'TECHNICIAN';
-- =============================================
-- SAMPLE DATA: PumpSystem
-- =============================================
INSERT INTO PumpSystem
    (system_code, system_name, location, status)
VALUES
    ('SYS-001', 'Water Circulation System A', 'Building A', 'ACTIVE'),
    ('SYS-002', 'Water Circulation System B', 'Building B', 'ACTIVE'),
    ('SYS-003', 'Cooling Water System', 'Factory Area 1', 'ACTIVE'),
    ('SYS-004', 'Industrial Pump System', 'Factory Area 2', 'ACTIVE');


-- =============================================
-- SAMPLE DATA: Pump
-- =============================================
INSERT INTO Pump
    (pump_code, system_id, pump_name, model, status)
VALUES
    ('PUMP-001', 1, 'Main Circulation Pump', 'Grundfos CR 10', 'ACTIVE'),
    ('PUMP-002', 1, 'Backup Circulation Pump', 'Grundfos CR 8', 'ACTIVE'),
    ('PUMP-003', 2, 'Building B Main Pump', 'KSB Etanorm', 'ACTIVE'),
    ('PUMP-004', 2, 'Building B Backup Pump', 'KSB Etanorm 50', 'MAINTENANCE'),
    ('PUMP-005', 3, 'Cooling Water Pump 1', 'Wilo Crono', 'ACTIVE'),
    ('PUMP-006', 4, 'Industrial Pump 1', 'Ebara 3D', 'ACTIVE');


-- =============================================
-- SAMPLE DATA: TestScenario
-- =============================================
INSERT INTO TestScenario
    (scenario_code, scenario_name, description, expected_label, status)
VALUES
    (
        'SCN-001',
        'Normal Operation',
        'Pump operates under normal working conditions.',
        'NORMAL',
        'ACTIVE'
    ),
    (
        'SCN-002',
        'Partial Valve Closure',
        'Partially close the valve and observe pump behavior.',
        'PARTIAL_VALVE_CLOSURE',
        'ACTIVE'
    ),
    (
        'SCN-003',
        'Pump Imbalance',
        'Introduce an imbalance condition during pump operation.',
        'IMBALANCE',
        'ACTIVE'
    ),
    (
        'SCN-004',
        'Water Leakage',
        'Simulate a water leakage condition in the circulation system.',
        'LEAK',
        'ACTIVE'
    ),
    (
        'SCN-005',
        'Pump Cavitation',
        'Simulate operating conditions that may cause cavitation.',
        'CAVITATION',
        'ACTIVE'
    ),
    (
        'SCN-006',
        'Sensor Fault',
        'Simulate abnormal or faulty sensor readings.',
        'SENSOR_FAULT',
        'ACTIVE'
    );
    -- =============================================
-- SAMPLE DATA: Valve
-- =============================================
INSERT INTO Valve
    (valve_code, pump_id, position, status)
VALUES
    ('V-001', 1, '100%', 'OPEN'),
    ('V-002', 1, '75%', 'OPEN'),
    ('V-003', 2, '100%', 'OPEN'),
    ('V-004', 3, '50%', 'PARTIAL'),
    ('V-005', 3, '100%', 'OPEN'),
    ('V-006', 5, '100%', 'OPEN'),
    ('V-007', 6, '25%', 'PARTIAL'),
    ('V-008', 6, '100%', 'OPEN');
-- staging table that holds the downloaded file as it is
CREATE TABLE RawSkab (dt DATETIME2, acc1 FLOAT, acc2 FLOAT, current_a FLOAT, pressure FLOAT,
  temperature FLOAT, thermocouple FLOAT, voltage FLOAT, flow FLOAT, anomaly INT, changepoint INT);
 
-- sessions rebuilt from the public data, same feature names as the device sends
CREATE TABLE PublicSession (
  public_id INT IDENTITY PRIMARY KEY,
  vib1_rms FLOAT,
  current_a FLOAT,
  pressure_bar FLOAT,
  fluid_temp_c FLOAT,
  flow_lpm FLOAT,
  label NVARCHAR(40),
  sent BIT DEFAULT 0);
-- each 60 consecutive rows is one pump run
WITH numbered AS (
  SELECT *, (ROW_NUMBER() OVER (ORDER BY dt) - 1) / 60 AS run_no FROM RawSkab)
INSERT INTO PublicSession (vib1_rms, current_a, pressure_bar, fluid_temp_c, flow_lpm, label)
SELECT AVG(acc1), AVG(current_a), AVG(pressure), AVG(thermocouple), AVG(flow),
       CASE WHEN MAX(anomaly) = 0 THEN 'NORMAL' ELSE 'LEAK' END
FROM numbered GROUP BY run_no;