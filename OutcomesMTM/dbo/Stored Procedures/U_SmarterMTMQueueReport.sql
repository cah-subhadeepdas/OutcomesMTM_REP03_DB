



CREATE proc [dbo].[U_SmarterMTMQueueReport]
as
begin
set nocount on;
set xact_abort on;


--drop table #tempupdate
create table #tempupdate (
id int identity(1,1) primary key
, smarterMTMQueueBucketID int 
, patientID int
)
insert into #tempupdate (smarterMTMQueueBucketID, patientID)
select p.smarterMTMQueueBucketID, p.patientID
from smarterMTMQueueReport p
join smarterMTMQueueReport_Staging t on t.smarterMTMQueueBucketID = p.smarterMTMQueueBucketID
									and t.patientID = p.patientID
where 1=1
and not (
			isnull(p.BucketName, '') = isnull(t.BucketName, '')
			and isnull(p.BucketNote, '') = isnull(t.bucketNote, '')
			and isnull(p.patientID_All, '') = isnull(t.patientID_All,'')
			and isnull(p.First_Name,'') = isnull(t.First_Name,'')
			and isnull(p.Last_Name,'') = isnull(t.Last_Name,'')
			and isnull(p.DOB, '19000101') = isnull(t.DOB, '19000101')
			and isnull(p.Phone,'') = isnull(t.Phone,'')
			and isnull(p.tipcnt,0) = isnull(t.tipcnt,0)
			and isnull(p.cmr,'') = isnull(t.cmr,'')
			and isnull(p.cmrEligible,0) = isnull(t.cmrEligible,0)
			and isnull(p.primaryPharmacyNABP,'') = isnull(t.primaryPharmacyNABP,'')
			and isnull(p.primaryPharmacyName,'') = isnull(t.primaryPharmacyName,'')
			and isnull(p.pctfillatcenter,0) = isnull(t.pctfillatcenter,0)
			and isnull(p.checkPointDue,'') = isnull(t.checkPointDue,'')
			and isnull(p.rank,0) = isnull(t.rank,0)
			and isnull(p.policyid,0) = isnull(t.policyid,0)

)

create nonclustered index ind_1 on #tempupdate (smarterMTMQueueBucketID, patientID)


declare @batch int = 500000
Declare @mincnt bigint = 1
Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
while (@mincnt <= @maxcnt)
BEGIN

		update p
		set p.BucketName = t.BucketName
		, p.bucketNote = t.bucketNote
		, p.patientID_All = t.patientID_All
		, p.First_Name = t.First_Name
		, p.Last_Name = t.Last_Name
		, p.DOB = t.DOB
		, p.Phone = t.Phone
		, p.tipcnt = t.tipcnt
		, p.cmr = t.cmr
		, p.cmrEligible = t.cmrEligible
		, p.primaryPharmacyNABP = t.primaryPharmacyNABP
		, p.primaryPharmacyName = t.primaryPharmacyName
		, p.pctfillatcenter = t.pctfillatcenter
		, p.checkPointDue = t.checkPointDue
		, p.rank = t.rank
		, p.policyid = t.policyid 
		from smarterMTMQueueReport p
		join smarterMTMQueueReport_Staging t on t.smarterMTMQueueBucketID = p.smarterMTMQueueBucketID
											and t.patientID = p.patientID
		join #tempupdate u on u.smarterMTMQueueBucketID = t.smarterMTMQueueBucketID
											and u.patientID = t.patientID
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

	insert into smarterMTMQueueReport (smarterMTMQueueBucketID
	, BucketName
	, bucketNote
	, patientID_All
	, patientID
	, First_Name
	, Last_Name
	, DOB
	, Phone
	, tipcnt
	, cmr
	, cmrEligible
	, primaryPharmacyNABP
	, primaryPharmacyName
	, pctfillatcenter
	, checkPointDue
	, rank
	, policyid 
	)
	select top (@batch) smarterMTMQueueBucketID
	, BucketName
	, bucketNote
	, patientID_All
	, patientID
	, First_Name
	, Last_Name
	, DOB
	, Phone
	, tipcnt
	, cmr
	, cmrEligible
	, primaryPharmacyNABP
	, primaryPharmacyName
	, pctfillatcenter
	, checkPointDue
	, rank
	, policyid 
	from smarterMTMQueueReport_Staging t
	where 1=1
	and not exists (select 1
					from smarterMTMQueueReport p
					where 1=1
					and p.smarterMTMQueueBucketID = t.smarterMTMQueueBucketID
					and p.patientID = t.patientID)

end

---------------

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	delete top (@batch) p
	from smarterMTMQueueReport p
	where 1=1
	and not exists (select 1
					from smarterMTMQueueReport_Staging t
					where 1=1
					and t.smarterMTMQueueBucketID = p.smarterMTMQueueBucketID
					and t.patientID = p.patientID)

end

end


