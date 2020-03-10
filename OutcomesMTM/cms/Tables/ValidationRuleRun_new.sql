CREATE TABLE [cms].[ValidationRuleRun_new] (
    [ValidationRuleRunID]    INT           IDENTITY (1, 1) NOT NULL,
    [ValidationRuleConfigID] INT           NULL,
    [BatchKey]               VARCHAR (255) NULL,
    [BatchValue]             VARCHAR (255) NULL,
    [ClientID]               INT           NULL,
    [ContractYear]           CHAR (4)      NULL,
    [ContractNumber]         VARCHAR (255) NULL,
    [Active]                 BIT           DEFAULT ((1)) NULL,
    [CreateDT]               DATETIME      DEFAULT (getdate()) NULL,
    [ChangeDT]               DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ValidationRuleRunID] ASC)
);

