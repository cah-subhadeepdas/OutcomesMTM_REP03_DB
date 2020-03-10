CREATE TABLE [staging].[smarterMTMQueueBucketPatient] (
    [smarterMTMQueueBucketPatientID] INT NOT NULL,
    [smarterMTMQueueBucketID]        INT NOT NULL,
    [patientID]                      INT NOT NULL,
    [policyID]                       INT NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_smarterMTMQueueBucketPatient_SmarterMTMQueueBucketPatientid]
    ON [staging].[smarterMTMQueueBucketPatient]([smarterMTMQueueBucketPatientID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_smarterMTMQueueBucketPatient_smartermtmqueuebucketid]
    ON [staging].[smarterMTMQueueBucketPatient]([smarterMTMQueueBucketID] ASC)
    INCLUDE([patientID]) WITH (FILLFACTOR = 100);

