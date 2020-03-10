CREATE TABLE [dbo].[remittance_master_adj] (
    [chainname]             VARCHAR (100) NULL,
    [ClaimNumber]           INT           NULL,
    [MTM_Service_Date]      VARCHAR (30)  NULL,
    [Pharmacy_NABP]         VARCHAR (50)  NULL,
    [Pharmacy_Name]         VARCHAR (200) NULL,
    [Adjustment_Amount]     MONEY         NULL,
    [Adjustment_Reason]     VARCHAR (50)  NULL,
    [ADJUSTMENT_DATE]       VARCHAR (30)  NULL,
    [Original_CheckNumber]  VARCHAR (10)  NULL,
    [Original_CheckDate]    VARCHAR (30)  NULL,
    [Original_PayeeName]    VARCHAR (35)  NULL,
    [Original_PayeeAddress] VARCHAR (35)  NULL,
    [Original_PayeeCity]    VARCHAR (30)  NULL,
    [Original_PayeeState]   CHAR (2)      NULL,
    [Original_PayeeZip]     VARCHAR (9)   NULL
);

