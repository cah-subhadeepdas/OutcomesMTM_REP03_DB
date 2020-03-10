CREATE TABLE [dbo].[Policy] (
    [policyID]         INT           NOT NULL,
    [policyName]       VARCHAR (100) NULL,
    [contractID]       INT           NULL,
    [policyTypeID]     INT           NULL,
    [IsMedicarePolicy] BIT           NULL,
    CONSTRAINT [PK_Policy] PRIMARY KEY CLUSTERED ([policyID] ASC) WITH (FILLFACTOR = 80)
);

