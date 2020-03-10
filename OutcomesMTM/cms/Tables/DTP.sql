CREATE TABLE [cms].[DTP] (
    [DTPID]             INT           IDENTITY (1, 1) NOT NULL,
    [ClaimID]           INT           NOT NULL,
    [MTMServiceDT]      DATETIME      NOT NULL,
    [ReasonCode]        INT           NOT NULL,
    [ActionCode]        INT           NOT NULL,
    [ResultCode]        INT           NOT NULL,
    [ClaimStatus]       VARCHAR (50)  NOT NULL,
    [ClaimStatusDT]     DATETIME      NULL,
    [PatientID]         INT           NOT NULL,
    [PharmacyID]        INT           NULL,
    [NCPDP_NABP]        VARCHAR (50)  NULL,
    [DTPRecommendation] BIT           NOT NULL,
    [GPI]               VARCHAR (50)  NULL,
    [MedName]           VARCHAR (300) NULL,
    [SuccessfulResult]  BIT           NOT NULL,
    [SnapshotID]        INT           NOT NULL,
    [CreateDT]          DATETIME      DEFAULT (getdate()) NOT NULL,
    [ChangeDT]          DATETIME      DEFAULT (getdate()) NOT NULL,
    [HashCheck]         AS            (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[DTPID]),'|',CONVERT([varbinary],[ClaimID]),'|',CONVERT([varbinary],[MTMServiceDT]),'|',CONVERT([varbinary],[ReasonCode]),'|',CONVERT([varbinary],[ActionCode]),'|',CONVERT([varbinary],[ResultCode]),'|',CONVERT([varbinary],[ClaimStatus]),'|',CONVERT([varbinary],[ClaimStatusDT]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[PharmacyID]),'|',CONVERT([varbinary],[NCPDP_NABP]),'|',CONVERT([varbinary],[DTPRecommendation]),'|',CONVERT([varbinary],[GPI]),'|',CONVERT([varbinary],[MedName]),'|',CONVERT([varbinary],[SuccessfulResult]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([DTPID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__DTP__HashCheck]
    ON [cms].[DTP]([HashCheck] ASC);


GO

    CREATE TRIGGER [cms].[T__DTP__Insert] ON [cms].[DTP] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[DTPLog] (  [DTPID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [DTPID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[DTPID] = i.[DTPID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[DTP] ENABLE TRIGGER [T__DTP__Insert]; 

GO

    CREATE TRIGGER [cms].[T__DTP__Update] ON [cms].[DTP] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[DTPLog] (  [DTPID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[DTPID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[DTPID] = i.[DTPID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[DTPID]=d.[DTPID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[DTP] ENABLE TRIGGER [T__DTP__Update]; 

GO

    CREATE TRIGGER [cms].[T__DTP__Delete] ON [cms].[DTP] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[DTPLog] (  [DTPID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [DTPID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[DTPID] = d.[DTPID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[DTP] ENABLE TRIGGER [T__DTP__Delete]; 
