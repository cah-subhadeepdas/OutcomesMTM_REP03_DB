CREATE TABLE [dbo].[diagnosisCodeDeltaQueueStaging] (
    [diagnosisCodeID]      BIGINT   NULL,
    [PatientID]            INT      NULL,
    [ICDCodeID]            INT      NULL,
    [diagnosisDate]        DATE     NULL,
    [active]               BIT      NULL,
    [repositoryArchiveID]  BIGINT   NULL,
    [fileid]               INT      NULL,
    [changeDate]           DATETIME NULL,
    [enterpriseChangeDate] DATETIME NULL,
    [prid]                 BIGINT   NULL,
    [queueDate]            DATETIME NOT NULL,
    [isDelete]             BIT      NOT NULL,
    [isInsert]             BIT      NOT NULL,
    [queueOrder]           INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_diagnosisCodeDeltaQueueStaging]
    ON [dbo].[diagnosisCodeDeltaQueueStaging]([PatientID] ASC, [ICDCodeID] ASC, [diagnosisDate] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[diagnosisCodeDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([PatientID], [ICDCodeID], [diagnosisDate], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[diagnosisCodeDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([PatientID], [ICDCodeID], [diagnosisDate], [queueOrder], [queueDate]);

