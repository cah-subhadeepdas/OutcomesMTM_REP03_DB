CREATE TABLE [dbo].[IdentificationTypeStaging] (
    [IdentificationTypeID] SMALLINT      NOT NULL,
    [IdentificationType]   VARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[IdentificationTypeStaging]([IdentificationTypeID] ASC);

