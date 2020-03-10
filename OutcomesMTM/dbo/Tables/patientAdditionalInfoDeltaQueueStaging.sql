CREATE TABLE [dbo].[patientAdditionalInfoDeltaQueueStaging] (
    [PatientAdditionalInfoID] INT      NOT NULL,
    [patientid]               INT      NOT NULL,
    [additionalinfoxml]       XML      NULL,
    [changeDate]              DATETIME NOT NULL,
    [enterpriseChangeDate]    DATETIME NULL,
    [queueDate]               DATETIME NOT NULL,
    [isDelete]                BIT      NOT NULL,
    [isInsert]                BIT      NOT NULL,
    [queueOrder]              INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientAdditionalInfoDeltaQueueStaging]
    ON [dbo].[patientAdditionalInfoDeltaQueueStaging]([patientid] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[patientAdditionalInfoDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientid], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[patientAdditionalInfoDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientid], [queueOrder], [queueDate]);

