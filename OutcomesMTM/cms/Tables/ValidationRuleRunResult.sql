CREATE TABLE [cms].[ValidationRuleRunResult] (
    [VallidationRuleRunResultID] BIGINT IDENTITY (1, 1) NOT NULL,
    [ValidationRuleRunID]        INT    NOT NULL,
    [ResultStatus]               BIT    NOT NULL,
    [SnapshotID]                 INT    NULL,
    [PatientID]                  BIGINT NULL,
    [BeneficiaryID]              BIGINT NULL,
    [MTMPEnrollmentID]           BIGINT NULL,
    [IngestLogID]                BIGINT NULL,
    [ReportLogID]                BIGINT NULL,
    PRIMARY KEY CLUSTERED ([VallidationRuleRunResultID] ASC)
);

