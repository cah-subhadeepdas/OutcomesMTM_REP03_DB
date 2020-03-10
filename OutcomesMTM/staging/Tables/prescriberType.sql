CREATE TABLE [staging].[prescriberType] (
    [prescriberTypeID] TINYINT      NOT NULL,
    [prescriberType]   VARCHAR (50) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_prescriberType_prescriberTypeID]
    ON [staging].[prescriberType]([prescriberTypeID] ASC);

