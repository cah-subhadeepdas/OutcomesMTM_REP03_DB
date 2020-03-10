CREATE TABLE [staging].[claimValidationPayment] (
    [claimValidationPaymentID]  INT             NOT NULL,
    [claimValidationID]         INT             NOT NULL,
    [ValidationPaymentStatusID] INT             NULL,
    [payment]                   DECIMAL (20, 2) NOT NULL,
    [processed]                 BIT             NOT NULL,
    [checkDate]                 DATE            NULL,
    [active]                    BIT             NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_claimValidationPayment_claimValidationPaymentID]
    ON [staging].[claimValidationPayment]([claimValidationPaymentID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_claimValidationPayment_claimValidationID]
    ON [staging].[claimValidationPayment]([claimValidationID] ASC)
    INCLUDE([payment], [processed], [checkDate], [active]);


GO
CREATE NONCLUSTERED INDEX [NC_claimValidationPayment_claimValidationPaymentID]
    ON [staging].[claimValidationPayment]([claimValidationPaymentID] ASC)
    INCLUDE([payment], [processed], [active]);

