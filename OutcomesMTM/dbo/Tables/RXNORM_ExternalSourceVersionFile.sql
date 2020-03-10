CREATE TABLE [dbo].[RXNORM_ExternalSourceVersionFile] (
    [rxxexverid]          INT          IDENTITY (1, 1) NOT NULL,
    [fileid]              INT          NOT NULL,
    [external_source]     VARCHAR (10) NOT NULL,
    [external_source_set] VARCHAR (10) NOT NULL,
    [version]             VARCHAR (10) NOT NULL,
    [reserve]             VARCHAR (18) NULL,
    [Active]              BIT          NOT NULL,
    [CreateDate]          DATETIME     CONSTRAINT [DF__RXNORM_ExternalSourceVersionFile__CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [UNC__RXNORM_ExternalSourceVersionFile__fileid__external_source__external_source_set__version] UNIQUE NONCLUSTERED ([fileid] ASC, [external_source] ASC, [external_source_set] ASC, [version] ASC)
);

