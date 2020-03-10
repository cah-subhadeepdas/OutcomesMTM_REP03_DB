CREATE TABLE [dbo].[IdentificationConfig] (
    [identificationConfigID]     INT           NOT NULL,
    [identificationConfigName]   VARCHAR (100) NULL,
    [identificationTypeID]       SMALLINT      NOT NULL,
    [PolicyID]                   INT           NOT NULL,
    [contractyear]               INT           NOT NULL,
    [serviceTypeID]              SMALLINT      NOT NULL,
    [patientActivate]            BIT           NOT NULL,
    [cmrActivate]                BIT           NOT NULL,
    [identificationConfigTypeID] SMALLINT      NULL,
    [ID]                         INT           NOT NULL,
    [identificationDXTypeID]     SMALLINT      NULL,
    [identificationRXTypeID]     SMALLINT      NULL,
    [identificationTipTypeID]    SMALLINT      NULL,
    [active]                     BIT           NOT NULL,
    [activeasof]                 DATETIME      NOT NULL,
    [activethru]                 DATETIME      NULL,
    [identificationSourceTypeID] SMALLINT      NOT NULL,
    CONSTRAINT [PK_IdentificationConfig] PRIMARY KEY CLUSTERED ([identificationConfigID] ASC) WITH (FILLFACTOR = 80)
);

