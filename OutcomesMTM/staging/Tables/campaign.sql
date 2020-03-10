CREATE TABLE [staging].[campaign] (
    [CampaignName] VARCHAR (100) NULL,
    [PolicyId]     INT           NOT NULL,
    [tipids]       VARCHAR (50)  NULL,
    [tiptitles]    VARCHAR (MAX) NULL,
    [loadtime]     SMALLDATETIME CONSTRAINT [DF_campaign_loadtime] DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([PolicyId] ASC)
);

