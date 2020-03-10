CREATE TABLE [dbo].[AdherenceMonitorDeltaQueueStaging] (
    [AdherenceMonitorID]  INT             NOT NULL,
    [PatientID]           INT             NOT NULL,
    [tipdetailID]         INT             NOT NULL,
    [GPI]                 VARCHAR (50)    NOT NULL,
    [CurrentPDC]          DECIMAL (20, 2) NULL,
    [DaysMissed]          SMALLINT        NULL,
    [AllowableDays]       SMALLINT        NULL,
    [BonusEligible]       BIT             NULL,
    [YearofUse]           SMALLINT        NULL,
    [repositoryArchiveid] INT             NULL,
    [fileid]              INT             NULL,
    [active]              BIT             NOT NULL,
    [queueDate]           DATETIME        NOT NULL,
    [isDelete]            BIT             NOT NULL,
    [isInsert]            BIT             NOT NULL,
    [queueOrder]          INT             NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_adherenceMonitorDeltaQueueStaging]
    ON [dbo].[AdherenceMonitorDeltaQueueStaging]([PatientID] ASC, [tipdetailID] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[AdherenceMonitorDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([PatientID], [tipdetailID], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[AdherenceMonitorDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([PatientID], [tipdetailID], [queueOrder], [queueDate]);

