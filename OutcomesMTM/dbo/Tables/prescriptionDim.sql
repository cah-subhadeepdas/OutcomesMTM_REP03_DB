CREATE TABLE [dbo].[prescriptionDim] (
    [prescriptionKey] BIGINT          IDENTITY (1, 1) NOT NULL,
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
    [isCurrent]       BIT             NOT NULL,
    CONSTRAINT [PK__prescriptionDIM] PRIMARY KEY CLUSTERED ([prescriptionKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_prescriptionDim_activeasof]
    ON [dbo].[prescriptionDim]([patientid] ASC, [NCPDP_NABP] ASC, [RxNumber] ASC, [RxDate] ASC, [NDC] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
ALTER INDEX [UK_prescriptionDim_activeasof]
    ON [dbo].[prescriptionDim] DISABLE;


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_prescriptionDim_activethru]
    ON [dbo].[prescriptionDim]([patientid] ASC, [NCPDP_NABP] ASC, [RxNumber] ASC, [RxDate] ASC, [NDC] ASC, [activeThru] ASC) WITH (FILLFACTOR = 80);


GO
ALTER INDEX [UK_prescriptionDim_activethru]
    ON [dbo].[prescriptionDim] DISABLE;


GO
CREATE NONCLUSTERED INDEX [IX__prescriptionDim__RxID]
    ON [dbo].[prescriptionDim]([RxID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NC_prescriptionDim_patientkey]
    ON [dbo].[prescriptionDim]([patientid] ASC, [NCPDP_NABP] ASC, [RxNumber] ASC, [active] ASC, [activeAsOf] ASC, [activeThru] ASC)
    INCLUDE([RxDate], [NDC], [isCurrent]);

