CREATE TABLE [dbo].[NCPDP_ProviderRelationship] (
    [NCPDP_ProviderRelationshipID] INT         NOT NULL,
    [NCPDP_Provider_ID]            VARCHAR (7) NULL,
    [Relationship_ID]              VARCHAR (3) NULL,
    [Payment_Center_ID]            VARCHAR (6) NULL,
    [Remit_Reconciliation_ID]      VARCHAR (6) NULL,
    [Provider_Type]                VARCHAR (2) NULL,
    [Is_Primary]                   VARCHAR (1) NULL,
    [Effective_From_Date]          DATE        NULL,
    [Effective_Through_Date]       DATE        NULL,
    [Active]                       BIT         NOT NULL,
    [fileid]                       INT         NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_NCPDP_ProviderRelationship_NCPDP_ProviderRelationshipID_dbo]
    ON [dbo].[NCPDP_ProviderRelationship]([NCPDP_ProviderRelationshipID] ASC);

