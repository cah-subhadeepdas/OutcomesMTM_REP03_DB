CREATE TABLE [dbo].[Contracted_Trained_mtmcenters] (
    [CenterID]                      BIGINT        NOT NULL,
    [NCPDP_NABP]                    VARCHAR (50)  NULL,
    [CenterName]                    VARCHAR (100) NULL,
    [NPI]                           VARCHAR (50)  NULL,
    [Contracted]                    BIT           NULL,
    [Active]                        BIT           NULL,
    [Number of Trained Pharmacists] INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [Contracted_Trained]
    ON [dbo].[Contracted_Trained_mtmcenters]([CenterID] ASC, [Contracted] ASC, [Active] ASC, [Number of Trained Pharmacists] ASC);

