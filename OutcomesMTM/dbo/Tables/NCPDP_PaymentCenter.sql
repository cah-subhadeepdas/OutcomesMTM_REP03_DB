CREATE TABLE [dbo].[NCPDP_PaymentCenter] (
    [NCPDP_PaymentCenterID]         INT          NOT NULL,
    [Payment_Center_ID]             VARCHAR (6)  NULL,
    [Payment_Center_Name]           VARCHAR (35) NULL,
    [Payment_Center_Address_1]      VARCHAR (55) NULL,
    [Payment_Center_Address_2]      VARCHAR (55) NULL,
    [Payment_Center_City]           VARCHAR (30) NULL,
    [Payment_Center_State_Code]     VARCHAR (2)  NULL,
    [Payment_Center_Zip_Code]       VARCHAR (9)  NULL,
    [Payment_Center_Phone_Number]   VARCHAR (10) NULL,
    [Payment_Center_Extension]      VARCHAR (5)  NULL,
    [Payment_Center_FAX_Number]     VARCHAR (10) NULL,
    [Payment_Center_NPI]            VARCHAR (10) NULL,
    [Payment_Center_Tax_ID]         VARCHAR (15) NULL,
    [Payment_Center_Contact_Name]   VARCHAR (30) NULL,
    [Payment_Center_Contact_Title]  VARCHAR (30) NULL,
    [Payment_Center_E-Mail_Address] VARCHAR (50) NULL,
    [Delete_Date]                   DATE         NULL,
    [active]                        BIT          NOT NULL,
    [fileid]                        INT          NOT NULL
);

