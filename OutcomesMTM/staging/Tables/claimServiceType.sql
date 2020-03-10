CREATE TABLE [staging].[claimServiceType] (
    [claimServiceTypeID] INT      NOT NULL,
    [claimID]            INT      NOT NULL,
    [serviceTypeID]      INT      NOT NULL,
    [active]             BIT      NOT NULL,
    [effectiveDate]      DATETIME NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_claimServiceType_claimServiceTypeID]
    ON [staging].[claimServiceType]([claimServiceTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_claimServiceType_claimid_active_serviceTpyeID]
    ON [staging].[claimServiceType]([claimID] ASC, [active] ASC, [serviceTypeID] ASC)
    INCLUDE([claimServiceTypeID], [effectiveDate]);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_claimServiceType_claimid_serviceTypeID]
    ON [staging].[claimServiceType]([claimID] ASC, [serviceTypeID] ASC);

