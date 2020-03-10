CREATE TABLE [cms].[RptRunResult] (
    [RptRunResultID] INT         IDENTITY (1, 1) NOT NULL,
    [RuleID]         INT         NOT NULL,
    [PatientID]      INT         NULL,
    [BeneficiaryID]  INT         NULL,
    [ResultStatus]   BIT         NOT NULL,
    [RunDT]          DATETIME    NULL,
    [RunID]          INT         NULL,
    [ClientID]       INT         NULL,
    [ContractNumber] VARCHAR (5) NULL,
    [BatchID]        INT         NOT NULL,
    PRIMARY KEY CLUSTERED ([RptRunResultID] ASC)
);

