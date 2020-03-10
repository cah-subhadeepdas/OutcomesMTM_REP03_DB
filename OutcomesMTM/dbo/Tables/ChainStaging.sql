CREATE TABLE [dbo].[ChainStaging] (
    [chainid]   INT            NOT NULL,
    [chaincode] VARCHAR (100)  NULL,
    [chainnm]   VARCHAR (1000) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[ChainStaging]([chainid] ASC);

