CREATE TABLE [dbo].[NCPDP_RemitReconciliation] (
    [NCPDP_RemitReconciliationID]             INT          NOT NULL,
    [Remit_and_Reconciliation_ID]             VARCHAR (6)  NULL,
    [Remit_and_Reconciliation_Name]           VARCHAR (35) NULL,
    [Remit_and_Reconciliation_Address_1]      VARCHAR (55) NULL,
    [Remit_and_Reconciliation_Address_2]      VARCHAR (55) NULL,
    [Remit_and_Reconciliation_City]           VARCHAR (30) NULL,
    [Remit_and_Reconciliation_State_Code]     VARCHAR (2)  NULL,
    [Remit_and_Reconciliation_Zip_Code]       VARCHAR (9)  NULL,
    [Remit_and_Reconciliation_Phone_Number]   VARCHAR (10) NULL,
    [Remit_and_Reconciliation_Extension]      VARCHAR (5)  NULL,
    [Remit_and_Reconciliation_FAX_Number]     VARCHAR (10) NULL,
    [Remit_and_Reconciliation_NPI]            VARCHAR (10) NULL,
    [Remit_and_Reconciliation_Tax_ID]         VARCHAR (15) NULL,
    [Remit_and_Reconciliation_Contact_Name]   VARCHAR (30) NULL,
    [Remit_and_Reconciliation_Contact_Title]  VARCHAR (30) NULL,
    [Remit_and_Reconciliation_E-Mail_Address] VARCHAR (50) NULL,
    [Delete_Date]                             DATE         NULL,
    [Active]                                  BIT          NOT NULL,
    [fileid]                                  INT          NOT NULL
);

