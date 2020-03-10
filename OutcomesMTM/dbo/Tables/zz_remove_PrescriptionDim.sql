CREATE TABLE [dbo].[zz_remove_PrescriptionDim] (
    [prescriptionKey] BIGINT          NOT NULL,
    [RxID]            BIGINT          NOT NULL,
    [patientid]       INT             NOT NULL,
    [NCPDP_NABP]      VARCHAR (50)    NOT NULL,
    [RxNumber]        VARCHAR (50)    NOT NULL,
    [RxDate]          DATE            NOT NULL,
    [NDC]             VARCHAR (50)    NOT NULL,
    [Qty]             DECIMAL (20, 2) NULL,
    [Supply]          DECIMAL (20, 2) NULL,
    [PatientCopay]    MONEY           NULL,
    [ClientPayment]   MONEY           NULL,
    [prid]            BIGINT          NULL,
    [PreferredFlag]   VARCHAR (50)    NULL,
    [PAStepIndicator] BIT             NULL,
    [DAW]             VARCHAR (50)    NULL,
    [active]          BIT             NOT NULL,
    [activeAsOf]      DATETIME        NOT NULL,
    [activeThru]      DATETIME        NULL,
    [isCurrent]       BIT             NOT NULL
);

