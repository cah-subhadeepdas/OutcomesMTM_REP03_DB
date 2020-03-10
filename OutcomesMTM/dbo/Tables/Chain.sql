CREATE TABLE [dbo].[Chain] (
    [chainid]   INT            NOT NULL,
    [chaincode] VARCHAR (100)  NULL,
    [chainnm]   VARCHAR (1000) NULL,
    CONSTRAINT [PK_Chain] PRIMARY KEY CLUSTERED ([chainid] ASC) WITH (FILLFACTOR = 80)
);

