CREATE TABLE [staging].[IdentificationRunResultDetail] (
    [IdentificationRunResultDetailID] BIGINT       NOT NULL,
    [IdentificationRunID]             INT          NOT NULL,
    [patientID]                       INT          NOT NULL,
    [identificationDetailID]          VARCHAR (50) NOT NULL,
    [identificationDetailTypeID]      SMALLINT     NOT NULL
);

