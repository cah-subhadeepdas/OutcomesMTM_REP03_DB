CREATE TABLE [staging].[invoiceClaimStatus] (
    [invoiceClaimStatusID] INT      NOT NULL,
    [claimID]              INT      NOT NULL,
    [invoiceStatusTypeID]  INT      NOT NULL,
    [active]               BIT      NOT NULL,
    [createDT]             DATETIME NOT NULL,
    [roleID]               INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_invoiceClaimStatus_invoiceClaimStatusID]
    ON [staging].[invoiceClaimStatus]([invoiceClaimStatusID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_invoiceClaimStatus_claimid_active]
    ON [staging].[invoiceClaimStatus]([claimID] ASC, [active] ASC);

