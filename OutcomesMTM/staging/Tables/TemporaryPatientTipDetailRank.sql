CREATE TABLE [staging].[TemporaryPatientTipDetailRank] (
    [tipresultid]          INT             NULL,
    [patientid_all]        VARCHAR (50)    NULL,
    [First_Name]           VARCHAR (50)    NULL,
    [last_name]            VARCHAR (50)    NULL,
    [DOB]                  DATETIME        NULL,
    [primaryPharmacy]      BIT             NULL,
    [pctFillatCenter]      DECIMAL (20, 2) NULL,
    [policyid]             INT             NOT NULL,
    [policyname]           VARCHAR (100)   NULL,
    [TipGenerationDT]      DATETIME        NULL,
    [reasontypeid]         INT             NOT NULL,
    [reasoncode]           INT             NULL,
    [reasonTypeDesc]       NVARCHAR (50)   NULL,
    [actionTypeID]         INT             NOT NULL,
    [actionCode]           INT             NULL,
    [actionNM]             VARCHAR (100)   NULL,
    [ecaLevelID]           INT             NULL,
    [tiptitle]             VARCHAR (100)   NOT NULL,
    [tiptype]              VARCHAR (7)     NOT NULL,
    [NPI]                  VARCHAR (50)    NULL,
    [Primary_NCPDP_NABP]   VARCHAR (50)    NULL,
    [Primary_PharmacyName] VARCHAR (100)   NULL,
    [Phone]                VARCHAR (50)    NULL,
    [Address1]             VARCHAR (50)    NULL,
    [Address2]             VARCHAR (50)    NULL,
    [City]                 VARCHAR (50)    NULL,
    [State]                VARCHAR (2)     NULL,
    [ZipCode]              VARCHAR (50)    NULL,
    [pharmacyCnt]          INT             NULL,
    [PharmacyNABPList]     VARCHAR (8000)  NULL,
    [pharmacyNameList]     VARCHAR (8000)  NULL,
    [primaryPharmacyList]  VARCHAR (8000)  NULL
);


GO
CREATE CLUSTERED INDEX [ind_2]
    ON [staging].[TemporaryPatientTipDetailRank]([tipresultid] ASC);

