CREATE TABLE [staging].[CMS_SFBene] (
    [SnapshotID]    INT           NOT NULL,
    [DataSetTypeID] INT           NOT NULL,
    [ClientID]      INT           NOT NULL,
    [ContractYear]  INT           NOT NULL,
    [ActiveFromDT]  DATETIME      NOT NULL,
    [ActiveThruDT]  DATETIME      NOT NULL,
    [LastRunDate]   DATETIME      NULL,
    [LastRunStatus] INT           NULL,
    [Description]   VARCHAR (500) NULL,
    [clientName]    VARCHAR (100) NULL
);

