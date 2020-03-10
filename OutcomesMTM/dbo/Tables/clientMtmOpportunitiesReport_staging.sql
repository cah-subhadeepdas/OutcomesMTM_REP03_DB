CREATE TABLE [dbo].[clientMtmOpportunitiesReport_staging] (
    [centerid]                      INT             NULL,
    [policyid]                      INT             NULL,
    [Trained RPhs]                  INT             NULL,
    [Trained Techs]                 INT             NULL,
    [TotalPatients]                 INT             NULL,
    [TotalPrimaryPatients]          INT             NULL,
    [Total CMRs]                    INT             NULL,
    [Potential CMR Revenue]         INT             NULL,
    [Total Primary CMRs]            INT             NULL,
    [Potential CMR Revenue Primary] INT             NULL,
    [CMRs scheduled]                INT             NULL,
    [TotalTIPs]                     INT             NULL,
    [TotalPrimaryTIPs]              INT             NULL,
    [PotentialTIPRevenue]           INT             NULL,
    [PotentialTIPRevenuePrimary]    INT             NULL,
    [Unfinished Claims]             INT             NULL,
    [Review/Resubmit]               INT             NULL,
    [QA zone]                       VARCHAR (50)    NULL,
    [DTP %]                         DECIMAL (20, 2) NULL,
    [6 Month Claim History]         INT             NULL,
    [NABP]                          VARCHAR (50)    NULL,
    [pharmacy_name]                 VARCHAR (100)   NULL,
    [pharmacy_type]                 VARCHAR (50)    NULL,
    [address]                       VARCHAR (50)    NULL,
    [city]                          VARCHAR (50)    NULL,
    [state]                         VARCHAR (2)     NULL,
    [stateID]                       INT             NULL,
    [zipCode]                       VARCHAR (50)    NULL,
    [phone]                         VARCHAR (50)    NULL,
    [fax]                           VARCHAR (50)    NULL,
    [contracted]                    BIT             NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[clientMtmOpportunitiesReport_staging]([centerid] ASC, [policyid] ASC);

