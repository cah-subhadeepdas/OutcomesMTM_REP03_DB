CREATE TABLE [dbo].[DxRxDeltaQueueStaging] (
    [dxrxid]     BIGINT   NOT NULL,
    [DXstateid]  INT      NOT NULL,
    [patientid]  INT      NOT NULL,
    [rxid]       BIGINT   NOT NULL,
    [queueDate]  DATETIME NOT NULL,
    [isDelete]   BIT      NOT NULL,
    [isInsert]   BIT      NOT NULL,
    [queueOrder] INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_DXRXDeltaQueueStaging]
    ON [dbo].[DxRxDeltaQueueStaging]([patientid] ASC, [DXstateid] ASC, [rxid] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[DxRxDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientid], [DXstateid], [rxid], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[DxRxDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientid], [DXstateid], [rxid], [queueOrder], [queueDate]);

