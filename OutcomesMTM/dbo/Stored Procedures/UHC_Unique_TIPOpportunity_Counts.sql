-- Ticket Name: KR - UHC Unique TIP Opportunity Counts Report (Start after 5/6)
-- DMRT#: DMRT-3717
-- TC#: TC-2981
-- Type: Automation 
-- Automation: Y
-- Reporter: Kelsey Rooker
-- Developer: Yuanpeng Li
-- Similarity: TC- 
-- Server: AOCWPAPSQL0.FUSEHEALTH.IO
-- Output save as: 
-- Code save as: \\fusehealth.io\outcomes-prod\shared\tcatsvn\SQLRequests\completed


CREATE   PROCEDURE [dbo].[UHC_Unique_TIPOpportunity_Counts]
@ReportRunDate date
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


	BEGIN TRY
			declare @startDate date =  DATEADD(yy,DATEDIFF(yy, 0, @ReportRunDate),0)
			declare @endDate date =  @ReportRunDate
			declare @ClientID int = 217 --Added By Subha (TC-3539)

			--print (@startDate)
			--print (@endDate)
			DROP TABLE IF EXISTS #RANK_1
			select	*
			INTO	#RANK_1
			FROM
			(
					select	
						--row_number() over (partition by ta.[patientID],ta.[tipdetailid], ta.[policyid] order by ta.[Completed Tips] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.[tipresultstatuscenterID] desc) as [rank],
						row_number() over (partition by ta.[patientID],ta.[tipdetailid], ta.[policyid] order by ta.[Completed Tips] desc) as [rank1]
							, ta.[TIP Opportunities]
							, ta.[tipdetailid]
							, ta.[tiptitle]
							, ta.[policyid]
							, ta.[patientid]
					from	[dbo].[vw_tipActivityCenterReport] ta --with (nolock)
							join [dbo].[ClientContractPolicyView] pv  on ta.policyid = pv.policyID
					where	1=1
							and pv.clientID = @ClientID
							--and pv.policyTypeID = 7
							and ta.tiptype = 'STAR' --Added By Subha (TC-3539)
							and ta.activethru >= @startDate and ta.activeasof <= @endDate
			)	r	
			where	1=1
					and [rank1] =  1


			--select	[TIP ID] = [tipdetailid]
			--		, [Tip Title] = [tiptitle]
			--		, sum([TIP Opportunities])  as [Total Count]
			--from	#RANK_1 
			--where	[policyid] = 998 and [tipdetailid] = 1768
			--group by [tipdetailid], [tiptitle]

			SELECT	[TIP ID] = [tipdetailid]
					, [Tip Title] = replace(replace(replace([tiptitle], char(9), ''), char(10), ''),char(13), '')
					, SUM([TIP Opportunities]) [Total Count]
			FROM	#RANK_1
			GROUP BY [tipdetailid], [tiptitle]
			ORDER BY [tiptitle]


	END TRY

		--// error handling
	BEGIN CATCH 

		PRINT ERROR_MESSAGE();

	END CATCH

END

