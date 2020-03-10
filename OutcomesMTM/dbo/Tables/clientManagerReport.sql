﻿CREATE TABLE [dbo].[clientManagerReport] (
    [clientManagerReportid]                              INT             IDENTITY (1, 1) NOT NULL,
    [claimid]                                            INT             NULL,
    [policyid]                                           INT             NULL,
    [policyNM]                                           NVARCHAR (100)  NULL,
    [mtmserviceDT]                                       DATETIME        NULL,
    [status]                                             VARCHAR (100)   NULL,
    [patientid]                                          INT             NULL,
    [MemberID]                                           VARCHAR (50)    NULL,
    [MemberFirstNM]                                      VARCHAR (50)    NULL,
    [MemberlastNM]                                       VARCHAR (50)    NULL,
    [MemberDOB]                                          DATE            NULL,
    [MemberGender]                                       CHAR (1)        NULL,
    [MemberPhone]                                        VARCHAR (50)    NULL,
    [memberCMSContractNumber]                            VARCHAR (50)    NULL,
    [memberPBP]                                          VARCHAR (50)    NULL,
    [centerid]                                           INT             NULL,
    [PharmacyNABP]                                       VARCHAR (50)    NULL,
    [PharmacyName]                                       VARCHAR (100)   NULL,
    [PharmacyState]                                      CHAR (2)        NULL,
    [pharmacistUserID]                                   INT             NULL,
    [pharmacistFirstNM]                                  VARCHAR (50)    NULL,
    [pharmacistlastNM]                                   VARCHAR (50)    NULL,
    [PharmacistlicenseNumber]                            VARCHAR (100)   NULL,
    [reasonTypeID]                                       INT             NULL,
    [reason]                                             INT             NULL,
    [reasonNM]                                           VARCHAR (100)   NULL,
    [actiontypeid]                                       INT             NULL,
    [action]                                             INT             NULL,
    [actionNM]                                           VARCHAR (100)   NULL,
    [resulttypeid]                                       INT             NULL,
    [result]                                             INT             NULL,
    [resultNM]                                           VARCHAR (100)   NULL,
    [ecalevelid]                                         INT             NULL,
    [serveritylevel]                                     INT             NULL,
    [serveritylevelNM]                                   VARCHAR (200)   NULL,
    [estimated_cost]                                     MONEY           NULL,
    [AIM]                                                MONEY           NULL,
    [charges]                                            MONEY           NULL,
    [ECAexplanation]                                     VARCHAR (MAX)   NULL,
    [additionalnotes]                                    VARCHAR (MAX)   NULL,
    [face2face]                                          BIT             NULL,
    [claimfromcmr]                                       BIT             NULL,
    [isTipClaim]                                         BIT             NULL,
    [tipResultID]                                        INT             NULL,
    [tiptitle]                                           VARCHAR (100)   NULL,
    [tipidentificationdate]                              DATE            NULL,
    [currentMedRxNumber]                                 VARCHAR (100)   NULL,
    [currentMedMetricQuantity]                           DECIMAL (20, 2) NULL,
    [currentMedDaysSupply]                               DECIMAL (20, 2) NULL,
    [currentMedGpi]                                      VARCHAR (100)   NULL,
    [currentMedName]                                     VARCHAR (300)   NULL,
    [newMedRxNumber]                                     VARCHAR (100)   NULL,
    [newMedMetricQuantity]                               DECIMAL (20, 2) NULL,
    [newMedDaysSupply]                                   DECIMAL (20, 2) NULL,
    [newMedGpi]                                          VARCHAR (100)   NULL,
    [newMedName]                                         VARCHAR (300)   NULL,
    [Adherence - Too many medications or doses per day]  VARCHAR (400)   NULL,
    [Adherence - Forgets to take on routine days]        VARCHAR (400)   NULL,
    [Adherence - Forgets to take on non-routine days]    VARCHAR (400)   NULL,
    [Feels medication is not helping]                    VARCHAR (400)   NULL,
    [Feels medication is not needed]                     VARCHAR (400)   NULL,
    [Experienced side effects]                           VARCHAR (400)   NULL,
    [Concerned about potential side effects]             VARCHAR (400)   NULL,
    [Medication cost is too high]                        VARCHAR (400)   NULL,
    [Decreased cognitive function]                       VARCHAR (400)   NULL,
    [Limitations on activities of daily living]          VARCHAR (400)   NULL,
    [Transportation limitations prevent pharmacy access] VARCHAR (400)   NULL,
    [Patient taking differently than written directions] VARCHAR (400)   NULL,
    [Pharmacy error in directions/delivery/medication]   VARCHAR (400)   NULL,
    [Refill request delay]                               VARCHAR (400)   NULL,
    [refillpickedup]                                     CHAR (2)        NULL,
    [memberRefusalDesc]                                  VARCHAR (1000)  NULL,
    [prescriberRefusalDesc]                              VARCHAR (1000)  NULL,
    [paiddate]                                           DATETIME        NULL,
    [claimSubmitDT]                                      DATETIME        NULL,
    [lastupdatedt]                                       DATETIME        NULL,
    [documentationUserID]                                INT             NULL,
    [documentationFirstNM]                               VARCHAR (50)    NULL,
    [documentationLastNM]                                VARCHAR (50)    NULL,
    [documentationRole]                                  VARCHAR (200)   NULL,
    [pctfillatCenter]                                    DECIMAL (20, 2) NULL,
    [pctfillatChain]                                     DECIMAL (20, 2) NULL,
    [primarypharmacy]                                    VARCHAR (3)     NULL,
    [validated]                                          BIT             NULL,
    [claimValidationProcessed]                           BIT             NULL,
    [claimValidationPaymentProcessed]                    BIT             NULL,
    [tipDetailID]                                        INT             NULL,
    [HealthTestValue]                                    VARCHAR (25)    NULL,
    [PCPName]                                            VARCHAR (50)    NULL,
    [pregTestResult]                                     BIT             NULL,
    [isLegacyServiceTypeClaim]                           BIT             NULL,
    [isEssentialServiceTypeClaim]                        BIT             NULL,
    [isStarServiceTypeClaim]                             BIT             NULL,
    [username]                                           VARCHAR (200)   NULL,
    [currentMedPrescriber]                               VARCHAR (100)   NULL,
    [currentPrescriberNPI]                               VARCHAR (50)    NULL,
    [timeToComplete]                                     INT             NULL,
    [numberOfNotes]                                      INT             NULL,
    [claimValidationFee]                                 MONEY           NULL,
    [No barrier identified]                              VARCHAR (400)   NULL,
    [invoiceStatusTypeID]                                INT             NULL,
    [invoiceStatusTypeNM]                                VARCHAR (400)   NULL,
    [invoiceStatusDT]                                    DATETIME        NULL,
    [cmrDeliveryTypeID]                                  INT             NULL,
    [createdt]                                           DATE            NULL,
    [statusDT]                                           DATE            NULL,
    [conditionNM]                                        VARCHAR (200)   NULL,
    [plannedMedSyncDT]                                   DATETIME        NULL,
    [labNM]                                              VARCHAR (100)   NULL,
    [isMedRecServiceTypeClaim]                           BIT             NULL,
    [currentMedName2]                                    VARCHAR (300)   NULL,
    [currentMedGpi2]                                     VARCHAR (100)   NULL,
    [currentMedRxNumber2]                                VARCHAR (100)   NULL,
    [currentMedMetricQuantity2]                          DECIMAL (20, 2) NULL,
    [currentMedDaysSupply2]                              DECIMAL (20, 2) NULL,
    [currentMedPrescriber2]                              VARCHAR (100)   NULL,
    [currentPrescriberNPI2]                              VARCHAR (50)    NULL,
    [Cognitive_Impairment_Status]                        VARCHAR (50)    NULL,
    [Cognitive_Impairment_Rationale]                     VARCHAR (100)   NULL,
    [patTakeAwayDT]                                      DATE            NULL,
    [recipientNM]                                        VARCHAR (200)   NULL,
    [CMR_Recipient_Rationale]                            VARCHAR (100)   NULL,
    [carrier]                                            VARCHAR (50)    NULL,
    [account]                                            VARCHAR (50)    NULL,
    [group]                                              VARCHAR (50)    NULL,
    [Believes to be adherent]                            VARCHAR (400)   NULL,
    [Forgets to take]                                    VARCHAR (400)   NULL,
    [Patient has no concerns or barriers]                VARCHAR (400)   NULL,
    [Unsure how to use medication]                       VARCHAR (400)   NULL,
    [Unable to swallow or administer]                    VARCHAR (400)   NULL,
    CONSTRAINT [PK_clientManagerReport] PRIMARY KEY CLUSTERED ([clientManagerReportid] ASC) WITH (FILLFACTOR = 80)
);

