
--==========
--Author:- Santhosh
--Description:- This code is for Automated  Pharmacy Payments 


CREATE   PROCEDURE [reporting].[S_ClaimDataForMonthlyFinancialClose]

As

BEGIN
declare @thruDate datetime
declare @fromDate datetime
DECLARE @Rundate date

SET @Rundate=GETDATE()
set @thruDate = CAST(CASE WHEN MONTH(@Rundate)=1 THEN DATEADD(dd,-1,DATEADD(YY,DATEDIFF(YY,0,@Rundate),0))  ELSE  DATEADD(dd,-1,DATEADD(yy,DATEDIFF(yy,0,@Rundate)+1,0)) END AS DATE);
set @fromDate = dateadd(year,datediff(year,0,@thruDate),0)

--PRINT @fromDate
--PRINT @thruDate


if object_id('tempdb.dbo.#pay') is not null
drop table #pay

select c.*, e.PayClaim
into #pay
from GetOutcomes2007.maint.tblout_acct_connectclaims c
cross apply GetOutcomes2007.maint.Acct_DNP_Claim(@Rundate,c.mtmservicedt,c.policyid,c.NCPDP_NABP) e

where 1=1
and c.mtmserviceDT >= @fromDate
and c.mtmserviceDT <= @thruDate
and c.claimstatus in (
	'Approved - Not Paid'
	,'Pending approval'
	,'ReviewResubmit'
	)


CREATE NONCLUSTERED INDEX IX ON #pay(ClaimID,NCPDP_NABP,PolicyID)






select distinct
  pay.ClaimID
, MTMServiceDT = convert(varchar,pay.MTMServiceDT,101)
, ClaimYear = year(pay.mtmserviceDT)
, ClaimMonth = month(pay.mtmserviceDT)
, PolicyID = pay.policyID
, PolicyName = g.Description
, ClaimStatus = pay.ClaimStatus
--,ReasonCode =pay.Reason
, ReasonName = pay.ReasonName
--,ActionCode=pay.Action
, ActionName = pay.ActionName
--,ResultCode=pay.Result
, ResultName = pay.ResultName
, TIPTitle = td.tiptitle 
, NCPDP_NABP = pay.Ncpdp_nabp
, PharmacyName = tp.[Name]
--, PayProvider = case when pay.PayClaim = 1 then 'Y' else 'N' end
, PayAmount = pay.Charges
from #pay pay
join GetOutcomes2007.dbo.tblgroups g WITH(NOLOCK)
	on g.groupid = pay.policyid
left join GetOutcomes2007.dbo.tblpharmacy tp WITH(NOLOCK)
	on tp.NCPDP_NABP = pay.NCPDP_NABP
left join aocwpapsql02.outcomes.dbo.claim c WITH(NOLOCK)
	on c.claimid = pay.ClaimID
left join aocwpapsql02.outcomes.dbo.TIPDetail td WITH(NOLOCK)
	on td.tipdetailid = c.tipdetailid
where payclaim=1
order by 4,5,7


END




--EXEC [reporting].[S_ClaimDataForInvoicing]
--WITH RESULT SETS((
--ClaimID INT
--,MTMServiceDT Date
--,ClaimYear INT
--,ClaimMonth INT
--,PolicyID INT
--,PolicyName VARCHAR(50)
--,ClaimStatus VARCHAR(50)
--,ReasonCode INT
--,ReasonName VARCHAR(5000)
--,ActionCode INT
--,ActionName VARCHAR(5000)
--,ResultCode INT
--,ResultName VARCHAR(5000)
--,TIPTitle VARCHAR(50)
--,NCPDP_NABP VARCHAR(5000)
--,PharmacyName VARCHAR(5000)
--,PayAmount MONEY
--))



