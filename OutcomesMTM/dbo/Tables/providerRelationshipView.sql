CREATE TABLE [dbo].[providerRelationshipView] (
    [mtmCenterNumber]          VARCHAR (7)  NOT NULL,
    [Relationship_ID]          VARCHAR (3)  NOT NULL,
    [Relationship_ID_Name]     VARCHAR (35) NULL,
    [Relationship_Type]        VARCHAR (2)  NULL,
    [relationShip_Type_Name]   VARCHAR (50) NULL,
    [Effective_From_Date]      DATE         NULL,
    [Effective_Through_Date]   DATE         NULL,
    [parent_organization_ID]   VARCHAR (6)  NULL,
    [parent_organization_Name] VARCHAR (35) NULL,
    CONSTRAINT [PK_providerRelationshipView] PRIMARY KEY CLUSTERED ([mtmCenterNumber] ASC, [Relationship_ID] ASC) WITH (FILLFACTOR = 80)
);

