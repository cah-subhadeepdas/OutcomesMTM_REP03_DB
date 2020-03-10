CREATE   VIEW [dbo].[vw_clientManagerReport] AS

SELECT claim.claimid
	 , policyid
	 , policyNM
	 , mtmserviceDT
	 , status
	 , patientid
	 , MemberID
	 , MemberFirstNM
	 , MemberlastNM
	 , MemberDOB
	 , MemberGender
	 , MemberPhone
	 , memberCMSContractNumber
	 , memberPBP
	 , claim.centerid
	 , PharmacyNABP
	 , PharmacyName
	 , carrier
	 , account
	 , [group]
	 , PharmacyState
	 , pharmacistUserID
	 , pharmacistFirstNM
	 , pharmacistlastNM
	 , PharmacistlicenseNumber
	 , reasonTypeID
	 , reason
	 , reasonNM
	 , actiontypeid
	 , action
	 , actionNM
	 , resulttypeid
	 , result
	 , resultNM
	 , ecalevelid
	 , serveritylevel
	 , serveritylevelNM
	 , estimated_cost
	 , AIM
	 , charges
	 , ECAexplanation
	 , additionalnotes
	 , face2face
	 , claimfromcmr
	 , isTipClaim
	 , tipResultID
	 , tiptitle
	 , tipidentificationdate
	 , currentMedRxNumber
	 , currentMedMetricQuantity
	 , currentMedDaysSupply
	 , currentMedGpi
	 , currentMedName
	 , newMedRxNumber
	 , newMedMetricQuantity
	 , newMedDaysSupply
	 , newMedGpi
	 , newMedName
	 , [Adherence - Too many medications or doses per day]
	 , [Adherence - Forgets to take on routine days]
	 , [Adherence - Forgets to take on non-routine days]
	 , [Feels medication is not helping]
	 , [Feels medication is not needed]
	 , [Experienced side effects]
	 , [Concerned about potential side effects]
	 , [Medication cost is too high]
	 , [Decreased cognitive function]
	 , [Limitations on activities of daily living]
	 , [Transportation limitations prevent pharmacy access]
	 , [Patient taking differently than written directions]
	 , [Pharmacy error in directions/delivery/medication]
	 , [Forgets to take]
	 , [Unsure how to use medication]
	 , [Unable to swallow or administer]
	 , [Believes to be adherent]
	 , [Patient has no concerns or barriers]
	 , [Refill request delay]
	 , refillpickedup
	 , memberRefusalDesc
	 , prescriberRefusalDesc
	 , paiddate
	 , claimSubmitDT
	 , lastupdatedt
	 , documentationUserID
	 , documentationFirstNM
	 , documentationLastNM
	 , documentationRole
	 , pctfillatCenter
	 , pctfillatChain
	 , primarypharmacy
	 , validated
	 , claimValidationProcessed
	 , claimValidationPaymentProcessed
	 , tipDetailID
	 , HealthTestValue
	 , PCPName
	 , pregTestResult
	 , isLegacyServiceTypeClaim
	 , isEssentialServiceTypeClaim
	 , isStarServiceTypeClaim
	 , isMedRecServiceTypeClaim
	 , username
	 , currentMedPrescriber
	 , currentPrescriberNPI
	 , timeToComplete
	 , numberOfNotes
	 , claimValidationFee
	 , [No barrier identified]
	 , invoiceStatusTypeID
	 , invoiceStatusTypeNM
	 , invoiceStatusDT
	 , cmrDeliveryTypeID
	 , createdt
	 , conditionNM
	 , plannedMedSyncDT
	 , labNM
	 , currentMedName2
	 , currentMedGpi2
	 , currentMedRxNumber2
	 , currentMedMetricQuantity2
	 , currentMedDaysSupply2
	 , currentMedPrescriber2
	 , currentPrescriberNPI2
	 , CASE WHEN Isnull(cpt.claimID, 0) > 0 THEN 'Yes' ELSE 'No' END AS Patient_Communication_Generated
	 , convert(varchar, cpt.takeawayDate, 101)                       AS Date_Patient_Communication_Delivered
	 , Cognitive_Impairment_Status
	 , Cognitive_Impairment_Rationale
	 , t.Relationship_ID                                             AS Relationship_ID
	 , t.Relationship_ID_Name                                        AS Relationship_Name
	 , patTakeAwayDT
	 , recipientNM
	 , cmr_recipient_rationale
	 , qa1.answer AS answer1
	 , qa2.answer AS answer2
	 , qa3.answer AS answer3
	 , qa4.answer AS answer4
	 , qa5.answer AS answer5
	 , qa6.answer AS answer6
	 , qa7.answer AS answer7
	 , qa8.answer AS answer8
	 , qa9.answer AS answer9
	 , qa10.answer AS answer10
	 , qa11.answer AS answer11
	 , qa12.answer AS answer12
	 , qa13.answer AS answer13
	 , qa14.answer AS answer14
	 , qa15.answer AS answer15
	 , qa16.answer AS answer16
	 , qa17.answer AS answer17

FROM dbo.clientManagerReport claim
LEFT JOIN dbo.claimPatientTakeaway cpt WITH (NOLOCK) ON claim.claimID = cpt.claimID
JOIN dbo.pharmacy ph ON ph.centerid = claim.centerid
LEFT JOIN (SELECT pv.mtmCenterNumber, pv.Relationship_ID, pv.Relationship_ID_Name, pp.chainid
		FROM dbo.pharmacychain pp
		JOIN dbo.pharmacy ph ON ph.centerid = pp.centerid
		JOIN dbo.Chain ch ON ch.chainid = pp.chainid
		LEFT JOIN dbo.providerRelationshipView pv
		ON ph.NCPDP_NABP = pv.mtmCenterNumber AND ch.chaincode = pv.Relationship_ID
 ) t ON t.mtmCenterNumber = ph.NCPDP_NABP
LEFT JOIN claimQuestionAnswers qa1 WITH (NOLOCK) ON qa1.claimid = claim.claimid AND qa1.claimQuestionId IN (9, 13, 17, 21)
LEFT JOIN claimQuestionAnswers qa2 WITH (NOLOCK) ON qa2.claimid = claim.claimid AND qa2.claimQuestionId IN (10, 14, 18, 22)
LEFT JOIN claimQuestionAnswers qa3 WITH (NOLOCK) ON qa3.claimid = claim.claimid AND qa3.claimQuestionId IN (8, 12, 16, 20)
LEFT JOIN claimQuestionAnswers qa4 WITH (NOLOCK) ON qa4.claimid = claim.claimid AND qa4.claimQuestionId IN (11, 15, 19, 23, 24, 26)
LEFT JOIN claimQuestionAnswers qa5 WITH (NOLOCK) ON qa5.claimid = claim.claimid AND qa5.claimQuestionId IN (50, 53)
LEFT JOIN claimQuestionAnswers qa6 WITH (NOLOCK) ON qa6.claimid = claim.claimid AND qa6.claimQuestionId IN (51, 54)
LEFT JOIN claimQuestionAnswers qa7 WITH (NOLOCK) ON qa7.claimid = claim.claimid AND qa7.claimQuestionId IN (52, 55)
LEFT JOIN claimQuestionAnswers qa8 WITH (NOLOCK) ON qa8.claimid = claim.claimid AND qa8.claimQuestionId = 56
LEFT JOIN claimQuestionAnswers qa9 WITH (NOLOCK) ON qa9.claimid = claim.claimid AND qa9.claimQuestionId = 57
LEFT JOIN claimQuestionAnswers qa10 WITH (NOLOCK) ON qa10.claimid = claim.claimid AND qa10.claimQuestionId = 58
LEFT JOIN claimQuestionAnswers qa11 WITH (NOLOCK) ON qa11.claimid = claim.claimid AND qa11.claimQuestionId = 59
LEFT JOIN claimQuestionAnswers qa12 WITH (NOLOCK) ON qa12.claimid = claim.claimid AND qa12.claimQuestionId = 60
LEFT JOIN claimQuestionAnswers qa13 WITH (NOLOCK) ON qa13.claimid = claim.claimid AND qa13.claimQuestionId = 61
LEFT JOIN claimQuestionAnswers qa14 WITH (NOLOCK) ON qa14.claimid = claim.claimid AND qa14.claimQuestionId = 62
LEFT JOIN claimQuestionAnswers qa15 WITH (NOLOCK) ON qa15.claimid = claim.claimid AND qa15.claimQuestionId = 63
LEFT JOIN claimQuestionAnswers qa16 WITH (NOLOCK) ON qa16.claimid = claim.claimid AND qa16.claimQuestionId = 64
LEFT JOIN claimQuestionAnswers qa17 WITH (NOLOCK) ON qa17.claimid = claim.claimid AND qa17.claimQuestionId = 67
WHERE 1 = 1
