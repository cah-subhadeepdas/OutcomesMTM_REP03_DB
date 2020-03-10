CREATE TABLE [dbo].[NCPDP_ParentOrganization] (
    [NCPDP_ParentOrganizationID] INT          NOT NULL,
    [Parent_Organization_ID]     VARCHAR (7)  NULL,
    [Parent_Organization_Name]   VARCHAR (35) NULL,
    [Address_1]                  VARCHAR (55) NULL,
    [Address_2]                  VARCHAR (55) NULL,
    [City]                       VARCHAR (30) NULL,
    [State_Code]                 VARCHAR (2)  NULL,
    [Zip_Code]                   VARCHAR (9)  NULL,
    [Phone_Number]               VARCHAR (10) NULL,
    [Extension]                  VARCHAR (5)  NULL,
    [FAX_Number]                 VARCHAR (10) NULL,
    [Parent_Organization_NPI]    VARCHAR (10) NULL,
    [Parent_Organization_Tax_ID] VARCHAR (15) NULL,
    [Contact_Name]               VARCHAR (30) NULL,
    [Contact_Title]              VARCHAR (30) NULL,
    [E-Mail_Address]             VARCHAR (50) NULL,
    [Delete_Date]                DATE         NULL,
    [Active]                     BIT          NOT NULL,
    [fileid]                     INT          NOT NULL
);

