CREATE TABLE [cms].[BeneficiaryMatch] (
    [BeneficiaryMatchID]          INT            IDENTITY (1, 1) NOT NULL,
    [SnapshotID]                  INT            NOT NULL,
    [PatientID]                   INT            NOT NULL,
    [BeneficiaryMatchCheck]       VARCHAR (8000) NOT NULL,
    [BeneficiaryMatch_PatientIDs] VARCHAR (255)  NOT NULL,
    [CreateDT]                    DATETIME       DEFAULT (getdate()) NOT NULL,
    [ChangeDT]                    DATETIME       DEFAULT (getdate()) NOT NULL,
    [HashCheck]                   AS             (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[BeneficiaryMatchID]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[BeneficiaryMatchCheck]),'|',CONVERT([varbinary],[BeneficiaryMatch_PatientIDs]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([BeneficiaryMatchID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__BeneficiaryMatch__HashCheck]
    ON [cms].[BeneficiaryMatch]([HashCheck] ASC);


GO
    CREATE TRIGGER [cms].[T__BeneficiaryMatch__Insert] ON [cms].[BeneficiaryMatch] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryMatchLog] (  [BeneficiaryMatchID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [BeneficiaryMatchID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[BeneficiaryMatchID] = i.[BeneficiaryMatchID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[BeneficiaryMatch] ENABLE TRIGGER [T__BeneficiaryMatch__Insert]; 

GO
    CREATE TRIGGER [cms].[T__BeneficiaryMatch__Update] ON [cms].[BeneficiaryMatch] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryMatchLog] (  [BeneficiaryMatchID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[BeneficiaryMatchID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[BeneficiaryMatchID] = i.[BeneficiaryMatchID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[BeneficiaryMatchID]=d.[BeneficiaryMatchID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[BeneficiaryMatch] ENABLE TRIGGER [T__BeneficiaryMatch__Update]; 

GO
    CREATE TRIGGER [cms].[T__BeneficiaryMatch__Delete] ON [cms].[BeneficiaryMatch] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryMatchLog] (  [BeneficiaryMatchID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [BeneficiaryMatchID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[BeneficiaryMatchID] = d.[BeneficiaryMatchID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[BeneficiaryMatch] ENABLE TRIGGER [T__BeneficiaryMatch__Delete]; 
