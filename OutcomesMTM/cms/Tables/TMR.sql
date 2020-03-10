CREATE TABLE [cms].[TMR] (
    [TMRID]      BIGINT   IDENTITY (1, 1) NOT NULL,
    [PatientID]  INT      NOT NULL,
    [TMRDate]    DATE     NOT NULL,
    [SnapshotID] INT      NOT NULL,
    [CreateDT]   DATETIME DEFAULT (getdate()) NOT NULL,
    [ChangeDT]   DATETIME DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([TMRID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__TMR__PatientID__TMRDate]
    ON [cms].[TMR]([PatientID] ASC, [TMRDate] ASC);


GO

    CREATE TRIGGER [cms].[T__TMR__Insert] ON [cms].[TMR] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[TMRLog] (  [TMRID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [TMRID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[TMRID] = i.[TMRID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[TMR] ENABLE TRIGGER [T__TMR__Insert]; 

GO
DISABLE TRIGGER [cms].[T__TMR__Insert]
    ON [cms].[TMR];


GO

    CREATE TRIGGER [cms].[T__TMR__Update] ON [cms].[TMR] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[TMRLog] (  [TMRID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[TMRID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[TMRID] = i.[TMRID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[TMRID]=d.[TMRID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[TMR] ENABLE TRIGGER [T__TMR__Update]; 

GO
DISABLE TRIGGER [cms].[T__TMR__Update]
    ON [cms].[TMR];


GO

    CREATE TRIGGER [cms].[T__TMR__Delete] ON [cms].[TMR] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[TMRLog] (  [TMRID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [TMRID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[TMRID] = d.[TMRID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[TMR] ENABLE TRIGGER [T__TMR__Delete]; 

GO
DISABLE TRIGGER [cms].[T__TMR__Delete]
    ON [cms].[TMR];

