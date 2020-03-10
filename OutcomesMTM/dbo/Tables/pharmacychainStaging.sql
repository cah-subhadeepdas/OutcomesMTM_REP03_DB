CREATE TABLE [dbo].[pharmacychainStaging] (
    [PharmacyChainID] INT NOT NULL,
    [centerid]        INT NULL,
    [chainid]         INT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[pharmacychainStaging]([PharmacyChainID] ASC);

