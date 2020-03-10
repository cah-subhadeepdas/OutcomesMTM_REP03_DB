CREATE TABLE [cms].[ValidationRuleRunResult_new] (
    [ValidationRuleRunResultID]  BIGINT         IDENTITY (1, 1) NOT NULL,
    [ValidationRuleRunID]        INT            NULL,
    [ValidationRuleResultStatus] TINYINT        NULL,
    [ValidationData]             NVARCHAR (MAX) NULL,
    [BatchKey]                   VARCHAR (255)  NULL,
    [BatchValue]                 VARCHAR (255)  NULL,
    [UIDKey]                     VARCHAR (255)  NULL,
    [UIDValue]                   VARCHAR (255)  NULL,
    PRIMARY KEY CLUSTERED ([ValidationRuleRunResultID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__ValidationRuleRunResult__ValidationRuleRunID]
    ON [cms].[ValidationRuleRunResult_new]([ValidationRuleRunID] ASC)
    INCLUDE([ValidationRuleResultStatus], [ValidationData], [UIDKey], [UIDValue]);


GO
CREATE NONCLUSTERED INDEX [IX__ValidationRuleRunResult__ValidationRuleRunID__UIDValue__UIDKey__ValidationRuleResultStatus]
    ON [cms].[ValidationRuleRunResult_new]([ValidationRuleRunID] ASC, [UIDValue] ASC, [UIDKey] ASC, [ValidationRuleResultStatus] ASC)
    INCLUDE([ValidationData]);


GO
CREATE NONCLUSTERED INDEX [IX__ValidationRuleRunResult__UIDValue__UIDKey__BatchValue__BatchKey]
    ON [cms].[ValidationRuleRunResult_new]([UIDValue] ASC, [UIDKey] ASC, [BatchValue] ASC, [BatchKey] ASC)
    INCLUDE([ValidationData]);

