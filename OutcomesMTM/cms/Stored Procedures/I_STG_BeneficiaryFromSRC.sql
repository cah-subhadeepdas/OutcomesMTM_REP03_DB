



CREATE    procedure [cms].[I_STG_BeneficiaryFromSRC] @ClientID int , @ContractYear int
as
SELECT [BeneficiaryID]
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
      ,[PatientID]
      ,[ranker]
  FROM [reporting].[CMS_Beneficiary_2018]
  WHERE	[ClientID] = @ClientID
  AND	[ContractYear] = @ContractYear


