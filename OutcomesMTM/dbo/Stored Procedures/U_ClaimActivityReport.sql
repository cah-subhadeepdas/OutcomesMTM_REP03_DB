


CREATE proc [dbo].[U_ClaimActivityReport]
as
begin
set nocount on;
set xact_abort on;


create table #tempupdate (
id int identity(1,1) primary key
, claimID int 
, [serviceTypeID] int 
)
insert into #tempupdate with (tablock) (claimID, [serviceTypeID])
select p.claimID, p.servicetypeid
from ClaimActivityReport p
join ClaimActivityReport_Staging t on t.claimID = p.claimID
									  and t.[serviceTypeID] = p.[serviceTypeID]
where 1=1
and not (
			isnull(p.statusID,0) = isnull(t.statusID,0)
			and isnull(p.statusNM,'') = isnull(t.statusNM,'')
			and isnull(p.serviceType,'') = isnull(t.serviceType,'')
			and isnull(p.mtmserviceDT, '19000101') = isnull(t.mtmserviceDT, '19000101')
			and isnull(p.patientID,0) = isnull(t.patientID,0)
			and isnull(p.CMSContractNumber,'') = isnull(t.CMSContractNumber,'')
			and isnull(p.policyID,0) = isnull(t.policyID,0)
			and isnull(p.policyName,'') = isnull(t.policyName,'')
			and isnull(p.policyTypeID,0) = isnull(t.policyTypeID,0)
			and isnull(p.policyType,'') = isnull(t.policyType,'')
			and isnull(p.clientID,0) = isnull(t.clientID,0)
			and isnull(p.clientName,'') = isnull(t.clientName,'')
			and isnull(p.paid,0) = isnull(t.paid,0)
			and isnull(p.reasontypeID,0) = isnull(t.reasontypeID,0)
			and isnull(p.actiontypeID,0) = isnull(t.actiontypeID,0)
			and isnull(p.resulttypeID,0) = isnull(t.resulttypeID,0)
			and isnull(p.isTipClaim,0) = isnull(t.isTipClaim,0)
			and isnull(p.[MTM CenterID],'') = isnull(t.[MTM CenterID],'')
			and isnull(p.chainID,0) = isnull(t.chainid,0)
			and isnull(p.[Pharmacy Chain],'') = isnull(t.[Pharmacy Chain],'')
			and isnull(p.AIM,0) = isnull(t.AIM,0)
			and isnull(p.charges,0) = isnull(t.charges,0)
			and isnull(p.payable,0) = isnull(t.payable,0)
			and isnull(p.validated,0) = isnull(t.validated,0)
			and isnull(p.processed,0) = isnull(t.processed,0)
			and isnull(p.payment,0) = isnull(t.payment,0)
			and isnull(p.claimCount,0) = isnull(t.claimCount,0)
			and isnull(p.TipClaim,0) = isnull(t.TipClaim,0)
			and isnull(p.PharmacistClaim,0) = isnull(t.PharmacistClaim,0)
			and isnull(p.CMRClaims,0) = isnull(t.CMRClaims,0)
			and isnull(p.[PatientEd/Monitoring],0) = isnull(t.[PatientEd/Monitoring],0)
			and isnull(p.PatientConsultation,0) = isnull(t.PatientConsultation,0)
			and isnull(p.PrescriberConsultation,0) = isnull(t.PrescriberConsultation,0)
			and isnull(p.SuccessfulPrescriberConsultation,0) = isnull(t.SuccessfulPrescriberConsultation,0)
			and isnull(p.SuccessfulPatientConsultation,0) = isnull(t.SuccessfulPatientConsultation,0)
			and isnull(p.PrescriberRefusal,0) = isnull(t.PrescriberRefusal,0)
			and isnull(p.UnableToReachPrescriber,0) = isnull(t.UnableToReachPrescriber,0)
			and isnull(p.PatientRefusal,0) = isnull(t.PatientRefusal,0)
			and isnull(p.UnableToReachPatient,0) = isnull(t.UnableToReachPatient,0)
			and isnull(p.PatientClaims,0) = isnull(t.PatientClaims,0)
)

create nonclustered index ind_1 on #tempupdate(claimID, servicetypeid)


declare @batch int = 500000
Declare @mincnt bigint = 1
Declare @maxcnt bigint = (select top 1 id from #tempupdate order by id desc)
while (@mincnt <= @maxcnt)
BEGIN

		update p
		set p.statusID = t.statusID
		, p.statusNM = t.statusNM
		, p.serviceType = t.serviceType
		, p.mtmserviceDT = t.mtmserviceDT
		, p.patientID = t.patientID
		, p.CMSContractNumber = t.CMSContractNumber
		, p.policyID = t.policyID
		, p.policyName = t.policyName
		, p.policyTypeID = t.policyTypeID
		, p.clientID = t.clientID
		, p.clientName = t.clientName
		, p.paid = t.paid
		, p.reasontypeID = t.reasontypeID
		, p.actiontypeID = t.actiontypeID
		, p.resulttypeID = t.resulttypeID
		, p.isTipClaim = t.isTipClaim
		, p.[MTM CenterID] = t.[MTM CenterID]
		, p.chainID = t.chainid
		, p.[Pharmacy Chain] = t.[Pharmacy Chain]
		, p.AIM = t.AIM
		, p.charges = t.charges
		, p.payable = t.payable
		, p.validated = t.validated
		, p.processed = t.processed
		, p.payment = t.payment
		, p.claimCount = t.claimCount
		, p.TipClaim = t.TipClaim
		, p.PharmacistClaim = t.PharmacistClaim
		, p.CMRClaims = t.CMRClaims
		, p.[PatientEd/Monitoring] = t.[PatientEd/Monitoring]
		, p.PatientConsultation = t.PatientConsultation
		, p.PrescriberConsultation = t.PrescriberConsultation
		, p.SuccessfulPrescriberConsultation = t.SuccessfulPrescriberConsultation
		, p.SuccessfulPatientConsultation = t.SuccessfulPatientConsultation
		, p.PrescriberRefusal = t.PrescriberRefusal
		, p.UnableToReachPrescriber = t.UnableToReachPrescriber
		, p.PatientRefusal = t.PatientRefusal
		, p.UnableToReachPatient = t.UnableToReachPatient
		, p.PatientClaims = t.PatientClaims
		from ClaimActivityReport p
		join ClaimActivityReport_Staging t on t.claimID = p.claimID and t.[serviceTypeID] = p.[serviceTypeID]
		join #tempupdate u on u.claimID = t.claimID and u.[serviceTypeID] = t.[serviceTypeID]
		where 1=1 
		and u.id >= @mincnt  
		and u.id < @mincnt+@batch

		set @mincnt = @mincnt+@batch

end

	------------

declare @temp int

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	insert into ClaimActivityReport (claimID
	, statusID
	, statusNM
	, serviceTypeID
	, serviceType
	, mtmserviceDT
	, patientID
	, CMSContractNumber
	, policyID
	, policyName
	, policyTypeID
	, policyType
	, clientID
	, clientName
	, paid
	, reasontypeID
	, actiontypeID
	, resulttypeID
	, isTipClaim
	, [MTM CenterID]
	, chainID
	, [Pharmacy Chain]
	, AIM
	, charges
	, payable
	, validated
	, processed
	, payment
	, claimCount
	, TipClaim
	, PharmacistClaim
	, CMRClaims
	, [PatientEd/Monitoring]
	, PatientConsultation
	, PrescriberConsultation
	, SuccessfulPrescriberConsultation
	, SuccessfulPatientConsultation
	, PrescriberRefusal
	, UnableToReachPrescriber
	, PatientRefusal
	, UnableToReachPatient
	, PatientClaims
	)
	select top(@batch) claimID
	, statusID
	, statusNM
	, serviceTypeID
	, serviceType
	, mtmserviceDT
	, patientID
	, CMSContractNumber
	, policyID
	, policyName
	, policyTypeID
	, policyType
	, clientID
	, clientName
	, paid
	, reasontypeID
	, actiontypeID
	, resulttypeID
	, isTipClaim
	, [MTM CenterID]
	, chainid
	, [Pharmacy Chain]
	, AIM
	, charges
	, payable
	, validated
	, processed
	, payment
	, claimCount
	, TipClaim
	, PharmacistClaim
	, CMRClaims
	, [PatientEd/Monitoring]
	, PatientConsultation
	, PrescriberConsultation
	, SuccessfulPrescriberConsultation
	, SuccessfulPatientConsultation
	, PrescriberRefusal
	, UnableToReachPrescriber
	, PatientRefusal
	, UnableToReachPatient
	, PatientClaims
	--select count(*)
	from ClaimActivityReport_Staging t
	where 1=1
	and not exists (select 1
					from ClaimActivityReport p
					where 1=1
					and p.claimID = t.claimID
					and isnull(t.[serviceTypeID],0) = isnull(p.[serviceTypeID],0))

end

set @temp = (select 1)
while (@@ROWCOUNT > 0)
BEGIN

	delete top(@batch) p
	--select count(*)
	from ClaimActivityReport p
	where 1=1
	and not exists (select 1
					from ClaimActivityReport_Staging t
					where 1=1
					and t.claimID = p.claimID
					and isnull(t.[serviceTypeID],0) = isnull(p.[serviceTypeID],0))

end

end



