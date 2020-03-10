CREATE TABLE [dbo].[patientCMREnrollmentReport_staging] (
    [policyid]   INT           NULL,
    [JAN]        INT           NULL,
    [FEB]        INT           NULL,
    [MAR]        INT           NULL,
    [APR]        INT           NULL,
    [MAY]        INT           NULL,
    [JUN]        INT           NULL,
    [JUL]        INT           NULL,
    [AUG]        INT           NULL,
    [SEP]        INT           NULL,
    [OCT]        INT           NULL,
    [NOV]        INT           NULL,
    [DEC]        INT           NULL,
    [total]      INT           NULL,
    [clientName] VARCHAR (100) NULL,
    [policyName] VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[patientCMREnrollmentReport_staging]([policyid] ASC);

