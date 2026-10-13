ALTER TABLE dbo.RawSkab_Import
ADD anomaly INT NOT NULL
        CONSTRAINT DF_RawSkab_Import_anomaly DEFAULT 0,
    changepoint INT NOT NULL
        CONSTRAINT DF_RawSkab_Import_changepoint DEFAULT 0;