

CREATE procedure [dbo].[S_rptNINtipReport_backup]
@policyID varchar(max)
,@tipDetailID varchar(max)
,@beginDT date =  null
,@endDT date = null
as
begin
set nocount on;
set xact_abort on;


DECLARE @DEFAULT_START VARCHAR(10)
DECLARE @DEFAULT_END VARCHAR(10)
DECLARE @TODAY VARCHAR(10)


SET @DEFAULT_START = cast(year(getdate()) as varchar(4)) + '0101'  
SET @DEFAULT_END = cast(year(getdate()) as varchar(4)) + '1231'  	 	
SET @TODAY = cast(getdate() as date)

if((@beginDT is not null and @beginDT < @DEFAULT_START) or (@endDT is not null and @endDT > @DEFAULT_END))
begin
	print('Dates must be between 01/01 and 12/31 of the current year')
end

else

begin

SELECT t.tipresultstatuscenterid 
, t.tipresultstatusid  
, t.patientid_all
, t.patientid 
, t.policyid 
, t.policyname
, t.centerid 
, t.tipdetailid  
, t.tiptitle 
, CASE WHEN ISNULL(td.StarTip, 0) = 1 THEN 'STAR' 
    WHEN ISNULL(td.StarTip, 0) = 0 AND td.reasonTypeID = 2 THEN 'COST' 
    ELSE 'QUALITY' 
	END AS tiptype 
, CASE WHEN DATEDIFF(DAY, CAST(t.submitDate AS DATE),CAST(t.activethru AS DATE)) < 30 THEN 0  ELSE 1 END AS [30dayrule] 
, 1 AS [TIP Opportunities]
, CASE WHEN t.tipstatusid IS NOT NULL THEN 1 ELSE 0 END AS [TIP Activity]
, CASE WHEN t.tipstatusid IS NOT NULL THEN 1 ELSE 0 END AS [No intervention Necessary TIPs]
, t.tipstatus
, ISNULL(ppp.primaryPharmacy,0) AS primaryPharmacy   
, CAST(t.submitdate AS DATE) AS submitdate
, CAST(t.activeasof AS DATE) AS activeasof
, CAST(t.activethru AS DATE) AS activethru
, t.[NIN Active]
, t.ncpdp_nabp AS [Pharmacy NABP]
, t.centername AS [Pharmacy Name]
, t.relationship_id
, t.relationship_id_name
, ppp.pctFillatCenter AS [Pct Filled at Pharmacy]
FROM (

	SELECT ts.tipresultstatuscenterid
	, ts.tipresultstatusid 
	, ts.patientid 
	, ts.centerid  
	, ts.tipresultid 
	, ts.tipdetailid  
	, ts.policyid 
	, ts.submitDate
	, ts.activeasof   
	, ts.activethru 
	, ts.[NIN Active]
	, ts.tipstatusid  
	, ts.tipstatus
	, ts.active
	, ts.chainid 
	, ts.centername
	, ts.chaincode
	, ts.chainnm
	, ts.ncpdp_nabp
	, ts.parent_organization_id
	, ts.parent_organization_name
	, ts.patientid_all
	, po.policyname
	, ts.relationship_id
	, ts.relationship_id_name
	, ts.relationship_type
	, ts.tiptitle
	FROM (

		SELECT ROW_NUMBER() OVER (PARTITION BY trs.tipOpportunityID ORDER BY i.createdate DESC) AS [Rank]
		, trsc.tipresultstatuscenterid
		, trs.tipresultstatusid 
		, trsc.centerid 
		, trs.tipresultid
		, tr.patientid 
		, tr.tipdetailid  
		, pt.policyid AS policyID
		, trsc.createdate AS submitDate
		, i.active as [NIN Active]
		, i.createdate AS activeasof   
		, COALESCE(i.activeenddate, @TODAY) AS activethru 
		, i.tipstatusid AS tipstatusid 
		, i.tipstatus
		, trsc.active
		, ch.chainid 
		, ch.chaincode
		, pt.patientid_all
		, ch.chainnm
		, ph.centername
		, ph.ncpdp_nabp
		, td.tiptitle
		, ncpdp.parent_organization_id
		, ncpdp.parent_organization_name
		, ncpdp.relationship_id
		, ncpdp.relationship_id_name
		, ncpdp.relationship_type
		FROM staging.tipresultstatuscenter trsc WITH (NOLOCK)
		JOIN staging.tipresultstatus trs WITH (NOLOCK) ON trs.tipresultstatusid = trsc.tipresultstatusid
		JOIN dbo.TIPResultDim tr WITH (NOLOCK) ON tr.TIPresultid = trs.tipresultid
												and tr.iscurrent = 1
		JOIN dbo.patientDim pt WITH (NOLOCK) ON pt.PatientID = tr.patientid
												and pt.activeAsOf <= @TODAY
												and ISNULL(pt.activeThru, @TODAY) >= @TODAY
		JOIN staging.TIPDetail_tip td WITH (NOLOCK) ON td.tipdetailid = tr.TIPdetailid
		LEFT JOIN (

			SELECT trs.tipresultid
			, trs.tipstatusid  
			, trsc.centerid 
			, trsc.createdate 
			, trsc.activeenddate
			, ts.tipstatus
			, trs.tipOpportunityID
			, trs.active
			FROM staging.tipresultstatus trs WITH (NOLOCK) 
			JOIN staging.tipresultstatuscenter trsc WITH (NOLOCK) ON trsc.tipresultstatusid = trs.tipresultstatusid 
			JOIN staging.tipstatus ts WITH (NOLOCK) ON ts.tipstatusid = trs.tipstatusid 
			WHERE 1=1
			AND tipstatustypeid = 2 
			AND CAST(trsc.createdate AS DATE) <= ISNULL(@endDT, @DEFAULT_END)
			AND ISNULL(CAST(trsc.activeenddate AS DATE), @TODAY) >= ISNULL(@beginDT, @DEFAULT_START)

		) i ON i.tipresultid = trs.tipresultid 
				AND i.tipOpportunityID = trs.tipOpportunityID
                 AND i.centerid = trsc.centerid  
		LEFT JOIN dbo.pharmacy ph WITH (NOLOCK) ON ph.centerid = trsc.centerid
		LEFT JOIN dbo.pharmacychain pc WITH (NOLOCK) ON pc.centerid = ph.centerid
		LEFT JOIN dbo.Chain ch WITH (NOLOCK) ON ch.chainid = pc.chainid
		LEFT JOIN dbo.providerRelationshipViewStaging ncpdp ON ncpdp.mtmCenterNumber = ph.NCPDP_NABP
														AND ncpdp.Relationship_ID = ch.chaincode
		where 1=1
		AND trs.tipstatusid = 1
		--and trs.tipresultid = 166052

	) ts
	JOIN dbo.Policy po ON po.policyID = ts.policyID
	WHERE 1=1
	AND ts.[Rank] = 1
	AND ts.tipstatusid IS NOT NULL
	AND po.policyID NOT IN (10, 20)
) t
JOIN staging.TIPDetail_tip td WITH (NOLOCK) ON td.tipdetailid = t.tipdetailid 
JOIN OutcomesMTM.dbo.DelimitedSplit8K (@policyID, ',') d ON t.policyID = d.Item
JOIN OutcomesMTM.dbo.DelimitedSplit8K (@tipDetailID, ',') d1 on td.tipdetailid = d1.Item
LEFT JOIN staging.patientPrimaryPharmacy ppp ON ppp.patientid = t.patientid 
								AND ppp.centerid = t.centerid 
								AND ppp.primaryPharmacy = 1

WHERE 1=1
ORDER BY t.policyID, t.patientid, td.tipdetailid, t.submitDate

END

END

