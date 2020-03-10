CREATE TABLE [dbo].[ZZ_medRecDim] (
    [medRecDimKey]            BIGINT   IDENTITY (1, 1) NOT NULL,
    [medRecID]                BIGINT   NOT NULL,
    [PatientID]               INT      NOT NULL,
    [dischargeDate]           DATETIME NOT NULL,
    [dischargeFromLocationID] INT      NULL,
    [dischargeToLocationID]   INT      NULL,
    [dischargingPRID]         BIGINT   NULL,
    [PCPPRID]                 BIGINT   NULL,
    [active]                  BIT      NOT NULL,
    [repositoryArchiveID]     BIGINT   NULL,
    [fileid]                  INT      NULL,
    [changeDate]              DATETIME NOT NULL,
    [enterpriseChangeDate]    DATETIME NULL,
    [activeasof]              DATETIME NOT NULL,
    [activethru]              DATETIME NULL,
    [iscurrent]               INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_medRecDim_medRecDimKey]
    ON [dbo].[ZZ_medRecDim]([medRecDimKey] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NC_medRedDim_patientID_dischargeDate]
    ON [dbo].[ZZ_medRecDim]([PatientID] ASC, [dischargeDate] ASC) WITH (FILLFACTOR = 80);

