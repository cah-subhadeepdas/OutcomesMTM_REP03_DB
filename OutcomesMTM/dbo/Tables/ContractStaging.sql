CREATE TABLE [dbo].[ContractStaging] (
    [contractID]   INT           NOT NULL,
    [contractName] VARCHAR (100) NULL,
    [clientID]     INT           NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[ContractStaging]([contractID] ASC);

