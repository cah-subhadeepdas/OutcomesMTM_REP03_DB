CREATE TABLE [cms].[ValidationRuleRun] (
    [ValidationRuleRunID]      INT         IDENTITY (1, 1) NOT NULL,
    [ValidationRuleID]         INT         NOT NULL,
    [ValidationRuleWorkflowID] INT         NOT NULL,
    [ClientID]                 INT         NOT NULL,
    [ContractYear]             CHAR (4)    NOT NULL,
    [ContractNumber]           VARCHAR (5) NULL,
    [CreateDT]                 DATETIME    DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ValidationRuleRunID] ASC)
);

