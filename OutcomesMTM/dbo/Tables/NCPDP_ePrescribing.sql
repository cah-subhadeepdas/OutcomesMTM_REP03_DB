CREATE TABLE [dbo].[NCPDP_ePrescribing] (
    [NCPDP_ePrescribingID]            INT           NOT NULL,
    [NCPDP_Provider_ID]               VARCHAR (7)   NULL,
    [ePrescribing_Network_Identifier] VARCHAR (3)   NULL,
    [Service_Level_Code]              VARCHAR (100) NULL,
    [Effective_From_Date]             DATE          NULL,
    [Effective_Through_Date]          DATE          NULL,
    [Active]                          BIT           NOT NULL,
    [fileid]                          INT           NOT NULL
);

