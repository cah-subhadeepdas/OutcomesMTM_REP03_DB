CREATE TABLE [dbo].[IdentificationType] (
    [IdentificationTypeID] SMALLINT      NOT NULL,
    [IdentificationType]   VARCHAR (100) NULL,
    CONSTRAINT [PK_IdentificationType] PRIMARY KEY CLUSTERED ([IdentificationTypeID] ASC) WITH (FILLFACTOR = 90)
);

