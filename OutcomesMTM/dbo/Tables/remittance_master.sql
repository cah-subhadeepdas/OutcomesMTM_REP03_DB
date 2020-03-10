CREATE TABLE [dbo].[remittance_master] (
    [chainname]          VARCHAR (100) NULL,
    [payeename1]         VARCHAR (35)  NULL,
    [claimid]            INT           NULL,
    [checkamount]        MONEY         NULL,
    [checkNumber]        VARCHAR (10)  NULL,
    [CheckDate]          VARCHAR (30)  NULL,
    [MTMServiceDt]       VARCHAR (30)  NULL,
    [ReferenceID]        INT           NULL,
    [PayType]            VARCHAR (25)  NULL,
    [PaidAmt]            MONEY         NULL,
    [rph_Name]           VARCHAR (100) NULL,
    [rph_license_Number] VARCHAR (50)  NULL,
    [reasondesc]         NVARCHAR (50) NULL,
    [actiondesc]         VARCHAR (50)  NULL,
    [resultdesc]         VARCHAR (100) NULL,
    [ncpdp_nabp]         VARCHAR (50)  NULL,
    [name]               VARCHAR (200) NULL
);

