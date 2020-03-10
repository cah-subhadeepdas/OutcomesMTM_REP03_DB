CREATE TABLE [cms].[CMRLog] (
    [CMRLogID]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [CMRID]        INT            NULL,
    [HashCheck]    BINARY (32)    NULL,
    [IsInsert]     BIT            NOT NULL,
    [IsDelete]     BIT            NOT NULL,
    [LogDT]        DATETIME       DEFAULT (getdate()) NOT NULL,
    [LogData_JSON] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CMRLogID] ASC)
);

