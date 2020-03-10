CREATE TABLE [dbo].[TIPResultDeltaQueueStaging] (
    [TIPresultid]  BIGINT       NOT NULL,
    [TIPdetailid]  INT          NOT NULL,
    [patientid]    INT          NOT NULL,
    [active]       BIT          NOT NULL,
    [GPI]          VARCHAR (50) NULL,
    [repositoryid] BIGINT       NULL,
    [fileid]       INT          NULL,
    [queueDate]    DATETIME     NOT NULL,
    [isDelete]     BIT          NOT NULL,
    [isInsert]     BIT          NOT NULL,
    [queueOrder]   INT          NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_TIPResultDeltaQueueStaging]
    ON [dbo].[TIPResultDeltaQueueStaging]([TIPdetailid] ASC, [patientid] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[TIPResultDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([TIPdetailid], [patientid], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[TIPResultDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([TIPdetailid], [patientid], [queueOrder], [queueDate]);

