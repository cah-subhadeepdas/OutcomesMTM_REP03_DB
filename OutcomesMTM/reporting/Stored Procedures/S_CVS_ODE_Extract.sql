
CREATE   PROCEDURE [reporting].[S_CVS_ODE_Extract]
	@ReportExtractLogID int

AS
BEGIN

SET NOCOUNT ON;

select CVSOpportunityID 
, TIPOpportunityID 
, RTRIM(LTRIM(NCPDP)) AS NCPDP
, NPI 
, CVSReimbursementID 
, OpportunityPharmacyPayment 
, OpportunityOutcome 
, ServiceStatus 
, DeclineReason 
, REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(25), ServiceDate, 120), '-', ''), ' ', ''), ':', '') AS ServiceDate
, REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(25), CloseDate, 120), '-', ''), ' ', ''), ':', '') AS CloseDate
, CloseReason 
, ExternalDispositionCode 
, REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(25), CaseFirstViewDate, 120), '-', ''), ' ', ''), ':', '') AS CaseFirstViewDate
, REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(25), CaseCreationDate, 120), '-', ''), ' ', ''), ':', '') AS CaseCreationDate
, REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(25), CaseAssignedDate, 120), '-', ''), ' ', ''), ':', '') AS CaseAssignedDate
, OmissionCareGapRule 
, AlertVerifiedTF 
, AlertType 
, REPLACE(REPLACE(REPLACE(REPLACE(SupportingNotes,char(9),''),char(10),''),char(13),''), '|', '') AS SupportingNotes
, '||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||' as [blank1]	--\\Blank Columns (Column 21 to Column 103)
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
, '||||||||||||||||||||||||||||||||||||||||||||||' as [Blank2]	--\\Blank columns (Column 145 to Column 191)
from OutcomesMTM.reporting.CVS_ODE_Extract
where 1=1
and [ReportExtractLogID] = @ReportExtractLogID

End