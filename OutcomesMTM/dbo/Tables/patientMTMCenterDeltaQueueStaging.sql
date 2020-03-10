CREATE TABLE [dbo].[patientMTMCenterDeltaQueueStaging] (
    [patientmtmcenterID] INT      NOT NULL,
    [patientid]          INT      NOT NULL,
    [centerid]           INT      NOT NULL,
    [createDT]           DATETIME NULL,
    [primaryPharmacy]    BIT      NULL,
    [ptcenterinprogress] BIT      NULL,
    [ptcenterlock]       BIT      NULL,
    [ptlock]             BIT      NULL,
    [queueDate]          DATETIME NOT NULL,
    [isDelete]           BIT      NOT NULL,
    [isInsert]           BIT      NOT NULL,
    [changeDate]         DATETIME NULL,
    [queueOrder]         INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientMTMCenterDeltaQueueStaging]
    ON [dbo].[patientMTMCenterDeltaQueueStaging]([patientid] ASC, [centerid] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[patientMTMCenterDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientid], [centerid], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[patientMTMCenterDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientid], [centerid], [queueOrder], [queueDate]);

