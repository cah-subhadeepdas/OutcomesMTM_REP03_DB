
CREATE FUNCTION [dbo].[tvf_Pt_Audit]
(	
	@ClientIDList AS VARCHAR(8000)
	, @rptFromDate AS DATE
	, @rptThruDate AS DATE
	, @PatientID bigint
)
RETURNS TABLE 
AS
RETURN 
(

	select 
		PatientID			= pt.PatientID
		, ClientID			= pt.ClientID
		, PatientID_All		= max( case when pt.Pt_ranker = 1 then pt.PatientID_All end )
		, MemberGenKey		= max( case when pt.Pt_ranker = 1 then pt.MemberGenKey end )
		, AlternateID		= max( case when pt.Pt_ranker = 1 then pt.AlternateID end )
		, DisplayID			= max( case when pt.Pt_ranker = 1 then pt.DisplayID end )
		, HICN				= max( case when pt.HICN_ranker = 1 then pt.HICN end )  --// returns the 1st non null, non blank HICN
		, First_Name		= max( case when pt.Pt_ranker = 1 then pt.First_Name end )
		, Last_Name			= max( case when pt.Pt_ranker = 1 then pt.Last_Name end )
		, DOB				= max( case when pt.Pt_ranker = 1 then pt.DOB end )
		, PlanEffectiveDate = max( case when pt.Pt_ranker = 1 then pt.PlanEffectiveDate end )

	from (
		select
			  pt.PatientID
			, pt.ClientID
			, pt.PatientID_All
			, pt.MemberGenKey
			, pt.alternateID
			, pt.displayID
			, HICN = isnull(pt.HICN,'')
			, pt.First_Name
			, pt.Last_Name
			, pt.DOB
			, pt.PlanEffectiveDate
			, pt.activeAsOf
			, pt.activeThru
			, HICN_ranker = ROW_NUMBER() over (partition by pt.PatientID order by (case when pt.HICN is not null and pt.HICN <> '' then 1 else 2 end), pt.ActiveAsOf)
			, Pt_ranker = ROW_NUMBER() over (partition by pt.PatientID order by pt.PlanEffectiveDate)
		from outcomesmtm.dbo.patientdim pt
		join string_split(@ClientIDList,',') cll
			on cll.value = pt.ClientID
		where 1=1
		and pt.activeasof < @rptThruDate
		and (		pt.activeThru > @rptFromDate
				OR	pt.activeThru is null
			)
		and (		pt.PatientID = @PatientID
				OR	@PatientID is null
			)
	) pt
	group by
		pt.PatientID
		, pt.ClientID
)

