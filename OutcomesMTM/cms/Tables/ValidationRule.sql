CREATE TABLE [cms].[ValidationRule] (
    [RuleID]                                     INT            NOT NULL,
    [Data Element]                               VARCHAR (50)   NOT NULL,
    [Automated Check/Validation]                 VARCHAR (1000) NULL,
    [Severity]                                   VARCHAR (10)   NULL,
    [OutcomesMTM Internal Error Description]     VARCHAR (1000) NULL,
    [Test during CMS Report Generation?]         BIT            NULL,
    [Test during Updated Supplemental Ingestion] BIT            NULL,
    [Test during Supplemental File Generation?]  BIT            NULL,
    [OMTM External Error Description]            VARCHAR (1000) NULL,
    [OMTM External Error Action Details ]        VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([RuleID] ASC)
);

