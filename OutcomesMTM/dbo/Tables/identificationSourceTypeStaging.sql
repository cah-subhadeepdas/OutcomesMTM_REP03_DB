CREATE TABLE [dbo].[identificationSourceTypeStaging] (
    [identificationSourceTypeID] SMALLINT     NOT NULL,
    [identificationSourceType]   VARCHAR (50) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[identificationSourceTypeStaging]([identificationSourceTypeID] ASC);

