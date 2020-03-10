CREATE TABLE [cms].[SFExportProcess_Queue] (
    [QueueID]         INT      IDENTITY (1, 1) NOT NULL,
    [ClientID]        INT      NULL,
    [ContractYear]    INT      NULL,
    [SnapshotId]      INT      NULL,
    [ProcessStartDT]  DATETIME NULL,
    [ProcessFinishDT] DATETIME NULL,
    [ProcessStatusID] INT      CONSTRAINT [DF_SFExportProcess_Queue_ProcessStatusID] DEFAULT ((0)) NULL,
    [CreateDT]        DATETIME CONSTRAINT [DF__SFExportP__Creat__23CA01AF] DEFAULT (getdate()) NULL,
    [DataSetTypeId]   INT      CONSTRAINT [DF_SFExportProcess_Queue_DataSetTypeId] DEFAULT ((2)) NULL,
    CONSTRAINT [PK__SFExport__8324E8F5C0B8A4A5] PRIMARY KEY CLUSTERED ([QueueID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Default is 0 (Ready to Process) .. other values are -2 (In-Process) ,  1 (Complete)  , -1 (Incomplete/Obsolete)', @level0type = N'SCHEMA', @level0name = N'cms', @level1type = N'TABLE', @level1name = N'SFExportProcess_Queue', @level2type = N'COLUMN', @level2name = N'ProcessStatusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' default is 2 for Beneficiary as per SnapshotTracker', @level0type = N'SCHEMA', @level0name = N'cms', @level1type = N'TABLE', @level1name = N'SFExportProcess_Queue', @level2type = N'COLUMN', @level2name = N'DataSetTypeId';

