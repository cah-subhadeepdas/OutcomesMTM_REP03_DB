CREATE TABLE [staging].[RAR] (
    [RARID]          INT             NOT NULL,
    [reasonTypeID]   SMALLINT        NOT NULL,
    [actionTypeID]   SMALLINT        NOT NULL,
    [resultTypeID]   SMALLINT        NOT NULL,
    [serviceFee]     DECIMAL (20, 2) NOT NULL,
    [invoiceAmount]  DECIMAL (20, 2) NOT NULL,
    [transactionFee] DECIMAL (20, 2) NOT NULL,
    [displayCS]      BIT             NOT NULL,
    [active]         BIT             NOT NULL
);

