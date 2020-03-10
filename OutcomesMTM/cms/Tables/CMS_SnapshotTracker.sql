CREATE TABLE [cms].[CMS_SnapshotTracker] (
    [SnapshotID]    INT           IDENTITY (1, 1) NOT NULL,
    [DataSetTypeID] INT           NOT NULL,
    [ClientID]      INT           NOT NULL,
    [ContractYear]  INT           NOT NULL,
    [ActiveFromDT]  DATETIME      CONSTRAINT [df2] DEFAULT (getdate()) NOT NULL,
    [ActiveThruDT]  DATETIME      CONSTRAINT [df1] DEFAULT ('9999-12-31') NOT NULL,
    [LastRunDate]   DATETIME      NULL,
    [LastRunStatus] INT           CONSTRAINT [df3] DEFAULT ((0)) NULL,
    [Description]   VARCHAR (500) NULL,
    CONSTRAINT [PK1] PRIMARY KEY CLUSTERED ([DataSetTypeID] ASC, [ClientID] ASC, [ContractYear] ASC, [ActiveThruDT] ASC)
);

