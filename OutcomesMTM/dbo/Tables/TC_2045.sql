﻿CREATE TABLE [dbo].[TC_2045] (
    [Policy Name]                  VARCHAR (100)  NULL,
    [Policy ID]                    INT            NULL,
    [Member ID]                    VARCHAR (50)   NULL,
    [Member First Name]            VARCHAR (50)   NULL,
    [Member Last Name]             VARCHAR (50)   NULL,
    [DOB]                          DATE           NULL,
    [Current TIP Opportunities]    INT            NULL,
    [CMR Eligible]                 BIT            NULL,
    [Currently Targeted for a CMR] VARCHAR (1)    NULL,
    [Last CMR - Date]              DATE           NULL,
    [Last CMR - Result Name]       VARCHAR (100)  NULL,
    [Last CMR - NCPDP]             VARCHAR (50)   NULL,
    [Last CMR - Pharmacy Name]     VARCHAR (100)  NULL,
    [Client Name]                  VARCHAR (100)  NULL,
    [Chain Name]                   VARCHAR (1000) NULL,
    [Chain Code]                   VARCHAR (100)  NULL,
    [Client ID]                    INT            NULL,
    [Primary MTM Center ID]        VARCHAR (50)   NULL,
    [Primary MTM Center Name]      VARCHAR (100)  NULL
);

