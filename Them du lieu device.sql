USE PRJ301_PUMP;
GO

INSERT INTO dbo.Device
    (device_code, location, firmware, status, api_key_hash)
VALUES
    ('PUMP-001', 'Test Location', '1.0', 'ACTIVE', 'test_key_hash_001');
GO

SELECT device_id, device_code, status, api_key_hash
FROM dbo.Device;