

CREATE   VIEW [cms].[CMS_MTMPEnrollment_History] 
AS

	select 
			mtmp.[MTMPEnrollmentID]
			,mtmp.[SnapshotID]
			,mtmp.[PatientID]
			,mtmp.[PatientID_All]
			,mtmp.[PolicyID]
			,mtmp.[ClientID]
			,mtmp.[ContractYear]
			,mtmp.[ContractNumber]
			,mtmp.[MTMPTargetingDate]
			,mtmp.[MTMPEnrollmentFromDate]
			,mtmp.[MTMPEnrollmentThruDate]
			,OptOutDate = case 	
						when isnull(right('00' + mtmp.OptOutReasonCode,2),'') in ('02') and coalesce(mtmp.OptOutDate, mtmp.MTMPEnrollmentThruDate) >= st.CYThruDate then NULL
						when isnull(right('00' + mtmp.OptOutReasonCode,2),'') in ('01','02','03','04') and coalesce(mtmp.OptOutDate, mtmp.MTMPEnrollmentThruDate) between st.CYFromDate 
						--and dateadd(day,-1,st.CYThruDate)   -- Old Code 
						and dateadd(day,0,st.CYThruDate)  --Added on 01/21/2019 by Sam due to optoutcode 01 and 12-31-2018 issue
						then coalesce(mtmp.OptOutDate, mtmp.MTMPEnrollmentThruDate)
						else null end
			,OptOutReasonCode = case 
						when isnull(right('00' + mtmp.OptOutReasonCode,2),'') in ('02') and coalesce(mtmp.OptOutDate, mtmp.MTMPEnrollmentThruDate) >= st.CYThruDate then ''
						when isnull(right('00' + mtmp.OptOutReasonCode,2),'') in ('01','02','03','04') and coalesce(mtmp.OptOutDate, mtmp.MTMPEnrollmentThruDate) between st.CYFromDate 
						--and dateadd(day,-1,st.CYThruDate)  -- Old Code 
						and dateadd(day,0,st.CYThruDate) --Added on 01/21/2019 by Sam due to optoutcode 01 and 12-31-2018 issue
						then mtmp.OptOutReasonCode  
						else '' end
			,mtmp.[CreateDT_Source]
			,mtmp.[ChangeDT_Source]
			,mtmp.[MTMPEnrollmentFromDate_InfoJSON]
			,mtmp.[MTMPTargetingDate_InfoJSON]
			,mtmp.[CreateDT]
			,mtmp.[ChangeDT]
			,st.[DataSetTypeID]
			,st.[ActiveFromDT]
			,st.[ActiveThruDT]
			,st.[LastRunDate]
			,st.[LastRunStatus]
			,st.[Description]
			,st.CYFromDate
			,st.CYThruDate
			,isCurrent = case when getdate() between st.activefromdt and st.activethrudt then 1 else 0 end

	from  cms.MTMPEnrollment mtmp with (nolock)
	join  (
			select
				st.SnapshotID
				,st.DataSetTypeID
				,st.ActiveFromDT
				,st.ActiveThruDT
				,st.LastRunDate
				,st.LastRunStatus
				,st.[Description]
				,CYFromDate = cast(cast(st.ContractYear as varchar)+'0101' as date)
				,CYThruDate = cast(cast(st.ContractYear as varchar)+'1231' as date)
			from cms.CMS_snapshottracker st with (nolock)
		) st
		on mtmp.snapshotID = st.snapshotID
	where  1=1

