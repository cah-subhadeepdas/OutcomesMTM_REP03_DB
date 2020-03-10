/****** Script for SelectTopNRows command from SSMS  ******/
CREATE procedure [dbo].[GenericPatientListSelect]
@policyIDs VARCHAR(MAX)
,@minEffectiveDate DATE
,@chainCodesExclude VARCHAR(MAX)
as

begin

	CREATE TABLE #tblPolicyIDs
	(
		policyID INT
	)
	INSERT INTO #tblPolicyIDs
	SELECT Item
	FROM OutcomesMTM.dbo.DelimitedSplit8K(@policyIDs, ',')
	
	-- Convert the comma separated list to a table.
	CREATE TABLE #tblChainCodesExclude
	(
		chainCode VARCHAR(50)
	)
	INSERT INTO #tblChainCodesExclude
	SELECT Item
	FROM OutcomesMTM.dbo.DelimitedSplit8K(@chainCodesExclude, ',');


SELECT 
    [PatientID]
      ,[PatientID_All]
      ,[PolicyID]
      ,[HICN]
      ,[PlanTermDate]
      ,[Carrier]
      ,[Account]
      ,[Group]
      ,[Policy]
      ,[termReason]
      ,[policyName]
      ,[Last_Name]
      ,[First_Name]
      ,[MI]
      ,[CMSContractNumber]
      ,[pbp]
      ,[Gender]
      ,[DOB]
      ,[PrimaryLanguage]
      ,[Address1]
      ,[Address2]
      ,[City]
      ,[State]
      ,[ZipCode]
      ,[Phone]
      ,[OutcomesEffectiveDate]
      ,[OutcomesTermDate]
      ,[MTMPEnrollmentFromDate]
      ,[MTMPEnrollmentThruDate]
      ,[cmrEnrollmentDate]
      ,[Current TIP Opportunities]
      ,[CMReligible]
      ,[Currently Targeted for a CMR]
      ,[Last CMR - Date]
      ,[Last CMR - Result Name]
      ,[Pharmacy1NABP]
      ,[Pharmacy1Name]
      ,[Pharmacy1Address1]
      ,[Pharmacy1Address2]
      ,[Pharmacy1City]
      ,[Pharmacy1State]
      ,[Pharmacy1ZipCode]
      ,[Pharmacy1Phone]
      ,[Pharmacy2NABP]
      ,[Pharmacy2Name]
      ,[Pharmacy2Address1]
      ,[Pharmacy2Address2]
      ,[Pharmacy2City]
      ,[Pharmacy2State]
      ,[Pharmacy2ZipCode]
      ,[Pharmacy2Phone]
      ,[Pharmacy3NABP]
      ,[Pharmacy3Name]
      ,[Pharmacy3Address1]
      ,[Pharmacy3Address2]
      ,[Pharmacy3City]
      ,[Pharmacy3State]
      ,[Pharmacy3ZipCode]
      ,[Pharmacy3Phone]
      ,[ConsultantPharmacyNABP]
      ,[ConsultantPharmacyName]
      ,[ConsultantPharmacyAddress1]
      ,[ConsultantPharmacyAddress2]
      ,[ConsultantPharmacyCity]
      ,[ConsultantPharmacyState]
      ,[ConsultantPharmacyZipCode]
      ,[ConsultantPharmacyPhone]
      ,[OutcomesEligibilityDate]
      ,[chaincode]
FROM [OutcomesMTM].[dbo].[GenericPatientList_Stage]
 where policyID in (
 select PolicyID
 from #tblPolicyIDs
 )
 and OutcomesEffectiveDate >= @minEffectiveDate 
 and chaincode not in (
 select chaincode
 from #tblChainCodesExclude
 )

end