CREATE TABLE [dbo].[ProviderChain] (
    [NCPDP_Provider_ID] VARCHAR (7) NOT NULL,
    [chaincode]         VARCHAR (3) NOT NULL,
    CONSTRAINT [PK_ProviderChain] PRIMARY KEY CLUSTERED ([NCPDP_Provider_ID] ASC, [chaincode] ASC) WITH (FILLFACTOR = 80)
);

