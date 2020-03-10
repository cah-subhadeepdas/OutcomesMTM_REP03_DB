


CREATE    procedure [cms].[I_CMS_DTPFromSTG] @ClientID int , @ContractYear int
as
INSERT INTO [cms].[CMS_DTP_2017]
           (
	 [ClaimID]
      ,[mtmServiceDT]
      ,[ReasonCode]
      ,[ActionCode]
      ,[ResultCode]
      ,[ClaimStatus]
      ,[ClaimStatusDT]
      ,[PatientID]
      ,[PharmacyNABP]
      ,[DTPRecommendation]
      ,[GPI]
      ,[MedName]
      ,[SuccessfulResult] )
     SELECT 
	 [ClaimID]
      ,[mtmServiceDT]
      ,[ReasonCode]
      ,[ActionCode]
      ,[ResultCode]
      ,[ClaimStatus]
      ,[ClaimStatusDT]
      ,[PatientID]
      ,[PharmacyNABP]
      ,[DTPRecommendation]
      ,[GPI]
      ,[MedName]
      ,[SuccessfulResult]
		 FROM  [staging].[CMS_DTP_STG]  
		 WHERE	[ClientID] = @ClientID
  AND	[ContractYear] = @ContractYear
 
      -- SET @Rowcount = @@ROWCOUNT


