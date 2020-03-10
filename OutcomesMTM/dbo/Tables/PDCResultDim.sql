CREATE TABLE [dbo].[PDCResultDim] (
    [PDCresultKey] BIGINT       IDENTITY (1, 1) NOT NULL,
    [PDCresultID]  BIGINT       NOT NULL,
    [PDCruleID]    INT          NOT NULL,
    [PatientID]    INT          NOT NULL,
    [coveredDays]  INT          NOT NULL,
    [minIndexDate] DATE         NOT NULL,
    [maxIndexDate] DATE         NOT NULL,
    [GPI]          VARCHAR (50) NULL,
    [activeasof]   DATETIME     NOT NULL,
    [activethru]   DATETIME     NULL,
    [iscurrent]    BIT          NOT NULL,
    CONSTRAINT [PK_PDCResultDim] PRIMARY KEY CLUSTERED ([PDCresultKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_PDCResultDim_activeasof]
    ON [dbo].[PDCResultDim]([PDCruleID] ASC, [PatientID] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_PDCResultDim_activethru]
    ON [dbo].[PDCResultDim]([PDCruleID] ASC, [PatientID] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);

