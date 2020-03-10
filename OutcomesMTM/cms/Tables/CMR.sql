CREATE TABLE [cms].[CMR] (
    [CMRID]                        INT           IDENTITY (1, 1) NOT NULL,
    [ClaimID]                      INT           NOT NULL,
    [MTMServiceDT]                 DATETIME      NOT NULL,
    [ReasonCode]                   INT           NOT NULL,
    [ActionCode]                   INT           NOT NULL,
    [ResultCode]                   INT           NOT NULL,
    [ClaimStatus]                  VARCHAR (50)  NOT NULL,
    [ClaimStatusDT]                DATETIME      NULL,
    [PatientID]                    INT           NOT NULL,
    [PharmacyID]                   INT           NULL,
    [NCPDP_NABP]                   VARCHAR (50)  NULL,
    [CMRWithSPT]                   BIT           NOT NULL,
    [CMROffer]                     BIT           NOT NULL,
    [CMRID_Source]                 VARCHAR (50)  NULL,
    [CognitivelyImpairedIndicator] VARCHAR (1)   NULL,
    [MethodOfDeliveryCode]         VARCHAR (2)   NULL,
    [ProviderCode]                 VARCHAR (2)   NULL,
    [RecipientCode]                VARCHAR (2)   NULL,
    [AuthorizedRepresentative]     VARCHAR (1)   NULL,
    [Topic01]                      VARCHAR (100) NULL,
    [Topic02]                      VARCHAR (100) NULL,
    [Topic03]                      VARCHAR (100) NULL,
    [Topic04]                      VARCHAR (100) NULL,
    [Topic05]                      VARCHAR (100) NULL,
    [MAPCount]                     INT           NULL,
    [SPTDate]                      DATE          NULL,
    [LTC]                          BIT           NULL,
    [SnapshotID]                   INT           NOT NULL,
    [CreateDT]                     DATETIME      DEFAULT (getdate()) NOT NULL,
    [ChangeDT]                     DATETIME      DEFAULT (getdate()) NOT NULL,
    [CMRSuccess]                   BIT           NULL,
    [SPTReturnDate]                DATE          NULL,
    [HashCheck]                    AS            (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[CMRID]),'|',CONVERT([varbinary],[ClaimID]),'|',CONVERT([varbinary],[MTMServiceDT]),'|',CONVERT([varbinary],[ReasonCode]),'|',CONVERT([varbinary],[ActionCode]),'|',CONVERT([varbinary],[ResultCode]),'|',CONVERT([varbinary],[ClaimStatus]),'|',CONVERT([varbinary],[ClaimStatusDT]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[PharmacyID]),'|',CONVERT([varbinary],[NCPDP_NABP]),'|',CONVERT([varbinary],[CMRWithSPT]),'|',CONVERT([varbinary],[CMROffer]),'|',CONVERT([varbinary],[CMRID_Source]),'|',CONVERT([varbinary],[CognitivelyImpairedIndicator]),'|',CONVERT([varbinary],[MethodOfDeliveryCode]),'|',CONVERT([varbinary],[ProviderCode]),'|',CONVERT([varbinary],[RecipientCode]),'|',CONVERT([varbinary],[AuthorizedRepresentative]),'|',CONVERT([varbinary],[Topic01]),'|',CONVERT([varbinary],[Topic02]),'|',CONVERT([varbinary],[Topic03]),'|',CONVERT([varbinary],[Topic04]),'|',CONVERT([varbinary],[Topic05]),'|',CONVERT([varbinary],[MAPCount]),'|',CONVERT([varbinary],[SPTDate]),'|',CONVERT([varbinary],[LTC]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|',CONVERT([varbinary],[CMRSuccess]),'|',CONVERT([varbinary],[SPTReturnDate]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([CMRID] ASC)
);


GO

    CREATE TRIGGER [cms].[T__CMR__Insert] ON [cms].[CMR] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMRLog] (  [CMRID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [CMRID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[CMRID] = i.[CMRID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[CMR] ENABLE TRIGGER [T__CMR__Insert]; 

GO

    CREATE TRIGGER [cms].[T__CMR__Update] ON [cms].[CMR] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMRLog] (  [CMRID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[CMRID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[CMRID] = i.[CMRID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[CMRID]=d.[CMRID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[CMR] ENABLE TRIGGER [T__CMR__Update]; 

GO

    CREATE TRIGGER [cms].[T__CMR__Delete] ON [cms].[CMR] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[CMRLog] (  [CMRID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [CMRID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[CMRID] = d.[CMRID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[CMR] ENABLE TRIGGER [T__CMR__Delete]; 
