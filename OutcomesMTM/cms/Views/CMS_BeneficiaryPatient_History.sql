
CREATE   VIEW [cms].[CMS_BeneficiaryPatient_History] 
AS
	select 
		   bp.[BeneficiaryPatientID]
		  ,bp.[SnapshotID]
		  ,bp.[BeneficiaryID]
		  ,bp.[PatientID]
		  ,bp.[CreateDT]
		  ,bp.[ChangeDT]
		  ,st.[DataSetTypeID]
		  ,st.[ActiveFromDT]
		  ,st.[ActiveThruDT]
		  ,st.[LastRunDate]
		  ,st.[LastRunStatus]
		  ,st.[Description]
		  ,isCurrent = case when getdate() between st.activefromdt and st.activethrudt then 1 else 0 end
	from  cms.beneficiaryPatient bp with (nolock)
	join  cms.CMS_snapshottracker st with (nolock)
		on bp.snapshotID = st.snapshotID
	where  1=1

