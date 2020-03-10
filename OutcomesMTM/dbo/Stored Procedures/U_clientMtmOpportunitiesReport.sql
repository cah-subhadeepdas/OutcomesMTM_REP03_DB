


CREATE procedure [dbo].[U_clientMtmOpportunitiesReport]
as
begin 
set nocount on;
set xact_abort on;

--drop table #tempupdate
create table #tempupdate (
id int identity(1,1) primary key 
,centerid int
, policyid int    
)
insert into #tempupdate (centerid, policyid) 
select p.centerid, p.policyid 
from ClientMTMOpportunitiesReport p 
join ClientMTMOpportunitiesReport_staging t on t.centerid = p.centerid 
                   and t.policyid = p.policyid   
where 1=1 
and not (
          isnull(p.[Trained RPhs],0) = isnull(t.[Trained RPhs],0) 
          and isnull(p.[Trained Techs],0) = isnull(t.[Trained Techs],0)  
          and isnull(p.[TotalPatients],0) = isnull(t.[TotalPatients],0)   
          and isnull(p.[TotalPrimaryPatients],0) = isnull(t.[TotalPrimaryPatients],0)    
          and isnull(p.[Total CMRs],0) = isnull(t.[Total CMRs],0)    
          and isnull(p.[Potential CMR Revenue],0) = isnull(t.[Potential CMR Revenue],0)   
          and isnull(p.[Total Primary CMRs],0) = isnull(t.[Total Primary CMRs],0)   
          and isnull(p.[Potential CMR Revenue Primary],0) = isnull(t.[Potential CMR Revenue Primary],0)    
          and isnull(p.[CMRs scheduled],0) = isnull(t.[CMRs scheduled],0)    
          and isnull(p.[TotalTIPs],0) = isnull(t.[TotalTIPs],0)     
          and isnull(p.[TotalPrimaryTIPs],0) = isnull(t.[TotalPrimaryTIPs],0)    
          and isnull(p.[PotentialTIPRevenue],0) = isnull(t.[PotentialTIPRevenue],0)   
          and isnull(p.[PotentialTIPRevenuePrimary],0) = isnull(t.[PotentialTIPRevenuePrimary],0)   
          and isnull(p.[PotentialTIPRevenuePrimary],0) = isnull(t.[PotentialTIPRevenuePrimary],0)    
          and isnull(p.[Unfinished Claims],0) = isnull(t.[Unfinished Claims],0)   
          and isnull(p.[Review/Resubmit],0) = isnull(t.[Review/Resubmit],0)   
          and isnull(p.[QA zone],0) = isnull(t.[QA zone],0)   
          and isnull(p.[DTP %],0) = isnull(t.[DTP %],0)   
          and isnull(p.[6 Month Claim History],0) = isnull(t.[6 Month Claim History],0) 
          and isnull(p.[NABP],'') = isnull(t.[NABP],'')  
          and isnull(p.[Pharmacy_Name],'') = isnull(t.[Pharmacy_Name],'')  
          and isnull(p.[pharmacy_type],'') = isnull(t.[pharmacy_type],'')  
          and isnull(p.[Address],'') = isnull(t.[Address],'')                       
          and isnull(p.[City],'') = isnull(t.[City],'')  
          and isnull(p.[State],'') = isnull(t.[State],'')  
          and isnull(p.[stateID],0) = isnull(t.[stateID],0)   
          and isnull(p.[ZipCode],'') = isnull(t.[ZipCode],'')  
          and isnull(p.[phone],'') = isnull(t.[phone],'')  
          and isnull(p.[fax],'') = isnull(t.[fax],'')  
          and isnull(p.[Contracted],'') = isnull(t.[Contracted],'')      
)

create nonclustered index ind_1 on #tempupdate(centerid, policyid)


declare @batch int = 500000
Declare @mincnt bigint = 1
Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
while (@mincnt <= @maxcnt)
BEGIN

		update p
		set p.[Trained RPhs] = t.[Trained RPhs]
		, p.[Trained Techs] = t.[Trained Techs]
		, p.[TotalPatients] = t.[TotalPatients]
		, p.[TotalPrimaryPatients] = t.[TotalPrimaryPatients]
		, p.[Total CMRs] = t.[Total CMRs]
		, p.[Potential CMR Revenue] = t.[Potential CMR Revenue]
		, p.[Total Primary CMRs] = t.[Total Primary CMRs]
		, p.[Potential CMR Revenue Primary] = t.[Potential CMR Revenue Primary]
		, p.[CMRs scheduled] = t.[CMRs scheduled]
		, p.[TotalTIPs] = t.[TotalTIPs]
		, p.[TotalPrimaryTIPs] = t.[TotalPrimaryTIPs]
		, p.[PotentialTIPRevenue] = t.[PotentialTIPRevenue]
		, p.[PotentialTIPRevenuePrimary] = t.[PotentialTIPRevenuePrimary]
		, p.[Unfinished Claims] = t.[Unfinished Claims]
		, p.[Review/Resubmit] = t.[Review/Resubmit]
		, p.[QA zone] = t.[QA zone]
		, p.[DTP %] = t.[DTP %]
		, p.[6 Month Claim History] = t.[6 Month Claim History]
		, p.[NABP] = t.[NABP]
		, p.[Pharmacy_Name] = t.[Pharmacy_Name]
		, p.[pharmacy_type] = t.[pharmacy_type]
		, p.[Address] = t.[Address]
		, p.[City] = t.[City]
		, p.[State] = t.[State]
		, p.[stateID] = t.[stateID]
		, p.[ZipCode] = t.[ZipCode]
		, p.[phone] = t.[phone]
		, p.[fax] = t.[fax]
		, p.[Contracted] = t.[Contracted]
		--select COUNT(*) 
		from ClientMTMOpportunitiesReport p 
		join ClientMTMOpportunitiesReport_staging t on t.centerid = p.centerid 
						   and t.policyid = p.policyid   
		join #tempupdate u on u.centerid = t.centerid 
							  and u.policyid = t.policyid 
		where 1=1 
		and u.id >= @mincnt  
		and u.id < @mincnt+@batch

		set @mincnt = @mincnt+@batch

end

---------


declare @temp int

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	insert into ClientMTMOpportunitiesReport (centerid 
	, policyid 
	, [Trained RPhs]
	, [Trained Techs]
	, [TotalPatients]
	, [TotalPrimaryPatients]
	, [Total CMRs]
	, [Potential CMR Revenue]
	, [Total Primary CMRs]
	, [Potential CMR Revenue Primary]
	, [CMRs scheduled]
	, [TotalTIPs]
	, [TotalPrimaryTIPs]
	, [PotentialTIPRevenue]
	, [PotentialTIPRevenuePrimary]
	, [Unfinished Claims]
	, [Review/Resubmit]
	, [QA zone]
	, [DTP %]
	, [6 Month Claim History]
	,NABP
	,[Pharmacy_Name] 
	,[pharmacy_type] 
	,[Address] 
	,[City] 
	,[State]
	,stateID
	,[ZipCode]
	,PHONE
	,FAX
	,contracted)
	select top (@batch) t.centerid 
	, t.policyid 
	, t.[Trained RPhs]
	, t.[Trained Techs]
	, t.[TotalPatients]
	, t.[TotalPrimaryPatients]
	, t.[Total CMRs]
	, t.[Potential CMR Revenue]
	, t.[Total Primary CMRs]
	, t.[Potential CMR Revenue Primary]
	, t.[CMRs scheduled]
	, t.[TotalTIPs]
	, t.[TotalPrimaryTIPs]
	, t.[PotentialTIPRevenue]
	, t.[PotentialTIPRevenuePrimary]
	, t.[Unfinished Claims]
	, t.[Review/Resubmit]
	, t.[QA zone]
	, t.[DTP %]
	, t.[6 Month Claim History]
	, t.NABP
	, t.[Pharmacy_Name] 
	, t.[pharmacy_type] 
	, t.[Address] 
	, t.[City] 
	, t.[State]
	, t.stateID
	, t.[ZipCode]
	, t.PHONE
	, t.FAX
	, t.contracted
	from ClientMTMOpportunitiesReport_staging t 
	where 1=1 
	and not exists (
					   select 1 
					   from ClientMTMOpportunitiesReport p 
					   where 1=1 
					   and t.centerid = p.centerid
					   and t.policyid = p.policyid  
	)

end

----------


set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	delete top (@batch) p 
	--select COUNT(*)
	from ClientMTMOpportunitiesReport p 
	where 1=1 
	and not exists (
					   select 1 
					   from ClientMTMOpportunitiesReport_staging t  
					   where 1=1 
					   and t.centerid = p.centerid 
					   and t.policyid = p.policyid  
	)                  
                   
end

END








