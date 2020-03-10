CREATE TABLE [cms].[EnrollmentConfig_2018] (
    [EnrollmentConfigID]  INT          IDENTITY (1, 1) NOT NULL,
    [ClientID]            INT          NOT NULL,
    [ContractYear]        CHAR (4)     NOT NULL,
    [ContractNumber]      VARCHAR (5)  NULL,
    [PolicyID]            INT          NULL,
    [EnrollmentType]      VARCHAR (50) NULL,
    [EnrollmentSource]    VARCHAR (50) NULL,
    [EnrollmentDateLogic] VARCHAR (50) NULL,
    [TargetingSource]     VARCHAR (50) NULL,
    [TargetingDateLogic]  VARCHAR (50) NULL,
    [ActiveFromDT]        DATETIME     DEFAULT (getdate()) NOT NULL,
    [ActiveThruDT]        DATETIME     DEFAULT ('9999-12-31') NOT NULL,
    PRIMARY KEY CLUSTERED ([EnrollmentConfigID] ASC)
);

