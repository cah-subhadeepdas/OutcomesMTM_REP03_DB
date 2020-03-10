CREATE TABLE [cms].[CMS_rpt_Batch] (
    [BatchID]        INT           IDENTITY (1, 1) NOT NULL,
    [ClientID]       INT           NOT NULL,
    [ContractYear]   CHAR (4)      NOT NULL,
    [ContractNumber] CHAR (5)      NOT NULL,
    [ActiveFromDT]   DATETIME      DEFAULT (getdate()) NOT NULL,
    [ActiveThruDT]   DATETIME      DEFAULT ('9999-12-31') NOT NULL,
    [Notes]          VARCHAR (100) NULL,
    [RptFromDT]      DATE          NULL,
    [RptThruDT]      DATE          NULL,
    PRIMARY KEY CLUSTERED ([BatchID] ASC)
);

