CREATE TABLE [dbo].[NCPDP_Medicaid] (
    [NCPDP_MedicaidID]  INT          NOT NULL,
    [NCPDP_Provider_ID] VARCHAR (7)  NOT NULL,
    [State_Code]        VARCHAR (2)  NULL,
    [Medicaid_ID]       VARCHAR (20) NULL,
    [Delete_Date]       DATE         NULL,
    [Active]            BIT          NOT NULL,
    [fileid]            INT          NOT NULL
);

