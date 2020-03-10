CREATE TABLE [dbo].[patientCenterTipDetailReport] (
    [patientCenterTipDetailReportid] INT             IDENTITY (1, 1) NOT NULL,
    [tipresultStatusID]              INT             NULL,
    [centerID]                       INT             NULL,
    [NCPDP_NABP]                     VARCHAR (50)    NULL,
    [centername]                     VARCHAR (100)   NULL,
    [patientid_all]                  VARCHAR (50)    NULL,
    [First_Name]                     VARCHAR (50)    NULL,
    [last_name]                      VARCHAR (50)    NULL,
    [DOB]                            DATETIME        NULL,
    [address1]                       VARCHAR (50)    NULL,
    [address2]                       VARCHAR (50)    NULL,
    [city]                           VARCHAR (50)    NULL,
    [state]                          VARCHAR (2)     NULL,
    [zipcode]                        VARCHAR (50)    NULL,
    [phone]                          VARCHAR (50)    NULL,
    [primaryPharmacy]                BIT             NULL,
    [pctFillatCenter]                DECIMAL (20, 2) NULL,
    [pctFillatChain]                 DECIMAL (20, 2) NULL,
    [policyid]                       INT             NULL,
    [policyname]                     VARCHAR (100)   NULL,
    [TipGenerationDT]                DATETIME        NULL,
    [reasontypeid]                   INT             NULL,
    [reasoncode]                     INT             NULL,
    [reasonTypeDesc]                 VARCHAR (100)   NULL,
    [actionTypeID]                   INT             NULL,
    [actionCode]                     INT             NULL,
    [actionNM]                       VARCHAR (100)   NULL,
    [ecaLevelID]                     INT             NULL,
    [tiptitle]                       VARCHAR (100)   NULL,
    [tiptype]                        VARCHAR (50)    NULL,
    [NPI]                            VARCHAR (50)    NULL,
    [Pharmacy_Address1]              VARCHAR (50)    NULL,
    [Pharmacy_Address2]              VARCHAR (50)    NULL,
    [Pharmacy_city]                  VARCHAR (50)    NULL,
    [Pharmacy_state]                 CHAR (2)        NULL,
    [Pharmacy_zip]                   VARCHAR (50)    NULL,
    [TipExpirationDT]                DATETIME        NULL,
    CONSTRAINT [PK_patientCenterTipDetailReport] PRIMARY KEY CLUSTERED ([patientCenterTipDetailReportid] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ind_centerid_tipgenerationDT_tiptype]
    ON [dbo].[patientCenterTipDetailReport]([centerID] ASC, [TipGenerationDT] ASC, [tiptype] ASC) WITH (FILLFACTOR = 80);

