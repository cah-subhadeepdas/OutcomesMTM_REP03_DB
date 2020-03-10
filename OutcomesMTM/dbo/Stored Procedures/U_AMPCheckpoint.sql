CREATE procedure [dbo].[U_AMPCheckpoint] 
as 
begin 

	update ch
	set ch.[QuarterEnrolled] = case when month(ch.[mtmserviceDT]) in (1,2,3) then 1 
									when month(ch.[mtmserviceDT]) in (4,5,6) then 2
									when month(ch.[mtmserviceDT]) in (7,8,9) then 3
									when month(ch.[mtmserviceDT]) in (10,11,12) then 4
								end,
		
		ch.[IsQ2Opportunity] =  case when ISDATE(ch.[Q2:Adherence Monitoring]) = 1 then 1 else 0 end , 
		ch.[IsQ3Opportunity] =  case when (ISDATE(ch.[Q3:Adherence Monitoring]) = 1 or (ch.[Q2:Result code] like '%Monitoring%checkpoint%complete%' and (ch.disEnrolledDate is  null or  month(ch.disEnrolledDate)  > 9) ) )  then 1 else 0 end , 
		ch.[IsQ4Opportunity] =  case when (ISDATE(ch.[Q4:Adherence Monitoring]) = 1 or (ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' and (ch.disEnrolledDate is  null or  month(ch.disEnrolledDate)  > 9)) ) then 1 else 0 end ,

		ch.[IsQ2Complete] =  case when (ch.[Q2:Result code] like '%Monitoring%checkpoint%complete%' or ch.[Q2:Result code] like '%Patient%refused%') then 1 else 0 end,
		ch.[IsQ3Complete] =  case when (ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' or ch.[Q3:Result code] like '%Patient%refused%') then 1 else 0 end,
		ch.[IsQ4Complete] =  case when (ch.[Q4:Result code] like '%Monitoring%checkpoint%complete%' or ch.[Q4:Result code] like '%Patient%refused%') then 1 else 0 end,

		ch.[IsQ2Successful] =  case when ch.[Q2:Result code] like '%Monitoring%checkpoint%complete%' then 1 else 0 end,
		ch.[IsQ3Successful] =  case when ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' then 1 else 0 end,
		ch.[IsQ4Successful] =  case when ch.[Q4:Result code] like '%Monitoring%checkpoint%complete%' then 1 else 0 end,		


		ch.Current_AMP_Status = case when ch.[Q4:Result code] like '%Monitoring%checkpoint%complete%' and ch.[disEnrolledDate] is null then 'Complete'
									 when ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' and isnull([Q4:Result code],'') not like '%Monitoring%checkpoint%complete%' and  ch.[disEnrolledDate] is not null  then 'Disenrolled'
									 when ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' and isnull([Q4:Result code],'') not like '%Monitoring%checkpoint%complete%' and  ch.[disEnrolledDate] is null  then 'Active'
									 end

	from dbo.ampcheckpoint_currentyear  ch ;

	update ch
	set	ch.TotalOpportunities_CheckpointCount = case when ch.[QuarterEnrolled] in (1,2) then (ch.[IsQ2Opportunity] + ch.[IsQ3Opportunity] + ch.[IsQ4Opportunity])												 
													 when ch.[QuarterEnrolled] in (3)   then (ch.[IsQ3Opportunity] +  ch.[IsQ4Opportunity])
													 when ch.[QuarterEnrolled] in (4)   then ch.[IsQ4Opportunity]
													 else 0 end , --check for quarter enrolled and then calculate

		ch.TotalCompleted_CheckpointCount = case when ch.[QuarterEnrolled] in (1,2) then (ch.[IsQ2Complete] + ch.[IsQ3Complete] + ch.[IsQ4Complete])												 
													 when ch.[QuarterEnrolled] in (3)   then (ch.[IsQ3Complete] + ch.[IsQ4Complete])
													 when ch.[QuarterEnrolled] in (4)   then ch.[IsQ4Complete]
													 else 0 end , --check for quarter enrolled and then calculate

		ch.TotalSuccessful_CheckpointCount = case when ch.[QuarterEnrolled] in (1,2) then (ch.[IsQ2Successful] + ch.[IsQ3Successful] + ch.[IsQ4Successful])												 
													 when ch.[QuarterEnrolled] in (3)   then (ch.[IsQ3Successful] + ch.[IsQ4Successful])
													 when ch.[QuarterEnrolled] in (4)   then ch.[IsQ4Successful]
													 else 0 end  --check for quarter enrolled and then calculate

	from dbo.ampcheckpoint_currentyear ch ;




	update ch
	set ch.[QuarterEnrolled] = case when month(ch.[mtmserviceDT]) in (1,2,3) then 1 
									when month(ch.[mtmserviceDT]) in (4,5,6) then 2
									when month(ch.[mtmserviceDT]) in (7,8,9) then 3
									when month(ch.[mtmserviceDT]) in (10,11,12) then 4
								end,
		ch.[IsQ2Opportunity] =  case when ISDATE(ch.[Q2:Adherence Monitoring]) = 1 then 1 else 0 end , 
		ch.[IsQ3Opportunity] =  case when (ISDATE(ch.[Q3:Adherence Monitoring]) = 1 or (ch.[Q2:Result code] like '%Monitoring%checkpoint%complete%' and (ch.disEnrolledDate is  null or  month(ch.disEnrolledDate)  > 9) ) )  then 1 else 0 end , 
		ch.[IsQ4Opportunity] =  case when (ISDATE(ch.[Q4:Adherence Monitoring]) = 1 or (ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' and (ch.disEnrolledDate is  null or  month(ch.disEnrolledDate)  > 9)) ) then 1 else 0 end ,

		ch.[IsQ2Complete] =  case when (ch.[Q2:Result code] like '%Monitoring%checkpoint%complete%' or ch.[Q2:Result code] like '%Patient%refused%') then 1 else 0 end,
		ch.[IsQ3Complete] =  case when (ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' or ch.[Q3:Result code] like '%Patient%refused%') then 1 else 0 end,
		ch.[IsQ4Complete] =  case when (ch.[Q4:Result code] like '%Monitoring%checkpoint%complete%' or ch.[Q4:Result code] like '%Patient%refused%') then 1 else 0 end,

		ch.[IsQ2Successful] =  case when ch.[Q2:Result code] like '%Monitoring%checkpoint%complete%' then 1 else 0 end,
		ch.[IsQ3Successful] =  case when ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' then 1 else 0 end,
		ch.[IsQ4Successful] =  case when ch.[Q4:Result code] like '%Monitoring%checkpoint%complete%' then 1 else 0 end,		


		ch.Current_AMP_Status = case when ch.[Q4:Result code] like '%Monitoring%checkpoint%complete%' and ch.[disEnrolledDate] is null then 'Complete'
									 when ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' and [Q4:Result code] not like '%Monitoring%checkpoint%complete%' and  ch.[disEnrolledDate] is not null  then 'Disenrolled'
									 when ch.[Q3:Result code] like '%Monitoring%checkpoint%complete%' and [Q4:Result code] not like '%Monitoring%checkpoint%complete%' and  ch.[disEnrolledDate] is null  then 'Active'
									 end

	from dbo.ampcheckpoint_previousyear  ch ; 


	update ch
	set	ch.TotalOpportunities_CheckpointCount = case when ch.[QuarterEnrolled] in (1,2) then (ch.[IsQ2Opportunity] + ch.[IsQ3Opportunity] + ch.[IsQ4Opportunity])												 
													 when ch.[QuarterEnrolled] in (3)   then (ch.[IsQ3Opportunity] +  ch.[IsQ4Opportunity])
													 when ch.[QuarterEnrolled] in (4)   then ch.[IsQ4Opportunity]
													 else 0 end , --check for quarter enrolled and then calculate

		ch.TotalCompleted_CheckpointCount = case when ch.[QuarterEnrolled] in (1,2) then (ch.[IsQ2Complete] + ch.[IsQ3Complete] + ch.[IsQ4Complete])												 
													 when ch.[QuarterEnrolled] in (3)   then (ch.[IsQ3Complete] + ch.[IsQ4Complete])
													 when ch.[QuarterEnrolled] in (4)   then ch.[IsQ4Complete]
													 else 0 end , --check for quarter enrolled and then calculate

		ch.TotalSuccessful_CheckpointCount = case when ch.[QuarterEnrolled] in (1,2) then (ch.[IsQ2Successful] + ch.[IsQ3Successful] + ch.[IsQ4Successful])												 
													 when ch.[QuarterEnrolled] in (3)   then (ch.[IsQ3Successful] + ch.[IsQ4Successful])
													 when ch.[QuarterEnrolled] in (4)   then ch.[IsQ4Successful]
													 else 0 end  --check for quarter enrolled and then calculate

	from dbo.ampcheckpoint_previousyear ch ;


	----- update the policyIds
	update ch
	set ch.policyId = P.policyID
	from dbo.ampcheckpoint_currentyear ch  join Policy P on ch.policyName = P.policyName ;

	update ch
	set ch.policyId = P.policyID
	from dbo.ampcheckpoint_previousyear ch  join Policy P on ch.policyName = P.policyName ;

end


