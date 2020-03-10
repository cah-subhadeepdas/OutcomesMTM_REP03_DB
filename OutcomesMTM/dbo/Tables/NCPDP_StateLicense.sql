CREATE TABLE [dbo].[NCPDP_StateLicense] (
    [NCPDP_StateLicenseID]    INT          NOT NULL,
    [NCPDP_Provider_ID]       VARCHAR (7)  NULL,
    [State_Code]              VARCHAR (2)  NULL,
    [State_License_ID]        VARCHAR (20) NULL,
    [License_Expiration_Date] DATE         NULL,
    [Delete_Date]             DATE         NULL,
    [Active]                  BIT          NOT NULL,
    [fileid]                  INT          NOT NULL
);

