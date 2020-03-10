CREATE TABLE [cms].[EnrollmentConfig] (
    [EnrollmentConfigID]  INT          NOT NULL,
    [ClientID]            INT          NOT NULL,
    [ContractYear]        CHAR (4)     NOT NULL,
    [ContractNumber]      VARCHAR (5)  NULL,
    [PolicyID]            INT          NULL,
    [EnrollmentType]      VARCHAR (50) NULL,
    [EnrollmentSource]    VARCHAR (50) NULL,
    [EnrollmentDateLogic] VARCHAR (50) NULL,
    [TargetingSource]     VARCHAR (50) NULL,
    [TargetingDateLogic]  VARCHAR (50) NULL,
    [ActiveFromDT]        DATETIME     NOT NULL,
    [ActiveThruDT]        DATETIME     NOT NULL,
    [Frequency]           VARCHAR (50) NULL
);

