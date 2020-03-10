CREATE TABLE [cmsETL].[CMROfferFileLoadArchive] (
    [MEMBER_ID]             VARCHAR (50)  NULL,
    [CMR_OFFER_DATE]        DATE          NULL,
    [CMR_OFFER_MODALITY]    VARCHAR (50)  NULL,
    [CMR_OFFER_RECIPIENT]   VARCHAR (50)  NULL,
    [CMR_OFFER_RETURN_DATE] DATE          NULL,
    [OMTM_CLIENT_ID]        INT           NULL,
    [Filename]              VARCHAR (100) NULL,
    [LoadTime]              DATETIME      NULL,
    [FileLoadId]            INT           NULL,
    [PublishTime]           DATETIME2 (7) NULL
);

