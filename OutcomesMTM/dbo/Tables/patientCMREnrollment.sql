CREATE TABLE [dbo].[patientCMREnrollment] (
    [patientCMREnrollmentID] INT      NOT NULL,
    [patientid]              INT      NULL,
    [policyid]               INT      NULL,
    [createDT]               DATETIME NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientCMREnrollment_patientCMREnrollmentID]
    ON [dbo].[patientCMREnrollment]([patientCMREnrollmentID] ASC);

