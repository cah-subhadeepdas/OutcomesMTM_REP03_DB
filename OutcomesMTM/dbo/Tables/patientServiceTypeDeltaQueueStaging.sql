CREATE TABLE [dbo].[patientServiceTypeDeltaQueueStaging] (
    [patientServiceTypeID] INT      NOT NULL,
    [patientID]            INT      NOT NULL,
    [serviceTypeID]        INT      NOT NULL,
    [changeDate]           DATETIME NULL,
    [queueDate]            DATETIME NOT NULL,
    [isDelete]             BIT      NOT NULL,
    [isInsert]             BIT      NOT NULL,
    [queueOrder]           INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientServiceTypeDeltaQueueStaging]
    ON [dbo].[patientServiceTypeDeltaQueueStaging]([patientID] ASC, [serviceTypeID] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[patientServiceTypeDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientID], [serviceTypeID], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[patientServiceTypeDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientID], [serviceTypeID], [queueOrder], [queueDate]);

