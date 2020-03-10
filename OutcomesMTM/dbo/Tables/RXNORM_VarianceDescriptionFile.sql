CREATE TABLE [dbo].[RXNORM_VarianceDescriptionFile] (
    [rxxvrdscid]                 INT          IDENTITY (1, 1) NOT NULL,
    [fileid]                     INT          NOT NULL,
    [variance_identifier]        INT          NOT NULL,
    [transaction_cd]             VARCHAR (1)  NULL,
    [variance_short_description] VARCHAR (15) NULL,
    [variance_description]       VARCHAR (50) NULL,
    [reserve]                    VARCHAR (25) NULL,
    [Active]                     BIT          NOT NULL,
    [CreateDate]                 DATETIME     CONSTRAINT [DF__RXNORM_VarianceDescriptionFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_VarianceDescriptionFile__fileid__variance_identifier] UNIQUE NONCLUSTERED ([fileid] ASC, [variance_identifier] ASC)
);

