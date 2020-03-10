CREATE TABLE [cms].[AuditDetail] (
    [AuditDetailID]                    BIGINT         IDENTITY (1, 1) NOT NULL,
    [ContractNumber]                   VARCHAR (5)    NOT NULL,
    [SnapshotID]                       INT            NOT NULL,
    [PatientID]                        INT            NOT NULL,
    [PatientID_All]                    VARCHAR (50)   NULL,
    [AuditActivityTypeID]              INT            NOT NULL,
    [AuditDetailAttributeName]         VARCHAR (50)   NULL,
    [AuditDetailAttributeNameExternal] VARCHAR (50)   NULL,
    [AuditDetailValue_OLD]             VARCHAR (8000) NULL,
    [AuditDetailValue_NEW]             VARCHAR (8000) NULL,
    [CreateDT]                         DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([AuditDetailID] ASC)
);

