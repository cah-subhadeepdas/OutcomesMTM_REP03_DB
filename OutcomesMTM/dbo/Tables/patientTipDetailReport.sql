CREATE TABLE [dbo].[patientTipDetailReport] (
    [patientTipDetailReportid] INT             IDENTITY (1, 1) NOT NULL,
    [tipresultid]              BIGINT          NULL,
    [patientid_all]            VARCHAR (50)    NULL,
    [First_Name]               VARCHAR (50)    NULL,
    [last_name]                VARCHAR (50)    NULL,
    [DOB]                      DATETIME        NULL,
    [primaryPharmacy]          BIT             NULL,
    [pctFillatCenter]          DECIMAL (20, 2) NULL,
    [policyid]                 INT             NULL,
    [policyname]               VARCHAR (100)   NULL,
    [TipGenerationDT]          DATETIME        NULL,
    [reasontypeid]             INT             NULL,
    [reasoncode]               INT             NULL,
    [reasonTypeDesc]           VARCHAR (100)   NULL,
    [actionTypeID]             INT             NULL,
    [actionCode]               INT             NULL,
    [actionNM]                 VARCHAR (100)   NULL,
    [ecaLevelID]               INT             NULL,
    [tiptitle]                 VARCHAR (100)   NULL,
    [tiptype]                  VARCHAR (50)    NULL,
    [pharmacyCnt]              INT             NULL,
    [PharmacyNABPList]         VARCHAR (8000)  NULL,
    [pharmacyNameList]         VARCHAR (8000)  NULL,
    [primaryPharmacyList]      VARCHAR (8000)  NULL,
    [NPI]                      VARCHAR (50)    NULL,
    [PRIMARY_NCPDP_NABP]       VARCHAR (50)    NULL,
    [Primary_PharmacyName]     VARCHAR (100)   NULL,
    [phone]                    VARCHAR (50)    NULL,
    [Address1]                 VARCHAR (50)    NULL,
    [Address2]                 VARCHAR (50)    NULL,
    [City]                     VARCHAR (50)    NULL,
    [state]                    VARCHAR (2)     NULL,
    [ZipCode]                  VARCHAR (50)    NULL,
    [TipExpirationDT]          DATETIME        NULL,
    CONSTRAINT [PK_patientTipDetailReport] PRIMARY KEY CLUSTERED ([patientTipDetailReportid] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_tipresultid]
    ON [dbo].[patientTipDetailReport]([tipresultid] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_reasontypeid_policyid_tipgenerationDT_tiptype]
    ON [dbo].[patientTipDetailReport]([reasontypeid] ASC, [policyid] ASC, [TipGenerationDT] ASC, [tiptype] ASC) WITH (FILLFACTOR = 80);

