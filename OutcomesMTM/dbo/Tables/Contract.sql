CREATE TABLE [dbo].[Contract] (
    [contractID]   INT           NOT NULL,
    [contractName] VARCHAR (100) NULL,
    [clientID]     INT           NULL,
    CONSTRAINT [PK_contract] PRIMARY KEY CLUSTERED ([contractID] ASC) WITH (FILLFACTOR = 80)
);

