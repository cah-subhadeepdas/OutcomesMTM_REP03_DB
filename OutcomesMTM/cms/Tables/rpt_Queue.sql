CREATE TABLE [cms].[rpt_Queue] (
    [QueueID]         INT         IDENTITY (1, 1) NOT NULL,
    [ClientID]        INT         NOT NULL,
    [ContractYear]    CHAR (4)    NOT NULL,
    [ContractNumber]  VARCHAR (5) NOT NULL,
    [ProcessStartDT]  DATETIME    NULL,
    [ProcessFinishDT] DATETIME    NULL,
    [ProcessStatusID] INT         NOT NULL,
    [CreateDT]        DATETIME    DEFAULT (getdate()) NOT NULL,
    [ChangeDT]        DATETIME    DEFAULT (getdate()) NOT NULL,
    [HashCheck]       AS          (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[QueueID]),'|',CONVERT([varbinary],[ClientID]),'|',CONVERT([varbinary],[ContractYear]),'|',CONVERT([varbinary],[ContractNumber]),'|',CONVERT([varbinary],[ProcessStartDT]),'|',CONVERT([varbinary],[ProcessFinishDT]),'|',CONVERT([varbinary],[ProcessStatusID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([QueueID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__rpt_Queue__HashCheck]
    ON [cms].[rpt_Queue]([HashCheck] ASC);


GO
	CREATE TRIGGER [cms].[T__rpt_Queue__Insert] ON [cms].[rpt_Queue] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[rpt_QueueLog] (  [QueueID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [QueueID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[QueueID] = i.[QueueID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[rpt_Queue] ENABLE TRIGGER [T__rpt_Queue__Insert]; 

GO
	CREATE TRIGGER [cms].[T__rpt_Queue__Update] ON [cms].[rpt_Queue] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[rpt_QueueLog] (  [QueueID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[QueueID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[QueueID] = i.[QueueID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[QueueID]=d.[QueueID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[rpt_Queue] ENABLE TRIGGER [T__rpt_Queue__Update]; 

GO
	CREATE TRIGGER [cms].[T__rpt_Queue__Delete] ON [cms].[rpt_Queue] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[rpt_QueueLog] (  [QueueID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [QueueID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[QueueID] = d.[QueueID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[rpt_Queue] ENABLE TRIGGER [T__rpt_Queue__Delete]; 
