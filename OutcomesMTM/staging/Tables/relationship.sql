CREATE TABLE [staging].[relationship] (
    [ncpdp_nabp]                                   VARCHAR (50)  NULL,
    [Relationship_Name]                            VARCHAR (200) NULL,
    [Legal_Business_Name]                          VARCHAR (255) NULL,
    [Name_(Doing_Business_As_Name)]                VARCHAR (255) NULL,
    [Physical_Location_Address_1]                  VARCHAR (255) NULL,
    [Physical_Location_Address_2]                  VARCHAR (255) NULL,
    [Physical_Location_City]                       VARCHAR (255) NULL,
    [Physical_Location_State_Code]                 VARCHAR (255) NULL,
    [Physical_Location_Zip_Code]                   VARCHAR (255) NULL,
    [Physical_Location_Phone_Number]               VARCHAR (255) NULL,
    [Physical_Location_Extension]                  VARCHAR (255) NULL,
    [Physical_Location_FAX_Number]                 VARCHAR (255) NULL,
    [Physical_Location_E-Mail_Address]             VARCHAR (255) NULL,
    [Physical_Location_Cross_Street_or_Directions] VARCHAR (255) NULL,
    [Mailing_Address_1]                            VARCHAR (255) NULL,
    [Mailing_Address_2]                            VARCHAR (50)  NULL,
    [Mailing_Address_City]                         VARCHAR (255) NULL,
    [Mailing_Address_State_Code]                   VARCHAR (255) NULL,
    [Mailing_Address_Zip_Code]                     VARCHAR (255) NULL,
    [Provider_Type_Code_(primary)]                 VARCHAR (255) NULL,
    [Name]                                         VARCHAR (255) NULL,
    [loadtime]                                     SMALLDATETIME CONSTRAINT [DF_relationship_loadtime] DEFAULT (getdate()) NULL
);


GO
CREATE CLUSTERED INDEX [IDX]
    ON [staging].[relationship]([ncpdp_nabp] ASC, [Relationship_Name] ASC);

