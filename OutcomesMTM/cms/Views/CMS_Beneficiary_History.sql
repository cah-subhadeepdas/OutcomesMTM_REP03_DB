
CREATE   VIEW [cms].[CMS_Beneficiary_History] 
AS 
	select  
		   b.[BeneficiaryID]
		  ,b.[ClientID]
		  ,b.[ContractYear]
		  ,b.[BeneficiaryKey]
		  ,b.[HICN]
		  ,b.[First_Name]
		  ,b.[MI]
		  ,b.[Last_Name]
		  ,b.[DOB]
		  ,b.[SnapshotID]
		  ,st.[DataSetTypeID]
		  ,st.[ActiveFromDT]
		  ,st.[ActiveThruDT]
		  ,st.[LastRunDate]
		  ,st.[LastRunStatus]
		  ,st.[Description]
		  ,isCurrent = case when getdate() between st.activefromdt and st.activethrudt then 1 else 0 end
	from cms.beneficiary b with (nolock)
	join cms.CMS_snapshottracker st with (nolock)
		on b.snapshotID = st.snapshotID
	where  1=1

