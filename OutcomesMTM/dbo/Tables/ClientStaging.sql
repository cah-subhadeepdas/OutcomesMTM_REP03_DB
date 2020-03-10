CREATE TABLE [dbo].[ClientStaging] (
    [clientID]   INT           NOT NULL,
    [clientName] VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[ClientStaging]([clientID] ASC);

