CREATE TABLE [staging].[dischargeLocation] (
    [dischargeLocationID]   INT           NOT NULL,
    [dischargeLocationName] VARCHAR (250) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_DischargeLocation_dischargeLocationID]
    ON [staging].[dischargeLocation]([dischargeLocationID] ASC);

