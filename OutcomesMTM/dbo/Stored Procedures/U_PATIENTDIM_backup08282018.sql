



create   procedure [dbo].[U_PATIENTDIM_backup08282018]
as 
begin
set nocount on;
set xact_abort on;

if(object_id('tempdb..#queueOrder') is not null)
drop table #queueOrder
create table #queueOrder (
queueOrderID int identity(1,1) primary key 
, queueOrder int 
)
insert into #queueOrder (queueOrder) 
select distinct queueOrder 
from patientDeltaQueueStaging 
order by queueOrder


/*  Disabling PatientDim Indexes */
ALTER INDEX [UNC_patientid_activeasof] ON [dbo].[patientDim] DISABLE
ALTER INDEX [UNC_patientid_activethru] ON [dbo].[patientDim] DISABLE
ALTER INDEX [ind_policyID] ON [dbo].[patientDim] DISABLE
ALTER INDEX [ind_PatientID] ON [dbo].[patientDim] DISABLE
ALTER INDEX [ind_activethru] ON [dbo].[patientDim] DISABLE



declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--patientDim
	--DELETES
	update d  
	set d.activethru = s.queueDate 
	, d.isCurrent = 1   
	--select count(*) 
	from patientDim d 
	join patientDeltaQueueStaging s on d.patientid = s.patientid and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1
	and s.isInsert = 0

	--UPDATES
	update d  
	set d.activethru = s.queueDate 
	, d.isCurrent = 0   
	--select count(*) 
	from patientDim d 
	join patientDeltaQueueStaging s on d.patientid = s.patientid and s.queueorder = @queueOrder  
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1
	and s.isInsert = 1
	and not (
		isnull(d.[PatientID_All],'') = isnull(s.[PatientID_All],'')
		and isnull(d.[ClientID],0) = isnull(s.[ClientID],0) 
		and isnull(d.[PolicyID],0) = isnull(s.[PolicyID],0) 
		and isnull(d.[CMSContractNumber],'') = isnull(s.[CMSContractNumber],'') 
		and isnull(d.[HICN],'') = isnull(s.[HICN],'') 
		and isnull(d.[LTCFlag],0) = isnull(s.[LTCFlag],0) 
		and isnull(d.[planeffectivedate],'19000101') = isnull(s.[planeffectivedate],'19000101') 
		and isnull(d.[plantermdate],'19000101') = isnull(s.[plantermdate],'19000101') 
		and isnull(d.[MTMEligibilityDate],'19000101') = isnull(s.[MTMEligibilityDate],'19000101') 
		and isnull(d.[MTMTermDate],'19000101') = isnull(s.[MTMTermDate],'19000101') 
		and isnull(d.[OutcomesEligibilityDate],'19000101') = isnull(s.[OutcomesEligibilityDate],'19000101') 
		and isnull(d.[OutcomesTermDate],'19000101') = isnull(s.[OutcomesTermDate],'19000101') 
		and isnull(d.[CMREligible],0) = isnull(s.[CMREligible],0) 
		and isnull(d.[First_Name],'') = isnull(s.[First_Name],'') 
		and isnull(d.[MI],'') = isnull(s.[MI],'') 
		and isnull(d.[Last_Name],'') = isnull(s.[Last_Name],'') 
		and isnull(d.[Gender],'') = isnull(s.[Gender],'') 
		and isnull(d.[DOB],'19000101') = isnull(s.[DOB],'19000101') 
		and isnull(d.[Address1],'') = isnull(s.[Address1],'') 
		and isnull(d.[Address2],'') = isnull(s.[Address2],'') 
		and isnull(d.[City],'') = isnull(s.[City],'') 
		and isnull(d.[State],'') = isnull(s.[State],'') 
		and isnull(d.[ZipCode],'') = isnull(s.[ZipCode],'') 
		and isnull(d.[Phone],'') = isnull(s.[Phone],'') 
		and isnull(d.[other_info],'') = isnull(s.[other_info],'') 
		and isnull(d.[pbp],'') = isnull(s.[pbp],'') 
		and isnull(d.[PrimaryLanguage],'') = isnull(s.[PrimaryLanguage],'') 
		and isnull(d.[PCP],'') = isnull(s.[PCP],'') 
		and isnull(d.[MTMCriteriaFlag],0) = isnull(s.[MTMCriteriaFlag],0) 
		and isnull(d.[StratScore],'') = isnull(s.[StratScore],'') 
		and isnull(d.[CMRFlag],0) = isnull(s.[CMRFlag],0) 
		and isnull(d.[MemberGenKey],'') = isnull(s.[MemberGenKey],'')
      and isnull(d.[newPatientid_all], '') = isnull(s.[newPatientid_all], '')
      and isnull(d.[alternateID], '') = isnull(s.[alternateID], '')
	   and isnull(d.[displayID], '') = isnull(s.[displayID], '')
	)

	--INSERTS
	insert into patientDim (
	[PatientID] 
	,[PatientID_All] 
	,[ClientID] 
	,[PolicyID] 
	,[CMSContractNumber] 
	,[HICN] 
	,[LTCFlag] 
	,[planeffectivedate] 
	,[plantermdate] 
	,[MTMEligibilityDate] 
	,[MTMTermDate] 
	,[OutcomesEligibilityDate] 
	,[OutcomesTermDate] 
	,[CMREligible] 
	,[First_Name] 
	,[MI] 
	,[Last_Name] 
	,[Gender] 
	,[DOB] 
	,[Address1] 
	,[Address2] 
	,[City] 
	,[State] 
	,[ZipCode] 
	,[Phone] 
	,[other_info] 
	,[pbp] 
	,[PrimaryLanguage] 
	,[PCP] 
	,[MTMCriteriaFlag] 
	,[StratScore] 
	,[CMRFlag] 
	,[MemberGenKey] 
   ,[newPatientid_all]
   ,[alternateID]
	,[displayID]
	,activeasof 
	,iscurrent
	) 
	select s.[PatientID] 
	,s.[PatientID_All] 
	,s.[ClientID] 
	,s.[PolicyID] 
	,s.[CMSContractNumber] 
	,s.[HICN] 
	,s.[LTCFlag] 
	,s.[planeffectivedate] 
	,s.[plantermdate] 
	,s.[MTMEligibilityDate] 
	,s.[MTMTermDate] 
	,s.[OutcomesEligibilityDate] 
	,s.[OutcomesTermDate] 
	,s.[CMREligible] 
	,s.[First_Name] 
	,s.[MI] 
	,s.[Last_Name] 
	,s.[Gender] 
	,s.[DOB] 
	,s.[Address1] 
	,s.[Address2] 
	,s.[City] 
	,s.[State] 
	,s.[ZipCode] 
	,s.[Phone] 
	,s.[other_info] 
	,s.[pbp] 
	,s.[PrimaryLanguage] 
	,s.[PCP] 
	,s.[MTMCriteriaFlag] 
	,s.[StratScore] 
	,s.[CMRFlag] 
	,s.[MemberGenKey] 
   ,s.[newPatientid_all]
   ,s.[alternateID]
	,s.[displayID]	,s.queueDate as activeasof 
	,1 as isCurrent
	--select count(*) 
	from patientDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder 
	and s.isinsert = 1
	and not exists (
			select 1 
			from patientDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from patientDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.activethru is null 
		)


	------------------------
	------------------------
	------------------------


	if(object_id('tempdb..#tempRepository') is not null)
	drop table #tempRepository
	create table #tempRepository (
	patientKey bigint primary key 
	, patientid int 
	, repositoryArchiveID bigint 
	, fileid int  
	, isDelete bit 
	, isInsert bit 
	, queuedate datetime  
	, activeKey bit 
	)

	insert into #tempRepository with (tablock) (patientKey, patientid, repositoryArchiveID, fileid, isDelete, isInsert, queuedate, activeKey)
	select d.patientKey
	, s.patientid 
	, s.repositoryarchiveid
	, s.fileid
	, s.isDelete
	, s.isInsert
	, s.queueDate 
	, 1 as activeKey 
	from patientDeltaQueueStaging s 
	join patientDim d on d.patientid = s.patientid 
	where 1=1 
	and s.queueorder = @queueOrder 
	and d.activethru is null 
	and s.isInsert = 1  
	and not exists (select 1 
					from patientRepositoryDim r 
					where 1=1 
					and r.patientkey = d.patientkey 
					and isnull(r.repositoryArchiveID,0) = isnull(s.repositoryArchiveID,0) 
					and isnull(r.fileid,0) = isnull(s.fileid,0)
					and r.activethru is null) 


	insert into #tempRepository with (tablock) (patientKey, patientid, repositoryArchiveID, fileid, isDelete, isInsert, queuedate, activeKey)
	select d.patientKey
	, s.patientid 
	, s.repositoryarchiveid
	, s.fileid
	, s.isDelete
	, s.isInsert
	, s.queueDate 
	, 0 as activeKey 
	from patientDeltaQueueStaging s 
	join patientDim d on d.patientid = s.patientid 
	join patientRepositoryDim r on r.patientKey = d.patientKey 
								   and r.activethru is null  
	where 1=1 
	and s.queueorder = @queueOrder 
	and ((s.isDelete = 1 and s.isinsert = 0) 
		  or 
		 (s.isDelete = 1  and exists (select 1 
									  from #tempRepository t 
									  where 1=1 
									  and t.patientid = s.patientid 
									  and t.patientKey <> d.patientkey))) 
   

	------------------------------------

	--2: update true deletes
	update d  
	set d.[activeThru] = s.queueDate
	, d.[isCurrent] = 1 
	--select count(*) 
	from patientRepositoryDim d 
	join #tempRepository s on s.patientkey = d.patientkey  
	where 1=1 
	and d.activeThru is null 
	and s.isDelete = 1 
	and s.isInsert = 0 
	and s.activeKey = 0 
	and not exists (
			select 1 
			from patientRepositoryDim d1
			where 1=1 
			and d1.patientkey = s.patientkey  
			and d1.activeasof = s.queueDate 
		)
	 and not exists (
			select 1 
			from patientRepositoryDim d2
			where 1=1 
			and d2.patientkey = s.patientkey  
			and d2.activethru = s.queueDate 
		)

	--3: only inactivate updates where data has changed
	--the and not represents all of the audit columns 
	update d  
	set d.[activeThru] = s.queueDate
	, d.[isCurrent] = 0
	--select count(*) 
	from patientRepositoryDim d 
	join #tempRepository s on s.patientkey = d.patientkey  
	where 1=1 
	and d.activeThru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and s.activeKey = 0 
	and not exists (
			select 1 
			from patientRepositoryDim d1
			where 1=1 
			and d1.patientkey = s.patientkey  
			and d1.activeasof = s.queueDate 
		)
	and not exists (
			select 1 
			from patientRepositoryDim d2
			where 1=1 
			and d2.patientkey = s.patientkey  
			and d2.activethru = s.queueDate 
		)

	--4: only insert updates that have been turned off or new inserts 
	--the (d.activethru is null or d.activethru = s.queueDate) is to handle 
	--if a new repository archive file turns off the record
	insert into patientRepositoryDim (
	patientkey
	,repositoryarchiveid
	,fileid   
	,activeasof 
	,iscurrent
	) 
	select s.patientkey
	,s.repositoryarchiveid
	,s.fileid   
	,s.queueDate as activeasof 
	,1 as isCurrent
	--select count(*) 
	from #tempRepository s
	where 1=1 
	and s.isinsert = 1
	and s.activeKey = 1 
	and not exists (
			select 1 
			from patientRepositoryDim d1
			where 1=1 
			and d1.patientkey = s.patientkey  
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from patientRepositoryDim d2
			where 1=1 
			and d2.patientkey = s.patientkey  
			and d2.activethru is null 
		)

set @cnt = @cnt + 1 

end--end loop

/*  Enabling PatientDim Indexes */
ALTER INDEX [UNC_patientid_activeasof] ON [dbo].[patientDim] REBUILD
ALTER INDEX [UNC_patientid_activethru] ON [dbo].[patientDim] REBUILD
ALTER INDEX [ind_policyID] ON [dbo].[patientDim] REBUILD
ALTER INDEX [ind_PatientID] ON [dbo].[patientDim] REBUILD
ALTER INDEX [ind_activethru] ON [dbo].[patientDim] REBUILD

END












