CREATE TABLE [dbo].[PolicyConfig] (
    [policyConfigID]     INT  NOT NULL,
    [policyID]           INT  NULL,
    [addUnlistedPatient] BIT  NULL,
    [QA]                 BIT  NULL,
    [insightActive]      BIT  NULL,
    [connectActive]      BIT  NULL,
    [activeAsOf]         DATE NULL,
    [activeThru]         DATE NULL,
    CONSTRAINT [PK_policyConfig] PRIMARY KEY CLUSTERED ([policyConfigID] ASC) WITH (FILLFACTOR = 80)
);

