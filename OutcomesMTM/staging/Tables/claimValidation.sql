CREATE TABLE [staging].[claimValidation] (
    [claimValidationID]                INT    NOT NULL,
    [claimid]                          INT    NOT NULL,
    [validationRuleID]                 INT    NOT NULL,
    [validated]                        BIT    NOT NULL,
    [processed]                        BIT    NOT NULL,
    [payable]                          BIT    NOT NULL,
    [policyValidationRuleTypeDetailID] INT    NULL,
    [RXID]                             BIGINT NULL,
    [active]                           BIT    NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_claimValidation_claimValidationID]
    ON [staging].[claimValidation]([claimValidationID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_claimValidation_claimid_validationRuleID]
    ON [staging].[claimValidation]([claimid] ASC, [validationRuleID] ASC)
    INCLUDE([validated], [processed], [active]);

