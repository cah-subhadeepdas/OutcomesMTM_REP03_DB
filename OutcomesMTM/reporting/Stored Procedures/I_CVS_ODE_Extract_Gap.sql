
CREATE   PROCEDURE [reporting].[I_CVS_ODE_Extract_Gap]
	@ReportExtractLogID int

AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @ErrorCondition int = 0
	DECLARE @Return varchar(8000) = ''

	BEGIN TRY	

--insert into reporting.CVS_ODE_Extract
drop table if exists #CVS_ODE_Extract_Gap

select co.CVSOpportunityID
	, co.TIPOpportunityID
	, co.ClaimID
	, co.ClaimStatusID
	, co.NCPDP
	, co.NPI
	, co.CVSReimbursementID
	, case --when ode.ClaimStatusID = 6 and co.ClaimStatusID = 5  then '-1'*co.OpportunityPharmacyPayment	--//Report a negative amount if the approved claim is sent already
		   when co.ClaimStatusID = 5 then 0
		   else co.OpportunityPharmacyPayment end as [OpportunityPharmacyPayment]
	, co.OpportunityOutcome
	, co.ServiceStatus
	, co.DeclineReason
	, co.ServiceDate
	, co.CloseDate
	, co.CloseReason
	, co.ExternalDispositionCode
	, co.CaseFirstViewDate
	, co.CaseCreationDate
	, co.CaseAssignedDate
	, co.OmissionCareGapRule
	, co.AlertVerifiedTF
	, co.AlertType
	, co.SupportingNotes
	--Barriers
	, co.[Medication cost is too high]
	, co.[Patient taking differently than written directions]
	, co.[Transportation limitations]
	, co.[Concerned about potential side effects]
	, co.[Experienced side effects]
	, co.[Too many medications or doses per day]
	, co.[Believes to be adherent]
	, co.[Decreased cognitive function]
	, co.[Feels medication is not helping]
	, co.[Feels medication is not needed]
	, co.[Forgets to take]
	, co.[Limitations on activities of daily living]
	, co.[Unsure how to use medication]
	, co.[Unable to swallow or administer]
	, co.[Refill request delay]
	, co.[Patient has no concerns or barriers]
	--Actions
	, co.[Addressed symptom and side effect management]
	, co.[Obtained accurately written prescription]
	, co.[Contacted provider to obtain alternative formulation]
	, co.[Identified area(s) to simplify medication regimen]
	, co.[Identified cost reduction strategies]
	, co.[Identified area(s) to adjust medication regimen]
	, co.[Provided patient education]
	, co.[Provided reminder tools or adherence aids]
	, co.[Offered prescription delivery]
	, co.[Addressed limitation to activities of daily living]
	, co.[Contacted provider to approve refill request]
	--NINs
	, co.[Patient received samples]
	, co.[Prescriber lowered dose]
	, co.[Patient obtained medication from an outside source]
	, co.[Patient is no longer on medication in targeted drug class]
	, co.[Directions written to take "as needed"]
	, co.[Patient paid cash]
	, co.[Patient was in hospital (or other transition of care)]
	, co.[Patient resides in a facility (LTC, assisted living, hospice, etc.)]
	, co.[Patient is deceased]
	, co.[Intervention already occurred]
	, co.[Patient had adverse event/allergy to suggested medication]
	, co.[Patient has tried and failed suggested medication]
	, co.[Patient is already taking the medication]
	, co.[Recommended therapy is not appropriate for patient]
	, co.[ReportType]
	, [ReportExtractLogID] = @ReportExtractLogID
into #CVS_ODE_Extract_Gap
from staging.CVS_ODE_Source_Gap co
left join (select * 
		   , ROW_NUMBER() over(partition by [CVSOpportunityID] order by [ReportExtractLogID] desc) as [Rank]
		   from reporting.CVS_ODE_Extract )ode 
	on ode.CVSOpportunityID = co.CVSOpportunityID and ode.[Rank] = 1	--//The latest record of the opportunity should be used to compare
where 1=1
and (ode.CVSOpportunityID is null or ode.ClaimStatusID <> co.ClaimStatusID)	--//Only new Opprtunities or the opportunities with a different claimstatusid should be reported


insert into reporting.CVS_ODE_Extract
(
 CVSOpportunityID 
, TIPOpportunityID 
, ClaimID 
, ClaimStatusID 
, NCPDP 
, NPI 
, CVSReimbursementID 
, OpportunityPharmacyPayment 
, OpportunityOutcome 
, ServiceStatus 
, DeclineReason 
, ServiceDate 
, CloseDate 
, CloseReason 
, ExternalDispositionCode 
, CaseFirstViewDate 
, CaseCreationDate 
, CaseAssignedDate 
, OmissionCareGapRule 
, AlertVerifiedTF 
, AlertType 
, SupportingNotes 
, [Medication cost is too high] 
, [Patient taking differently than written directions] 
, [Transportation limitations] 
, [Concerned about potential side effects] 
, [Experienced side effects] 
, [Too many medications or doses per day] 
, [Believes to be adherent] 
, [Decreased cognitive function] 
, [Feels medication is not helping] 
, [Feels medication is not needed] 
, [Forgets to take] 
, [Limitations on activities of daily living] 
, [Unsure how to use medication] 
, [Unable to swallow or administer] 
, [Refill request delay] 
, [Patient has no concerns or barriers] 
, [Addressed symptom and side effect management] 
, [Obtained accurately written prescription] 
, [Contacted provider to obtain alternative formulation] 
, [Identified area(s) to simplify medication regimen] 
, [Identified cost reduction strategies] 
, [Identified area(s) to adjust medication regimen] 
, [Provided patient education] 
, [Provided reminder tools or adherence aids] 
, [Offered prescription delivery] 
, [Addressed limitation to activities of daily living] 
, [Contacted provider to approve refill request] 
, [Patient received samples] 
, [Prescriber lowered dose] 
, [Patient obtained medication from an outside source] 
, [Patient is no longer on medication in targeted drug class] 
, [Directions written to take "as needed"] 
, [Patient paid cash] 
, [Patient was in hospital (or other transition of care)] 
, [Patient resides in a facility (LTC, assisted living, hospice, etc.)] 
, [Patient is deceased] 
, [Intervention already occurred] 
, [Patient had adverse event/allergy to suggested medication] 
, [Patient has tried and failed suggested medication] 
, [Patient is already taking the medication] 
, [Recommended therapy is not appropriate for patient] 
, [ReportType] 
, [ReportExtractLogID] 
)

select  CVSOpportunityID 
, TIPOpportunityID 
, ClaimID 
, ClaimStatusID 
, NCPDP 
, NPI 
, CVSReimbursementID 
, OpportunityPharmacyPayment 
, OpportunityOutcome 
, ServiceStatus 
, DeclineReason 
, ServiceDate 
, CloseDate 
, CloseReason 
, ExternalDispositionCode 
, CaseFirstViewDate 
, CaseCreationDate 
, CaseAssignedDate 
, OmissionCareGapRule 
, AlertVerifiedTF 
, AlertType 
, SupportingNotes 
, [Medication cost is too high] 
, [Patient taking differently than written directions] 
, [Transportation limitations] 
, [Concerned about potential side effects] 
, [Experienced side effects] 
, [Too many medications or doses per day] 
, [Believes to be adherent] 
, [Decreased cognitive function] 
, [Feels medication is not helping] 
, [Feels medication is not needed] 
, [Forgets to take] 
, [Limitations on activities of daily living] 
, [Unsure how to use medication] 
, [Unable to swallow or administer] 
, [Refill request delay] 
, [Patient has no concerns or barriers] 
, [Addressed symptom and side effect management] 
, [Obtained accurately written prescription] 
, [Contacted provider to obtain alternative formulation] 
, [Identified area(s) to simplify medication regimen] 
, [Identified cost reduction strategies] 
, [Identified area(s) to adjust medication regimen] 
, [Provided patient education] 
, [Provided reminder tools or adherence aids] 
, [Offered prescription delivery] 
, [Addressed limitation to activities of daily living] 
, [Contacted provider to approve refill request] 
, [Patient received samples] 
, [Prescriber lowered dose] 
, [Patient obtained medication from an outside source] 
, [Patient is no longer on medication in targeted drug class] 
, [Directions written to take "as needed"] 
, [Patient paid cash] 
, [Patient was in hospital (or other transition of care)] 
, [Patient resides in a facility (LTC, assisted living, hospice, etc.)] 
, [Patient is deceased] 
, [Intervention already occurred] 
, [Patient had adverse event/allergy to suggested medication] 
, [Patient has tried and failed suggested medication] 
, [Patient is already taking the medication] 
, [Recommended therapy is not appropriate for patient] 
, [ReportType] 
, [ReportExtractLogID] 
from #CVS_ODE_Extract_Gap


	--//  use this to check for error conditions to exit the proc (if used inside begin/commit transaction, the tran will be rolled back when the condition is met; otherwise, the tran will be committed)
	IF @ErrorCondition <> 0
	BEGIN
		SET @Return = 'Error Condition Met; Transaction Rolled Back.';  --// can customize return message
		THROW 51000, @Return, 1;
	END

	IF XACT_STATE() = 1 COMMIT TRANSACTION;

	--//  put any post-CRUD work in this section


END TRY
BEGIN CATCH

	IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

	IF ISNULL(@Return,'') <> ''
		PRINT @Return;
	ELSE
		THROW;

END CATCH

end
