CREATE TABLE [dbo].[IdentificationConfigTypeStaging] (
    [IdentificationConfigTypeID] SMALLINT      NOT NULL,
    [IdentificationConfigType]   VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[IdentificationConfigTypeStaging]([IdentificationConfigTypeID] ASC);

