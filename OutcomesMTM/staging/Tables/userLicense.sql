CREATE TABLE [staging].[userLicense] (
    [userLicenseID] INT           NOT NULL,
    [userID]        INT           NOT NULL,
    [licenseTypeID] INT           NOT NULL,
    [stateID]       INT           NULL,
    [licenseNumber] VARCHAR (100) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [UC_userLicense_userLicenseID]
    ON [staging].[userLicense]([userLicenseID] ASC);

