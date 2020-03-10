
CREATE PROCEDURE [dbo].[U_PatientCMREnrollment]
AS
BEGIN
   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   INSERT INTO PatientCMREnrollment(
      patientCMREnrollmentID, 
      patientid, 
      policyid, 
      createDT)
   SELECT
      patientCMREnrollmentID, 
      patientid, 
      policyid, 
      createDT
   FROM patientCMREnrollmentDeltaQueueStaging


END