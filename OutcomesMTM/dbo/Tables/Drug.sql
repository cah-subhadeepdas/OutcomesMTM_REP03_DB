CREATE TABLE [dbo].[Drug] (
    [DrugID]                  BIGINT           NULL,
    [FILEID]                  INT              NULL,
    [NDC]                     VARCHAR (50)     NULL,
    [MnDrugCode]              VARCHAR (50)     NULL,
    [Brand_Name_Code]         VARCHAR (50)     NULL,
    [OTCIndicator]            VARCHAR (50)     NULL,
    [MnLabel]                 VARCHAR (50)     NULL,
    [MnAbbreviated]           VARCHAR (50)     NULL,
    [Drug_Name_Strength]      VARCHAR (50)     NULL,
    [Product_Name]            VARCHAR (50)     NULL,
    [GPI]                     VARCHAR (50)     NULL,
    [Generic_Ingredient_Name] VARCHAR (100)    NULL,
    [NDC_UPC_HRI]             VARCHAR (50)     NULL,
    [Package_Description]     VARCHAR (50)     NULL,
    [AHFS_Code]               VARCHAR (50)     NULL,
    [AWP_Unit_Price]          NUMERIC (27, 12) NULL,
    [WAC_Unit_Price]          NUMERIC (27, 12) NULL,
    [CMS_ful_price]           NUMERIC (27, 12) NULL,
    [DP_Unit_Price]           NUMERIC (27, 12) NULL
);

