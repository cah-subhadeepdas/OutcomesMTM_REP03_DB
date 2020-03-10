CREATE TABLE [cms].[CMRSupplemental] (
    [CMRSupplementalID]            INT          IDENTITY (1, 1) NOT NULL,
    [CMRSupplementalID_Source]     VARCHAR (50) NULL,
    [SourceSystem]                 VARCHAR (50) NOT NULL,
    [PatientID]                    INT          NOT NULL,
    [PatientID_All]                VARCHAR (50) NULL,
    [ClientID]                     INT          NULL,
    [CMRDate]                      DATE         NOT NULL,
    [SPTDate]                      DATE         NOT NULL,
    [CognitivelyImpairedIndicator] VARCHAR (1)  NULL,
    [MethodOfDeliveryCode]         VARCHAR (2)  NULL,
    [ProviderCode]                 VARCHAR (2)  NULL,
    [RecipientCode]                VARCHAR (2)  NULL,
    [AuthorizedRepresentative]     VARCHAR (1)  NULL,
    [SnapshotID]                   INT          NOT NULL,
    [CreateDT]                     DATETIME     DEFAULT (getdate()) NOT NULL,
    [ChangeDT]                     DATETIME     DEFAULT (getdate()) NOT NULL,
    [HashCheck]                    AS           (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[CMRSupplementalID]),'|',CONVERT([varbinary],[CMRSupplementalID_Source]),'|',CONVERT([varbinary],[SourceSystem]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[PatientID_All]),'|',CONVERT([varbinary],[ClientID]),'|',CONVERT([varbinary],[CMRDate]),'|',CONVERT([varbinary],[SPTDate]),'|',CONVERT([varbinary],[CognitivelyImpairedIndicator]),'|',CONVERT([varbinary],[MethodOfDeliveryCode]),'|',CONVERT([varbinary],[ProviderCode]),'|',CONVERT([varbinary],[RecipientCode]),'|',CONVERT([varbinary],[AuthorizedRepresentative]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([CMRSupplementalID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__CMRSupplemental__HashCheck]
    ON [cms].[CMRSupplemental]([HashCheck] ASC);


GO

    CREATE TRIGGER [cms].[T__CMRSupplemental__Delete] ON [cms].[CMRSupplemental] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMRSupplementalLog] (  [CMRSupplementalID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [CMRSupplementalID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[CMRSupplementalID] = d.[CMRSupplementalID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[CMRSupplemental] ENABLE TRIGGER [T__CMRSupplemental__Delete]; 

GO

    CREATE TRIGGER [cms].[T__CMRSupplemental__Insert] ON [cms].[CMRSupplemental] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMRSupplementalLog] (  [CMRSupplementalID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [CMRSupplementalID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[CMRSupplementalID] = i.[CMRSupplementalID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[CMRSupplemental] ENABLE TRIGGER [T__CMRSupplemental__Insert]; 

GO

    CREATE TRIGGER [cms].[T__CMRSupplemental__Update] ON [cms].[CMRSupplemental] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMRSupplementalLog] (  [CMRSupplementalID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[CMRSupplementalID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[CMRSupplementalID] = i.[CMRSupplementalID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[CMRSupplementalID]=d.[CMRSupplementalID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[CMRSupplemental] ENABLE TRIGGER [T__CMRSupplemental__Update]; 
