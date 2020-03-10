CREATE TABLE [cms].[AuditActivityType] (
    [AuditActivityTypeID]          INT           NOT NULL,
    [AuditActivityTypeDescription] VARCHAR (100) NULL,
    [AuditDetailText]              VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([AuditActivityTypeID] ASC)
);

