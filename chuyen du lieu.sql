INSERT INTO dbo.RawSkab
    (dt, acc1, acc2, current_a, pressure,
     temperature, thermocouple, voltage, flow,
     anomaly, changepoint)
SELECT
    TRY_CONVERT(DATETIME2, [datetime]),
    TRY_CONVERT(FLOAT, [Accelerometer1RMS]),
    TRY_CONVERT(FLOAT, [Accelerometer2RMS]),
    TRY_CONVERT(FLOAT, [Current]),
    TRY_CONVERT(FLOAT, [Pressure]),
    TRY_CONVERT(FLOAT, [Temperature]),
    TRY_CONVERT(FLOAT, [Thermocouple]),
    TRY_CONVERT(FLOAT, [Voltage]),
    TRY_CONVERT(FLOAT, [Volume_Flow_RateRMS]),
    TRY_CONVERT(INT, [anomaly]),
    TRY_CONVERT(INT, [changepoint])
FROM dbo.RawSkab_Import;
