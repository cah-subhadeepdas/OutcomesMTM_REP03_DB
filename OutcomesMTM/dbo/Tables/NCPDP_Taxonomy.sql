CREATE TABLE [dbo].[NCPDP_Taxonomy] (
    [NCPDP_TaxonomyID]   INT          NOT NULL,
    [NCPDP_Provider_ID]  VARCHAR (7)  NULL,
    [Taxonomy_Code]      VARCHAR (10) NULL,
    [Provider_Type_Code] VARCHAR (2)  NULL,
    [Delete_Date]        DATE         NULL,
    [Active]             BIT          NOT NULL,
    [fileid]             INT          NOT NULL
);

