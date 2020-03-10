CREATE TABLE [staging].[policyRAR] (
    [policyRARID]    INT             NOT NULL,
    [policyID]       INT             NOT NULL,
    [RARID]          INT             NOT NULL,
    [serviceFee]     DECIMAL (20, 2) NOT NULL,
    [invoiceAmount]  DECIMAL (20, 2) NOT NULL,
    [transactionFee] DECIMAL (20, 2) NOT NULL,
    [activeAsOf]     DATE            NOT NULL,
    [activeThru]     DATE            NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_PolicyRAR_PolicyRARID]
    ON [staging].[policyRAR]([policyRARID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [NC_policyRAR_policyID]
    ON [staging].[policyRAR]([policyID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [NC_policyRAR_RARID]
    ON [staging].[policyRAR]([RARID] ASC) WITH (FILLFACTOR = 100);

