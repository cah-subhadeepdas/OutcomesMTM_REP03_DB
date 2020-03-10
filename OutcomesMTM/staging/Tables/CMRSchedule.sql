CREATE TABLE [staging].[CMRSchedule] (
    [CMRScheduleID]     INT          NOT NULL,
    [patientID]         INT          NOT NULL,
    [centerID]          INT          NOT NULL,
    [providerID]        INT          NULL,
    [claimID]           INT          NULL,
    [ScheduleDate]      DATE         NULL,
    [ScheduleTime]      TIME (7)     NULL,
    [CreateDate]        DATETIME     NOT NULL,
    [active]            BIT          NOT NULL,
    [cmrScheduleResult] VARCHAR (20) NULL,
    [timeZoneID]        INT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_CMRSchedule_CMR_ScheduleID]
    ON [staging].[CMRSchedule]([CMRScheduleID] ASC);


GO
CREATE NONCLUSTERED INDEX [NC_CMRSchedule_active]
    ON [staging].[CMRSchedule]([centerID] ASC, [active] ASC)
    INCLUDE([patientID], [ScheduleDate]);


GO
CREATE NONCLUSTERED INDEX [NC_CMRSchedule_patientid]
    ON [staging].[CMRSchedule]([patientID] ASC)
    INCLUDE([active]);

