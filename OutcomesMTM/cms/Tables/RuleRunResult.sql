CREATE TABLE [cms].[RuleRunResult] (
    [RuleRunResultID] INT         IDENTITY (1, 1) NOT NULL,
    [RuleID]          INT         NOT NULL,
    [PatientID]       INT         NULL,
    [BeneficiaryID]   INT         NULL,
    [SnapshotID]      INT         NOT NULL,
    [MTMEnrollmentID] INT         NULL,
    [ResultStatus]    BIT         NOT NULL,
    [RunDT]           DATETIME    NULL,
    [RunID]           INT         NULL,
    [ClientID]        INT         NULL,
    [ContractNumber]  VARCHAR (5) NULL,
    [BatchID]         INT         NOT NULL,
    PRIMARY KEY CLUSTERED ([RuleRunResultID] ASC)
);

