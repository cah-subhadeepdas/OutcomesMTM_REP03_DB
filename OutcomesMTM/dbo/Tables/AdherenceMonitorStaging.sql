CREATE TABLE [dbo].[AdherenceMonitorStaging] (
    [AdherenceMonitorID] INT             NOT NULL,
    [PatientID]          INT             NOT NULL,
    [tipdetailID]        INT             NOT NULL,
    [GPI]                VARCHAR (50)    NOT NULL,
    [CurrentPDC]         DECIMAL (20, 2) NULL,
    [DaysMissed]         SMALLINT        NULL,
    [AllowableDays]      SMALLINT        NULL,
    [BonusEligible]      BIT             NULL,
    [YearofUse]          SMALLINT        NULL,
    [active]             BIT             NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[AdherenceMonitorStaging]([AdherenceMonitorID] ASC);

