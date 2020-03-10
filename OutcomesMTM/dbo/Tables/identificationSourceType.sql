CREATE TABLE [dbo].[identificationSourceType] (
    [identificationSourceTypeID] SMALLINT     NOT NULL,
    [identificationSourceType]   VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([identificationSourceTypeID] ASC) WITH (FILLFACTOR = 80)
);

