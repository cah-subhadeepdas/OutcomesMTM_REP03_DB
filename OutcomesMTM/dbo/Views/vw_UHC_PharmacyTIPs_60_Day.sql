

CREATE view [dbo].[vw_UHC_PharmacyTIPs_60_Day]
as 

select c.chaincode as chainID
, c.chainnm as ChainName
, p.NCPDP_NABP as [Pharmacy NABP]
, replace(replace(replace(p.centername, char(9),''),char(10),''), char(13),'') as [Pharmacy Name]
, p.Address1 as [Pharmacy Address]
, p.AddressCity as [Pharmacy City]
, p.AddressState as [Pharmacy State]
, p.AddressPostalCode as [Pharmacy Zip]
, t1.[Total Opportunities]
, t1.[Count of Opportunities > 60 days]
, t1.[Count of Completed TIPs]
, t1.[Count of Successful TIPs]
, t1.[Count of Active TIPs]
, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, t1.[% Completed]
, t1.[% Success]
, t1.[% Net Effective]
-- select *
from outcomesMTM.dbo.pharmacy p 
JOIN 
(
	select t.centerID
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[60dayTip]) as decimal) as [Count of Opportunities > 60 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)/NULLIF(cast(sum(t.[60dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)/NULLIF(cast(sum(t.[60dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 60 then 1 else 0 end as [60dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
		where 1 = 1
		and (ta.primaryPharmacy = 1 or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
	) t
	where 1 = 1
	and t.Rank = 1
	group by t.centerID
) t1 on p.centerid = t1.centerid
left join (
			select amq.centerID, count(amq.AdherenceMonitorQueueID) as CheckpointCount
			FROM outcomesMTM.dbo.AdherenceMonitorQueue amq with(nolock) 
			JOIN outcomesMTM.dbo.AdherenceMonitor am with(nolock) on am.AdherenceMonitorID = amq.AdherenceMonitorID
			join outcomesMTM.dbo.patientDim pd with(nolock) on pd.PatientID = am.PatientID
			join outcomesMTM.dbo.Policy po with(nolock) on po.policyID = pd.PolicyID
			join outcomesMTM.dbo.Contract co with(nolock) on co.contractID = po.contractID
			join outcomesMTM.dbo.Client cl with(nolock) on cl.clientID = co.clientID
			join outcomesMTM.dbo.pharmacy ph on ph.centerID = amq.centerID
			join outcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerID
			join outcomesMTM.dbo.chain ch on ch.chainid = pc.chainid
			WHERE 1=1
			and amq.AdherenceMonitorQueueStatusID = 1
			AND cast(getdate() as date) between amq.QueueStart and amq.QueueEnd
			and pd.isCurrent = 1
			and cl.clientID = 105
			GROUP BY amq.centerID
) aa on aa.centerID = p.centerID
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1


