﻿CREATE TABLE [cmsETL].[TMR_CVSTEST] (
    [TMRID]     BIGINT NULL,
    [PatientID] INT    NULL,
    [TMRDate]   DATE   NULL
);


GO
CREATE NONCLUSTERED INDEX [IX__TMR_CVSTEST__PatientID__TMRDate]
    ON [cmsETL].[TMR_CVSTEST]([PatientID] ASC, [TMRDate] ASC)
    INCLUDE([TMRID]);

