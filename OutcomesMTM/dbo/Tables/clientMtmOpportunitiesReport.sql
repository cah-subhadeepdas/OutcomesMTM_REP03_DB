CREATE TABLE [dbo].[clientMtmOpportunitiesReport] (
    [clientMtmOpportunitiesReportid] INT             IDENTITY (1, 1) NOT NULL,
    [centerid]                       INT             NULL,
    [policyid]                       INT             NULL,
    [Trained RPhs]                   INT             NULL,
    [Trained Techs]                  INT             NULL,
    [TotalPatients]                  INT             NULL,
    [TotalPrimaryPatients]           INT             NULL,
    [Total CMRs]                     INT             NULL,
    [Potential CMR Revenue]          INT             NULL,
    [Total Primary CMRs]             INT             NULL,
    [Potential CMR Revenue Primary]  INT             NULL,
    [CMRs scheduled]                 INT             NULL,
    [TotalTIPs]                      INT             NULL,
    [TotalPrimaryTIPs]               INT             NULL,
    [PotentialTIPRevenue]            INT             NULL,
    [PotentialTIPRevenuePrimary]     INT             NULL,
    [Unfinished Claims]              INT             NULL,
    [Review/Resubmit]                INT             NULL,
    [QA zone]                        VARCHAR (50)    NULL,
    [DTP %]                          DECIMAL (20, 2) NULL,
    [6 Month Claim History]          INT             NULL,
    [NABP]                           VARCHAR (50)    NULL,
    [pharmacy_name]                  VARCHAR (100)   NULL,
    [pharmacy_type]                  VARCHAR (50)    NULL,
    [address]                        VARCHAR (50)    NULL,
    [city]                           VARCHAR (50)    NULL,
    [state]                          VARCHAR (2)     NULL,
    [stateID]                        INT             NULL,
    [zipCode]                        VARCHAR (50)    NULL,
    [phone]                          VARCHAR (50)    NULL,
    [fax]                            VARCHAR (50)    NULL,
    [contracted]                     BIT             NULL,
    CONSTRAINT [PK_clientMtmOpportunitiesReport] PRIMARY KEY CLUSTERED ([clientMtmOpportunitiesReportid] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_centerid]
    ON [dbo].[clientMtmOpportunitiesReport]([centerid] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ind_centerid_policyid]
    ON [dbo].[clientMtmOpportunitiesReport]([centerid] ASC, [policyid] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_policyid]
    ON [dbo].[clientMtmOpportunitiesReport]([policyid] ASC)
    INCLUDE([centerid], [Trained RPhs], [Trained Techs], [TotalPatients], [TotalPrimaryPatients], [Total CMRs], [Potential CMR Revenue], [Total Primary CMRs], [Potential CMR Revenue Primary], [CMRs scheduled], [TotalTIPs], [TotalPrimaryTIPs], [PotentialTIPRevenue], [PotentialTIPRevenuePrimary], [Unfinished Claims], [Review/Resubmit]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [policyid_stateid]
    ON [dbo].[clientMtmOpportunitiesReport]([policyid] ASC, [stateID] ASC) WITH (FILLFACTOR = 80);

