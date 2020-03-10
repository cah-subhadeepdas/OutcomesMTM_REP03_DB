CREATE TABLE [dbo].[PDCResultDeltaQueueStaging] (
    [PDCresultID]  BIGINT       NOT NULL,
    [PDCruleID]    INT          NOT NULL,
    [PatientID]    INT          NOT NULL,
    [coveredDays]  INT          NOT NULL,
    [minIndexDate] DATE         NOT NULL,
    [maxIndexDate] DATE         NOT NULL,
    [active]       BIT          NOT NULL,
    [GPI]          VARCHAR (50) NULL,
    [queueDate]    DATETIME     NOT NULL,
    [isDelete]     BIT          NOT NULL,
    [isInsert]     BIT          NOT NULL,
    [queueOrder]   INT          NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_PDCResultDeltaQueueStaging]
    ON [dbo].[PDCResultDeltaQueueStaging]([PatientID] ASC, [PDCruleID] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[PDCResultDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([PatientID], [PDCruleID], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[PDCResultDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([PatientID], [PDCruleID], [queueOrder], [queueDate]);

