CREATE TABLE [dbo].[patientPrimaryPharmacyDeltaQueueStaging] (
    [patientPrimaryPharmacyID] INT      NOT NULL,
    [patientid]                INT      NOT NULL,
    [centerid]                 INT      NOT NULL,
    [primaryPharmacy]          BIT      NOT NULL,
    [changeDate]               DATETIME NULL,
    [queueDate]                DATETIME NOT NULL,
    [isDelete]                 BIT      NOT NULL,
    [isInsert]                 BIT      NOT NULL,
    [queueOrder]               INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientPrimaryPharmacyDeltaQueueStaging]
    ON [dbo].[patientPrimaryPharmacyDeltaQueueStaging]([patientid] ASC, [centerid] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[patientPrimaryPharmacyDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientid], [centerid], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[patientPrimaryPharmacyDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientid], [centerid], [queueOrder], [queueDate]);

