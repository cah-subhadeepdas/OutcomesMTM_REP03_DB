CREATE TABLE [dbo].[rptHumanaLegalEntityInvoiceBreakdown] (
    [humanaLegalEntityInvoiceBreakdownID] INT            NOT NULL,
    [fileID]                              INT            NOT NULL,
    [fileLoadDate]                        DATETIME       NULL,
    [fileName]                            VARCHAR (8000) NULL,
    [sourceCode]                          VARCHAR (50)   NULL,
    [legalEntityNumber]                   VARCHAR (50)   NULL,
    [legalEntityName]                     VARCHAR (250)  NULL,
    [recordCount]                         INT            NULL,
    [active]                              BIT            NULL,
    [createDate]                          DATETIME       NULL,
    CONSTRAINT [PK_humanaLegalEntityInvoiceBreakdown] PRIMARY KEY CLUSTERED ([humanaLegalEntityInvoiceBreakdownID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IX_fileID]
    ON [dbo].[rptHumanaLegalEntityInvoiceBreakdown]([fileID] ASC) WITH (FILLFACTOR = 80);

