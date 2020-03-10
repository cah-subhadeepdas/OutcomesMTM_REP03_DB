CREATE TABLE [dbo].[patientCMREnrollmentReport] (
    [patientCMREnrollmentReportid] INT           IDENTITY (1, 1) NOT NULL,
    [policyid]                     INT           NULL,
    [JAN]                          INT           NULL,
    [FEB]                          INT           NULL,
    [MAR]                          INT           NULL,
    [APR]                          INT           NULL,
    [MAY]                          INT           NULL,
    [JUN]                          INT           NULL,
    [JUL]                          INT           NULL,
    [AUG]                          INT           NULL,
    [SEP]                          INT           NULL,
    [OCT]                          INT           NULL,
    [NOV]                          INT           NULL,
    [DEC]                          INT           NULL,
    [total]                        INT           NULL,
    [clientName]                   VARCHAR (100) NULL,
    [policyName]                   VARCHAR (100) NULL,
    CONSTRAINT [PK_patientCMREnrollmentReport] PRIMARY KEY CLUSTERED ([patientCMREnrollmentReportid] ASC) WITH (FILLFACTOR = 80)
);

