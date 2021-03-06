﻿CREATE TABLE [dbo].[NCPDP_Services] (
    [NCPDP_ServicesID]                          INT         NOT NULL,
    [NCPDP_Provider_ID]                         VARCHAR (7) NULL,
    [Accepts_E-Prescriptions_Indicator]         VARCHAR (1) NULL,
    [Accepts_E-Prescriptions_Code]              VARCHAR (2) NULL,
    [Delivery_Service_Indicator]                VARCHAR (1) NULL,
    [Delivery_Service_Code]                     VARCHAR (2) NULL,
    [Compounding_Service_Indicator]             VARCHAR (1) NULL,
    [Compounding_Service_Code]                  VARCHAR (2) NULL,
    [Drive-up_Window_Indicator]                 VARCHAR (1) NULL,
    [Drive-up_Window_Code]                      VARCHAR (2) NULL,
    [Durable_Medical_Equipment_Indicator]       VARCHAR (1) NULL,
    [Durable_Medical_Equipment_Code]            VARCHAR (2) NULL,
    [Walk-In_Clinic_Indicator]                  VARCHAR (1) NULL,
    [Walk-In_Clinic_Code]                       VARCHAR (2) NULL,
    [24Hr_Emergency_Service_Indicator]          VARCHAR (1) NULL,
    [24Hr_Emergency_Service_Code]               VARCHAR (2) NULL,
    [Multi-Dose_Compliance_Packaging_Indicator] VARCHAR (1) NULL,
    [Multi-Dose_Compliance_Packaging_Code]      VARCHAR (2) NULL,
    [Immunizations_Provided_Indicator]          VARCHAR (1) NULL,
    [Immunizations_Provided_Code]               VARCHAR (2) NULL,
    [Handicapped_Accessible_Indicator]          VARCHAR (1) NULL,
    [Handicapped_Accessible_Code]               VARCHAR (2) NULL,
    [340B_Status_Indicator]                     VARCHAR (1) NULL,
    [340B_Status_Code]                          VARCHAR (2) NULL,
    [Closed_Door_Facility_Indicator]            VARCHAR (1) NULL,
    [Closed_Door_Facility_Code]                 VARCHAR (2) NULL,
    [Active]                                    BIT         NOT NULL,
    [fileid]                                    INT         NOT NULL
);

