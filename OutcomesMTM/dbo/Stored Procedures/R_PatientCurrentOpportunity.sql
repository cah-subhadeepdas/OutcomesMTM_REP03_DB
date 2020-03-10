/****** Script for SelectTopNRows command from SSMS  ******/
CREATE procedure [dbo].[R_PatientCurrentOpportunity]
@ClientID varchar(max) = null
,@ChainCode varchar(MAX)
as
begin

	CREATE TABLE #ClientId
	(
		ClientID INT
	)
	INSERT INTO #ClientId
	SELECT Item
	FROM OutcomesMTM.dbo.DelimitedSplit8K(@ClientID, ',')

   CREATE TABLE #ChainCode
	(
		[Chain Code] varchar(100)
	)
	INSERT INTO #ChainCode
	SELECT Item
	FROM OutcomesMTM.dbo.DelimitedSplit8K(@ChainCode, ',')

SELECT cpo.[ID]
      ,cpo.[Policy Name]
      ,cpo.[Policy ID]
      ,cpo.[Member ID]
      ,cpo.[Member First Name]
      ,cpo.[Member Last Name]
      ,cpo.[DOB]
      ,cpo.[Current TIP Opportunities]
      ,cpo.[CMR Eligible]
      ,cpo.[Currently Targeted for a CMR]
      ,cpo.[Last CMR - Date]
      ,cpo.[Last CMR - Result Name]
      ,cpo.[Last CMR - NCPDP]
      ,cpo.[Last CMR - Pharmacy Name]
      ,cpo.[ClientId]
      ,cpo.[Client Name]
      ,cpo.[Chain Code]
      ,cpo.[Chain Name]
      ,cpo.[Primary Pharmacy NABP]
  FROM [OutcomesMTM].[dbo].[CurrentPatientOpportunities] cpo
  inner join #ClientId cl
  on cpo.clientID = cl.ClientID
  inner join #ChainCode cc
  on cpo.[Chain Code] = cc.[Chain Code]
 
end 