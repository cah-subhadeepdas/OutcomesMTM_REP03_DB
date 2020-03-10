CREATE TABLE [dbo].[legacy_tblChain] (
    [ChainID]          INT           NOT NULL,
    [ChainCode]        VARCHAR (50)  NULL,
    [ChainName]        VARCHAR (100) NULL,
    [ActiveFlag]       BIT           NOT NULL,
    [IPTracking]       BIT           NOT NULL,
    [FaxNumber]        VARCHAR (50)  NULL,
    [TIPAlertOverride] BIT           NULL,
    [Chainflag]        BIT           NULL,
    [CreateDate]       DATETIME      NULL,
    [CreatedBy]        VARCHAR (50)  NULL,
    [ModifyDate]       DATETIME      NULL,
    [ModifiedBy]       VARCHAR (50)  NULL,
    [PSAOFlag]         BIT           NULL
);

