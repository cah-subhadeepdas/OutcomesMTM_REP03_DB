CREATE TABLE [dbo].[medRecDeltaQueueStaging] (
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
    [queueDate]               DATETIME NOT NULL,
    [isDelete]                BIT      NOT NULL,
    [isInsert]                BIT      NOT NULL
);


GO
CREATE CLUSTERED INDEX [CI_medRecDeltaQueueStaging_medRecID]
    ON [dbo].[medRecDeltaQueueStaging]([medRecID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_medRedDeltaQueueStaging_patientID_dischargeDate]
    ON [dbo].[medRecDeltaQueueStaging]([PatientID] ASC, [dischargeDate] ASC);

