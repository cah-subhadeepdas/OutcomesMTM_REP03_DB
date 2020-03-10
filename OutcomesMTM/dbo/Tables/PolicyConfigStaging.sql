CREATE TABLE [dbo].[PolicyConfigStaging] (
    [policyConfigID]     INT  NOT NULL,
    [policyID]           INT  NULL,
    [addUnlistedPatient] BIT  NULL,
    [QA]                 BIT  NULL,
    [insightActive]      BIT  NULL,
    [connectActive]      BIT  NULL,
    [activeAsOf]         DATE NULL,
    [activeThru]         DATE NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[PolicyConfigStaging]([policyConfigID] ASC);

