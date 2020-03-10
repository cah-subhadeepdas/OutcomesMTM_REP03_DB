CREATE TABLE [dbo].[UHC_ChainRollUp] (
    [ChainRollupID]              INT           IDENTITY (1, 1) NOT NULL,
    [Preferred]                  INT           NULL,
    [Organization Category Size] INT           NULL,
    [Organization Name]          VARCHAR (100) NOT NULL,
    [RelationshipID]             VARCHAR (50)  NULL,
    [NABP]                       VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ChainRollupID] ASC) WITH (FILLFACTOR = 80)
);

