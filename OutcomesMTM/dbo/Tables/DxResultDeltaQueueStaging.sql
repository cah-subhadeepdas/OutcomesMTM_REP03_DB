CREATE TABLE [dbo].[DxResultDeltaQueueStaging] (
    [dxresultid] BIGINT   NOT NULL,
    [DXstateid]  INT      NOT NULL,
    [patientid]  INT      NOT NULL,
    [active]     INT      NOT NULL,
    [queueDate]  DATETIME NOT NULL,
    [isDelete]   BIT      NOT NULL,
    [isInsert]   BIT      NOT NULL,
    [queueOrder] INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_DXResultDeltaQueueStaging]
    ON [dbo].[DxResultDeltaQueueStaging]([patientid] ASC, [DXstateid] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[DxResultDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientid], [DXstateid], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[DxResultDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientid], [DXstateid], [queueOrder], [queueDate]);

