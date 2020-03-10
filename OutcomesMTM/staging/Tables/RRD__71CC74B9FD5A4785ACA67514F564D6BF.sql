CREATE TABLE [staging].[RRD__71CC74B9FD5A4785ACA67514F564D6BF] (
    [patientID]                  INT      NULL,
    [IdentificationRunID]        INT      NULL,
    [IdentificationDetailTypeID] SMALLINT NULL,
    [IdentificationDetailID]     BIGINT   NULL
);


GO
CREATE CLUSTERED INDEX [PK__Audit_IdentRRD]
    ON [staging].[RRD__71CC74B9FD5A4785ACA67514F564D6BF]([patientID] ASC, [IdentificationDetailID] ASC, [IdentificationRunID] ASC, [IdentificationDetailTypeID] ASC) WITH (DATA_COMPRESSION = PAGE);

