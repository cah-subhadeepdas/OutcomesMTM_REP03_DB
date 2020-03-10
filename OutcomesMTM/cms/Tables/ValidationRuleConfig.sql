CREATE TABLE [cms].[ValidationRuleConfig] (
    [ValidationRuleConfigID]     INT            IDENTITY (1, 1) NOT NULL,
    [ValidationDataSet]          INT            NOT NULL,
    [ValidationRuleDescription]  VARCHAR (MAX)  NULL,
    [ValidationFields]           NVARCHAR (MAX) NULL,
    [ValidationSQL]              NVARCHAR (MAX) NOT NULL,
    [SeverityLevel]              TINYINT        NULL,
    [External_RuleID]            INT            NULL,
    [External_Error_Description] VARCHAR (255)  NULL,
    [External_Action_Details]    VARCHAR (255)  NULL,
    [Active]                     BIT            DEFAULT ((1)) NOT NULL,
    [CreateDT]                   DATETIME       DEFAULT (getdate()) NOT NULL,
    [ChangeDT]                   DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ValidationRuleConfigID] ASC)
);

