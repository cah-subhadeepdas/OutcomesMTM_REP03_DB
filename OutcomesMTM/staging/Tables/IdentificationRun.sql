CREATE TABLE [staging].[IdentificationRun] (
    [identificationRunid]    INT      NOT NULL,
    [identificationConfigid] INT      NOT NULL,
    [runRxDataThru]          DATE     NOT NULL,
    [policyid]               INT      NOT NULL,
    [policyRxDataFrom]       DATE     NOT NULL,
    [policyRxDataThru]       DATE     NOT NULL,
    [RunDate]                DATETIME NULL,
    [ApprovedDate]           DATETIME NULL,
    [active]                 BIT      NOT NULL,
    [RunInactivationDate]    DATETIME NULL
);

