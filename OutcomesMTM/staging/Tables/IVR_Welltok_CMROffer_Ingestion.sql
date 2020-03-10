﻿CREATE TABLE [staging].[IVR_Welltok_CMROffer_Ingestion] (
    ["SIRFID"]                       VARCHAR (200) NULL,
    ["CALLID"]                       VARCHAR (200) NULL,
    ["ATTEMPT"]                      VARCHAR (200) NULL,
    ["QUEUEID"]                      VARCHAR (200) NULL,
    ["EVENTTIME"]                    VARCHAR (200) NULL,
    ["STATUS"]                       VARCHAR (200) NULL,
    ["GROUPNAME"]                    VARCHAR (200) NULL,
    ["COMMRECIPIENTSTATUS"]          VARCHAR (200) NULL,
    ["PrimaryKey"]                   VARCHAR (200) NULL,
    ["NameLast"]                     VARCHAR (200) NULL,
    ["NameFirst"]                    VARCHAR (200) NULL,
    ["Phone"]                        VARCHAR (200) NULL,
    ["CustomerProvidedPhone"]        VARCHAR (200) NULL,
    ["Phone Append"]                 VARCHAR (200) NULL,
    ["RecipientAddress"]             VARCHAR (200) NULL,
    ["RecipientAddress2"]            VARCHAR (200) NULL,
    ["RecipientCity"]                VARCHAR (200) NULL,
    ["RecipientState"]               VARCHAR (200) NULL,
    ["Zip"]                          VARCHAR (200) NULL,
    ["CustomerProvidedAddress"]      VARCHAR (200) NULL,
    ["CustomerProvidedAddress2"]     VARCHAR (200) NULL,
    ["CustomerProvidedCity"]         VARCHAR (200) NULL,
    ["CustomerProvidedState"]        VARCHAR (200) NULL,
    ["CustomerProvidedZip"]          VARCHAR (200) NULL,
    ["RecipientDOB"]                 VARCHAR (200) NULL,
    ["RecipientGender"]              VARCHAR (200) NULL,
    ["RecipientSelectedLanguage"]    VARCHAR (200) NULL,
    ["RecipientPreferredLanguage"]   VARCHAR (200) NULL,
    ["CampaignResult"]               VARCHAR (200) NULL,
    ["CampaignTriggerCode"]          VARCHAR (200) NULL,
    ["CampaignCOBResult"]            VARCHAR (200) NULL,
    ["CampaignRXResult"]             VARCHAR (200) NULL,
    ["CampaignAlternateCallerId"]    VARCHAR (200) NULL,
    ["AlternateTransferToNum"]       VARCHAR (200) NULL,
    ["CampaignImportFileName"]       VARCHAR (200) NULL,
    ["CampaignLoadDateTime"]         VARCHAR (200) NULL,
    ["CampaignSegmentCode"]          VARCHAR (200) NULL,
    ["CampaignSegmentCode2"]         VARCHAR (200) NULL,
    ["MemberPlanLogo"]               VARCHAR (200) NULL,
    ["MemberPlanName"]               VARCHAR (200) NULL,
    ["FaxNumberPrimary"]             VARCHAR (200) NULL,
    ["Pharmacy1Phone"]               VARCHAR (200) NULL,
    ["Pharmacy1Name"]                VARCHAR (200) NULL,
    ["Pharmacy1NCPDP"]               VARCHAR (200) NULL,
    ["Pharmacy1Address1"]            VARCHAR (200) NULL,
    ["Pharmacy1Address2"]            VARCHAR (200) NULL,
    ["Pharmacy1City"]                VARCHAR (200) NULL,
    ["Pharmacy1State"]               VARCHAR (200) NULL,
    ["Pharmacy1ZipCode"]             VARCHAR (200) NULL,
    ["PlanPhone"]                    VARCHAR (200) NULL,
    ["MemberID"]                     VARCHAR (200) NULL,
    ["PolicyID"]                     VARCHAR (200) NULL,
    ["PolicyName"]                   VARCHAR (200) NULL,
    ["CMSContractYear"]              VARCHAR (200) NULL,
    ["CMSContractNumber"]            VARCHAR (200) NULL,
    ["HICN"]                         VARCHAR (200) NULL,
    ["MTMPEnrollmentDate"]           VARCHAR (200) NULL,
    ["CMROfferDeadlineDate"]         VARCHAR (200) NULL,
    ["LastCMRDate"]                  VARCHAR (200) NULL,
    ["LastCMRResult"]                VARCHAR (200) NULL,
    ["PharmacyFax"]                  VARCHAR (200) NULL,
    ["CampaignProperty53"]           VARCHAR (200) NULL,
    ["Plan Phone"]                   VARCHAR (200) NULL,
    ["BatchDate"]                    VARCHAR (200) NULL,
    ["Mail Result"]                  VARCHAR (200) NULL,
    ["UID"]                          VARCHAR (200) NULL,
    ["Mode"]                         VARCHAR (200) NULL,
    ["NumberofDays"]                 VARCHAR (200) NULL,
    ["CampaignProperty1"]            VARCHAR (200) NULL,
    ["CampaignProperty2"]            VARCHAR (200) NULL,
    ["CampaignProperty3"]            VARCHAR (200) NULL,
    ["CampaignProperty4"]            VARCHAR (200) NULL,
    ["CampaignProperty5"]            VARCHAR (200) NULL,
    ["CampaignProperty6"]            VARCHAR (200) NULL,
    ["CampaignProperty7"]            VARCHAR (200) NULL,
    ["CampaignProperty8"]            VARCHAR (200) NULL,
    ["CampaignProperty9"]            VARCHAR (200) NULL,
    ["CampaignProperty10"]           VARCHAR (200) NULL,
    ["CampaignProperty11"]           VARCHAR (200) NULL,
    ["CampaignProperty12"]           VARCHAR (200) NULL,
    ["CampaignProperty13"]           VARCHAR (200) NULL,
    ["CampaignProperty14"]           VARCHAR (200) NULL,
    ["CampaignProperty15"]           VARCHAR (200) NULL,
    ["CampaignProperty16"]           VARCHAR (200) NULL,
    ["CampaignProperty17"]           VARCHAR (200) NULL,
    ["CampaignProperty18"]           VARCHAR (200) NULL,
    ["CampaignProperty19"]           VARCHAR (200) NULL,
    ["CampaignProperty20"]           VARCHAR (200) NULL,
    ["CampaignProperty21"]           VARCHAR (200) NULL,
    ["CampaignProperty22"]           VARCHAR (200) NULL,
    ["CampaignProperty23"]           VARCHAR (200) NULL,
    ["CampaignProperty24"]           VARCHAR (200) NULL,
    ["CampaignProperty25"]           VARCHAR (200) NULL,
    ["CampaignProperty26"]           VARCHAR (200) NULL,
    ["CampaignProperty27"]           VARCHAR (200) NULL,
    ["CampaignProperty29"]           VARCHAR (200) NULL,
    ["CampaignProperty30"]           VARCHAR (200) NULL,
    ["CampaignProperty34"]           VARCHAR (200) NULL,
    ["CampaignProperty58"]           VARCHAR (200) NULL,
    ["CampaignProperty59"]           VARCHAR (200) NULL,
    ["CampaignProperty60"]           VARCHAR (200) NULL,
    ["CampaignProperty61"]           VARCHAR (200) NULL,
    ["CampaignProperty62"]           VARCHAR (200) NULL,
    ["CampaignProperty63"]           VARCHAR (200) NULL,
    ["CampaignProperty64"]           VARCHAR (200) NULL,
    ["CampaignProperty65"]           VARCHAR (200) NULL,
    ["CampaignProperty66"]           VARCHAR (200) NULL,
    ["CampaignProperty67"]           VARCHAR (200) NULL,
    ["CampaignProperty68"]           VARCHAR (200) NULL,
    ["CampaignProperty69"]           VARCHAR (200) NULL,
    ["CampaignProperty70"]           VARCHAR (200) NULL,
    ["CampaignProperty71"]           VARCHAR (200) NULL,
    ["CampaignProperty72"]           VARCHAR (200) NULL,
    ["CampaignProperty73"]           VARCHAR (200) NULL,
    ["CampaignProperty74"]           VARCHAR (200) NULL,
    ["CampaignProperty75"]           VARCHAR (200) NULL,
    ["CampaignProperty76"]           VARCHAR (200) NULL,
    ["CampaignProperty77"]           VARCHAR (200) NULL,
    ["CampaignProperty78"]           VARCHAR (200) NULL,
    ["CampaignProperty79"]           VARCHAR (200) NULL,
    ["CampaignProperty80"]           VARCHAR (200) NULL,
    ["CampaignProperty81"]           VARCHAR (200) NULL,
    ["CampaignProperty82"]           VARCHAR (200) NULL,
    ["CampaignProperty83"]           VARCHAR (200) NULL,
    ["CampaignProperty84"]           VARCHAR (200) NULL,
    ["CampaignProperty85"]           VARCHAR (200) NULL,
    ["CampaignProperty86"]           VARCHAR (200) NULL,
    ["CampaignProperty87"]           VARCHAR (200) NULL,
    ["CampaignProperty88"]           VARCHAR (200) NULL,
    ["CampaignProperty89"]           VARCHAR (200) NULL,
    ["CampaignProperty90"]           VARCHAR (200) NULL,
    ["CampaignProperty91"]           VARCHAR (200) NULL,
    ["CampaignProperty92"]           VARCHAR (200) NULL,
    ["CampaignProperty93"]           VARCHAR (200) NULL,
    ["CampaignProperty94"]           VARCHAR (200) NULL,
    ["CampaignProperty95"]           VARCHAR (200) NULL,
    ["CampaignProperty96"]           VARCHAR (200) NULL,
    ["CampaignProperty97"]           VARCHAR (200) NULL,
    ["CampaignProperty98"]           VARCHAR (200) NULL,
    ["CampaignProperty99"]           VARCHAR (200) NULL,
    ["CampaignProperty100"]          VARCHAR (200) NULL,
    ["CampaignProperty101"]          VARCHAR (200) NULL,
    ["CampaignProperty102"]          VARCHAR (200) NULL,
    ["CampaignProperty103"]          VARCHAR (200) NULL,
    ["CampaignProperty104"]          VARCHAR (200) NULL,
    ["CampaignProperty105"]          VARCHAR (200) NULL,
    ["CampaignProperty106"]          VARCHAR (200) NULL,
    ["CampaignProperty107"]          VARCHAR (200) NULL,
    ["CampaignProperty108"]          VARCHAR (200) NULL,
    ["CampaignProperty109"]          VARCHAR (200) NULL,
    ["CampaignProperty110"]          VARCHAR (200) NULL,
    ["CampaignProperty111"]          VARCHAR (200) NULL,
    ["CampaignProperty112"]          VARCHAR (200) NULL,
    ["CampaignProperty113"]          VARCHAR (200) NULL,
    ["CampaignProperty114"]          VARCHAR (200) NULL,
    ["CampaignReturnAddressName"]    VARCHAR (200) NULL,
    ["CampaignReturnAddressName2"]   VARCHAR (200) NULL,
    ["CampaignReturnAddressStreet"]  VARCHAR (200) NULL,
    ["CampaignReturnAddressStreet2"] VARCHAR (200) NULL,
    ["CampaignReturnAddressCity"]    VARCHAR (200) NULL,
    ["CampaignReturnAddressState"]   VARCHAR (200) NULL,
    ["CampaignReturnAddressZip"]     VARCHAR (200) NULL,
    ["ProgramType"]                  VARCHAR (200) NULL,
    ["OptOut"]                       VARCHAR (200) NULL
);

