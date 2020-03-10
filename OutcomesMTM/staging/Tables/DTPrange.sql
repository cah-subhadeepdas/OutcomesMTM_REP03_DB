CREATE TABLE [staging].[DTPrange] (
    [DTPrangeID]       INT             NOT NULL,
    [ClaimStartNumber] INT             NOT NULL,
    [ClaimEndNumber]   INT             NOT NULL,
    [DTPLow]           DECIMAL (20, 2) NOT NULL,
    [DTPHigh]          DECIMAL (20, 2) NOT NULL,
    [DTPTypeID]        SMALLINT        NOT NULL,
    [active]           BIT             NOT NULL
);

