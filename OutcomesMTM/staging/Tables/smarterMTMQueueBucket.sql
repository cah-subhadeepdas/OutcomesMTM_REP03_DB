CREATE TABLE [staging].[smarterMTMQueueBucket] (
    [smarterMTMQueueBucketID] INT            NOT NULL,
    [bucketDesc]              VARCHAR (300)  NULL,
    [bucketNote]              VARCHAR (1000) NULL,
    [priority]                INT            NULL,
    [createBy]                BIGINT         NOT NULL,
    [createDT]                DATETIME       NULL,
    [inactiveDT]              DATETIME       NULL,
    [inactiveBy]              BIGINT         NULL,
    [fileName]                VARCHAR (1000) NULL,
    [processed]               BIT            NOT NULL,
    [processedDT]             DATETIME       NULL,
    [active]                  BIT            NOT NULL
);

