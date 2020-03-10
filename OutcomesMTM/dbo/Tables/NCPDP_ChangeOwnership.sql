CREATE TABLE [dbo].[NCPDP_ChangeOwnership] (
    [NCPDP_ChangeOwnershipID]            INT         NOT NULL,
    [NCPDP_Provider_ID]                  VARCHAR (7) NULL,
    [Old_NCPDP_Provider_ID]              VARCHAR (7) NULL,
    [Old_Store_Close_Date]               DATE        NULL,
    [Change_of_Ownership_Effective_Date] DATE        NULL,
    [Active]                             BIT         NOT NULL,
    [fileid]                             INT         NOT NULL
);

