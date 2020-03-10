




CREATE    procedure [cms].[I_CMS_CMRFromSTG] @ClientID int , @ContractYear int
as
INSERT INTO [cms].[CMS_CMR_2017]
           ([SourceSystem]
           ,[ClaimID]
           ,[mtmServiceDT]
           ,[ReasonCode]
           ,[ActionCode]
           ,[ResultCode]
           ,[ClaimStatus]
           ,[ClaimStatusDT]
           ,[PatientID]
           ,[PharmacyID]
           ,[NCPDP_NABP]
           ,[CMRWithSPT]
           ,[CMROffer]
           ,[cmrID]
           ,[CognitivelyImpairedIndicator]
           ,[MethodOfDeliveryCode]
           ,[MethodOfDeliveryCode_OLD]
           ,[ProviderCode]
           ,[RecipientCode]
           ,[AuthorizedRepresentative]
           ,[Topic01]
           ,[Topic02]
           ,[Topic03]
           ,[Topic04]
           ,[Topic05]
           ,[MAPCount]
           ,[SPTDate]
           ,[LTC])
     SELECT
           [SourceSystem]
           ,[ClaimID]
           ,[mtmServiceDT]
           ,[ReasonCode]
           ,[ActionCode]
           ,[ResultCode]
           ,[ClaimStatus]
           ,[ClaimStatusDT]
           ,[PatientID]
           ,[PharmacyID]
           ,[NCPDP_NABP]
           ,[CMRWithSPT]
           ,[CMROffer]
           ,[cmrID]
           ,[CognitivelyImpairedIndicator]
           ,[MethodOfDeliveryCode]
           ,[MethodOfDeliveryCode_OLD]
           ,[ProviderCode]
           ,[RecipientCode]
           ,[AuthorizedRepresentative]
           ,[Topic01]
           ,[Topic02]
           ,[Topic03]
           ,[Topic04]
           ,[Topic05]
           ,[MAPCount]
           ,[SPTDate]
           ,[LTC]
		 FROM  [staging].[CMS_CMR_STG]  
		 WHERE	[ClientID] = @ClientID
  AND	[ContractYear] = @ContractYear
 
      -- SET @Rowcount = @@ROWCOUNT


