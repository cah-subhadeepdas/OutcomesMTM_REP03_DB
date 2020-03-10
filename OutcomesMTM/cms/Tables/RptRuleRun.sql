CREATE TABLE [cms].[RptRuleRun] (
    [RunID]          INT         IDENTITY (1, 1) NOT NULL,
    [ClientID]       INT         NULL,
    [RuleWorkflowID] INT         NULL,
    [ContractYear]   VARCHAR (4) NULL,
    [ContractNumber] VARCHAR (5) NULL,
    [RunDT]          DATETIME    NULL,
    [BatchID]        INT         NULL,
    CONSTRAINT [PK_CMSRun] PRIMARY KEY CLUSTERED ([RunID] ASC)
);

