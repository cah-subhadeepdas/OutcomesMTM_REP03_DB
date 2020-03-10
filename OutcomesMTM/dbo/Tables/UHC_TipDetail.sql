CREATE TABLE [dbo].[UHC_TipDetail] (
    [TipDetailID] INT           NOT NULL,
    [TipTitle]    VARCHAR (100) NOT NULL,
    [TipTypeID]   INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([TipDetailID] ASC) WITH (FILLFACTOR = 80)
);

