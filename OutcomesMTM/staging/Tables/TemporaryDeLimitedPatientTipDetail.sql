CREATE TABLE [staging].[TemporaryDeLimitedPatientTipDetail] (
    [tipresultID]     BIGINT         NOT NULL,
    [ncpdp_nabp]      VARCHAR (8000) NULL,
    [centerName]      VARCHAR (8000) NULL,
    [primaryPharmacy] VARCHAR (7)    NOT NULL,
    [PharmacyCnt]     INT            NOT NULL,
    [rowid]           INT            IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([rowid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_2]
    ON [staging].[TemporaryDeLimitedPatientTipDetail]([tipresultID] ASC);

