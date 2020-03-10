CREATE TABLE [cms].[Beneficiary] (
    [BeneficiaryID]   INT           IDENTITY (1, 1) NOT NULL,
    [ClientID]        INT           NOT NULL,
    [ContractYear]    CHAR (4)      NOT NULL,
    [BeneficiaryKey]  VARCHAR (100) NOT NULL,
    [HICN]            VARCHAR (15)  NOT NULL,
    [First_Name]      VARCHAR (30)  NOT NULL,
    [MI]              VARCHAR (1)   NOT NULL,
    [Last_Name]       VARCHAR (30)  NOT NULL,
    [DOB]             DATE          NOT NULL,
    [CreateDT_Source] DATETIME      NULL,
    [ChangeDT_Source] DATETIME      NULL,
    [SnapshotID]      INT           NOT NULL,
    [CreateDT]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [ChangeDT]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [HashCheck]       AS            (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[BeneficiaryID]),'|',CONVERT([varbinary],[ClientID]),'|',CONVERT([varbinary],[ContractYear]),'|',CONVERT([varbinary],[BeneficiaryKey]),'|',CONVERT([varbinary],[HICN]),'|',CONVERT([varbinary],[First_Name]),'|',CONVERT([varbinary],[MI]),'|',CONVERT([varbinary],[Last_Name]),'|',CONVERT([varbinary],[DOB]),'|',CONVERT([varbinary],[CreateDT_Source]),'|',CONVERT([varbinary],[ChangeDT_Source]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([BeneficiaryID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__Beneficiary__HashCheck]
    ON [cms].[Beneficiary]([HashCheck] ASC);


GO
CREATE NONCLUSTERED INDEX [IX__Beneficiary__SnapshotID__Beneficiary]
    ON [cms].[Beneficiary]([SnapshotID] ASC, [BeneficiaryID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Beneficiary_SnapshotID_BeneficiaryKey]
    ON [cms].[Beneficiary]([SnapshotID] DESC, [BeneficiaryKey] DESC);


GO

    CREATE TRIGGER [cms].[T__Beneficiary__Delete] ON [cms].[Beneficiary] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryLog] (  [BeneficiaryID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [BeneficiaryID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[BeneficiaryID] = d.[BeneficiaryID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[Beneficiary] ENABLE TRIGGER [T__Beneficiary__Delete]; 

GO

    CREATE TRIGGER [cms].[T__Beneficiary__Insert] ON [cms].[Beneficiary] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryLog] (  [BeneficiaryID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [BeneficiaryID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[BeneficiaryID] = i.[BeneficiaryID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[Beneficiary] ENABLE TRIGGER [T__Beneficiary__Insert]; 

GO

    CREATE TRIGGER [cms].[T__Beneficiary__Update] ON [cms].[Beneficiary] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryLog] (  [BeneficiaryID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[BeneficiaryID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[BeneficiaryID] = i.[BeneficiaryID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[BeneficiaryID]=d.[BeneficiaryID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[Beneficiary] ENABLE TRIGGER [T__Beneficiary__Update]; 
