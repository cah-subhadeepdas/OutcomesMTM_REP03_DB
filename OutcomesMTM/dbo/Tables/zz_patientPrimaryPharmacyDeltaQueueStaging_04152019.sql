CREATE TABLE [dbo].[zz_patientPrimaryPharmacyDeltaQueueStaging_04152019] (
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

