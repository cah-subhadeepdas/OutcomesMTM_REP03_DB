
CREATE PROCEDURE [dbo].[U_Claim]
AS
BEGIN
   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   INSERT INTO dbo.Claim(
       claimid
      ,patientid
      ,reasonTypeID
      ,actionTypeID
      ,resultTypeID
      ,estimated_cost
      ,AIM
      ,initDT
      ,completeDT
      ,resultDT
      ,otcTherapyName
      ,problemsImproved
      ,adverseReactions
      ,therapyCompliant
      ,refillPickedUp
      ,useAsDirected
      ,patRefusalID
      ,patRefusalReason
      ,presRefusalID
      ,presRefusalReason
      ,immunizationDT
      ,mtmServiceDT
      ,ecaLevelID
      ,productName
      ,timeToComplete
      ,reasonWaitID
      ,expireDT
      ,newMedName
      ,newMedGpi
      ,newMedRxNumber
      ,newMedDispensedDT
      ,newMedMetricQuantity
      ,newMedDaysSupply
      ,newMedPrescriber
      ,newMedPrescriberID
      ,currentMedName
      ,currentMedGpi
      ,currentMedRxNumber
      ,currentMedDispensedDT
      ,currentMedMetricQuantity
      ,currentMedDaysSupply
      ,currentMedPrescriber
      ,currentPrescriberID
      ,currentMedfromHistory
      ,cmrPostDischarge
      ,initialConsultDT
      ,followUpConsultDT
      ,therapySatisfied
      ,adverseReactionsReported
      ,featureEncounter
      ,charges
      ,isTipClaim
      ,createDT
      ,face2face
      ,cmrFace2Face
      ,cmrPhoneReasonID
      ,cmrCompleted
      ,pharmacistID
      ,priorAuthCode
      ,tipResultID
      ,medicationID
      ,paid
      ,paiddate
      ,funded
      ,fundeddate
      ,claimfromCMR
      ,APIclaim
      ,currentPrescriberNPI
      ,tipDetailID
      ,HealthTestValue
      ,PCPName
      ,pregTestResult
      ,policyID
      ,invoiced
      ,invoiceddate
      ,cmrDeliveryTypeID
      ,ninetyDayAttestQ1
      ,ninetyDayAttestQ2
      ,refillRxAttestQ1
      ,refillRxAttestQ2
      ,centerID
      ,statusID
      ,submitDT
      ,documentationRoleID
      ,invoiceStatusTypeID
      ,changeDate
      ,condition
      ,labID
      ,currentMedName2
      ,currentMedGpi2
      ,currentMedRxNumber2
      ,currentMedMetricQuantity2
      ,currentMedDaysSupply2
      ,currentMedPrescriber2
      ,currentPrescriberNPI2)
   SELECT
       cs.claimid
      ,cs.patientid
      ,cs.reasonTypeID
      ,cs.actionTypeID
      ,cs.resultTypeID
      ,cs.estimated_cost
      ,cs.AIM
      ,cs.initDT
      ,cs.completeDT
      ,cs.resultDT
      ,cs.otcTherapyName
      ,cs.problemsImproved
      ,cs.adverseReactions
      ,cs.therapyCompliant
      ,cs.refillPickedUp
      ,cs.useAsDirected
      ,cs.patRefusalID
      ,cs.patRefusalReason
      ,cs.presRefusalID
      ,cs.presRefusalReason
      ,cs.immunizationDT
      ,cs.mtmServiceDT
      ,cs.ecaLevelID
      ,cs.productName
      ,cs.timeToComplete
      ,cs.reasonWaitID
      ,cs.expireDT
      ,cs.newMedName
      ,cs.newMedGpi
      ,cs.newMedRxNumber
      ,cs.newMedDispensedDT
      ,cs.newMedMetricQuantity
      ,cs.newMedDaysSupply
      ,cs.newMedPrescriber
      ,cs.newMedPrescriberID
      ,cs.currentMedName
      ,cs.currentMedGpi
      ,cs.currentMedRxNumber
      ,cs.currentMedDispensedDT
      ,cs.currentMedMetricQuantity
      ,cs.currentMedDaysSupply
      ,cs.currentMedPrescriber
      ,cs.currentPrescriberID
      ,cs.currentMedfromHistory
      ,cs.cmrPostDischarge
      ,cs.initialConsultDT
      ,cs.followUpConsultDT
      ,cs.therapySatisfied
      ,cs.adverseReactionsReported
      ,cs.featureEncounter
      ,cs.charges
      ,cs.isTipClaim
      ,cs.createDT
      ,cs.face2face
      ,cs.cmrFace2Face
      ,cs.cmrPhoneReasonID
      ,cs.cmrCompleted
      ,cs.pharmacistID
      ,cs.priorAuthCode
      ,cs.tipResultID
      ,cs.medicationID
      ,cs.paid
      ,cs.paiddate
      ,cs.funded
      ,cs.fundeddate
      ,cs.claimfromCMR
      ,cs.APIclaim
      ,cs.currentPrescriberNPI
      ,cs.tipDetailID
      ,cs.HealthTestValue
      ,cs.PCPName
      ,cs.pregTestResult
      ,cs.policyID
      ,cs.invoiced
      ,cs.invoiceddate
      ,cs.cmrDeliveryTypeID
      ,cs.ninetyDayAttestQ1
      ,cs.ninetyDayAttestQ2
      ,cs.refillRxAttestQ1
      ,cs.refillRxAttestQ2
      ,cs.centerID
      ,cs.statusID
      ,cs.submitDT
      ,cs.documentationRoleID
      ,cs.invoiceStatusTypeID
      ,cs.changeDate
      ,cs.condition
      ,cs.labID
      ,currentMedName2
      ,currentMedGpi2
      ,currentMedRxNumber2
      ,currentMedMetricQuantity2
      ,currentMedDaysSupply2
      ,currentMedPrescriber2
      ,currentPrescriberNPI2
   FROM dbo.ClaimDeltaQueueStaging cs
   WHERE 1 = 1
     AND NOT EXISTS (SELECT 1
                     FROM dbo.Claim cd
                     WHERE 1 = 1
                       AND cs.claimID = cd.claimID)

   UPDATE cd
      SET cd.patientid = cs.patientid
         ,cd.reasonTypeID = cs.reasonTypeID
         ,cd.actionTypeID = cs.actionTypeID
         ,cd.resultTypeID = cs.resultTypeID
         ,cd.estimated_cost = cs.estimated_cost
         ,cd.AIM = cs.AIM
         ,cd.initDT = cs.initDT
         ,cd.completeDT = cs.completeDT
         ,cd.resultDT = cs.resultDT
         ,cd.otcTherapyName = cs.otcTherapyName
         ,cd.problemsImproved = cs.problemsImproved
         ,cd.adverseReactions = cs.adverseReactions
         ,cd.therapyCompliant = cs.therapyCompliant
         ,cd.refillPickedUp = cs.refillPickedUp
         ,cd.useAsDirected = cs.useAsDirected
         ,cd.patRefusalID = cs.patRefusalID
         ,cd.patRefusalReason = cs.patRefusalReason
         ,cd.presRefusalID = cs.presRefusalID
         ,cd.presRefusalReason = cs.presRefusalReason
         ,cd.immunizationDT = cs.immunizationDT
         ,cd.mtmServiceDT = cs.mtmServiceDT
         ,cd.ecaLevelID = cs.ecaLevelID
         ,cd.productName = cs.productName
         ,cd.timeToComplete = cs.timeToComplete
         ,cd.reasonWaitID = cs.reasonWaitID
         ,cd.expireDT = cs.expireDT
         ,cd.newMedName = cs.newMedName
         ,cd.newMedGpi = cs.newMedGpi
         ,cd.newMedRxNumber = cs.newMedRxNumber
         ,cd.newMedDispensedDT = cs.newMedDispensedDT
         ,cd.newMedMetricQuantity = cs.newMedMetricQuantity
         ,cd.newMedDaysSupply = cs.newMedDaysSupply
         ,cd.newMedPrescriber = cs.newMedPrescriber
         ,cd.newMedPrescriberID = cs.newMedPrescriberID
         ,cd.currentMedName = cs.currentMedName
         ,cd.currentMedGpi = cs.currentMedGpi
         ,cd.currentMedRxNumber = cs.currentMedRxNumber
         ,cd.currentMedDispensedDT = cs.currentMedDispensedDT
         ,cd.currentMedMetricQuantity = cs.currentMedMetricQuantity
         ,cd.currentMedDaysSupply = cs.currentMedDaysSupply
         ,cd.currentMedPrescriber = cs.currentMedPrescriber
         ,cd.currentPrescriberID = cs.currentPrescriberID
         ,cd.currentMedfromHistory = cs.currentMedfromHistory
         ,cd.cmrPostDischarge = cs.cmrPostDischarge
         ,cd.initialConsultDT = cs.initialConsultDT
         ,cd.followUpConsultDT = cs.followUpConsultDT
         ,cd.therapySatisfied = cs.therapySatisfied
         ,cd.adverseReactionsReported = cs.adverseReactionsReported
         ,cd.featureEncounter = cs.featureEncounter
         ,cd.charges = cs.charges
         ,cd.isTipClaim = cs.isTipClaim
         ,cd.createDT = cs.createDT
         ,cd.face2face = cs.face2face
         ,cd.cmrFace2Face = cs.cmrFace2Face
         ,cd.cmrPhoneReasonID = cs.cmrPhoneReasonID
         ,cd.cmrCompleted = cs.cmrCompleted
         ,cd.pharmacistID = cs.pharmacistID
         ,cd.priorAuthCode = cs.priorAuthCode
         ,cd.tipResultID = cs.tipResultID
         ,cd.medicationID = cs.medicationID
         ,cd.paid = cs.paid
         ,cd.paiddate = cs.paiddate
         ,cd.funded = cs.funded
         ,cd.fundeddate = cs.fundeddate
         ,cd.claimfromCMR = cs.claimfromCMR
         ,cd.APIclaim = cs.APIclaim
         ,cd.currentPrescriberNPI = cs.currentPrescriberNPI
         ,cd.tipDetailID = cs.tipDetailID
         ,cd.HealthTestValue = cs.HealthTestValue
         ,cd.PCPName = cs.PCPName
         ,cd.pregTestResult = cs.pregTestResult
         ,cd.policyID = cs.policyID
         ,cd.invoiced = cs.invoiced
         ,cd.invoiceddate = cs.invoiceddate
         ,cd.cmrDeliveryTypeID = cs.cmrDeliveryTypeID
         ,cd.ninetyDayAttestQ1 = cs.ninetyDayAttestQ1
         ,cd.ninetyDayAttestQ2 = cs.ninetyDayAttestQ2
         ,cd.refillRxAttestQ1 = cs.refillRxAttestQ1
         ,cd.refillRxAttestQ2 = cs.refillRxAttestQ2
         ,cd.centerID = cs.centerID
         ,cd.statusID = cs.statusID
         ,cd.submitDT = cs.submitDT
         ,cd.documentationRoleID = cs.documentationRoleID
         ,cd.invoiceStatusTypeID = cs.invoiceStatusTypeID
         ,cd.changeDate = cs.changeDate
         ,cd.condition = cs.condition
         ,cd.labID = cs.labID
         ,cd.currentMedName2 = cs.currentMedName2
         ,cd.currentMedGpi2 = cs.currentMedGpi2
         ,cd.currentMedRxNumber2 = cs.currentMedRxNumber2
         ,cd.currentMedMetricQuantity2 = cs.currentMedMetricQuantity2
         ,cd.currentMedDaysSupply2 = cs.currentMedDaysSupply2
         ,cd.currentMedPrescriber2 = cs.currentMedPrescriber2
         ,cd.currentPrescriberNPI2 = cs.currentPrescriberNPI2
   FROM dbo.Claim cd
      JOIN dbo.ClaimDeltaQueueStaging cs
         ON cs.ClaimID = cd.ClaimID
   WHERE cs.changedate IS NOT NULL
     AND cs.changedate != cd.changedate

END




