CREATE TABLE [dbo].[IdentificationConfigType] (
    [IdentificationConfigTypeID] SMALLINT      NOT NULL,
    [IdentificationConfigType]   VARCHAR (100) NULL,
    CONSTRAINT [PK_IdentificationConfigType] PRIMARY KEY CLUSTERED ([IdentificationConfigTypeID] ASC) WITH (FILLFACTOR = 80)
);

