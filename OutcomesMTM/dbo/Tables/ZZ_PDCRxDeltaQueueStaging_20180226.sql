CREATE TABLE [dbo].[ZZ_PDCRxDeltaQueueStaging_20180226] (
    [PDCRXID]    BIGINT   NOT NULL,
    [PDCruleID]  INT      NOT NULL,
    [PatientID]  INT      NOT NULL,
    [RXID]       BIGINT   NOT NULL,
    [queueDate]  DATETIME NOT NULL,
    [isDelete]   BIT      NOT NULL,
    [isInsert]   BIT      NOT NULL,
    [queueOrder] INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_PDCRXDeltaQueueStaging]
    ON [dbo].[ZZ_PDCRxDeltaQueueStaging_20180226]([PatientID] ASC, [PDCruleID] ASC, [RXID] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[ZZ_PDCRxDeltaQueueStaging_20180226]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([PatientID], [PDCruleID], [RXID], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[ZZ_PDCRxDeltaQueueStaging_20180226]([isInsert] ASC)
    INCLUDE([PatientID], [PDCruleID], [RXID], [queueOrder], [queueDate]);

