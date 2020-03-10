CREATE TABLE [dbo].[ReportExtract] (
    [ReportExtractID]   INT           IDENTITY (1, 1) NOT NULL,
    [ReportExtractName] VARCHAR (100) NOT NULL,
    [CreateDate]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [ActiveThru]        DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ReportExtractID] ASC)
);

