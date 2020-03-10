CREATE TABLE [staging].[adherenceBarrier] (
    [adherenceBarrierID]     INT NOT NULL,
    [adherenceBarrierTypeID] INT NOT NULL,
    [claimID]                INT NOT NULL,
    [adherenceActionTypeID]  INT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_adherenceBarrier_adherenceBarrierID]
    ON [staging].[adherenceBarrier]([adherenceBarrierID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_adherenceBarrier_adherenceBarrierTypeID_claimID]
    ON [staging].[adherenceBarrier]([adherenceBarrierTypeID] ASC, [claimID] ASC)
    INCLUDE([adherenceBarrierID], [adherenceActionTypeID]);

