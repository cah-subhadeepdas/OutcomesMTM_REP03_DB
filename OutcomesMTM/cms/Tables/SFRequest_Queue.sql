CREATE TABLE [cms].[SFRequest_Queue] (
    [QueueID]                   INT           IDENTITY (1, 1) NOT NULL,
    [ClientID]                  INT           NULL,
    [ContractYear]              INT           NULL,
    [OverwriteSnapshot]         CHAR (1)      NULL,
    [SFRequestFile]             VARCHAR (100) NULL,
    [SnapshotId]                INT           NULL,
    [ProcessStartDT]            DATETIME      NULL,
    [IsDuplicate]               BIT           CONSTRAINT [DF_SF_Queue_IsDuplicate] DEFAULT ((1)) NULL,
    [ProcessFinishDT]           DATETIME      NULL,
    [ProcessStatusID]           INT           NULL,
    [CreateDT]                  DATETIME      CONSTRAINT [DF_SF_Queue_CreateDT] DEFAULT (getdate()) NULL,
    [LastModifiedDT]            DATETIME      NULL,
    [OnlyDoSFExport]            BIT           NULL,
    [SnapshotRunTime]           VARCHAR (50)  NULL,
    [ValidClientIdContractYear] BIT           CONSTRAINT [DF_SFRequest_Queue_InvalidClientIdContractYear] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__SF_Queue__8324E8F567888AE5] PRIMARY KEY CLUSTERED ([QueueID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' Default is 1 (isduplicate), then after de-duplication in U_SFRequest_Queue , it is set to 0', @level0type = N'SCHEMA', @level0name = N'cms', @level1type = N'TABLE', @level1name = N'SFRequest_Queue', @level2type = N'COLUMN', @level2name = N'IsDuplicate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' first stage is 0 (ready for process)   and then set to -2 (in-process) in U_SFRequest_Queue and then to 1 (completed) ', @level0type = N'SCHEMA', @level0name = N'cms', @level1type = N'TABLE', @level1name = N'SFRequest_Queue', @level2type = N'COLUMN', @level2name = N'ProcessStatusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ClientId should be valid and Contractyear should in the last 3 years then this value stays 1 or else becomes 0', @level0type = N'SCHEMA', @level0name = N'cms', @level1type = N'TABLE', @level1name = N'SFRequest_Queue', @level2type = N'COLUMN', @level2name = N'ValidClientIdContractYear';

