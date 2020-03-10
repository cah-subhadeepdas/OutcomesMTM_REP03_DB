CREATE TABLE [dbo].[Audit_IdentRxDetail] (
    [PatientID]                  INT             NULL,
    [IdentificationRunID]        INT             NULL,
    [IdentificationDetailTypeID] SMALLINT        NULL,
    [RxID]                       BIGINT          NULL,
    [RxDate]                     DATE            NULL,
    [PatientCopay]               DECIMAL (19, 4) NULL,
    [ClientPayment]              DECIMAL (19, 4) NULL,
    [NDC]                        VARCHAR (50)    NULL
);

