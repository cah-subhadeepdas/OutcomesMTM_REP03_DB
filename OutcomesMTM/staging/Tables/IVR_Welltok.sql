﻿CREATE TABLE [staging].[IVR_Welltok] (
    ["SIRFID"]                       VARCHAR (50)  NULL,
    ["CALLID"]                       VARCHAR (50)  NULL,
    ["ATTEMPT"]                      VARCHAR (50)  NULL,
    ["QUEUEID"]                      VARCHAR (50)  NULL,
    ["EVENTTIME"]                    VARCHAR (50)  NULL,
    ["STATUS"]                       VARCHAR (50)  NULL,
    ["GROUPNAME"]                    VARCHAR (200) NULL,
    ["COMMRECIPIENTSTATUS"]          VARCHAR (50)  NULL,
    ["PrimaryKey"]                   VARCHAR (50)  NULL,
    ["NameLast"]                     VARCHAR (50)  NULL,
    ["NameFirst"]                    VARCHAR (50)  NULL,
    ["Phone"]                        VARCHAR (50)  NULL,
    ["CustomerProvidedPhone"]        VARCHAR (50)  NULL,
    ["Phone Append"]                 VARCHAR (50)  NULL,
    ["RecipientAddress"]             VARCHAR (50)  NULL,
    ["RecipientAddress2"]            VARCHAR (50)  NULL,
    ["RecipientCity"]                VARCHAR (50)  NULL,
    ["RecipientState"]               VARCHAR (50)  NULL,
    ["Zip"]                          VARCHAR (50)  NULL,
    ["CustomerProvidedAddress"]      VARCHAR (50)  NULL,
    ["CustomerProvidedAddress2"]     VARCHAR (50)  NULL,
    ["CustomerProvidedCity"]         VARCHAR (50)  NULL,
    ["CustomerProvidedState"]        VARCHAR (50)  NULL,
    ["CustomerProvidedZip"]          VARCHAR (50)  NULL,
    ["RecipientDOB"]                 VARCHAR (50)  NULL,
    ["RecipientGender"]              VARCHAR (50)  NULL,
    ["RecipientSelectedLanguage"]    VARCHAR (50)  NULL,
    ["RecipientPreferredLanguage"]   VARCHAR (50)  NULL,
    ["CampaignResult"]               VARCHAR (50)  NULL,
    ["CampaignTriggerCode"]          VARCHAR (50)  NULL,
    ["CampaignCOBResult"]            VARCHAR (50)  NULL,
    ["CampaignRXResult"]             VARCHAR (50)  NULL,
    ["CampaignAlternateCallerId"]    VARCHAR (50)  NULL,
    ["AlternateTransferToNum"]       VARCHAR (50)  NULL,
    ["CampaignImportFileName"]       VARCHAR (50)  NULL,
    ["CampaignLoadDateTime"]         VARCHAR (50)  NULL,
    ["CampaignSegmentCode"]          VARCHAR (50)  NULL,
    ["CampaignSegmentCode2"]         VARCHAR (50)  NULL,
    ["MemberPlanLogo"]               VARCHAR (50)  NULL,
    ["MemberPlanName"]               VARCHAR (50)  NULL,
    ["FaxNumberPrimary"]             VARCHAR (50)  NULL,
    ["Pharmacy1Phone"]               VARCHAR (50)  NULL,
    ["Pharmacy1Name"]                VARCHAR (50)  NULL,
    ["Pharmacy1NCPDP"]               VARCHAR (50)  NULL,
    ["Pharmacy1Address1"]            VARCHAR (50)  NULL,
    ["Pharmacy1Address2"]            VARCHAR (50)  NULL,
    ["Pharmacy1City"]                VARCHAR (50)  NULL,
    ["Pharmacy1State"]               VARCHAR (50)  NULL,
    ["Pharmacy1ZipCode"]             VARCHAR (50)  NULL,
    ["PlanPhone"]                    VARCHAR (50)  NULL,
    ["MemberID"]                     VARCHAR (50)  NULL,
    ["PolicyID"]                     VARCHAR (50)  NULL,
    ["PolicyName"]                   VARCHAR (50)  NULL,
    ["CMSContractYear"]              VARCHAR (50)  NULL,
    ["CMSContractNumber"]            VARCHAR (50)  NULL,
    ["HICN"]                         VARCHAR (50)  NULL,
    ["MTMPEnrollmentDate"]           VARCHAR (50)  NULL,
    ["CMROfferDeadlineDate"]         VARCHAR (50)  NULL,
    ["LastCMRDate"]                  VARCHAR (50)  NULL,
    ["LastCMRResult"]                VARCHAR (50)  NULL,
    ["PharmacyFax"]                  VARCHAR (50)  NULL,
    ["CampaignProperty53"]           VARCHAR (50)  NULL,
    ["Plan Phone"]                   VARCHAR (50)  NULL,
    ["BatchDate"]                    VARCHAR (50)  NULL,
    ["Mail Result"]                  VARCHAR (50)  NULL,
    ["UID"]                          VARCHAR (50)  NULL,
    ["Mode"]                         VARCHAR (50)  NULL,
    ["NumberofDays"]                 VARCHAR (50)  NULL,
    ["CampaignProperty1"]            VARCHAR (50)  NULL,
    ["CampaignProperty2"]            VARCHAR (50)  NULL,
    ["CampaignProperty3"]            VARCHAR (50)  NULL,
    ["CampaignProperty4"]            VARCHAR (50)  NULL,
    ["CampaignProperty5"]            VARCHAR (50)  NULL,
    ["CampaignProperty6"]            VARCHAR (50)  NULL,
    ["CampaignProperty7"]            VARCHAR (50)  NULL,
    ["CampaignProperty8"]            VARCHAR (50)  NULL,
    ["CampaignProperty9"]            VARCHAR (50)  NULL,
    ["CampaignProperty10"]           VARCHAR (50)  NULL,
    ["CampaignProperty11"]           VARCHAR (50)  NULL,
    ["CampaignProperty12"]           VARCHAR (50)  NULL,
    ["CampaignProperty13"]           VARCHAR (50)  NULL,
    ["CampaignProperty14"]           VARCHAR (50)  NULL,
    ["CampaignProperty15"]           VARCHAR (50)  NULL,
    ["CampaignProperty16"]           VARCHAR (50)  NULL,
    ["CampaignProperty17"]           VARCHAR (50)  NULL,
    ["CampaignProperty18"]           VARCHAR (50)  NULL,
    ["CampaignProperty19"]           VARCHAR (50)  NULL,
    ["CampaignProperty20"]           VARCHAR (50)  NULL,
    ["CampaignProperty21"]           VARCHAR (50)  NULL,
    ["CampaignProperty22"]           VARCHAR (50)  NULL,
    ["CampaignProperty23"]           VARCHAR (50)  NULL,
    ["CampaignProperty24"]           VARCHAR (50)  NULL,
    ["CampaignProperty25"]           VARCHAR (50)  NULL,
    ["CampaignProperty26"]           VARCHAR (50)  NULL,
    ["CampaignProperty27"]           VARCHAR (50)  NULL,
    ["CampaignProperty29"]           VARCHAR (50)  NULL,
    ["CampaignProperty30"]           VARCHAR (50)  NULL,
    ["CampaignProperty34"]           VARCHAR (50)  NULL,
    ["CampaignProperty58"]           VARCHAR (50)  NULL,
    ["CampaignProperty59"]           VARCHAR (50)  NULL,
    ["CampaignProperty60"]           VARCHAR (50)  NULL,
    ["CampaignProperty61"]           VARCHAR (50)  NULL,
    ["CampaignProperty62"]           VARCHAR (50)  NULL,
    ["CampaignProperty63"]           VARCHAR (50)  NULL,
    ["CampaignProperty64"]           VARCHAR (50)  NULL,
    ["CampaignProperty65"]           VARCHAR (50)  NULL,
    ["CampaignProperty66"]           VARCHAR (50)  NULL,
    ["CampaignProperty67"]           VARCHAR (50)  NULL,
    ["CampaignProperty68"]           VARCHAR (50)  NULL,
    ["CampaignProperty69"]           VARCHAR (50)  NULL,
    ["CampaignProperty70"]           VARCHAR (50)  NULL,
    ["CampaignProperty71"]           VARCHAR (50)  NULL,
    ["CampaignProperty72"]           VARCHAR (50)  NULL,
    ["CampaignProperty73"]           VARCHAR (50)  NULL,
    ["CampaignProperty74"]           VARCHAR (50)  NULL,
    ["CampaignProperty75"]           VARCHAR (50)  NULL,
    ["CampaignProperty76"]           VARCHAR (50)  NULL,
    ["CampaignProperty77"]           VARCHAR (50)  NULL,
    ["CampaignProperty78"]           VARCHAR (50)  NULL,
    ["CampaignProperty79"]           VARCHAR (50)  NULL,
    ["CampaignProperty80"]           VARCHAR (50)  NULL,
    ["CampaignProperty81"]           VARCHAR (50)  NULL,
    ["CampaignProperty82"]           VARCHAR (50)  NULL,
    ["CampaignProperty83"]           VARCHAR (50)  NULL,
    ["CampaignProperty84"]           VARCHAR (50)  NULL,
    ["CampaignProperty85"]           VARCHAR (50)  NULL,
    ["CampaignProperty86"]           VARCHAR (50)  NULL,
    ["CampaignProperty87"]           VARCHAR (50)  NULL,
    ["CampaignProperty88"]           VARCHAR (50)  NULL,
    ["CampaignProperty89"]           VARCHAR (50)  NULL,
    ["CampaignProperty90"]           VARCHAR (50)  NULL,
    ["CampaignProperty91"]           VARCHAR (50)  NULL,
    ["CampaignProperty92"]           VARCHAR (50)  NULL,
    ["CampaignProperty93"]           VARCHAR (50)  NULL,
    ["CampaignProperty94"]           VARCHAR (50)  NULL,
    ["CampaignProperty95"]           VARCHAR (50)  NULL,
    ["CampaignProperty96"]           VARCHAR (50)  NULL,
    ["CampaignProperty97"]           VARCHAR (50)  NULL,
    ["CampaignProperty98"]           VARCHAR (50)  NULL,
    ["CampaignProperty99"]           VARCHAR (50)  NULL,
    ["CampaignProperty100"]          VARCHAR (50)  NULL,
    ["CampaignProperty101"]          VARCHAR (50)  NULL,
    ["CampaignProperty102"]          VARCHAR (50)  NULL,
    ["CampaignProperty103"]          VARCHAR (50)  NULL,
    ["CampaignProperty104"]          VARCHAR (50)  NULL,
    ["CampaignProperty105"]          VARCHAR (50)  NULL,
    ["CampaignProperty106"]          VARCHAR (50)  NULL,
    ["CampaignProperty107"]          VARCHAR (50)  NULL,
    ["CampaignProperty108"]          VARCHAR (50)  NULL,
    ["CampaignProperty109"]          VARCHAR (50)  NULL,
    ["CampaignProperty110"]          VARCHAR (50)  NULL,
    ["CampaignProperty111"]          VARCHAR (50)  NULL,
    ["CampaignProperty112"]          VARCHAR (50)  NULL,
    ["CampaignProperty113"]          VARCHAR (50)  NULL,
    ["CampaignProperty114"]          VARCHAR (50)  NULL,
    ["CampaignReturnAddressName"]    VARCHAR (50)  NULL,
    ["CampaignReturnAddressName2"]   VARCHAR (50)  NULL,
    ["CampaignReturnAddressStreet"]  VARCHAR (50)  NULL,
    ["CampaignReturnAddressStreet2"] VARCHAR (50)  NULL,
    ["CampaignReturnAddressCity"]    VARCHAR (50)  NULL,
    ["CampaignReturnAddressState"]   VARCHAR (50)  NULL,
    ["CampaignReturnAddressZip"]     VARCHAR (50)  NULL,
    ["ProgramType"]                  VARCHAR (50)  NULL,
    ["OptOut"]                       VARCHAR (50)  NULL
);

