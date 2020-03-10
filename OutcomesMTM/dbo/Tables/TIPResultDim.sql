CREATE TABLE [dbo].[TIPResultDim] (
    [TIPresultKey] BIGINT       IDENTITY (1, 1) NOT NULL,
    [TIPresultid]  BIGINT       NOT NULL,
    [TIPdetailid]  INT          NOT NULL,
    [patientid]    INT          NOT NULL,
    [GPI]          VARCHAR (50) NULL,
    [repositoryid] BIGINT       NULL,
    [fileid]       INT          NULL,
    [activeasof]   DATETIME     NOT NULL,
    [activethru]   DATETIME     NULL,
    [iscurrent]    BIT          NOT NULL,
    CONSTRAINT [PK_TIPResultDim] PRIMARY KEY CLUSTERED ([TIPresultKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_TIPResultDim_activeasof]
    ON [dbo].[TIPResultDim]([TIPdetailid] ASC, [patientid] ASC, [activeasof] ASC) WITH (FILLFACTOR = 80);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_TIPResultDim_activethru]
    ON [dbo].[TIPResultDim]([TIPdetailid] ASC, [patientid] ASC, [activethru] ASC) WITH (FILLFACTOR = 80);

