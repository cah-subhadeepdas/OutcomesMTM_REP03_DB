CREATE TABLE [cms].[CMROfferSupplemental] (
    [CMROfferSupplementalID]        INT           IDENTITY (1, 1) NOT NULL,
    [CMROfferSupplementalID_Source] VARCHAR (50)  NULL,
    [SourceSystem]                  VARCHAR (50)  NOT NULL,
    [PatientID]                     INT           NOT NULL,
    [PatientID_All]                 VARCHAR (50)  NULL,
    [ClientID]                      INT           NULL,
    [CMROfferDate]                  DATE          NULL,
    [CMROfferModality]              VARCHAR (50)  NULL,
    [SnapshotID]                    INT           NOT NULL,
    [CreateDT]                      DATETIME      DEFAULT (getdate()) NOT NULL,
    [ChangeDT]                      DATETIME      DEFAULT (getdate()) NOT NULL,
    [CMROfferRecipient]             VARCHAR (100) NULL,
    [CMROfferReturnDate]            DATE          NULL,
    [CMROfferRecipientCode]         CHAR (2)      NULL,
    [HashCheck]                     AS            (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[CMROfferSupplementalID]),'|',CONVERT([varbinary],[CMROfferSupplementalID_Source]),'|',CONVERT([varbinary],[SourceSystem]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[PatientID_All]),'|',CONVERT([varbinary],[ClientID]),'|',CONVERT([varbinary],[CMROfferDate]),'|',CONVERT([varbinary],[CMROfferModality]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[CMROfferRecipient]),'|',CONVERT([varbinary],[CMROfferReturnDate]),'|',CONVERT([varbinary],[ChangeDT]),'|',CONVERT([varbinary],[CMROfferRecipientCode]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([CMROfferSupplementalID] ASC)
);


GO

    CREATE TRIGGER [cms].[T__CMROfferSupplemental__Insert] ON [cms].[CMROfferSupplemental] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMROfferSupplementalLog] (  [CMROfferSupplementalID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [CMROfferSupplementalID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[CMROfferSupplementalID] = i.[CMROfferSupplementalID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[CMROfferSupplemental] ENABLE TRIGGER [T__CMROfferSupplemental__Insert]; 

GO

    CREATE TRIGGER [cms].[T__CMROfferSupplemental__Update] ON [cms].[CMROfferSupplemental] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMROfferSupplementalLog] (  [CMROfferSupplementalID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[CMROfferSupplementalID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[CMROfferSupplementalID] = i.[CMROfferSupplementalID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[CMROfferSupplementalID]=d.[CMROfferSupplementalID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[CMROfferSupplemental] ENABLE TRIGGER [T__CMROfferSupplemental__Update]; 

GO

    CREATE TRIGGER [cms].[T__CMROfferSupplemental__Delete] ON [cms].[CMROfferSupplemental] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMROfferSupplementalLog] (  [CMROfferSupplementalID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [CMROfferSupplementalID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[CMROfferSupplementalID] = d.[CMROfferSupplementalID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[CMROfferSupplemental] ENABLE TRIGGER [T__CMROfferSupplemental__Delete]; 
