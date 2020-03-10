CREATE TABLE [cms].[RuleRun] (
    [RunID]          INT         IDENTITY (1, 1) NOT NULL,
    [ClientID]       INT         NOT NULL,
    [RuleWorkflowID] INT         NOT NULL,
    [ContractYear]   VARCHAR (4) NULL,
    [ContractNumber] VARCHAR (5) NULL,
    [RunDT]          DATETIME    NOT NULL,
    [BatchID]        INT         NOT NULL,
    CONSTRAINT [PK_Run] PRIMARY KEY CLUSTERED ([RunID] ASC),
    CONSTRAINT [AK_Run] UNIQUE NONCLUSTERED ([ClientID] ASC, [RuleWorkflowID] ASC, [ContractNumber] ASC, [RunDT] ASC)
);

