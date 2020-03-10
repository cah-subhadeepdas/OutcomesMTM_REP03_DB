CREATE TABLE [dbo].[patientCMREnrollmentDeltaQueueStaging] (
    [patientCMREnrollmentID] INT      NOT NULL,
    [patientid]              INT      NULL,
    [policyid]               INT      NULL,
    [createDT]               DATETIME NULL
);

