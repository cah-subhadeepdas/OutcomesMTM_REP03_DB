CREATE TABLE [dbo].[smarterMTMQueueReport_Staging] (
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
    [policyid]                INT             NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[smarterMTMQueueReport_Staging]([smarterMTMQueueBucketID] ASC, [patientID] ASC);

