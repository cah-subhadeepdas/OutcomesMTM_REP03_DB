CREATE TABLE [cmsETL].[CMROfferFileLoadStage] (
    [MEMBER_ID]             VARCHAR (50)  NULL,
    [CMR_OFFER_DATE]        DATE          NULL,
    [CMR_OFFER_MODALITY]    VARCHAR (50)  NULL,
    [CMR_OFFER_RECIPIENT]   VARCHAR (50)  NULL,
    [CMR_OFFER_RETURN_DATE] DATE          NULL,
    [OMTM_CLIENT_ID]        INT           NULL,
    [Filename]              VARCHAR (100) NULL,
    [LoadTime]              DATETIME      CONSTRAINT [DF_CMROfferFileLoadStage_LoadTime] DEFAULT (getdate()) NULL,
    [FileLoadId]            INT           NULL,
    [PublishTime]           DATETIME2 (7) NULL
);


GO
CREATE NONCLUSTERED INDEX [NC_CMROfferFileLoadStage]
    ON [cmsETL].[CMROfferFileLoadStage]([FileLoadId] ASC)
    INCLUDE([MEMBER_ID], [CMR_OFFER_DATE], [OMTM_CLIENT_ID]);

