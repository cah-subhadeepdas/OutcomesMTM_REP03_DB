CREATE TABLE [dbo].[TIPRuleStaging] (
    [tipruleid]   INT           NOT NULL,
    [tipdetailid] INT           NOT NULL,
    [ruleid]      VARCHAR (100) NOT NULL,
    [ruletype]    VARCHAR (50)  NOT NULL,
    [sort]        INT           NOT NULL,
    [concat]      VARCHAR (10)  NOT NULL,
    [leftParen]   BIT           NOT NULL,
    [rightParen]  BIT           NOT NULL,
    [excludedrug] BIT           NULL,
    [active]      BIT           NULL,
    [activeasof]  DATETIME      NULL,
    [activethru]  DATETIME      NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[TIPRuleStaging]([tipruleid] ASC);

