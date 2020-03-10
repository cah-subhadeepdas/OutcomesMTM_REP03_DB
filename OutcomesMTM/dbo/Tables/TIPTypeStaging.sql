CREATE TABLE [dbo].[TIPTypeStaging] (
    [TIPTypeID] SMALLINT      NOT NULL,
    [TipType]   VARCHAR (100) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[TIPTypeStaging]([TIPTypeID] ASC);

