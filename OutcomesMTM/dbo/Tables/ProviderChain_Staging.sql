CREATE TABLE [dbo].[ProviderChain_Staging] (
    [NCPDP_Provider_ID] VARCHAR (7) NOT NULL,
    [chaincode]         VARCHAR (3) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[ProviderChain_Staging]([NCPDP_Provider_ID] ASC, [chaincode] ASC);

