CREATE TABLE [dbo].[Client] (
    [clientID]   INT           NOT NULL,
    [clientName] VARCHAR (100) NULL,
    CONSTRAINT [PK_client] PRIMARY KEY CLUSTERED ([clientID] ASC) WITH (FILLFACTOR = 80)
);

