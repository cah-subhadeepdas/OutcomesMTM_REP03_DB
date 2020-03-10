CREATE TABLE [staging].[invoiceStatusType] (
    [invoiceStatusTypeID] INT          NOT NULL,
    [invoiceStatusTypeNM] VARCHAR (50) NOT NULL,
    [active]              BIT          NOT NULL,
    [createDT]            DATETIME     NOT NULL,
    [createUser]          INT          NULL
);

