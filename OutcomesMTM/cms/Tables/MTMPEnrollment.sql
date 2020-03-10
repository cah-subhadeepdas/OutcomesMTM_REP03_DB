CREATE TABLE [cms].[MTMPEnrollment] (
    [MTMPEnrollmentID]                INT            IDENTITY (1, 1) NOT NULL,
    [PatientID]                       INT            NOT NULL,
    [PatientID_All]                   INT            NOT NULL,
    [PolicyID]                        INT            NOT NULL,
    [ClientID]                        INT            NOT NULL,
    [ContractYear]                    CHAR (4)       NOT NULL,
    [ContractNumber]                  CHAR (5)       NOT NULL,
    [MTMPTargetingDate]               DATE           NULL,
    [MTMPEnrollmentFromDate]          DATE           NOT NULL,
    [MTMPEnrollmentThruDate]          DATE           NOT NULL,
    [OptOutDate]                      DATE           NULL,
    [OptOutReasonCode]                VARCHAR (2)    NOT NULL,
    [CreateDT_Source]                 DATETIME       NULL,
    [ChangeDT_Source]                 DATETIME       NULL,
    [MTMPEnrollmentFromDate_InfoJSON] NVARCHAR (MAX) NULL,
    [SnapshotID]                      INT            NOT NULL,
    [MTMPTargetingDate_InfoJSON]      NVARCHAR (MAX) NULL,
    [CreateDT]                        DATETIME       DEFAULT (getdate()) NOT NULL,
    [ChangeDT]                        DATETIME       DEFAULT (getdate()) NOT NULL,
    [HashCheck]                       AS             (CONVERT([binary](32),hashbytes('SHA2_256',concat(CONVERT([varbinary],[MTMPEnrollmentID]),'|',CONVERT([varbinary],[PatientID]),'|',CONVERT([varbinary],[PatientID_All]),'|',CONVERT([varbinary],[PolicyID]),'|',CONVERT([varbinary],[ClientID]),'|',CONVERT([varbinary],[ContractYear]),'|',CONVERT([varbinary],[ContractNumber]),'|',CONVERT([varbinary],[MTMPTargetingDate]),'|',CONVERT([varbinary],[MTMPEnrollmentFromDate]),'|',CONVERT([varbinary],[MTMPEnrollmentThruDate]),'|',CONVERT([varbinary],[OptOutDate]),'|',CONVERT([varbinary],[OptOutReasonCode]),'|',CONVERT([varbinary],[CreateDT_Source]),'|',CONVERT([varbinary],[ChangeDT_Source]),'|',CONVERT([varbinary],[MTMPEnrollmentFromDate_InfoJSON]),'|',CONVERT([varbinary],[SnapshotID]),'|',CONVERT([varbinary],[MTMPTargetingDate_InfoJSON]),'|',CONVERT([varbinary],[CreateDT]),'|',CONVERT([varbinary],[ChangeDT]),'|')))) PERSISTED,
    PRIMARY KEY CLUSTERED ([MTMPEnrollmentID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX__MTMPEnrollment__HashCheck]
    ON [cms].[MTMPEnrollment]([HashCheck] ASC);


GO
CREATE NONCLUSTERED INDEX [IX__Beneficiary__SnapshotID__Beneficiary]
    ON [cms].[MTMPEnrollment]([SnapshotID] ASC, [PatientID] ASC);


GO

    CREATE TRIGGER [cms].[T__MTMPEnrollment__Delete] ON [cms].[MTMPEnrollment] AFTER DELETE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[MTMPEnrollmentLog] (  [MTMPEnrollmentID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [MTMPEnrollmentID], [HashCheck], [IsInsert] = 0, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select d2.* from deleted d2 where d2.[MTMPEnrollmentID] = d.[MTMPEnrollmentID] for JSON AUTO) FROM deleted d WHERE 1=1 END;  ALTER TABLE [cms].[MTMPEnrollment] ENABLE TRIGGER [T__MTMPEnrollment__Delete]; 

GO

    CREATE TRIGGER [cms].[T__MTMPEnrollment__Insert] ON [cms].[MTMPEnrollment] AFTER INSERT AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[MTMPEnrollmentLog] (  [MTMPEnrollmentID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   [MTMPEnrollmentID], [HashCheck], [IsInsert] = 1, [IsDelete] = 0, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[MTMPEnrollmentID] = i.[MTMPEnrollmentID] for JSON AUTO) FROM inserted i WHERE 1=1 END;  ALTER TABLE [cms].[MTMPEnrollment] ENABLE TRIGGER [T__MTMPEnrollment__Insert]; 

GO

    CREATE TRIGGER [cms].[T__MTMPEnrollment__Update] ON [cms].[MTMPEnrollment] AFTER UPDATE AS BEGIN SET XACT_ABORT ON; SET NOCOUNT ON; DECLARE @date DATETIME = GETDATE() INSERT INTO [cms].[MTMPEnrollmentLog] (  [MTMPEnrollmentID], [HashCheck], [IsInsert], [IsDelete], [LogDT], [LogData_JSON] ) SELECT   i.[MTMPEnrollmentID], [HashCheck] = i.[HashCheck], [IsInsert] = 1, [IsDelete] = 1, [LogDT] = @date, [LogData_JSON] = (select i2.* from inserted i2 where i2.[MTMPEnrollmentID] = i.[MTMPEnrollmentID] for JSON AUTO) FROM inserted i JOIN deleted d ON i.[MTMPEnrollmentID]=d.[MTMPEnrollmentID] WHERE 1=1 and i.hashcheck <> d.hashcheck END;  ALTER TABLE [cms].[MTMPEnrollment] ENABLE TRIGGER [T__MTMPEnrollment__Update]; 
