



CREATE    procedure [cms].[I_CMS_BeneficiaryFromSTG] @ClientID int , @ContractYear int
as
INSERT INTO [cms].[CMS_Beneficiary_2018]
           ([PatientID]
           ,[BeneficiaryID]
           ,[ClientID]
           ,[ContractYear]
           ,[BeneficiaryKey]
           ,[HICN]
           ,[First_Name]
           ,[MI]
           ,[Last_Name]
           ,[DOB]
           ,[ActiveFromDT]
           ,[ActiveThruDT]
           ,[ranker]
           ,[DataSetTypeID])
SELECT [PatientID]
      ,[BeneficiaryID]
      ,[ClientID]
      ,[ContractYear]
      ,[BeneficiaryKey]
      ,[HICN]
      ,[First_Name]
      ,[MI]
      ,[Last_Name]
      ,[DOB]
      ,[ActiveFromDT]
      ,[ActiveThruDT]
      ,[ranker]
      ,2
  FROM [staging].[CMS_Beneficiary_2018]
  WHERE	[ClientID] = @ClientID
  AND	[ContractYear] = @ContractYear
 
       --SET @Rowcount = @@ROWCOUNT


