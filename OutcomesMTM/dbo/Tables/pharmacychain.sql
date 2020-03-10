CREATE TABLE [dbo].[pharmacychain] (
    [PharmacyChainID] INT NOT NULL,
    [centerid]        INT NULL,
    [chainid]         INT NULL,
    CONSTRAINT [PK_pharmacychain] PRIMARY KEY CLUSTERED ([PharmacyChainID] ASC) WITH (FILLFACTOR = 80)
);

