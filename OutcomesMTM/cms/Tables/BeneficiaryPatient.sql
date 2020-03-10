CREATE TABLE [cms].[BeneficiaryPatient] (
    [BeneficiaryPatientID] INT      IDENTITY (1, 1) NOT NULL,
    [BeneficiaryID]        INT      NOT NULL,
    [PatientID]            INT      NOT NULL,
    [SnapshotID]           INT      NOT NULL,
    [CreateDT]             DATETIME DEFAULT (getdate()) NOT NULL,
    [ChangeDT]             DATETIME DEFAULT (getdate()) NOT NULL,
    [HashCheck]            AS       (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[BeneficiaryPatientID]),'|',CONVERT([varbinary],[BeneficiaryID]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([BeneficiaryPatientID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__BeneficiaryPatient__HashCheck]
    ON [cms].[BeneficiaryPatient]([HashCheck] ASC);


GO
CREATE NONCLUSTERED INDEX [IX__Beneficiary__SnapshotID__Beneficiary]
    ON [cms].[BeneficiaryPatient]([SnapshotID] ASC, [BeneficiaryID] ASC, [PatientID] ASC);


GO

    CREATE TRIGGER [cms].[T__BeneficiaryPatient__Insert] ON [cms].[BeneficiaryPatient] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryPatientLog] (  [BeneficiaryPatientID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [BeneficiaryPatientID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[BeneficiaryPatientID] = i.[BeneficiaryPatientID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[BeneficiaryPatient] ENABLE TRIGGER [T__BeneficiaryPatient__Insert]; 

GO

    CREATE TRIGGER [cms].[T__BeneficiaryPatient__Update] ON [cms].[BeneficiaryPatient] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryPatientLog] (  [BeneficiaryPatientID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[BeneficiaryPatientID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[BeneficiaryPatientID] = i.[BeneficiaryPatientID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[BeneficiaryPatientID]=d.[BeneficiaryPatientID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[BeneficiaryPatient] ENABLE TRIGGER [T__BeneficiaryPatient__Update]; 

GO

    CREATE TRIGGER [cms].[T__BeneficiaryPatient__Delete] ON [cms].[BeneficiaryPatient] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[BeneficiaryPatientLog] (  [BeneficiaryPatientID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [BeneficiaryPatientID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[BeneficiaryPatientID] = d.[BeneficiaryPatientID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[BeneficiaryPatient] ENABLE TRIGGER [T__BeneficiaryPatient__Delete]; 
