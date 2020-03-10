CREATE TABLE [dbo].[IdentificationConfigStaging] (
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
    [identificationSourceTypeID] SMALLINT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [ind_1]
    ON [dbo].[IdentificationConfigStaging]([identificationConfigID] ASC);

