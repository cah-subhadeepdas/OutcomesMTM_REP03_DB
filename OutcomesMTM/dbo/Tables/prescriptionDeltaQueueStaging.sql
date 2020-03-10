CREATE TABLE [dbo].[prescriptionDeltaQueueStaging] (
    [RxID]                 BIGINT          NULL,
    [patientid]            INT             NULL,
    [NCPDP_NABP]           VARCHAR (50)    NULL,
    [RxNumber]             VARCHAR (50)    NULL,
    [RxDate]               DATE            NULL,
    [NDC]                  VARCHAR (50)    NULL,
    [Qty]                  DECIMAL (20, 2) NULL,
    [Supply]               DECIMAL (20, 2) NULL,
    [PreferredFlag]        VARCHAR (50)    NULL,
    [PatientCopay]         MONEY           NULL,
    [ClientPayment]        MONEY           NULL,
    [PAStepIndicator]      BIT             NULL,
    [DAW]                  VARCHAR (50)    NULL,
    [patientresidence]     VARCHAR (50)    NULL,
    [active]               BIT             NULL,
    [repositoryArchiveID]  BIGINT          NULL,
    [fileID]               INT             NULL,
    [prid]                 BIGINT          NULL,
    [enterpriseChangeDate] DATETIME        NULL,
    [changeDate]           DATETIME        NULL,
    [queueDate]            DATETIME        NOT NULL,
    [isDelete]             BIT             NOT NULL,
    [isInsert]             BIT             NOT NULL,
    [queueOrder]           INT             NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_prescriptionDeltaQueueStaging]
    ON [dbo].[prescriptionDeltaQueueStaging]([patientid] ASC, [NCPDP_NABP] ASC, [RxNumber] ASC, [RxDate] ASC, [NDC] ASC, [queueOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_isDelete_isInsert]
    ON [dbo].[prescriptionDeltaQueueStaging]([isDelete] ASC, [isInsert] ASC)
    INCLUDE([patientid], [NCPDP_NABP], [RxNumber], [RxDate], [NDC], [queueOrder], [queueDate]);


GO
CREATE NONCLUSTERED INDEX [ind_isInsert]
    ON [dbo].[prescriptionDeltaQueueStaging]([isInsert] ASC)
    INCLUDE([patientid], [NCPDP_NABP], [RxNumber], [RxDate], [NDC], [queueOrder], [queueDate]);

