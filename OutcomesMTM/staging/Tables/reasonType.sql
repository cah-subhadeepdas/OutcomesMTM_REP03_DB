CREATE TABLE [staging].[reasonType] (
    [reasonTypeID]     INT             NOT NULL,
    [reasonTypeDesc]   NVARCHAR (50)   NULL,
    [reasonCode]       INT             NULL,
    [sort]             INT             NULL,
    [activeflag]       BIT             NOT NULL,
    [actionVerbiage]   NVARCHAR (1000) NULL,
    [TIPModalQuestion] VARCHAR (1000)  NULL
);

