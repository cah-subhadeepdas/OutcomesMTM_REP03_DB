CREATE TABLE [dbo].[PolicyStaging] (
    [policyID]         INT           NOT NULL,
    [policyName]       VARCHAR (100) NULL,
    [contractID]       INT           NULL,
    [policyTypeID]     INT           NULL,
    [IsMedicarePolicy] BIT           NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[PolicyStaging]([policyID] ASC);

