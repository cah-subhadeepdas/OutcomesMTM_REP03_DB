CREATE TABLE [dbo].[ZZ_adherenceMonitorDim] (
    [AdherenceMonitorKey] BIGINT          IDENTITY (1, 1) NOT NULL,
    [AdherenceMonitorID]  INT             NOT NULL,
    [PatientID]           INT             NOT NULL,
    [tipdetailID]         INT             NOT NULL,
    [GPI]                 VARCHAR (50)    NOT NULL,
    [CurrentPDC]          DECIMAL (20, 2) NULL,
    [DaysMissed]          SMALLINT        NULL,
    [AllowableDays]       SMALLINT        NULL,
    [BonusEligible]       BIT             NULL,
    [YearofUse]           SMALLINT        NULL,
    [repositoryArchiveid] INT             NULL,
    [fileid]              INT             NULL,
    [activeasof]          DATETIME        NOT NULL,
    [activethru]          DATETIME        NULL,
    [iscurrent]           BIT             NOT NULL,
    CONSTRAINT [PK_AdherenceMonitorDim] PRIMARY KEY CLUSTERED ([AdherenceMonitorKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_AdherenceMonitorID_activeasof]
    ON [dbo].[ZZ_adherenceMonitorDim]([PatientID] ASC, [tipdetailID] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_AdherenceMonitorID_activethru]
    ON [dbo].[ZZ_adherenceMonitorDim]([PatientID] ASC, [tipdetailID] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [ind_activethru]
    ON [dbo].[ZZ_adherenceMonitorDim]([activethru] ASC)
    INCLUDE([AdherenceMonitorKey], [AdherenceMonitorID]) WITH (FILLFACTOR = 80);

