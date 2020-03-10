CREATE TABLE [dbo].[rptHumanaLegalEntityInvoiceBreakdownStaging] (
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
    CONSTRAINT [PK_humanaLegalEntityInvoiceBreakdownStaging] PRIMARY KEY CLUSTERED ([humanaLegalEntityInvoiceBreakdownID] ASC) WITH (FILLFACTOR = 90)
);

