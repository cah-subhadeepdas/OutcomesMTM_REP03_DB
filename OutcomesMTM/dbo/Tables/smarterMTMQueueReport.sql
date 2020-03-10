CREATE TABLE [dbo].[smarterMTMQueueReport] (
    [smarterMTMQueueReportID] INT             IDENTITY (1, 1) NOT NULL,
    [smarterMTMQueueBucketID] INT             NULL,
    [BucketName]              VARCHAR (300)   NULL,
    [bucketNote]              VARCHAR (1000)  NULL,
    [patientID_All]           VARCHAR (50)    NULL,
    [patientID]               INT             NULL,
    [First_Name]              VARCHAR (100)   NULL,
    [Last_Name]               VARCHAR (100)   NULL,
    [DOB]                     DATE            NULL,
    [Phone]                   VARCHAR (50)    NULL,
    [tipcnt]                  INT             NULL,
    [cmr]                     CHAR (1)        NULL,
    [cmrEligible]             BIT             NULL,
    [primaryPharmacyNABP]     VARCHAR (50)    NULL,
    [primaryPharmacyName]     VARCHAR (100)   NULL,
    [pctfillatcenter]         DECIMAL (20, 2) NULL,
    [checkPointDue]           CHAR (1)        NULL,
    [rank]                    INT             NULL,
    [policyid]                INT             NULL,
    CONSTRAINT [PK_smarterMTMQueueReport] PRIMARY KEY CLUSTERED ([smarterMTMQueueReportID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_smarterMTMQueueReport]
    ON [dbo].[smarterMTMQueueReport]([smarterMTMQueueBucketID] ASC, [patientID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NC_smarterMTMQueueBucketID]
    ON [dbo].[smarterMTMQueueReport]([smarterMTMQueueBucketID] ASC)
    INCLUDE([smarterMTMQueueReportID], [BucketName], [bucketNote], [patientID_All], [patientID], [First_Name], [Last_Name], [DOB], [Phone], [tipcnt], [cmr], [cmrEligible], [primaryPharmacyNABP], [primaryPharmacyName], [pctfillatcenter], [checkPointDue], [rank]) WITH (FILLFACTOR = 80);

