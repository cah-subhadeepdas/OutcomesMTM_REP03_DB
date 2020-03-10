CREATE TABLE [dbo].[CampaignOppData] (
    [NCPDP_NABP]               VARCHAR (8000) NULL,
    [CampaignName]             VARCHAR (8000) NULL,
    [RelationshipName]         VARCHAR (1)    NOT NULL,
    [CMROpportunity]           INT            NOT NULL,
    [completedCMRs]            INT            NOT NULL,
    [PrimaryCMRsAvailable]     INT            NOT NULL,
    [CMRsAvailable]            INT            NOT NULL,
    [CMRsScheduled]            INT            NOT NULL,
    [TIP Opportunities]        DECIMAL (18)   NOT NULL,
    [TIPs Sucessful]           DECIMAL (18)   NOT NULL,
    [TIPs Available (Primary)] DECIMAL (18)   NOT NULL,
    [TIPs Available]           DECIMAL (18)   NOT NULL
);

