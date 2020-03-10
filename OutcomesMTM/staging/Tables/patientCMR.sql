CREATE TABLE [staging].[patientCMR] (
    [patientCMR]       INT      NOT NULL,
    [patientid]        INT      NOT NULL,
    [CMRcompleteddate] DATETIME NULL,
    [CMRcompleted]     BIT      NULL,
    [CMRoffereddate]   DATETIME NULL,
    [CMRoffered]       BIT      NULL,
    [CMRsuccess]       BIT      NULL,
    [CMRrefused]       BIT      NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_patientCMR_patientCMR]
    ON [staging].[patientCMR]([patientCMR] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UNC_patientCMR_patientid]
    ON [staging].[patientCMR]([patientid] ASC);

