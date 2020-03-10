CREATE TABLE [dbo].[patientServiceTypeDim] (
    [patientServiceTypeKey] BIGINT   IDENTITY (1, 1) NOT NULL,
    [patientServiceTypeID]  INT      NOT NULL,
    [patientID]             INT      NOT NULL,
    [serviceTypeID]         INT      NOT NULL,
    [activeAsOf]            DATETIME NOT NULL,
    [activeThru]            DATETIME NULL,
    PRIMARY KEY CLUSTERED ([patientServiceTypeKey] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [UK_patientServiceTypeDIM_activeasof]
    ON [dbo].[patientServiceTypeDim]([patientID] ASC, [serviceTypeID] ASC, [activeAsOf] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [UK_patientServiceTypeDIM_activethru]
    ON [dbo].[patientServiceTypeDim]([patientID] ASC, [serviceTypeID] ASC, [activeThru] ASC) WITH (FILLFACTOR = 80);

