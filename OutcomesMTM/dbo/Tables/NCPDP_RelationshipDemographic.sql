﻿CREATE TABLE [dbo].[NCPDP_RelationshipDemographic] (
    [NCPDP_RelationshipDemographicID] INT          NOT NULL,
    [Relationship_ID]                 VARCHAR (3)  NULL,
    [Relationship_Type]               VARCHAR (2)  NULL,
    [Name]                            VARCHAR (35) NULL,
    [Address_1]                       VARCHAR (55) NULL,
    [Address_2]                       VARCHAR (55) NULL,
    [City]                            VARCHAR (30) NULL,
    [State_Code]                      VARCHAR (2)  NULL,
    [Zip_Code]                        VARCHAR (9)  NULL,
    [Phone_Number]                    VARCHAR (10) NULL,
    [Extension]                       VARCHAR (5)  NULL,
    [FAX_Number]                      VARCHAR (10) NULL,
    [Relationship_NPI]                VARCHAR (10) NULL,
    [Relationship_Tax_ID]             VARCHAR (15) NULL,
    [Contact_Name]                    VARCHAR (30) NULL,
    [Contact_Title]                   VARCHAR (30) NULL,
    [Contact_E-Mail_Address]          VARCHAR (50) NULL,
    [Contractual_Contact_Name]        VARCHAR (30) NULL,
    [Contractual_Contact_Title]       VARCHAR (30) NULL,
    [Contractual_Contact_E-Mail]      VARCHAR (50) NULL,
    [Operational_Contact_Name]        VARCHAR (30) NULL,
    [Operational_Contact_Title]       VARCHAR (30) NULL,
    [Operational_Contact_E-Mail]      VARCHAR (50) NULL,
    [Technical_Contact_Name]          VARCHAR (30) NULL,
    [Technical_Contact_Title]         VARCHAR (30) NULL,
    [Technical_Contact_E-Mail]        VARCHAR (50) NULL,
    [Audit_Contact_Name]              VARCHAR (30) NULL,
    [Audit_Contact_Title]             VARCHAR (30) NULL,
    [Audit_Contact_E-Mail]            VARCHAR (50) NULL,
    [Parent_Organization_ID]          VARCHAR (6)  NULL,
    [Effective_From_Date]             DATE         NULL,
    [Delete_Date]                     DATE         NULL,
    [Active]                          BIT          NOT NULL,
    [fileid]                          INT          NOT NULL
);

