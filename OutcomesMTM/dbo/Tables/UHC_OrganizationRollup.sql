CREATE TABLE [dbo].[UHC_OrganizationRollup] (
    [OrgID]                      INT           IDENTITY (1, 1) NOT NULL,
    [organization Name]          VARCHAR (100) NOT NULL,
    [Organization Category Size] INT           NULL,
    PRIMARY KEY CLUSTERED ([OrgID] ASC) WITH (FILLFACTOR = 80)
);

