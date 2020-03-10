CREATE TABLE [dbo].[Rx2] (
    [patientid] INT          NOT NULL,
    [rxid]      BIGINT       NOT NULL,
    [ndc]       VARCHAR (50) NOT NULL,
    [rxdate]    DATE         NOT NULL
);


GO
CREATE CLUSTERED INDEX [IDX]
    ON [dbo].[Rx2]([patientid] ASC);

